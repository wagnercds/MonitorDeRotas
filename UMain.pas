unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, Grids, ExtCtrls, Buttons, Spin, LibString, UAddRota,
  StrUtils, IniFiles, Menus;

const
  wm_IconMessage = wm_User;

type
  TfMain = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    seMinuto: TSpinEdit;
    Label2: TLabel;
    stData: TStaticText;
    btAtu: TBitBtn;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    stgRotAtv: TStringGrid;
    GroupBox3: TGroupBox;
    stgRotPer: TStringGrid;
    Timer: TTimer;
    btAD: TBitBtn;
    btDel: TBitBtn;
    PopupMenu: TPopupMenu;
    Rastrear1: TMenuItem;
    N7Sair1: TMenuItem;
    procedure btAtuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btADClick(Sender: TObject);
    procedure btDElClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure seMinutoChange(Sender: TObject);
    procedure Rastrear1Click(Sender: TObject);
    procedure N7Sair1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    nid: TNotifyIconData;
    procedure MensErroArq(Mens, TipAtu : string);
    function MontaRelatorio(Tela, Log : boolean) : boolean;
    { Private declarations }
  public
    procedure IconTray(var Msg: TMessage);  message wm_IconMessage;
    { Public declarations }
  end;

var
 fMain : TfMain;

implementation

{$R *.dfm}

function TfMain.MontaRelatorio(Tela, Log : boolean) : boolean;
var
 Aux, Secao : TStringList;
 Count, iLoop, iLoop2 : integer;
 WinIni : TIniFile;
 Comm : array[1..250] of char;
 bAux : boolean;
