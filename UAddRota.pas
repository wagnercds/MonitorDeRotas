unit UAddRota;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfAddRota = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edDest: TEdit;
    edMask: TEdit;
    edGate: TEdit;
    cbPers: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
