object repTian2Form: TrepTian2Form
  Left = 288
  Top = 138
  Width = 1063
  Height = 702
  Caption = 'repTian2Form'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 384
    Width = 12
    Height = 12
    Caption = #20174
  end
  object Label2: TLabel
    Left = 135
    Top = 384
    Width = 12
    Height = 12
    Caption = #21040
  end
  object Label3: TLabel
    Left = 24
    Top = 16
    Width = 48
    Height = 12
    Caption = #20840#37096#29992#25143
  end
  object Label4: TLabel
    Left = 544
    Top = 72
    Width = 156
    Height = 12
    Caption = #20197#19979#29992#25143#23646#20110#24403#21069#22810#30005#34920#29992#25143
  end
  object Label5: TLabel
    Left = 544
    Top = 40
    Width = 84
    Height = 12
    Caption = #30005#34920#29992#25143#21517#31216#65306
  end
  object dtpBegin: TDateTimePicker
    Left = 24
    Top = 378
    Width = 89
    Height = 20
    Date = 39630.653550706020000000
    Time = 39630.653550706020000000
    TabOrder = 0
  end
  object dtpEnd: TDateTimePicker
    Left = 150
    Top = 379
    Width = 91
    Height = 20
    Date = 39721.653550706020000000
    Time = 39721.653550706020000000
    TabOrder = 1
  end
  object Button1: TButton
    Left = 248
    Top = 376
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 344
    Top = 376
    Width = 593
    Height = 281
    Lines.Strings = (
      #25143#21495' '#21517#31216' '#25152#23646#20998#23616' '#21464#21387#22120#23481#37327' '#26368#22823#36127#33655' '#24179#22343#36127#33655' '#26368#23567#36127#33655)
    TabOrder = 3
  end
  object cldbhMemo: TMemo
    Left = 24
    Top = 416
    Width = 281
    Height = 241
    TabOrder = 4
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 40
    Width = 809
    Height = 305
    DataSource = DataModule1.dsUser
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
  object Button2: TButton
    Left = 848
    Top = 64
    Width = 75
    Height = 25
    Caption = #26597#25214
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 848
    Top = 104
    Width = 75
    Height = 25
    Caption = #21152#20837
    TabOrder = 7
    OnClick = Button3Click
  end
  object FindDialog1: TFindDialog
    OnFind = FindDialog1Find
    Left = 712
    Top = 8
  end
end
