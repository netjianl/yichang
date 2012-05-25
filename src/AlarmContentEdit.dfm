object FormAlarmContent: TFormAlarmContent
  Left = 192
  Top = 110
  Width = 549
  Height = 665
  Caption = #21578#35686#20869#23481#32534#36753
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
    Left = 24
    Top = 59
    Width = 489
    Height = 505
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnTitleClick = DBGrid1TitleClick
    Columns = <
      item
        Expanded = False
        FieldName = #20869#23481#32534#30721
        Visible = True
      end
      item
        Expanded = False
        FieldName = #20869#23481
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 136
    Top = 16
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 1
  end
  object Button1: TButton
    Left = 416
    Top = 587
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 2
    OnClick = Button1Click
  end
  object ADOTable1: TADOTable
    Connection = DataModule1.Conn_acess
    CursorType = ctStatic
    TableName = #21578#35686#23545#29031
    Left = 24
    Top = 24
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 64
    Top = 24
  end
end
