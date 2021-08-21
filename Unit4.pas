unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm4 = class(TForm)
    Button1: TButton;
    RichEdit1: TRichEdit;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm4.Button1Click(Sender: TObject);
begin
   Form4.Close;
end;

procedure TForm4.FormActivate(Sender: TObject);
begin
   Form4.Caption := Form1.url;
   RichEdit1.Text := Form1.htmlcode;
   RichEdit1.Lines.Count;
end;

end.
