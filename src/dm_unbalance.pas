//------------------------------------------------------------------------------
//   模块名称:  dm_unbalance
//   功能:      处理高压电流，高压电压，低压电压，低压电流这4个不平衡报表
//              增加了不平衡历史表 2009-9
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------
unit dm_unbalance;

interface

uses
  SysUtils, Classes, Controls, DB, ADODB;

type
  Tunbalance_dm = class(TDataModule)
    ADOQuery1: TADOQuery;
    notShowTable: TADOTable;
    dsNotShowTable: TDataSource;
    queryHistory: TADOQuery;
    dsHistory: TDataSource;
  private
    { Private declarations }
    //procedure updateHistoryDay(voltype:string);overload;
  public
    { Public declarations }
    //得到高压电压异常的用户
    procedure copyUnnormalByVoltageInHighVoltage(aDay: TDate); //高压电压
    procedure copyUnnormalbyVoltageInLowVoltage(aDay: TDate); //低压电压
    procedure copyUnnormalByCurrentInHighVoltage(aDay: TDate);
    procedure copyUnnormalByCurrentInLowVoltage(aDay: TDate);
    //删除那些指定为正常的用户，在“不平衡报表排除用户”表中
    procedure deleteCheckUser;
    procedure deleteLowVolNot3Day(day:integer);

    //将当前用户表的数据插入到历史表中
    procedure copyCurDay2History;
    //得到历史表中的所有用户名
    procedure get_all_names(namelist:tstrings);
    //得到历史表中某个用户的记录，数据在queryHistory中
    procedure getHistoryByName(aname:String);
    //对于电压异常用户，更新它的连续发生天数
    procedure updateHistoryDay;overload;
    //得到历史表中最后一天是哪一天
    function getLastProcDay:Tdate;

    procedure updateCheckUserNames;
    //反极性用户
    //procedure getAntiPolarUser;

  end;

var
  unbalance_dm: Tunbalance_dm;

implementation

uses dm, V_NCYHXX_unit, iniConfig;

{$R *.dfm}

procedure Tunbalance_dm.copyUnnormalByVoltageInHighVoltage(aDay: TDate);
var
  sSql: string;
  query1: TadoQuery;
  QueryAccess: TADoQuery;
