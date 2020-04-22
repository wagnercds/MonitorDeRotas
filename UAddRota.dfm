object fAddRota: TfAddRota
  Left = 401
  Top = 163
  ActiveControl = edDest
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Adicionar Rota'
  ClientHeight = 130
  ClientWidth = 181
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 181
    Height = 99
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 9
      Width = 36
      Height = 13
      Caption = 'Destino'
    end
    object TLabel
      Left = 11
      Top = 33
      Width = 40
      Height = 13
      Caption = 'Mascara'
    end
    object TLabel
      Left = 8
      Top = 56
      Width = 43
      Height = 13
      Caption = 'Gateway'
    end
    object edDest: TEdit
      Left = 53
      Top = 5
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object edMask: TEdit
      Left = 53
      Top = 29
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object edGate: TEdit
      Left = 53
      Top = 53
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object cbPers: TCheckBox
      Left = 53
      Top = 77
      Width = 97
      Height = 17
      Caption = 'Persistente'
      TabOrder = 3
    end
  end
  object TPanel
    Left = 0
    Top = 99
    Width = 181
    Height = 31
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 43
      Top = 3
      Width = 41
      Height = 25
      Caption = ' '
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 97
      Top = 3
      Width = 41
      Height = 25
      Caption = ' '
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
