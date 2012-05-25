object hourcount_dm: Thourcount_dm
  OldCreateOrder = False
  Left = 728
  Top = 136
  Height = 329
  Width = 217
  object ADOQuery1: TADOQuery
    Connection = DataModule1.Conn_acess
    Parameters = <>
    Left = 40
    Top = 16
  end
  object hourCountQuery: TADOQuery
    Connection = DataModule1.Conn_acess
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from ['#25972#28857#37319#38598#32479#35745']')
    Left = 48
    Top = 104
  end
  object dsHourCount: TDataSource
    DataSet = hourCountQuery
    Left = 144
    Top = 104
  end
  object sumInDay: TADOQuery
    Connection = DataModule1.Conn_acess
    Parameters = <>
    Left = 48
    Top = 160
  end
end
