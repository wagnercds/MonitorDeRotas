program MonRota;

uses
  Forms,
  UMain in 'UMain.pas' {fMain},
  UAddRota in 'UAddRota.pas' {fAddRota};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := true;
  Application.Title := 'EnvCom';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
