object oneUserYichangeForm: ToneUserYichangeForm
  Left = 74
  Top = 100
  Width = 1085
  Height = 627
  Caption = #24322#24120#21382#21490#35760#24405
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
  object DBGrid2: TDBGrid
    Left = 8
    Top = 8
    Width = 1049
    Height = 529
    DataSource = DataSource1
    ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = #23458#25143#23616#21495
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = #23458#25143#21517#31216
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = #37096#38376#21517#31216
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = #30005#34920#23616#21495
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = #26102#38388
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = #30005#37327
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = #24179#22343#30005#37327
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = #23481#37327
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = #20449#29992#31561#32423
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = #22825#25968
        Width = 26
        Visible = True
      end
      item
        Expanded = False
        FieldName = #20998#26512
        Width = 84
        Visible = True
      end
      item
        Expanded = False
        FieldName = #21453#39304
        Width = 84
        Visible = True
      end
      item
        Expanded = False
        FieldName = #24322#24120#26631#35760
        PickList.Strings = (
          ''
          #27491#24120
          #24322#24120
          #37325#22823#24322#24120
          #24674#22797#27491#24120)
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = #26159#21542#26377#20572#30005#35760#24405
        Width = 88
        Visible = True
      end
      item
        Expanded = False
        FieldName = #26159#21542#26159#22810#34920#29992#25143
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 496
    Top = 560
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 1
    OnClick = Button1Click
  end
  object ADOQuery1: TADOQuery
    Connection = DataModule1.Conn_acess
    Parameters = <
      item
        Name = '1'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select * from ['#30005#37327#24322#24120']'
      'where ['#27979#37327#28857#32534#21495'] = :1 ')
    Left = 168
    Top = 64
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 200
    Top = 64
  end
end