begin
  sSql :=               //
    'SELECT vn.KHJH, vn.KHMC, vn.KXMC, vn.BMMC, vn.DBJH, dd.SJSJ, dd.AXDY, ' +
    '             dd.BXDY, dd.CXDY, dd.AXDL, dd.BXDL, dd.CXDL, vn.XYDJ' +
    '  FROM gruser.DATA_SSLSD dd, '+ aIniConfig.V_NCYHXX + ' vn' +
    '  WHERE '+
    '          (  (((dd.AXDY<85) or (dd.CXDY<85)) AND (dd.BXDY=0))'+
    '             OR'+
    '             ((dd.BXDY=0) AND ((dd.AXDY<55) or (dd.CXDY<55)) AND '+
    '               (dd.BXDL +dd.AXDL+dd.CXDL > 0))'+
    '          ) AND' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
                                  #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
                                                       #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　　dd.SJSJ<to_date(' +
                               #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
                               #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB>1) ' +
    '  ORDER BY vn.XYDJ, vn.BMMC, vn.KHJH';
{
  sSql := 'SELECT vn.KHJH, vn.KHMC, vn.KXMC, vn.BMMC, vn.DBJH, dd.SJSJ, dd.AXDY, ' +
    ' dd.BXDY, dd.CXDY, dd.AXDL, dd.BXDL, dd.CXDL, vn.XYDJ' +
    ' FROM gruser.DATA_SSLSD dd, gruser.V_NCYHXX vn' +
    '    WHERE (dd.AXDY<90) AND' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
                                  #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
                                                       #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　　dd.SJSJ<to_date(' +
                               #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
                               #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB>1) ' +
    '        OR ' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
                                #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
                                #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　　dd.SJSJ<to_date(' +
                                #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
                                #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB>1) AND ' +
    '          (dd.CXDY<90)' +
    '     ORDER BY vn.XYDJ, vn.BMMC, vn.KHJH';
 }
  query1 := DataModule1.runSql(sSql);

  QueryAccess := TADOQuery.Create(self);
  QueryAccess.Connection := DataModule1.Conn_acess;
  sSql := 'delete * from [高压电压]';
  DataModule1.Conn_acess.Execute(sSql);
  sSql := 'select * from [高压电压]';
  QueryAccess.SQL.Text := sSql;
  QueryAccess.Open;

  if (query1.Active = true) then
  begin
    with query1 do
    begin
      first;
      while not eof do
      begin
        if (pos('路灯', FieldbyName('KXMC').AsString) = 0) then
        begin
          QueryAccess.Append;
          QueryAccess.FieldByName('户号').AsString := FieldbyName('KHJH').AsString;
          QueryAccess.FieldByName('线路').AsString := FieldbyName('KXMC').AsString;
          QueryAccess.FieldByName('客户名称').AsString := FieldbyName('KHMC').AsString;
          QueryAccess.FieldByName('部门名称').AsString := FieldbyName('BMMC').AsString;
          QueryAccess.FieldByName('电表局号').AsString := FieldbyName('DBJH').AsString;
          QueryAccess.FieldByName('数据时间').AsString := FieldbyName('SJSJ').AsString;
          QueryAccess.FieldByName('A相电压').AsString := FieldbyName('AXDY').AsString;
          QueryAccess.FieldByName('B相电压').AsString := FieldbyName('BXDY').AsString;
          QueryAccess.FieldByName('C相电压').AsString := FieldbyName('CXDY').AsString;
          QueryAccess.FieldByName('A相电流').AsString := FieldbyName('AXDL').AsString;
          QueryAccess.FieldByName('B相电流').AsString := FieldbyName('BXDL').AsString;
          QueryAccess.FieldByName('C相电流').AsString := FieldbyName('CXDL').AsString;
          QueryAccess.FieldByName('信用等级').AsString := FieldbyName('XYDJ').AsString;
          QueryAccess.Post;
        end;
        next;
      end;
    end;
  end;
  QueryAccess.Free;

  //删除那些电流为0的记录
  //sSql := 'delete from [高压电压] '
  //       +'   where [A相电流]+[B相电流]+[C相电流] < 0.001';
  //DataModule1.Conn_acess.Execute(sSql);  
end;

procedure Tunbalance_dm.copyUnnormalbyVoltageInLowVoltage(aDay: TDate);
var
  sSql: string;
  query1: TadoQuery;
  QueryAccess: TADoQuery;
begin
  sSql := 'SELECT vn.KHJH, vn.KHMC,vn.KXMC, vn.BMMC, vn.DBJH, dd.SJSJ, dd.AXDY, ' +
    ' dd.BXDY, dd.CXDY, dd.AXDL, dd.BXDL, dd.CXDL, vn.XYDJ, vn.ZDLJDZ' +
    ' FROM gruser.DATA_SSLSD dd, '+ aIniConfig.V_NCYHXX + ' vn' +
    '    WHERE (dd.AXDY<180) AND' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　　dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB=1) ' +
    '        OR ' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　　dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB=1) AND ' +
    '          (dd.BXDY<180)' +
    '        OR ' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　　dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB=1) AND ' +
    '          (dd.CXDY<180)' +
    '     ORDER BY vn.XYDJ, vn.BMMC, vn.KHJH';
  query1 := DataModule1.runSql(sSql);

  QueryAccess := TADOQuery.Create(self);
  QueryAccess.Connection := DataModule1.Conn_acess;
  sSql := 'delete * from [低压电压]';
  DataModule1.Conn_acess.Execute(sSql);
  sSql := 'select * from [低压电压]';
  QueryAccess.SQL.Text := sSql;
  QueryAccess.Open;

  if (query1.Active = true) then
    with query1 do
    begin
      first;
      while not eof do
      begin
        if (pos('路灯', FieldbyName('KXMC').AsString) = 0) then
        begin
          QueryAccess.Append;
          QueryAccess.FieldByName('户号').AsString := FieldbyName('KHJH').AsString;
          QueryAccess.FieldByName('客户名称').AsString := FieldbyName('KHMC').AsString;
          QueryAccess.FieldByName('线路').AsString := FieldbyName('KXMC').AsString;
          QueryAccess.FieldByName('部门名称').AsString := FieldbyName('BMMC').AsString;
          QueryAccess.FieldByName('电表局号').AsString := FieldbyName('DBJH').AsString;
          QueryAccess.FieldByName('数据时间').AsString := FieldbyName('SJSJ').AsString;
          QueryAccess.FieldByName('A相电压').AsString := FieldbyName('AXDY').AsString;
          QueryAccess.FieldByName('B相电压').AsString := FieldbyName('BXDY').AsString;
          QueryAccess.FieldByName('C相电压').AsString := FieldbyName('CXDY').AsString;
          QueryAccess.FieldByName('A相电流').AsString := FieldbyName('AXDL').AsString;
          QueryAccess.FieldByName('B相电流').AsString := FieldbyName('BXDL').AsString;
          QueryAccess.FieldByName('C相电流').AsString := FieldbyName('CXDL').AsString;
          QueryAccess.FieldByName('信用等级').AsString := FieldbyName('XYDJ').AsString;
          QueryAccess.FieldByName('终端地址').AsString := FieldbyName('ZDLJDZ').AsString;
          QueryAccess.Post;
        end;
        next;
      end;
    end;
  QueryAccess.Free;

  //删除那些电流为0的记录
  //sSql := 'delete from [低压电压] '
  //      + '   where [A相电流]+[B相电流]+[C相电流] < 0.001' ;
  //DataModule1.Conn_acess.Execute(sSql);  
  
