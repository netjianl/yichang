object hourCountForm: ThourCountForm
  Left = 202
  Top = 174
  Width = 487
  Height = 524
  Caption = #37319#38598#32570#28857#29992#25143
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 24
    Top = 40
    Width = 425
    Height = 425
    DataSource = hourcount_dm.dsHourCount
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = #27979#37327#28857#32534#21495
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = #34920#21495
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = #26085#26399
        Width = 113
        Visible = True
      end
      item
        Expanded = False
        FieldName = #25972#28857#37319#38598#25968
        Width = 65
        Visible = True
      end>
  end
  object findButton: TButton
    Left = 24
    Top = 8
    Width = 75
    Height = 25
    Caption = #26597#25214
    TabOrder = 1
    OnClick = findButtonClick
  end
  object Button1: TButton
    Left = 344
    Top = 8
    Width = 75
    Height = 25
    Caption = #20851#38381
    ModalResult = 1
    TabOrder = 2
  end
  object FindDialog1: TFindDialog
    OnFind = FindDialog1Find
    Left = 104
    Top = 8
  end
end
