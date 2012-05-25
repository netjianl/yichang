object unbalance_dm: Tunbalance_dm
  OldCreateOrder = False
  Left = 266
  Top = 184
  Height = 411
  Width = 320
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 80
    Top = 24
  end
  object notShowTable: TADOTable
    Connection = DataModule1.Conn_acess
    CursorType = ctStatic
    TableName = #19981#24179#34913#25253#34920#25490#38500#29992#25143
    Left = 56
    Top = 104
  end
  object dsNotShowTable: TDataSource
    DataSet = notShowTable
    Left = 136
    Top = 104
  end
  object queryHistory: TADOQuery
    Connection = DataModule1.Conn_acess
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from ['#19981#24179#34913#21382#21490#34920'] where 1=0')
    Left = 56
    Top = 160
  end
  object dsHistory: TDataSource
    DataSet = queryHistory
    Left = 136
    Top = 160
  end
end