end;

procedure Tunbalance_dm.copyUnnormalByCurrentInHighVoltage(aDay: TDate);
var
  sSql: string;
  query1: TadoQuery;
  QueryAccess: TADoQuery;
begin

  sSql := 'SELECT vn.KHJH, vn.KHMC,vn.KXMC, vn.DBJH, dd.SJSJ, dd.AXDL*dd.CTBB AXDL, ' +
    '       dd.BXDL*dd.ctBB BXDL, dd.CXDL*dd.ctbb CXDL, vn.BMMC, vn.XYDJ ' +
    '  FROM gruser.DATA_sslsd dd, '+ aIniConfig.V_NCYHXX +  ' vn' +
    '  WHERE (dd.CLDBH=vn.CLDBH) AND ' +
    '        (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '        (abs(dd.AXDl/(dd.CXDL+0.00001)-1)>1) AND ' +
    '        (dd.PTBB>1) AND ' +
    '        ((dd.CXDL+dd.BXDL+dd.AXDL)*dd.CTBB>2)' +
    '      OR (dd.CLDBH=vn.CLDBH) AND ' +
    '        (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '         (dd.PTBB>1) AND ' +
    '         ((dd.CXDL+dd.BXDL+dd.AXDL)*dd.CTBB>2) AND ' +
    '         (abs(dd.CXDl/(dd.AXDL+0.00001)-1)>1)' +
    '  ORDER BY vn.XYDJ, vn.BMMC, vn.KHJH';

  query1 := DataModule1.runSql(sSql);

  QueryAccess := TADOQuery.Create(self);
  QueryAccess.Connection := DataModule1.Conn_acess;
  sSql := 'delete * from [高压电流]';
  DataModule1.Conn_acess.Execute(sSql);
  sSql := 'select * from [高压电流]';
  QueryAccess.SQL.Text := sSql;
  QueryAccess.Open;

  if (query1.Active = true) then
    with query1 do
    begin
      first;
      while not eof do
      begin
        if (pos('路灯', FieldbyName('KXMC').AsString) = 0) then
        begin
          QueryAccess.Append;
          QueryAccess.FieldByName('户号').AsString := FieldbyName('KHJH').AsString;
          QueryAccess.FieldByName('客户名称').AsString := FieldbyName('KHMC').AsString;
          QueryAccess.FieldByName('线路').AsString := FieldbyName('KXMC').AsString;
          QueryAccess.FieldByName('电表局号').AsString := FieldbyName('DBJH').AsString;
          QueryAccess.FieldByName('数据时间').AsString := FieldbyName('SJSJ').AsString;
          QueryAccess.FieldByName('部门名称').AsString := FieldbyName('BMMC').AsString;
          QueryAccess.FieldByName('A相电流').AsString := FieldbyName('AXDL').AsString;
          QueryAccess.FieldByName('B相电流').AsString := FieldbyName('BXDL').AsString;
          QueryAccess.FieldByName('C相电流').AsString := FieldbyName('CXDL').AsString;
          QueryAccess.FieldByName('信用等级').AsString := FieldbyName('XYDJ').AsString;
          QueryAccess.Post;
        end;
        next;
      end;
    end;
  QueryAccess.Free;

  //删除那些电流告警比较少记录的
  sSql := 'delete from [高压电流] ' +
    '   where [户号]  in ( select [户号] from [高压电流] ' +
    '                         group by [户号]' +
    '                         having count([户号])<4)';
  DataModule1.Conn_acess.Execute(sSql);