begin
   stData.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss',Now);
   Result := false;
   // Criando bat para pegar as rotas
   Aux := TStringList.Create;
   Aux.Add('route print > c:\monrota.awe');
   Aux.SaveToFile('c:\monrota.bat');
   // Executa a bat para capturar as rotas
   ShellExecute(Handle,nil,'c:\monrota.bat',nil,'c:\', SW_HIDE);
   Count := 0;
   // Verifica se o arquivo foi criado

   //sleep(1000);
   while not FileExists('c:\monrota.awe') do
   begin
      sleep(100);
      Inc(Count);
      if Count > 100 then
         break;
      Application.ProcessMessages;
   end;
   // Apagando a bat
   DeleteFile('c:\monrota.bat');
   // Verifica se o arquivo foi criado com exito
   if FileExists('c:\monrota.awe') then
   begin
      // Atualizando a tela de dados
      bAux := false;
      while not bAux do
      begin
         try
           Aux.LoadFromFile('c:\monrota.awe');
           bAux := true;
         except
           bAux := false;
         end;
         sleep(100);
         Application.ProcessMessages;
      end;

      for iLoop := 0 to Aux.Count - 1 do
      begin
         if Pos('Ender',Aux.Strings[iLoop]) > 0 then
         begin
            Count := iLoop;
            break;
         end;
      end;
      stgRotAtv.RowCount := 2;
      // Rotas ativas
      for iLoop := Count + 1 to Aux.Count - 1 do
      begin
         if (Pos('===',Aux.Strings[iLoop]) > 0) or
            (Pos('Gateway',Aux.Strings[iLoop]) > 0) then
            break;

         Aux.Strings[iLoop] := Trim(Aux.Strings[iLoop]);

         stgRotAtv.Cells[0,stgRotAtv.RowCount - 1] := Pal(Trim(Aux.Strings[iLoop]),' ',1);

         Aux.Strings[iLoop] := Trim(Copy(Aux.Strings[iLoop],
                                         Length(stgRotAtv.Cells[0,stgRotAtv.RowCount - 1]) + 1,
                                         Length(Aux.Strings[iLoop])));
         stgRotAtv.Cells[1,stgRotAtv.RowCount - 1] := Pal(Trim(Aux.Strings[iLoop]),' ',1);

         Aux.Strings[iLoop] := Trim(Copy(Aux.Strings[iLoop],
                                         Length(stgRotAtv.Cells[1,stgRotAtv.RowCount - 1]) + 1,
                                         Length(Aux.Strings[iLoop])));
         stgRotAtv.Cells[2,stgRotAtv.RowCount - 1] := Pal(Trim(Aux.Strings[iLoop]),' ',1);

         Aux.Strings[iLoop] := Trim(Copy(Aux.Strings[iLoop],
                                         Length(stgRotAtv.Cells[2,stgRotAtv.RowCount - 1]) + 1,
                                         Length(Aux.Strings[iLoop])));
         stgRotAtv.Cells[3,stgRotAtv.RowCount - 1] := Pal(Trim(Aux.Strings[iLoop]),' ',1);
         stgRotAtv.Cells[3,stgRotAtv.RowCount - 1] := Copy(stgRotAtv.Cells[3,stgRotAtv.RowCount - 1],
                                                           1, Length(stgRotAtv.Cells[3,stgRotAtv.RowCount - 1]) - 1);
         stgRotAtv.RowCount := stgRotAtv.RowCount + 1;
      end;

      stgRotAtv.RowCount := stgRotAtv.RowCount - 1;

      // Rotas persistentes
      stgRotPer.RowCount := 2;
      stgRotPer.Cells[0,1] := '';
      stgRotPer.Cells[1,1] := '';
      stgRotPer.Cells[2,1] := '';
      if (Pos('Gateway',Aux.Strings[iLoop]) > 0) then
         Count := iLoop + 3
      else
         Count := iLoop + 2;

      if Pos('Nenhuma', Aux.Strings[Count]) = 0 then
      begin
         for iLoop := Count + 1 to Aux.Count - 1 do
         begin
            Aux.Strings[iLoop] := Trim(Aux.Strings[iLoop]);

            stgRotPer.Cells[0,stgRotPer.RowCount - 1] := Pal(Trim(Aux.Strings[iLoop]),' ',1);

            Aux.Strings[iLoop] := Trim(Copy(Aux.Strings[iLoop],
                                            Length(stgRotPer.Cells[0,stgRotPer.RowCount - 1]) + 1,
                                            Length(Aux.Strings[iLoop])));
            stgRotPer.Cells[1,stgRotPer.RowCount - 1] := Pal(Trim(Aux.Strings[iLoop]),' ',1);

            Aux.Strings[iLoop] := Trim(Copy(Aux.Strings[iLoop],
                                            Length(stgRotPer.Cells[1,stgRotPer.RowCount - 1]) + 1,
                                            Length(Aux.Strings[iLoop])));
            stgRotPer.Cells[2,stgRotPer.RowCount - 1] := Pal(Trim(Aux.Strings[iLoop]),' ',1);

            Aux.Strings[iLoop] := Trim(Copy(Aux.Strings[iLoop],
                                            Length(stgRotPer.Cells[2,stgRotPer.RowCount - 1]) + 1,
                                            Length(Aux.Strings[iLoop])));
            stgRotPer.Cells[3,stgRotPer.RowCount - 1] := Pal(Trim(Aux.Strings[iLoop]),' ',1);
            stgRotPer.Cells[3,stgRotPer.RowCount - 1] := Copy(stgRotPer.Cells[3,stgRotPer.RowCount - 1],
                                                              1, Length(stgRotPer.Cells[3,stgRotPer.RowCount - 1]) - 1);
            stgRotPer.RowCount := stgRotPer.RowCount + 1;
         end;
         stgRotPer.RowCount := stgRotPer.RowCount - 1;
      end;

      DeleteFile('c:\monrota.awe');

      Result := true;

      if Log then
      begin
         if FileExists('LOGMR' + FormatDateTime('yyyymmdd',now) + '.txt') then
            Aux.LoadFromFile('LOGMR' + FormatDateTime('yyyymmdd',now) + '.txt')
         else
            Aux.Clear;

         Aux.Add(' ');
         if Tela then
            Aux.Add('Atualização manual feita com sucesso')
         else
           Aux.Add('Atualização automática com suceeso');
         Aux.Add(FormatDateTime('dd/mm/yyyy hh:mm:ss', Now));
         Aux.Add(' ');
         Aux.Add('Rotas Ativas');
         Aux.Add('DESTINO' + DupeString(' ',9) + 'MASCARA' + DupeString(' ',9) +
                 'GATEWAY' + DupeString(' ',9) + 'INTERFACE');
         for iLoop := 1 to stgRotAtv.RowCount do
             Aux.Add(stgRotAtv.Cells[0, iLoop] + DupeString(' ',16 - Length(stgRotAtv.Cells[0, iLoop])) +
                     stgRotAtv.Cells[1, iLoop] + DupeString(' ',16 - Length(stgRotAtv.Cells[1, iLoop])) +
                     stgRotAtv.Cells[2, iLoop] + DupeString(' ',16 - Length(stgRotAtv.Cells[2, iLoop])) +
                     stgRotAtv.Cells[1, iLoop]);
         Aux.Add(' ');
         Aux.Add('Rotas persistentes');
         Aux.Add('DESTINO' + DupeString(' ',9) + 'MASCARA' + DupeString(' ',9) +
                 'GATEWAY');
         for iLoop := 1 to stgRotPer.RowCount do
             Aux.Add(stgRotPer.Cells[0, iLoop] + DupeString(' ',16 - Length(stgRotPer.Cells[0, iLoop])) +
                     stgRotPer.Cells[1, iLoop] + DupeString(' ',16 - Length(stgRotPer.Cells[1, iLoop])) +
                     stgRotPer.Cells[2, iLoop]);

         // Verificando se todas as rotas estão no sistema
         WinIni := TIniFile.Create('MonRotaPer.ini');
         Secao := TStringList.Create;
         WinIni.ReadSections(Secao);
         for iLoop := 0 to Secao.Count - 1 do
         begin
            bAux := false;
            for iLoop2 := 1 to stgRotAtv.RowCount do
            begin
               // Verifica se a rota está ativa
               if stgRotAtv.Cells[0, iLoop2] = Secao.Strings[iLoop] then
               begin
                  bAux := true;
                  break;
               end;
            end;
            // Se não estiver adiciona novamente
            if not bAux then
            begin
               StrPCopy(@Comm, '-p ADD ' + Secao.Strings[iLoop] + ' mask ' +
                               WinIni.ReadString(Secao.Strings[iLoop],'Mascara',' ') +
                               ' ' +
                               WinIni.ReadString(Secao.Strings[iLoop],'Gateway',' '));
                ShellExecute(handle,nil,'route',@Comm,'C:\',SW_HIDE);
                Aux.Add('Rota Destino :' + Secao.Strings[iLoop] + ' Mascara :' +
                        WinIni.ReadString(Secao.Strings[iLoop],'Mascara',' ') +
                        ' Gateway :' +
                        WinIni.ReadString(Secao.Strings[iLoop],'Gateway',' ') +
                        ' foi perdida e novamente adicionada.');
            end;
         end;
         Secao.Free;
         WinIni.Free;
         Aux.Add('================== FINAL DA VARREDURA ==================');
         Aux.SaveToFile('LOGMR' + FormatDateTime('yyyymmdd',now) + '.txt');
      end;
   end
   else
   begin
      if Tela then
      begin
         Application.MessageBox('Não foi possível acessar a tabela de rotas !',
                                'Erro 0x01', MB_OK + MB_IconError);
         MensErroArq('Erro na leitura das rotas(0x01).','Atualização manual');
      end
      else
         MensErroArq('Erro na leitura das rotas(0x01).','Atualização automática');
   end;
   Aux.Free;
end;

procedure TfMain.btAtuClick(Sender: TObject);
begin
   btAtu.Enabled := false;
   MontaRelatorio(true, true);
   btAtu.Enabled := true;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
 WinIni : TIniFile;
begin
 // Configura o icone na bandeja de tarefas
   nid.cbSize := sizeof (nid);
   nid.wnd := Handle;
   nid.uID := 1; // código do ícone
   nid.uCallBackMessage := wm_IconMessage;
   nid.hIcon := Icon.Handle;
   nid.szTip := 'Monitor de Rotas (1.0.0)';
   nid.uFlags := nif_Message or nif_Icon or nif_Tip;
   Shell_NotifyIcon (NIM_ADD, @nid);

   // Atualizando o grid de rotas ativas
   stgRotAtv.Cells[0,0] := 'DESTINO';
   stgRotAtv.Cells[1,0] := 'MASCARA';
   stgRotAtv.Cells[2,0] := 'GATEWAY';
   stgRotAtv.Cells[3,0] := 'INTERFACE';

   // Atualizando o grid de rotas persistentes
   stgRotPer.Cells[0,0] := 'DESTINO';
   stgRotPer.Cells[1,0] := 'MASCARA';
   stgRotPer.Cells[2,0] := 'GATEWAY';

   WinIni := TIniFile.Create('monrota.ini');
   Timer.Interval := WinIni.ReadInteger('CONF','TEMPO',900000);
   seMinuto.Value := Timer.Interval div 60000;
   WinIni.Free;
   Timer.Enabled := true;
   btAtuClick(btAtu);
end;

procedure TfMain.MensErroArq(Mens, TipAtu: string);
var
 Aux : TStringList;
begin
   Aux := TStringList.Create;
   if FileExists('LOGMR' + FormatDateTime('yyyymmdd',now) + '.txt') then
      Aux.LoadFromFile('LOGMR' + FormatDateTime('yyyymmdd',now) + '.txt');
   Aux.Add(' ');
   Aux.Add('*' + TipAtu);
   Aux.Add(FormatDateTime('dd/mm/yyyy hh:mm:ss', Now));
   Aux.Add('*' + Mens);
   Aux.SaveToFile('LOGMR' + FormatDateTime('yyyymmdd',now) + '.txt');
end;


procedure TfMain.btADClick(Sender: TObject);
var
 FAddRota : TfAddRota;
 Comm : array[1..250] of char;
 bAux : boolean;
 iLoop : integer;
 WinIni : TIniFile;
begin
   btAD.Enabled := false;
   FAddRota := TfAddRota.Create(Self);
   FAddRota.ShowModal;
   if fAddRota.ModalResult = MROK then
   begin
      StrPCopy(@Comm, IfThen(fAddRota.cbPers.Checked,'-p ') + 'ADD ' +
                      fAddRota.edDest.Text + ' mask ' + fAddRota.edMask.Text +
                      ' ' + fAddRota.edGate.Text);
      ShellExecute(handle,nil,'route',@Comm,'C:\',SW_HIDE);
      if MontaRelatorio(True, false) then
      begin
         bAux := false;
         for iLoop := 1 to stgRotAtv.RowCount do
         begin
            if (stgRotAtv.Cells[0,iLoop] = fAddRota.edDest.Text) and
               (stgRotAtv.Cells[1,iLoop] = fAddRota.edMask.Text) and
               (stgRotAtv.Cells[2,iLoop] = fAddRota.edGate.Text) then
            begin
               bAux := true;
               break;
            end;
         end;
         if not bAux then
            Application.MessageBox('Erro ao adicionar rota !','Erro 0x04',
                                   MB_OK + MB_IconError)
         else
         begin
            WinIni := TIniFile.Create('MonRotaPer.ini');
            WinIni.WriteString(fAddRota.edDest.Text, 'Mascara',
                               fAddRota.edMask.Text);
            WinIni.WriteString(fAddRota.edDest.Text, 'Gateway',
                               fAddRota.edGate.Text);
            WinIni.Free;
         end;
      end
      else
         Application.MessageBox('Não foi possível confirmar a adição da rota !',
                                'Erro 0x03', MB_OK + MB_IconError);
   end;
   FAddRota.Free;
   btAD.Enabled := true;
end;

procedure TfMain.btDElClick(Sender: TObject);
var
 Comm : array[1..250] of char;
 bAux : boolean;
 iLoop : integer;
 Dados : array[1..3] of string;
 WinIni : TIniFile;
begin
   btDel.Enabled := false;

   Dados[1] := stgRotAtv.Cells[0, stgRotAtv.Selection.TopLeft.Y];
   Dados[2] := stgRotAtv.Cells[1, stgRotAtv.Selection.TopLeft.Y];
   Dados[3] := stgRotAtv.Cells[2, stgRotAtv.Selection.TopLeft.Y];

   StrPCopy(@Comm, 'DELETE ' + stgRotAtv.Cells[0, stgRotAtv.Selection.TopLeft.Y]);
   ShellExecute(handle,nil,'route',@Comm,'C:\',SW_HIDE);
   if MontaRelatorio(True, false) then
   begin
      bAux := true;
      for iLoop := 1 to stgRotAtv.RowCount do
      begin
         if (stgRotAtv.Cells[0,iLoop] = Dados[1]) and
            (stgRotAtv.Cells[1,iLoop] = Dados[2]) and
            (stgRotAtv.Cells[2,iLoop] = Dados[3]) then
         begin
            bAux := false;
            break;
         end;
      end;
      if not bAux then
         Application.MessageBox('Não foi possível remover a rota !','Erro 0x05',
                                MB_OK + MB_IconError)
      else
      begin
         WinIni := TIniFile.Create('MonRotaPer.ini');
         WinIni.EraseSection(Dados[1]);
         WinIni.Free;
      end;
   end
   else
      Application.MessageBox('Não foi possível confirmar a adição da rota !',
                             'Erro 0x03', MB_OK + MB_IconError);

   btDel.Enabled := true;
end;

procedure TfMain.TimerTimer(Sender: TObject);
begin
   Timer.Enabled := false;
   btAtu.Enabled := false;
   MontaRelatorio(false, true);
   MontaRelatorio(false, false);
   btAtu.Enabled := true;
   Timer.Enabled := true;
end;

procedure TfMain.seMinutoChange(Sender: TObject);
var
 WinIni : TIniFile;
begin
   Timer.Enabled := false;
   Timer.Interval := seMinuto.Value * 60000;
   Timer.Enabled := true;
   WinIni := TIniFile.Create('MonRota.ini');
   WinIni.WriteInteger('CONF','TEMPO',Timer.Interval);
   WinIni.Free;
end;

procedure TfMain.IconTray(var Msg: TMessage);
var
  Pt: TPoint;
begin
  if Msg.lParam = wm_rbuttondown then
  begin
    GetCursorPos(Pt);
    PopupMenu.Popup(Pt.x, Pt.y);
  end
  else
  if Msg.lParam = wm_lbuttondown then
     show;
end;

procedure TfMain.Rastrear1Click(Sender: TObject);
begin
   Show;
end;

procedure TfMain.N7Sair1Click(Sender: TObject);
begin
   Application.Terminate;
end;

procedure TfMain.FormDestroy(Sender: TObject);
begin
  nid.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @nid);
end;

procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   Hide;
   CanClose := false;
end;

end.
