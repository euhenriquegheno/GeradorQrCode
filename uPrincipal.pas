unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DelphiZXIngQRCode, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    edtLink: TEdit;
    Label1: TLabel;
    PaintBox1: TPaintBox;
    btnSalvarQrCode: TButton;
    Image1: TImage;
    procedure edtLinkChange(Sender: TObject);
    procedure btnSalvarQrCodeClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    QRCodeBitmap: TBitmap;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSalvarQrCodeClick(Sender: TObject);
var
  bmp: TBitmap;
  png: TPngImage;
begin
  Image1.Canvas.CopyRect(Image1.Canvas.ClipRect, PaintBox1.Canvas, PaintBox1.Canvas.ClipRect);
  Image1.Picture.SaveToFile(ExtractFilePath(Application.ExeName) + 'qrCodeSalvo.png');
end;



procedure TForm1.edtLinkChange(Sender: TObject);
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := edtLink.Text;
    QRCode.Encoding := TQRCodeEncoding(0);
    QRCode.QuietZone := 4;
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
        end else
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;
  finally
    QRCode.Free;
  end;
  PaintBox1.Repaint;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  QRCodeBitmap.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  QRCodeBitmap := TBitmap.Create;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  Scale: Double;
begin
  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
  if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then
  begin
    if (PaintBox1.Width < PaintBox1.Height) then
    begin
      Scale := PaintBox1.Width / QRCodeBitmap.Width;
    end else
    begin
      Scale := PaintBox1.Height / QRCodeBitmap.Height;
    end;
    PaintBox1.Canvas.StretchDraw(Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width), Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);
  end;
end;

end.