end;

procedure Tunbalance_dm.copyUnnormalByCurrentInLowVoltage(aDay: TDate);
var
  sSql: string;
  query1: TadoQuery;
  QueryAccess: TADoQuery;
begin
  {
  sSql := 'SELECT vn.KHJH, vn.KHMC, vn.DBJH, dd.SJSJ, dd.AXDL*dd.CTBB AXDL, ' +
          '       dd.BXDL*dd.ctBB BXDL, dd.CXDL*dd.ctbb CXDL, vn.BMMC, vn.XYDJ ' +
          '  FROM gruser.DATA_sslsd dd, ' + aIniConfig.V_NCYHXX + ' vn '+
          '  WHERE (dd.CLDBH=vn.CLDBH) AND ' +
          '        (dd.SJSJ>= to_date('+
                   #39 + formatdatetime('yyyy-mm-dd',aday-1 )+ #39 + ','+
                   #39 +'yyyy-mm-dd'+#39+') and '+
          '　　　　dd.SJSJ<to_date('+
                   #39 + formatdatetime('yyyy-mm-dd',aday+1 )+ #39 + ','+
                   #39 +'yyyy-mm-dd'+#39+')) and '+
          '        (abs(dd.AXDl/(dd.CXDL+0.00001)-1)>1) AND ' +
          '        (dd.PTBB=1) AND '+
          '        ((dd.CXDL+dd.BXDL+dd.AXDL)*dd.CTBB>40)'+
          '      OR (dd.CLDBH=vn.CLDBH) AND ' +
          '        (dd.SJSJ>= to_date('+
                   #39 + formatdatetime('yyyy-mm-dd',aday-1 )+ #39 + ','+
                   #39 +'yyyy-mm-dd'+#39+') and '+
          '　　　　dd.SJSJ<to_date('+
                   #39 + formatdatetime('yyyy-mm-dd',aday+1 )+ #39 + ','+
                   #39 +'yyyy-mm-dd'+#39+')) and '+
          '         (dd.PTBB=1) AND ' +
          '         ((dd.CXDL+dd.BXDL+dd.AXDL)*dd.CTBB>40) AND '+
          '         (abs(dd.CXDl/(dd.AXDL+0.00001)-1)>1)'+
          '  ORDER BY vn.XYDJ, vn.BMMC, vn.KHJH';
  }
  sSql := 'SELECT vn.KHJH, vn.KHMC,vn.KXMC, vn.DBJH, dd.SJSJ, dd.AXDL*dd.CTBB AXDL, ' +
    '       dd.BXDL*dd.CTBB BXDL, dd.CXDL*dd.CTBB CXDL, vn.BMMC, vn.XYDJ ' +
    '  FROM gruser.DATA_sslsd dd, '+ aIniConfig.V_NCYHXX + ' vn ' +
    '  WHERE (dd.CLDBH=vn.CLDBH) AND' +
    '        (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '　　　　dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '        (dd.PTBB=1)  and  ' +
    '        ( (((dd.AXDL*dd.CTBB<0.5) or (dd.CXDL*dd.CTBB<0.5) or (dd.BXDL*dd.CTBB<0.5))' +
    '                and  (dd.AXDL+dd.BXDL+dd.CXDL)*dd.CTBB>50)' +
    '          or ' +
    '          (((dd.AXDL*dd.CTBB<5) or (dd.CXDL*dd.CTBB<5) or (dd.BXDL*dd.CTBB<5)) ' +
    '                  and  (dd.AXDL+dd.BXDL+dd.CXDL)*dd.CTBB>100)' +
    '        )' +
    '  ORDER BY vn.BMMC, vn.KHJH';

  query1 := DataModule1.runSql(sSql);

  QueryAccess := TADOQuery.Create(self);
  QueryAccess.Connection := DataModule1.Conn_acess;
  sSql := 'delete * from [低压电流]';
  DataModule1.Conn_acess.Execute(sSql);
  sSql := 'select * from [低压电流]';
  QueryAccess.SQL.Text := sSql;
  QueryAccess.Open;

  if (query1.Active = true) then
    with query1 do
    begin
      first;
      while not eof do
      begin
        if (pos('路灯', FieldbyName('KXMC').AsString) = 0) then
        begin
          QueryAccess.Append;
          QueryAccess.FieldByName('户号').AsString := FieldbyName('KHJH').AsString;
          QueryAccess.FieldByName('客户名称').AsString := FieldbyName('KHMC').AsString;
          QueryAccess.FieldByName('线路').AsString := FieldbyName('KXMC').AsString;
          QueryAccess.FieldByName('电表局号').AsString := FieldbyName('DBJH').AsString;
          QueryAccess.FieldByName('数据时间').AsString := FieldbyName('SJSJ').AsString;
          QueryAccess.FieldByName('部门名称').AsString := FieldbyName('BMMC').AsString;
          QueryAccess.FieldByName('A相电流').AsString := FieldbyName('AXDL').AsString;
          QueryAccess.FieldByName('B相电流').AsString := FieldbyName('BXDL').AsString;
          QueryAccess.FieldByName('C相电流').AsString := FieldbyName('CXDL').AsString;
          QueryAccess.FieldByName('信用等级').AsString := FieldbyName('XYDJ').AsString;
          QueryAccess.Post;
        end;
        next;
      end;
    end;
  QueryAccess.Free;

  //删除那些电流告警比较少记录的
  sSql := 'delete from [低压电流] ' +
    '   where [户号]  in ( select [户号] from [低压电流] ' +
    '                         group by [户号]' +
    '                         having count([户号])<4)';
  DataModule1.Conn_acess.Execute(sSql);

