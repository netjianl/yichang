object wetherdm: Twetherdm
  OldCreateOrder = False
  Left = 688
  Top = 469
  Height = 344
  Width = 240
  object tableWether: TADOTable
    Connection = DataModule1.Conn_acess
    CursorType = ctStatic
    TableName = #27668#35937#20449#24687
    Left = 32
    Top = 16
  end
  object dsWether: TDataSource
    DataSet = tableWether
    Left = 104
    Top = 16
  end
  object queryWether: TADOQuery
    Connection = DataModule1.Conn_acess
    Parameters = <>
    SQL.Strings = (
      'select * from ['#27668#35937#20449#24687']')
    Left = 40
    Top = 120
  end
  object queryWetherLastyear: TADOQuery
    Connection = DataModule1.Conn_acess
    Parameters = <>
    SQL.Strings = (
      'select * from ['#27668#35937#20449#24687']')
    Left = 120
    Top = 120
  end
end
