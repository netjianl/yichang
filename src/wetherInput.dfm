object wetherForm: TwetherForm
  Left = 331
  Top = 236
  Width = 524
  Height = 671
  Caption = #27668#35937#20449#24687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 16
    Top = 56
    Width = 489
    Height = 505
    DataSource = wetherdm.dsWether
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = #26085#26399
        Visible = True
      end
      item
        Expanded = False
        FieldName = #22825#27668
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = #26368#39640#27668#28201
        Visible = True
      end
      item
        Expanded = False
        FieldName = #26368#20302#27668#28201
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 136
    Top = 16
    Width = 240
    Height = 25
    DataSource = wetherdm.dsWether
    TabOrder = 1
  end
  object Button1: TButton
    Left = 400
    Top = 592
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 2
    OnClick = Button1Click
  end
end
