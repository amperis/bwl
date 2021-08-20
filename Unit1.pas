unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.OleCtrls, SHDocVw, IdNetworkCalculator, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, ShellApi, wintypes,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  IdDNSResolver, System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    dd1: TMenuItem;
    Acercade1: TMenuItem;
    Salir1: TMenuItem;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    StatusBar1: TStatusBar;
    ListBox1: TListBox;
    WebBrowser1: TWebBrowser;
    Timer1: TTimer;
    IdTCPClient1: TIdTCPClient;
    IdNetworkCalculator1: TIdNetworkCalculator;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    Nmap1: TMenuItem;
    IE1: TMenuItem;
    Ping1: TMenuItem;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    IdDNSResolver1: TIdDNSResolver;
    DNSreverse1: TMenuItem;
    SaveDialog1: TSaveDialog;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    Guadarresultado1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Acercade1Click(Sender: TObject);
    procedure Ping1Click(Sender: TObject);
    procedure Nmap1Click(Sender: TObject);
    procedure IE1Click(Sender: TObject);
    procedure DNSreverse1Click(Sender: TObject);
    procedure Guadarresultado1Click(Sender: TObject);
  private
    { Private declarations }
    i: integer;
    ipbuscada: string;
    webs_encontradas: integer;
    protocolo: string;
  public
    { Public declarations }
    CONST
       SUBRED_EJEMPLO = '192.168.1.0';
       MASCARA_EJEMPLO = '255.255.255.0';
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2;

procedure TForm1.Acercade1Click(Sender: TObject);
begin
   //MessageDlg('BWL - Buscador Web Local ' + #10#13 + 'version 0.1' + #10#13 + 'amperis@gmail.com',mtInformation, [mbOK], 0);
   Form2.Show();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   if (not CheckBox1.Checked) and (not CheckBox2.Checked) then begin
      MessageDlg('Debe seleccionar al menos un protocolo.' ,mtError, [mbOK], 0);
      exit();
   end;

   try
      ListBox1.Clear;
      WebBrowser1.Navigate('about:blank');
      IdNetworkCalculator1.NetworkAddress.AsString := Edit1.Text;
      IdNetworkCalculator1.NetworkMask.AsString := Edit2.Text;
      i:=0;
      webs_encontradas := 0;
      StatusBar1.Panels[1].Text := '';
      ProgressBar1.Max :=  IdNetworkCalculator1.ListIP.Count-1;
      Button1.Enabled := FALSE;
      Timer1.Enabled := TRUE;
   except
      on E : Exception do begin
       MessageDlg(E.Message,mtError, [mbOK], 0);
     end;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   Timer1.Enabled := FALSE;
   ListBox1.Clear;
   ProgressBar1.Max := 0;
   Edit1.Text := SUBRED_EJEMPLO;
   Edit2.Text := MASCARA_EJEMPLO;
   StatusBar1.Panels[0].Text := '';
   StatusBar1.Panels[1].Text := '';
   Button3.Enabled := FALSE;
   WebBrowser1.Navigate('about:blank');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   param, navegador: string;
   r: integer;
begin
   param := ListBox1.Items[ListBox1.ItemIndex];
   navegador := 'C:\Program Files\Internet Explorer\iexplore.exe';
   ShellExecute(0, 'open', PChar(navegador), PChar(param), nil, SW_SHOW);
   r := GetLastError;
   if r <> 0 then MessageDlg(SysErrorMessage(r), mtError, [mbOK], 0);
end;

procedure TForm1.DNSreverse1Click(Sender: TObject);
var
   ip: string;
begin
   if ListBox1.Items.Count > 0 then begin
      ip := StringReplace(ListBox1.Items[ListBox1.ItemIndex], 'http://', '',[rfReplaceAll, rfIgnoreCase]);
      ShowMessage(ip);
   end else
      MessageDlg('Ningun elemento seleccionado. Realiza una busqueda primero.', mtError, [mbOK], 0)
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Edit1.Text := SUBRED_EJEMPLO;
   Edit2.Text := MASCARA_EJEMPLO;
   Button3.Enabled := FALSE;
end;

procedure TForm1.Guadarresultado1Click(Sender: TObject);
begin
   if ListBox1.Items.Count > 0 then begin
      if SaveDialog1.Execute then begin
         ListBox1.Items.SaveToFile(SaveDialog1.FileName);
      end;

   end else
      MessageDlg('Ningun elemento para guardar. Realiza una busqueda primero.', mtError, [mbOK], 0)
end;