end;

{
procedure Tunbalance_dm.getAntiPolarUser;
var
  sSql: string;
  aQuery, aQueryTmp: Tadoquery;

begin
  sSql := 'SELECT vn.cldbh, vn.KHJH, vn.KHMC, vn.DBJH, vn.BMMC, td.KSSJ, td.ZXZDL, td.FXZDL' +
    '　FROM gruser.tj_dlxx td, ' + aIniConfig.V_NCYHXX + ' vn ' +
    '  WHERE td.CLDBH = vn.CLDBH AND ((td.KSSJ>=trunc(sysdate-3)) AND (td.FXZDL>0)) ' +
    '  ORDER BY vn.BMMC';
  aQuery := tadoquery.Create(self);
  aQuery.Connection := DataModule1.conn_oracle;
  aQueryTmp := tadoquery.Create(self);
  aQueryTmp.Connection := DataModule1.conn_oracle;

  DataModule1.runSql(sSql, aQuery);

  while aQuery.Eof do
  begin
    sSql := 'SELECT vn.KHJH, vn.KHMC, vn.DBJH, dd.AXyggl, dd.BXyggl, dd.CXyggl,dd.yggl' +
      '   FROM gruser.DATA_sslsd dd, ' + aIniConfig.V_NCYHXX + ' vn ' +
      '   WHERE (dd.CLDBH=vn.CLDBH)  AND dd.SJSJ>=trunc(sysdate)  ' +
      '         AND  (dd.yggl<(dd.axyggl+dd.bxyggl+dd.cxyggl)*0.5) ' +
      '         and dd.cldbh = ' + #39 + aQuery.fieldbyname('cldbh').AsString + #39 +
      '         and rownum<=2 ' +
      '   ORDER BY vn.KHJH, dd.yggl';
    datamodule1.runSql(sSql, aQueryTmp);
    if(aqueryTmp.FieldByName('KHJH').AsString = '')then
    begin
    end;
    aQuery.next;
  end;
  aQuery.Free;
end;
}

procedure Tunbalance_dm.deleteCheckUser;
Var
  aSql :String;
