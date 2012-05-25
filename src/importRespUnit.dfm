object importRespForm: TimportRespForm
  Left = 222
  Top = 74
  Width = 847
  Height = 648
  Caption = 'importRespForm'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 60
    Height = 12
    Caption = #23548#20837#30340#25991#20214
  end
  object SpeedButton1: TSpeedButton
    Left = 707
    Top = 11
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = SpeedButton1Click
  end
  object EditExcelFile: TEdit
    Left = 72
    Top = 11
    Width = 625
    Height = 20
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 40
    Width = 817
    Height = 481
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    OnTitleClick = DBGrid1TitleClick
  end
  object Button1: TButton
    Left = 744
    Top = 8
    Width = 75
    Height = 25
    Caption = #24320#22987#23548#20837
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 536
    Width = 817
    Height = 73
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clScrollBar
    Lines.Strings = (
      #35828#26126#65306
      
        '1'#12289#24517#39035#20197#25143#21495#20316#20026#31532#19968#20010#23383#27573#65292#21453#39304#20316#20026#31532'3'#20010#23383#27573','#31532'4'#21015#20316#20026#26631#35782#23383#27573#65292#20540#20026#65306'c'#65306#22788#29702#20013#65292'f'#65306#24322#24120#65292' '#20854#20182#65306#27491#24120#65292#24182#19988#24517#39035#24378#21046#20026#23383 +
        #31526#20018#65292#21542#21017#21487#33021
      #26080#27861#23548#20837#25968#25454
      '2'#12289'excel'#20013#24517#39035#26377'sheet1'#34920#26684#65292#24182#19988#21453#39304#22312#36825#20010#34920#26684#20013
      '3'#12289#20808#36873#25991#20214#65292#22312#25968#25454#26174#31034#20986#26469#21518#20877#24320#22987#23548#20837)
    ReadOnly = True
    TabOrder = 3
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 176
    Top = 96
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.xls'
    Filter = #30005#23376#34920#26684#25991#20214'|*.xls'
    Left = 448
    Top = 8
  end
  object ADOTable1: TADOTable
    CursorType = ctStatic
    TableDirect = True
    TableName = 'Sheet1$'
    Left = 136
    Top = 96
  end
end
