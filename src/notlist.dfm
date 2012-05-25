object noListForm: TnoListForm
  Left = 394
  Top = 229
  Width = 328
  Height = 499
  Caption = 'noListForm'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object DBGrid1: TDBGrid
    Left = 8
    Top = 48
    Width = 297
    Height = 361
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 32
    Top = 16
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 1
  end
  object Button1: TButton
    Left = 224
    Top = 432
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 2
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 80
    Top = 48
  end
  object ADOQuery1: TADOQuery
    Connection = DataModule1.Conn_acess
    Parameters = <>
    SQL.Strings = (
      'select * from ['#21517#31216']')
    Left = 112
    Top = 48
  end
end
