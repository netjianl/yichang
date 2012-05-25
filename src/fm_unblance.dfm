object unbalanceForm: TunbalanceForm
  Left = 145
  Top = 167
  Width = 589
  Height = 504
  Caption = #19981#24179#34913#25253#34920
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 168
    Height = 12
    Caption = #20197#19979#29992#25143#23558#19981#20877#25554#20837#21040#25253#34920#20013#65306
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 168
    Height = 12
    Caption = #20302#21387#30005#21387#23569#20110#27492#22825#25968#21017#19981#25253#21578#65306
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 80
    Width = 553
    Height = 257
    DataSource = unbalance_dm.dsNotShowTable
    TabOrder = 0
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = #25143#21495
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = #23458#25143#21517#31216
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = #22788#29702#29366#24577
        PickList.Strings = (
          #27491#24120
          #27491#22312#22788#29702
          #20998#23616#22788#29702)
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = #24773#20917#35828#26126
        Width = 150
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 344
    Top = 48
    Width = 65
    Height = 25
    Caption = #20570#25253#34920
    TabOrder = 1
    OnClick = Button1Click
  end
  object DBNavigator1: TDBNavigator
    Left = 16
    Top = 48
    Width = 240
    Height = 25
    DataSource = unbalance_dm.dsNotShowTable
    TabOrder = 2
  end
  object DBMemo1: TDBMemo
    Left = 16
    Top = 344
    Width = 553
    Height = 105
    DataField = #24773#20917#35828#26126
    DataSource = unbalance_dm.dsNotShowTable
    TabOrder = 3
  end
  object Button3: TButton
    Left = 264
    Top = 48
    Width = 75
    Height = 25
    Caption = #26356#26032#21517#31216
    TabOrder = 4
    OnClick = Button3Click
  end
  object dayEdit: TSpinEdit
    Left = 184
    Top = 4
    Width = 49
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object Button2: TButton
    Left = 440
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 6
    Visible = False
    OnClick = Button2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 458
    Width = 581
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
end