begin
  aSql := 'delete from [低压电流] ' +
          '  where [户号] in (select [户号] from [不平衡报表排除用户]'+
          '                      where [处理状态] = '+ #39 + '正常' + #39 + ') ';
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'delete from [高压电流] ' +
          '  where [户号] in (select [户号] from [不平衡报表排除用户]'+
          '                      where [处理状态] = '+ #39 + '正常' + #39 + ') ';
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'delete from [低压电压] ' +
          '  where [户号] in (select [户号] from [不平衡报表排除用户]'+
          '                      where [处理状态] = '+ #39 + '正常' + #39 + ') ';
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'delete from [高压电压] ' +
          '  where [户号] in (select [户号] from [不平衡报表排除用户]'+
          '                      where [处理状态] = '+ #39 + '正常' + #39 + ') ';
  datamodule1.Conn_acess.Execute(aSql);

  aSql := 'update [低压电流] a, [不平衡报表排除用户] b  ' +
          '   set a.[情况说明] = b.[情况说明]'+
          '   where a.[户号] = b.[户号] ';// +
          //'      and b.[处理状态] <> '+ #39 + '正常' + #39;
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'update [低压电压] a, [不平衡报表排除用户] b  ' +
          '   set a.[情况说明] = b.[情况说明]'+
          '   where a.[户号] = b.[户号] ';// +
          //'      and b.[处理状态] <> '+ #39 + '正常' + #39;
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'update [高压电流] a, [不平衡报表排除用户] b  ' +
          '   set a.[情况说明] = b.[情况说明]'+
          '   where a.[户号] = b.[户号] ';// +
          //'      and b.[处理状态] <> '+ #39 + '正常' + #39;
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'update [高压电压] a, [不平衡报表排除用户] b  ' +
          '   set a.[情况说明] = b.[情况说明]'+
          '   where a.[户号] = b.[户号] ';// +
          //'      and b.[处理状态] <> '+ #39 + '正常' + #39;
  datamodule1.Conn_acess.Execute(aSql);

  

end;

procedure Tunbalance_dm.updateCheckUserNames;
var
  strName:String;
begin
  with notShowTable do
  begin
    try
      DisableControls;
      first;
      while not eof do
      begin
        strName := dm_userInfo.getName_byUserId_oracle(fieldbyname('户号').AsString);
        if(strName <> '')then
        begin
          edit;
          fieldbyname('客户名称').AsString := strName;
          post;
        end;
        next;
      end;
    finally
      EnableControls;
    end;
  end;
end;

procedure Tunbalance_dm.copyCurDay2History;
var
  sSql :String;
begin
  sSql := 'insert into [不平衡历史表]([户号],[客户名称],[日期],[类型])' +
          '      SELECT [户号],max([客户名称]) as [客户名称1], '+
          '             min([数据时间]) as 日期,"电流" as [类型]'+
          '         from [低压电流]' +
          '         group by [户号]';
  datamodule1.Conn_acess.Execute(sSql);

  sSql := 'insert into [不平衡历史表]([户号],[客户名称],[日期],[类型])' +
          '      SELECT [户号],max([客户名称]) as [客户名称1], '+
          '             min([数据时间]) as 日期,"电流" as [类型]'+
          '         from [高压电流]' +
          '         group by [户号]';
  datamodule1.Conn_acess.Execute(sSql);

  sSql := 'insert into [不平衡历史表]([户号],[客户名称],[日期],[类型])' +
          '      SELECT [户号],max([客户名称]) as [客户名称1], '+
          '             min([数据时间]) as 日期,"电压" as [类型]'+
          '         from [低压电压]' +
          '         group by [户号]';
  datamodule1.Conn_acess.Execute(sSql);

  sSql := 'insert into [不平衡历史表]([户号],[客户名称],[日期],[类型])' +
          '      SELECT [户号],max([客户名称]) as [客户名称1], '+
          '             min([数据时间]) as 日期,"电压" as [类型]'+
          '         from [高压电压]' +
          '         group by [户号]';
  datamodule1.Conn_acess.Execute(sSql);

end;

procedure Tunbalance_dm.get_all_names(namelist: tstrings);
var
  sSql :string;
  aQuery :TADOQuery;
begin
  sSql := 'select distinct([客户名称]) from [不平衡历史表]';
  aQuery := DataModule1.runSql_access(sSQL);
  if(aQuery.Active )then
  begin
    while not aQuery.Eof do
    begin
      namelist.Add(aquery.Fields[0].AsString);
      aQuery.next;
    end;
  end;
