object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 686
  Top = 26
  Height = 711
  Width = 493
  object conn_oracle: TADOConnection
    ConnectionString = 
      'Provider=OraOLEDB.Oracle;Password=yxuser;Persist Security Info=T' +
      'rue;User ID=yxuser;Data Source=ydgl'
    LoginPrompt = False
    Provider = 'OraOLEDB.Oracle'
    Left = 56
    Top = 40
  end
  object query_yichang_avg: TADOQuery
    Connection = conn_oracle
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT  vn.khjh as '#23458#25143#23616#21495',vn.KHMC as '#23458#25143#21517#31216',vn.BMMC '#37096#38376#21517#31216',vn.DBJH as ' +
        #30005#34920#23616#21495','
      
        '      tj_dlxx.kssj as '#26102#38388',tj_dlxx.zxzdl '#30005#37327', t1.avg_zxzdl as '#24179#22343#30005#37327',' +
        'vn.sbrl as '#23481#37327',vn.xydj as '#20449#29992#31561#32423
      
        'FROM gruser.tj_dlxx, (select avg(zxzdl) as avg_zxzdl,cldbh from ' +
        'gruser.tj_dlxx '
      '       where (tj_dlxx.kssj > sysdate - 5) AND tj_dlxx.SJLX=20 '
      '       group by cldbh)  t1,gruser.V_NCYHXX vn'
      'WHERE (tj_dlxx.cldbh = t1.cldbh and'
      '     tj_dlxx.zxzdl < t1.avg_zxzdl*0.6'
      '     and vn.CLDBH = tj_dlxx.cldbh  and t1.avg_zxzdl>99'
      '     and vn.CLDBH = t1.cldbh'
      '     and tj_dlxx.kssj > sysdate - 2 and   tj_dlxx.SJLX=20 )'
      'order by vn.xydj,vn.BMMC,tj_dlxx.zxzdl')
    Left = 152
    Top = 40
  end
  object Conn_acess: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=D:\ji' +
      'an\'#23567#31243#24207'\yichang_version1\yichang.mdb;Mode=Share Deny None;Extende' +
      'd Properties="";Persist Security Info=False;Jet OLEDB:System dat' +
      'abase="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password=' +
      '"";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet' +
      ' OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transacti' +
      'ons=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System' +
      ' Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don'#39't' +
      ' Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica ' +
      'Repair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 32
    Top = 384
  end
  object table_yichang_now1: TADOTable
    Connection = Conn_acess
    CursorType = ctStatic
    TableName = #30005#37327#24322#24120
    Left = 96
    Top = 400
  end
  object tempQuery_ora: TADOQuery
    Connection = conn_oracle
    Parameters = <>
    SQL.Strings = (
      'select * from gruser.tj_dlxx')
    Left = 256
    Top = 40
  end
  object tempQuery_access: TADOQuery
    Connection = Conn_acess
    Parameters = <>
    Left = 208
    Top = 400
  end
  object poweroff_query: TADOQuery
    Connection = conn_oracle
    Parameters = <>
    Left = 344
    Top = 48
  end
  object dianliang_query: TADOQuery
    Connection = conn_oracle
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select to_date(to_char(kssj,'#39'yyyy-mm-dd'#39'),'#39'yyyy-mm-dd'#39') kssj,'
      '       zxzdl,cldbh '
      'from gruser.tj_dlxx  where cldbh = '#39'41078'#39' and'
      ' kssj > to_date('#39'2008-02-23'#39','#39'yyyy-mm-dd'#39') -1 '
      'and kssj < to_date('#39'2008-03-24'#39','#39'yyyy-mm-dd'#39') +1'
      'order by kssj ')
    Left = 200
    Top = 104
  end
  object table_yichang_now: TADOQuery
    Connection = Conn_acess
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from ['#30005#37327#24322#24120']'
      'where'
      ' ['#24322#24120#26631#35760'] <>  '#39#24674#22797#27491#24120#39
      ' or ['#24322#24120#26631#35760'] is null')
    Left = 96
    Top = 480
  end
  object user_query: TADOQuery
    Connection = conn_oracle
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select khjh '#25143#21495',dbjh '#34920#21495',zdljdz '#32456#31471#36923#36753#22320#22336','
      'cldbh '#27979#37327#28857#32534#21495', khmc '#23458#25143#21517#31216',bmmc '#20998#23616
      'from gruser.v_ncyhxx')
    Left = 352
    Top = 104
  end
  object dsUser: TDataSource
    DataSet = user_query
    Left = 400
    Top = 104
  end
  object mutliUser_query: TADOQuery
    Connection = Conn_acess
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'index'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select * from ['#22810#34920#29992#25143']'
      'where ['#32034#24341#20540'] = :index')
    Left = 200
    Top = 480
  end
  object dsMutiUser: TDataSource
    DataSet = mutliUser_query
    Left = 272
    Top = 480
  end
  object mutliUserList_query: TADOQuery
    Connection = Conn_acess
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from ['#22810#34920#29992#25143']'
      'order by ['#32034#24341#20540'] desc')
    Left = 208
    Top = 536
  end
  object dsMultiUserList: TDataSource
    DataSet = mutliUserList_query
    Left = 296
    Top = 536
  end
  object query_mutilUser_dianliang: TADOQuery
    Connection = conn_oracle
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select  sum(zxzdl) '#30005#37327',  kssj '#26085#26399' from  '
      '    (select zxzdl, to_char(kssj,'#39'yyyy-mm-dd'#39') kssj '
      '          from gruser.tj_dlxx  '
      '          where cldbh = '#39'41558'#39' or cldbh = '#39'41560'#39')'
      'group by kssj'
      'order by kssj desc')
    Left = 41
    Top = 120
  end
  object dsMutliUser_dianliang: TDataSource
    DataSet = query_mutilUser_dianliang
    Left = 40
    Top = 176
  end
  object query_mutilUser_dianliang_lastyear: TADOQuery
    Connection = conn_oracle
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select  sum(zxzdl) '#30005#37327',  kssj '#26085#26399' '
      'from (select zxzdl, to_char(kssj,'#39'yyyy/mm/dd'#39') kssj '
      '         from gruser.tj_dlxx  '
      '              where ( cldbh = '#39'31836'#39' or cldbh = '#39'31838'#39' ) '
      
        '                    and kssj > to_date('#39'2007-02-04'#39','#39'yyyy-mm-dd'#39 +
        ')  '
      
        '                    and kssj < to_date('#39'2007-05-06'#39','#39'yyyy-mm-dd'#39 +
        ')  '
      '                    and sjlx = 20'
      '     ) '
      'group by kssj '
      'order by kssj desc')
    Left = 73
    Top = 232
  end
  object ds_mutilUser_dianliang_lastyear: TDataSource
    DataSet = query_mutilUser_dianliang_lastyear
    Left = 72
    Top = 288
  end
  object dianliang_lastyear: TADOQuery
    Connection = conn_oracle
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select to_date(to_char(kssj,'#39'yyyy-mm-dd'#39'),'#39'yyyy-mm-dd'#39') kssj,'
      '       zxzdl,cldbh '
      'from gruser.tj_dlxx  where cldbh = '#39'41078'#39' and'
      ' kssj > to_date('#39'2008-02-23'#39','#39'yyyy-mm-dd'#39') -1 '
      'and kssj < to_date('#39'2008-03-24'#39','#39'yyyy-mm-dd'#39') +1'
      'order by kssj ')
    Left = 200
    Top = 168
  end
end
