object multiMeterUserForm: TmultiMeterUserForm
  Left = 228
  Top = 167
  Width = 881
  Height = 699
  Caption = #22810#34920#29992#25143#30340#32534#36753
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 48
    Height = 12
    Caption = #20840#37096#29992#25143
  end
  object Label2: TLabel
    Left = 544
    Top = 72
    Width = 156
    Height = 12
    Caption = #20197#19979#29992#25143#23646#20110#24403#21069#22810#30005#34920#29992#25143
  end
  object Label3: TLabel
    Left = 544
    Top = 40
    Width = 84
    Height = 12
    Caption = #30005#34920#29992#25143#21517#31216#65306
  end
  object Label4: TLabel
    Left = 64
    Top = 488
    Width = 84
    Height = 12
    Caption = #24403#21069#22810#34920#29992#25143'ID'
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 40
    Width = 809
    Height = 425
    DataSource = DataModule1.dsUser
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 0
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = #25143#21495
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = #34920#21495
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = #32456#31471#36923#36753#22320#22336
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = #27979#37327#28857#32534#21495
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = #20998#23616
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = #23458#25143#21517#31216
        Width = 350
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 8
    Top = 512
    Width = 75
    Height = 25
    Caption = #21152#20837
    TabOrder = 1
    OnClick = Button1Click
  end
  object editMutliName: TEdit
    Left = 168
    Top = 482
    Width = 153
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ReadOnly = True
    TabOrder = 2
  end
  object Button2: TButton
    Left = 752
    Top = 8
    Width = 75
    Height = 25
    Caption = #26597#25214
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 552
    Width = 75
    Height = 25
    Caption = #21024#38500
    TabOrder = 4
    OnClick = Button3Click
  end
  object DBGrid2: TDBGrid
    Left = 88
    Top = 512
    Width = 745
    Height = 145
    DataSource = DataModule1.dsMutiUser
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 5
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = #32034#24341#20540
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = #20998#23616
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = #23458#25143#21517#31216
        Width = 380
        Visible = True
      end
      item
        Expanded = False
        FieldName = #27979#37327#28857#32534#21495
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = #21452#30005#28304#26631#24535
        Visible = True
      end>
  end
  object Button4: TButton
    Left = 8
    Top = 632
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 6
    OnClick = Button4Click
  end
  object cbDoublePower: TCheckBox
    Left = 336
    Top = 485
    Width = 97
    Height = 17
    Caption = #21452#30005#28304#29992#25143
    TabOrder = 7
    OnClick = cbDoublePowerClick
  end
  object FindDialog1: TFindDialog
    OnFind = FindDialog1Find
    Left = 712
    Top = 8
  end
end