end;

procedure Tunbalance_dm.getHistoryByName(aname: String);
var
  sSql :string;
begin
  sSql := 'select * from [不平衡历史表]' +
          '  where [客户名称] = ' + #39 + aName + #39;
  DataModule1.runSql_access(sSql, queryHistory);
end;

procedure Tunbalance_dm.updateHistoryDay;
begin
  //updateHistoryDay('低压电压');
  //updateHistoryDay('高压电压');
end;


{
procedure Tunbalance_dm.updateHistoryDay(voltype: string);
var
  aQuery:TadoQuery;
  aHistoryQuery:TADoquery;
  sSql:string;
  count:integer;
  aName:string;
  aDate:Tdate;
begin
  aQuery := TADOQuery.Create(self);
  aHistoryQuery := TADOQuery.Create(self);
  //aquery.Connection := datamodule1.Conn_acess;
  sSql := 'select [客户名称],min(DateValue([数据时间])) from [' + voltype + ']'
         +'  group by [客户名称]';
  DataModule1.runSql_access(sSql, aQuery);
  aQuery.First;
  while not aQuery.Eof do
  begin
    aName := aQuery.Fields[0].AsString;
    aDate := aQuery.Fields[1].AsDatetime;
    sSql := 'select * from ( select distinct(DateValue([日期])) as 发生日期'
           +'                  from  [不平衡历史表]'
           +'                 where [客户名称] = ' + #39 + aName + #39
           +'                 and [类型] = ' + #39 + '电压' + #39
           +'              )'
           +'order by  发生日期 desc';
    DataModule1.runSql_access(sSql, aHistoryQuery);
    aHistoryQuery.First;
    count := 0;
    while not aHistoryQuery.Eof do
    begin
      if(adate - aHistoryQuery.Fields[0].AsDateTime = count)then
      begin
        inc(count);
      end
      else
      begin
        break;
      end;
    end;
    sSql := 'update [' + voltype + '] set [持续天数]= '
           +   inttostr(count)
           +'  where [客户名称] = ' + #39 + aName + #39;
    DataModule1.execSqu_access(sSql);
    aHistoryQuery.Next;
    aQuery.Next;
  end;

  aQuery.Free;
  aHistoryQuery.Free;
end;
}


(*delete from [低压电压] where [户号] not in
(
  select [户号] from
  (
    select  [户号],count( * ) as c1
    from (      SELECT distinct [日期],[户号]
                FROM 不平衡历史表
               WHERE (((不平衡历史表.类型)="电压") AND ((不平衡历史表.日期)>#7/13/2009# And (不平衡历史表.日期)<#10/15/2009#))
         )
    group by [户号]
  )
  where c1 > 3
)
*)
procedure Tunbalance_dm.deleteLowVolNot3Day(day:integer);
var
  strDistinctTable :String;
  strCountTable:String;
  strIdTable:String;
  strDelete:String;
begin
  strDistinctTable :=
    'SELECT distinct [日期],[户号]   '+
    '  FROM [不平衡历史表] ' +
    '  WHERE (([类型]="电压") '+
    '    AND  ([日期]<=#'+FormatDateTime('m/d/yyyy', now -1 ) + '# '+
    '               And [日期]>=#'+FormatDateTime('m/d/yyyy', now - 1 - day)+'#)'+
    '        )';
  strCountTable :=
    'select   [户号],count( * ) as c1 ' +
    '  from (' +  strDistinctTable + ')' +
    '  group by [户号]';
  strIdTable :=
    'select  [户号] ' +
    '  from (' + strCountTable + ')' +
    '  where c1 >= ' + inttostr(day) ;
  strDelete :=
    'delete * from  [低压电压]' +
    '  where [户号] not in (' + strIdTable + ')';
  datamodule1.Conn_acess.Execute(strDelete);
end;

function Tunbalance_dm.getLastProcDay: Tdate;
Var
  sSql:String;
  aQuery :TAdoQuery;
begin
  sSql :=
    'SELECT max([日期]) '+
    '  FROM [不平衡历史表] ';
  aQuery := DataModule1.runSql_access(sSql);
  result := EncodeDate(2000,1,1);
  if(not aQuery.IsEmpty)then
    result := aQuery.Fields[0].AsDateTime;
end;

end.

