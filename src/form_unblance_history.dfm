object fm_unbance_history: Tfm_unbance_history
  Left = 192
  Top = 114
  Width = 735
  Height = 578
  Caption = #19981#24179#34913#29992#25143#21382#21490#35760#24405
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object ListBox1: TListBox
    Left = 16
    Top = 64
    Width = 201
    Height = 465
    ItemHeight = 12
    Sorted = True
    TabOrder = 0
    OnClick = ListBox1Click
    OnKeyPress = ListBox1KeyPress
  end
  object DBGrid1: TDBGrid
    Left = 232
    Top = 64
    Width = 473
    Height = 465
    DataSource = unbalance_dm.dsHistory
    TabOrder = 1
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    OnTitleClick = DBGrid1TitleClick
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
        FieldName = #26085#26399
        Visible = True
      end
      item
        Expanded = False
        FieldName = #31867#22411
        Width = 50
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 144
    Top = 32
    Width = 75
    Height = 25
    Caption = #26597#25214
    TabOrder = 2
    OnClick = Button1Click
  end
  object FindDialog1: TFindDialog
    OnFind = FindDialog1Find
    Left = 96
    Top = 32
  end
end