procedure TForm1.IdTCPClient1Connected(Sender: TObject);
begin
   if IdTCPClient1.Port = 80 then
      ListBox1.Items.Add('http://'+ipbuscada)
   else
      ListBox1.Items.Add('https://'+ipbuscada);
   inc(webs_encontradas);
   StatusBar1.Panels[1].Text := webs_encontradas.ToString() + ' webs encontradas';
end;

procedure TForm1.IE1Click(Sender: TObject);
var
   param, navegador: string;
   r: integer;
begin
   if ListBox1.Items.Count > 0 then begin
      param := ListBox1.Items[ListBox1.ItemIndex];
      navegador := 'C:\Program Files\Internet Explorer\iexplore.exe';
      ShellExecute(0, 'open', PChar(navegador), PChar(param), nil, SW_SHOW);
      r := GetLastError;
      if r <> 0 then MessageDlg(SysErrorMessage(r), mtError, [mbOK], 0)
   end else
      MessageDlg('Ningun elemento seleccionado. Realiza una busqueda primero.', mtError, [mbOK], 0)
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
   if ListBox1.Items.Count > 0 then begin
      StatusBar1.Panels[0].Text :=  'Cargando ' + ListBox1.Items[ListBox1.ItemIndex];
      WebBrowser1.Navigate(ListBox1.Items[ListBox1.ItemIndex]);
      Button3.Enabled := TRUE;
   end;
end;


procedure TForm1.Nmap1Click(Sender: TObject);
var
   param, comando: string;
   r: integer;
   ip: string;
begin
   if ListBox1.Items.Count > 0 then begin
      ip := StringReplace(ListBox1.Items[ListBox1.ItemIndex], 'http://', '',[rfReplaceAll, rfIgnoreCase]);
      ip := StringReplace(ip, 'https://', '',[rfReplaceAll, rfIgnoreCase]);
      param := '/c nmap -sV '+ip+' && pause';
      comando := 'cmd.exe';
      ShellExecute(0, 'open', PChar(comando), PChar(param), nil, SW_SHOW);
      r := GetLastError;
      if r <> 0 then MessageDlg(SysErrorMessage(r), mtError, [mbOK], 0)
   end else
      MessageDlg('Ningun elemento seleccionado. Realiza una busqueda primero.', mtError, [mbOK], 0)

end;

procedure TForm1.Ping1Click(Sender: TObject);
var
   param, comando: string;
   r: integer;
   ip: string;
begin
   if ListBox1.Items.Count > 0 then begin
      ip := StringReplace(ListBox1.Items[ListBox1.ItemIndex], 'http://', '',[rfReplaceAll, rfIgnoreCase]);
      ip := StringReplace(ip, 'https://', '',[rfReplaceAll, rfIgnoreCase]);
      param := '/c ping '+ip+' && pause';
      comando := 'cmd.exe';
      ShellExecute(0, 'open', PChar(comando), PChar(param), nil, SW_SHOW);
      r := GetLastError;
      if r <> 0 then MessageDlg(SysErrorMessage(r), mtError, [mbOK], 0)
   end else
      MessageDlg('Ningun elemento seleccionado. Realiza una busqueda primero.', mtError, [mbOK], 0)
end;

procedure TForm1.Salir1Click(Sender: TObject);
begin
   Form1.Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   if i <= IdNetworkCalculator1.ListIP.Count-1 then begin
      ipbuscada := IdNetworkCalculator1.ListIP[i];
      //--- busqueda HTTP
      if CheckBox1.Checked then begin
         StatusBar1.Panels[0].Text :=  'Buscando ' + 'http://' + ipbuscada + '...';
         IdTCPClient1.Host := ipbuscada;
         IdTCPClient1.Port := 80;

         try
            IdTCPClient1.Connect;
            IdTCPClient1.Disconnect;
         except
         end;
      end;
      //--- busqueda HTTPS
      if CheckBox2.Checked then begin
         StatusBar1.Panels[0].Text :=  'Buscando ' + 'https://' + ipbuscada + '...';
         IdTCPClient1.Host := ipbuscada;
         IdTCPClient1.Port := 443;
         try
            IdTCPClient1.Connect;
            IdTCPClient1.Disconnect;
         except
         end;
      end;
      inc(i);
      ProgressBar1.Position := ProgressBar1.Position+1;

   end else begin
      Timer1.Enabled := FALSE;
      StatusBar1.Panels[0].Text := '';
      StatusBar1.Panels[1].Text := webs_encontradas.ToString() + ' webs encontradas';
      MessageDlg('Busqueda finalizada. '+webs_encontradas.ToString()+' resultados encontrados.',mtInformation, [mbOK], 0);
      ProgressBar1.Max := 0;
      Button1.Enabled := TRUE;
   end;
end;


end.
