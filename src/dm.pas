//------------------------------------------------------------------------------
//   模块名称:  dm
//   功能:      数据连接和Sql扎堆的地方
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------
unit dm;

interface

uses
  SysUtils, Classes, DB, ADODB, Controls;

type
  TDataModule1 = class(TDataModule)
    conn_oracle: TADOConnection;
    query_yichang_avg: TADOQuery;
    Conn_acess: TADOConnection;
    table_yichang_now1: TADOTable;
    tempQuery_ora: TADOQuery;
    tempQuery_access: TADOQuery;
    poweroff_query: TADOQuery;
    dianliang_query: TADOQuery;
    table_yichang_now: TADOQuery;
    user_query: TADOQuery;
    dsUser: TDataSource;
    mutliUser_query: TADOQuery;
    dsMutiUser: TDataSource;
    mutliUserList_query: TADOQuery;
    dsMultiUserList: TDataSource;
    query_mutilUser_dianliang: TADOQuery;
    dsMutliUser_dianliang: TDataSource;
    query_mutilUser_dianliang_lastyear: TADOQuery;
    ds_mutilUser_dianliang_lastyear: TDataSource;
    dianliang_lastyear: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function runSql(str: string): TAdoquery; overload;
    procedure runSql(str: string; aQuery: TAdoQuery); overload;
    function runSql_access(str: string): TAdoquery; overload;
    procedure runSql_access(str: string; aQuery: TAdoQuery); overload;
    //这个函数简单的执行一些不需要返回数据的sql,必然update,delete等
    procedure execSqu_access(str:String);

    procedure copyAYiChangeRecord; //复制当前oracle中的记录到access中
    //增加反馈到异常分析表中
    procedure addRespondInYichang(userId, respond,yichangFlag:String);

    function getYestedayDianliang(huhao: string): real; //得到最新的日电量值
    function getYesterdayDianliang_CDLBH(cldbh: string; aDay: TDate): real; //得到最新的日电量值,但使用测量点编号做为依据
    procedure getAvgYichang(aDay: TDate); overload;
    procedure getAvgYichang(aDay: TDate; aPercent: string); overload;
    procedure getAvgYichang(aDay: TDate; aPercent: string; cldbh: string); overload;
    procedure getAvgYichang(aDay: TDate; aPercent, cldbh, avgdays: string); overload;

    //得到一段时间的电量数据，可以给曲线用
    procedure getYichange(cldbh: string; beginDay, endDay: TDate);

    function getLastYichangeDate: TDate; //得到最后的异常日期
    function getOracleDate: TDate;

    //停电信息
    function Have_alarm_record(cldbh: string; aDay: TDate): boolean;
    function get_alarm(cldbh: string): TAdoQuery;
    //是否存在计量装置门打开的记录
    function Have_doorOpened(cldbh: string; aDay: TDate): string;
    //是否存在停电记录
    function Have_powerOff(cldbh: string; aDay: TDate): string;
    //是否存在高供高计 电表停走
    function Have_MeterStop(cldbh: string; aDay: Tdate): string;
    //是否存在ct二次侧短路记录
    function have_CTcut(cldbh: string; aDay: TDate): string;


    //打开本地异常分析表
    procedure get_access_yichange(flag: string); overload;
    procedure get_access_yichange(userName: string; departName: string;
      yichangFlag: string; userId: string; industries: string); overload;

    //对本地多表用户的处理
    function get_multi_nextId: string;
    procedure open_multi_data(userId: string);
    function isMutiMeterUser(cldbh: string): Boolean;
    function getMutiMeterUserId(cldbh: string): string;

    //多表用户的oracle部分处理
    procedure get_mutliUser_dianliang(userId: string); overload;
    procedure get_mutliUser_dianliang(userId: string; beginDay, endDay: Tdate); overload;
    function isMutiMeterUserYichange(cldbh: string; aDay: TDate; rate: real): boolean;

    //得到所有的分局列表
    function getDeparts: TStrings;
    function getYichangeFlags: Tstrings;
    function getIndustries: TStrings;

    //update someting
    procedure update_always_normal;



    //这是专门给用点科小田的报表
    function getTianRep(cldbh: string; beginDay, endDay: TDate): string;

    //得到告警异常代码表
    function getAlarmContent: string;


    //得到运行次数
    //function getRunCounts: Integer;

    //判断表是否存在
    //function isTableExist(tableName: string): Boolean;
  end;

var
  DataModule1: TDataModule1;

implementation

uses iniConfig, writelog;

{$R *.dfm}

{ TDataModule1 }

procedure TDataModule1.copyAYiChangeRecord;
begin
  table_yichang_now.Insert;
  table_yichang_now.FieldByName('客户局号').AsString :=
    query_yichang_avg.fieldbyname('客户局号').AsString;
  table_yichang_now.FieldByName('客户名称').AsString :=
    query_yichang_avg.fieldbyname('客户名称').AsString;
  table_yichang_now.FieldByName('部门名称').AsString :=
    query_yichang_avg.fieldbyname('部门名称').AsString;
  table_yichang_now.FieldByName('电表局号').AsString :=
    query_yichang_avg.fieldbyname('电表局号').AsString;
  table_yichang_now.FieldByName('时间').AsString :=
    query_yichang_avg.fieldbyname('时间').AsString;
  table_yichang_now.FieldByName('今日电量').AsString :=
    query_yichang_avg.fieldbyname('电量').AsString;
  table_yichang_now.FieldByName('平均电量').AsString :=
    query_yichang_avg.fieldbyname('平均电量').AsString;
  table_yichang_now.FieldByName('容量').AsString :=
    query_yichang_avg.fieldbyname('容量').AsString;
  table_yichang_now.FieldByName('信用等级').AsString :=
    query_yichang_avg.fieldbyname('信用等级').AsString;
  table_yichang_now.FieldByName('测量点编号').AsString :=
    query_yichang_avg.fieldbyname('测量点编号').AsString;
  table_yichang_now.FieldByName('行业').AsString :=
    query_yichang_avg.fieldbyname('行业').AsString;
  table_yichang_now.FieldByName('线路').AsString :=
    query_yichang_avg.fieldbyname('线路').AsString;
  table_yichang_now.Post;
end;

procedure TDataModule1.getAvgYichang(aDay: TDate);
var
  sSql: string;
begin
  sSql := 'SELECT  vn.khjh as 客户局号,vn.KHMC as 客户名称,vn.BMMC 部门名称,' +
    ' vn.zdljdz 终端逻辑地址, vn.cldbh as 测量点编号, ' +
    ' vn.DBJH as 电表局号,tj_dlxx.kssj as 时间,tj_dlxx.zxzdl 电量,' +
    ' t1.avg_zxzdl as 平均电量,vn.sbrl as 容量,vn.xydj as 信用等级' +
    ' FROM gruser.tj_dlxx, ' +
    ' (select avg(zxzdl) as avg_zxzdl,cldbh from gruser.tj_dlxx ' +
    ' where (tj_dlxx.kssj > to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' +
    '  - 5) AND tj_dlxx.SJLX=20 ' +
    ' group by cldbh) ' +
    't1,' + aIniConfig.V_NCYHXX + ' vn ' +
    'WHERE (tj_dlxx.cldbh = t1.cldbh and ' +
    'tj_dlxx.zxzdl < t1.avg_zxzdl*0.6 ' +
    'and vn.CLDBH = tj_dlxx.cldbh  and t1.avg_zxzdl>99 ' +
    'and vn.CLDBH = t1.cldbh ' +
    'and tj_dlxx.kssj > sysdate - 2 and   tj_dlxx.SJLX=20 ) ' +
    'order by vn.xydj,vn.BMMC,tj_dlxx.zxzdl';
  query_yichang_avg.Close;
  query_yichang_avg.SQL.Text := sSql;
  query_yichang_avg.Open;
end;

function TDataModule1.getYestedayDianliang(huhao: string): real;
var
  sSql: string;
  query1: tadoQuery;
begin
  query1 := tadoquery.Create(self);
  sSql := 'select tj_dlxx.zxzdl 电量 from gruser.tj_dlxx tj_dlxx, '+ aIniConfig.V_NCYHXX + ' v_ncyhxx' + 
    ' where tj_dlxx.cldbh = v_ncyhxx.cldbh' +
    ' and tj_dlxx.kssj > sysdate - 2' +
    ' and v_ncyhxx.khjh = ' + #39 + huhao + #39; //5101000109'
  query1.Connection := conn_oracle;
  query1.SQL.Text := sSql;
  query1.open;
  if (not query1.IsEmpty) then
    result := query1.Fields[0].AsFloat
  else
    result := 0;
  query1.Free;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  try
    conn_oracle.Connected := false;
  except
  end;

  if (aIniConfig.noOracle = '0') then
  begin
    try
      if (aIniConfig.debug = '1') then
      begin
      end
      else
      begin
        self.conn_oracle.ConnectionString := 'Provider=MSDAORA.1;' +
          'Password=yxuser;User ID=yxuser;' +
          'Data Source=grv32;Persist Security Info=True';
        conn_oracle.Connected := true;
      end;
    except
    end;
  end;

  //多表用户的sql改为配置中的表名
  self.user_query.close;
  self.user_query.SQL.Text :=
    'select khjh 户号,dbjh 表号,zdljdz 终端逻辑地址, '+
    '       cldbh 测量点编号, khmc 客户名称,bmmc 分局 ' +
    '  from ' + aIniConfig.V_NCYHXX; //gruser.v_ncyhxx

  Conn_acess.Connected := false;
  Conn_acess.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
    ' User ID=Admin;Data Source=yichang.mdb;Mode=Share Deny None;' +
    ' Extended Properties="";Persist Security Info=False;' +
    ' Jet OLEDB:System database="";' +
    ' Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";' +
    ' Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;' +
    ' Jet OLEDB:Global Partial Bulk Ops=2;' +
    ' Jet OLEDB:Global Bulk Transactions=1;' +
    ' Jet OLEDB:New Database Password="";' +
    ' Jet OLEDB:Create System Database=False;' +
    ' Jet OLEDB:Encrypt Database=False;' +
    ' Jet OLEDB:Don' + #39 + 't Copy Locale on Compact=False;' +
    ' Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False';
  Conn_acess.Connected := true;

end;

function TDataModule1.getOracleDate: TDate;
var
  sSql: string;
  query1: TadoQuery;
begin
  sSql := 'select sysdate from dual';
  query1 := runSql(sSql);
  if (not query1.IsEmpty) then
    result := query1.Fields[0].AsDateTime
  else
    result := EncodeDate(2000, 1, 1);
end;

function TDataModule1.runSql(str: string): TAdoquery;
begin
  if (aIniConfig.isSqlLog = '1') then
    sysLog.writeln(str);
  result := tempQuery_ora;
  if (aIniConfig.noOracle = '1') then
    exit;
  try
    if (conn_oracle.Connected = false) then
      conn_oracle.Connected := true;
    tempQuery_ora.Close;
    tempQuery_ora.SQL.Text := str;
    tempQuery_ora.Open;
    result := tempQuery_ora;
  except
    on E: Exception do sysLog.writeln(E.Message); //+ ' inttostr(E.HelpContext));
  end;
end;

function TDataModule1.getLastYichangeDate: TDate;
var
  sSql: string;
  query1: TadoQuery;
begin
  sSql := 'select max([时间]) from [电量异常]';
  query1 := runSql_access(sSql);
  if (not query1.IsEmpty) then
    result := query1.Fields[0].AsDateTime
  else
    result := EncodeDate(2000, 1, 1);
end;

function TDataModule1.runSql_access(str: string): TAdoquery;
begin
  tempQuery_access.Close;
  tempQuery_access.SQL.Text := str;
  tempQuery_access.Open;
  result := tempQuery_access;

end;

function TDataModule1.Have_alarm_record(cldbh: string;
  aDay: TDate): boolean;
var
  sSql: string;
  query1: TadoQuery;
begin
  sSql := 'select count(*) from gruser.yccl_ycsj where zdljdz = ' +
    // #39 +
  '(select zdljdz from ' + aIniConfig.V_NCYHXX + 'where cldbh = ' +
    #39 + cldbh + #39 + ')'
    //+ #39
  + ' and ycfssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') -1'
    + ' and ycjssj <  to_date('
    + #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') +1';
  query1 := runSql(sSql);
  if (not query1.IsEmpty )then
  begin
    if (query1.Fields[0].AsInteger > 0) then
      result := true
    else
      result := false;
  end
  else
    result := false;
end;


function TDataModule1.getYesterdayDianliang_CDLBH(cldbh: string;
  aDay: TDate): real;
var
  sSql: string;
  sResult: string;
  query1: tadoQuery;
begin
  sSql := 'select tj_dlxx.zxzdl 电量 from gruser.tj_dlxx ' +
    ' where tj_dlxx.kssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') -1'
    + ' and tj_dlxx.kssj <  to_date('
    + #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') +1' +

      //sysdate - 2'+
  ' and tj_dlxx.cldbh = ' + #39 + cldbh + #39; //5101000109'
  query1 := runSql(sSql);
  if(not query1.IsEmpty)then
    sResult := query1.Fields[0].AsString;
  if (sResult = '') then
    result := -1
  else
    result := query1.Fields[0].AsFloat;
end;

function TDataModule1.get_alarm(cldbh: string): TAdoQuery;
var
  sSql: string;
begin
  //sSQl := 'select count(*) from  "GRUSER"."YCCL_YCSJ"';

  sSql := 'select ' +
    ' decode(ycbm,' +
       {
        #39+'01'+#39+','+#39+'计量装置门关闭'+#39+','+
        #39+'21'+#39+','+#39+'电表停走'+#39+','+
        #39+'81'+#39+','+#39+'计量装置打开'+#39+','+
        #39+'95'+#39+','+#39+'停电'+#39+','+
        #39+'138'+#39+','+#39+'通讯故障'+#39+','+
        #39+'146'+#39+','+#39+'A相电压断相'+#39+','+
        #39+'147'+#39+','+#39+'B相电压断相'+#39+','+
        #39+'148'+#39+','+#39+'C相电压断相'+#39+','+
        #39+'0149'+#39+','+#39+'A相电压缺相'+#39+','+
        #39+'014A'+#39+','+#39+'B相电压缺相'+#39+','+
        #39+'014B'+#39+','+#39+'C相电压缺相'+#39+','+
        #39+'01B8'+#39+','+#39+'通讯故障恢复'+#39+','+
        #39+'01C6'+#39+','+#39+'A相电压断相恢复'+#39+','+
        #39+'01C7'+#39+','+#39+'B相电压断相恢复'+#39+','+
        #39+'01C8'+#39+','+#39+'C相电压断相恢复'+#39+','+
        #39+'01C9'+#39+','+#39+'A相电压缺相恢复'+#39+','+
        #39+'01CA'+#39+','+#39+'B相电压缺相恢复'+#39+','+
        #39+'01CC'+#39+','+#39+'C相电压缺相恢复'+#39+','+
        #39+'A1'+#39+','+#39+'电表停走恢复'+#39+','+
        #39+'15'+#39+','+#39+'来电'+#39+','+
        }
  getAlarmContent +
    ' ycbm) 异常编号, ' +
    ' to_char(tj.ycfssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') 发生时间, ' +
    ' to_char(tj.ycjssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') 结束时间,' +
    ' yhxx.khmc 客户名称 ' +
    ' from (select * from gruser.yccl_ycsj ' +
    '        where ycfssj >  to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', now - 30) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') -1' +
    ' and zdljdz = (select zdljdz from '+ aIniConfig.V_NCYHXX + ' v_ncyhxx' +
    ' where cldbh = ' + #39 + cldbh + #39 + ')' +
    ' order by ycfssj desc' +
    //')tj, v_ncyhxx yhxx' +
    ')tj, '+ aIniConfig.V_NCYHXX + ' yhxx' +
    ' where yhxx.cldbh = ' + #39 + cldbh + #39 +
    ' and yhxx.zdljdz = tj.zdljdz' +
    ' and rownum<200 ';

  poweroff_query.Close;
  poweroff_query.SQL.Text := ssql;
  sysLog.writeln(ssql);
  poweroff_query.Prepared := true;
  poweroff_query.Open;

  result := nil;
//  runsql(ssql, poweroff_query);
//  result := poweroff_query;
end;

procedure TDataModule1.runSql(str: string; aQuery: TAdoQuery);
begin
  if (aIniConfig.isSqlLog = '1') then
    sysLog.writeln(str);
  if (aIniConfig.noOracle = '1') then
    exit;
  try
    if (conn_oracle.Connected = false) then
      conn_oracle.Connected := true;
    aQuery.Close;
    aQuery.SQL.Text := str;
    aQuery.Open;
  except
    on E: Exception do sysLog.writeln(E.Message); //+ ' inttostr(E.HelpContext));

  end;
end;

procedure TDataModule1.getYichange(cldbh: string; beginDay, endDay: TDate);
var
  sSql: string;
begin
  sSql := 'select to_date(to_char(kssj,' + #39 + 'yyyy-mm-dd' + #39 + '), ' +
    #39 + 'yyyy-mm-dd' + #39 + ') as kssj,' +
    'zxzdl,cldbh from gruser.tj_dlxx ' +
    ' where cldbh = ' + #39 + cldbh + #39 +
    ' and kssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', beginDay - 1) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') ' +
    ' and kssj < to_date('
    + #39 + formatdatetime('yyyy-mm-dd', endDay + 1) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') '
    + ' and sjlx = 20 '
    + ' order by kssj ';
  runsql(sSql, dianliang_query);
  {
  dianliang_query.Close;
  dianliang_query.SQL.Text := sSql;
  dianliang_query.Open;
  }
  //打开去年同期的数据
  sSql := 'select to_date(to_char(kssj,' + #39 + 'yyyy-mm-dd' + #39 + '), ' +
    #39 + 'yyyy-mm-dd' + #39 + ') as kssj,' +
    'zxzdl,cldbh from gruser.tj_dlxx ' +
    ' where cldbh = ' + #39 + cldbh + #39 +
    ' and kssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', beginDay - 1 - 365) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') ' +
    ' and kssj < to_date('
    + #39 + formatdatetime('yyyy-mm-dd', endDay + 1 - 365) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') '
    + ' and sjlx = 20 '
    + ' order by kssj ';
  runsql(sSql, dianliang_lastyear);
  {
  dianliang_lastyear.Close;
  dianliang_lastyear.SQL.Text := sSql;
  dianliang_lastyear.Open;
  }

end;

procedure TDataModule1.get_access_yichange(flag: string);
var
  sSql: string;
begin
  if (pos('普通的', flag) > 0) then
    sSql := 'select * from [电量异常] where [异常标记] <>'
      + #39 + '恢复正常' + #39 +
      'or [异常标记] is null'
  else if (pos('恢复正常的', flag) > 0) then
    sSql := 'select * from [电量异常] where [异常标记] ='
      + #39 + '恢复正常' + #39
  else if (pos('未标记的', flag) > 0) then
    sSql := 'select * from [电量异常] where [异常标记] is null' +
      ' or   [异常标记] = ' + #39#39
  else
    sSql := 'select * from [电量异常]';
  table_yichang_now.Close;
  table_yichang_now.SQL.Text := sSql;
  table_yichang_now.Open;
end;

function TDataModule1.get_multi_nextId: string;
var
  sSql: string;
  aQuery: TADOQuery;
begin
  sSql := 'select max([索引值]) from [多表用户]';
  aQuery := runSql_access(sSql);
  if(aQuery.IsEmpty)then
    result := '1'
  else
  begin
    if (aQuery.Fields[0].AsString = '') then
      result := '1'
    else
      result := inttostr(aQuery.Fields[0].asinteger + 1);
  end;
end;

procedure TDataModule1.open_multi_data(userId: string);
begin
  with self.mutliUser_query do
  begin
    close;
    Parameters[0].Value := userId;
    open;
  end;
end;

procedure TDataModule1.getAvgYichang(aDay: TDate; aPercent: string);
var
  sSql: string;
begin
  sSql := 'SELECT  vn.khjh as 客户局号,vn.KHMC as 客户名称,vn.BMMC 部门名称,' +
    ' vn.zdljdz 终端逻辑地址, vn.cldbh as 测量点编号, ' +
    ' vn.DBJH as 电表局号,tj_dlxx.kssj as 时间,tj_dlxx.zxzdl 电量,' +
    ' t1.avg_zxzdl as 平均电量,vn.sbrl as 容量,vn.xydj as 信用等级,' +
    ' vn.HY as 行业, vn.KXMC 线路 ' +
    ' FROM gruser.tj_dlxx, ' +
    ' (select avg(zxzdl) as avg_zxzdl,cldbh from gruser.tj_dlxx ' +
    ' where (tj_dlxx.kssj > to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + '  - 5) and ' +
    'tj_dlxx.kssj < to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + '  - 1 and ' +
    'tj_dlxx.SJLX=20 ' +
    ' group by cldbh) ' +
    't1,'+ aIniConfig.V_NCYHXX + ' vn ' +
    'WHERE (tj_dlxx.cldbh = t1.cldbh and ' +
    'tj_dlxx.zxzdl < t1.avg_zxzdl* ' + aPercent + ' ' +
    'and vn.CLDBH = tj_dlxx.cldbh  and t1.avg_zxzdl>99 ' +
    'and vn.CLDBH = t1.cldbh ' +
    'and tj_dlxx.kssj = to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + ' and ' +
    ' tj_dlxx.SJLX=20 ) ' +
    'order by vn.xydj,vn.BMMC,tj_dlxx.zxzdl';
  query_yichang_avg.Close;
  query_yichang_avg.SQL.Text := sSql;
  query_yichang_avg.Open;
end;


function TDataModule1.isMutiMeterUser(cldbh: string): Boolean;
var
  sSql: string;
  aQuery: TAdoquery;
begin
  sSql := 'select * from [多表用户] where [测量点编号] = ' + #39 + cldbh + #39;
  aQuery := runSql_access(sSql);
  if (aQuery.RecordCount = 0) then
    result := false
  else
    result := true;
end;

procedure TDataModule1.get_mutliUser_dianliang(userId: string);
var
  users: TStrings;
  sSql: string;
  aQuery: TADoquery;
  i: integer;
begin
  sSql := 'select [测量点编号] from [多表用户] where [索引值] = '
    + userId;
  aQuery := runSql_access(sSql);
  if (aQuery.Recordcount = 0) then
    exit;
  users := tstringlist.Create;
  while not aQuery.Eof do
  begin
    users.Add(aQuery.Fields[0].asstring);
    aquery.next;
  end;
  sSql := 'select  sum(zxzdl) 电量,  kssj 日期 from  ' +
    ' (select zxzdl, to_char(kssj,' + #39 + 'yyyy/mm/dd' + #39 + ') kssj from gruser.tj_dlxx ' +
    ' where cldbh = ' + #39 + users[0] + #39;
  for i := 1 to users.Count - 1 do
  begin
    sSql := sSql + ' or cldbh = ' + #39 + users[i] + #39;
  end;
  sSql := sSql + ') group by kssj order by kssj desc';
  query_mutilUser_dianliang.Close;
  query_mutilUser_dianliang.SQL.Text := sSql;
  query_mutilUser_dianliang.Open;
  users.Free;
end;

procedure TDataModule1.get_mutliUser_dianliang(userId: string; beginDay,
  endDay: Tdate);
var
  users: TStrings;
  sSql: string;
  aQuery: TADoquery;
  i: integer;
begin
  sSql := 'select [测量点编号] from [多表用户] where [索引值] = '
    + userId;
  aQuery := runSql_access(sSql);
  if (aQuery.Recordcount = 0) then
    exit;
  users := tstringlist.Create;
  while not aQuery.Eof do
  begin
    users.Add(aQuery.Fields[0].asstring);
    aquery.next;
  end;
  sSql := 'select  sum(zxzdl) 电量,  kssj 日期 from  ' +
    ' (select zxzdl, to_char(kssj,' + #39 + 'yyyy/mm/dd' + #39 + ') kssj from gruser.tj_dlxx ' +
    ' where ( cldbh = ' + #39 + users[0] + #39;
  for i := 1 to users.Count - 1 do
  begin
    sSql := sSql + ' or cldbh = ' + #39 + users[i] + #39;
  end;
  sSql := sSql +
    ' ) and kssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', beginDay - 1) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') ' +
    ' and kssj < to_date('
    + #39 + formatdatetime('yyyy-mm-dd', endDay + 1) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') '
    + ' and sjlx = 20';
  sSql := sSql + ') group by kssj order by kssj desc';
  query_mutilUser_dianliang.Close;
  query_mutilUser_dianliang.SQL.Text := sSql;
  query_mutilUser_dianliang.Open;

  //把上年同期的也query出来好了
  sSql := 'select  sum(zxzdl) 电量,  kssj 日期 from  ' +
    ' (select zxzdl, to_char(kssj,' + #39 + 'yyyy/mm/dd' + #39 + ') kssj from gruser.tj_dlxx ' +
    ' where ( cldbh = ' + #39 + users[0] + #39;
  for i := 1 to users.Count - 1 do
  begin
    sSql := sSql + ' or cldbh = ' + #39 + users[i] + #39;
  end;
  sSql := sSql +
    ' ) and kssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', beginDay - 1 - 365) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') ' +
    ' and kssj < to_date('
    + #39 + formatdatetime('yyyy-mm-dd', endDay + 1 - 365) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') '
    + ' and sjlx = 20';
  sSql := sSql + ') group by kssj order by kssj desc';
  query_mutilUser_dianliang_lastyear.Close;
  query_mutilUser_dianliang_lastyear.SQL.Text := sSql;
  query_mutilUser_dianliang_lastyear.Open;
  users.Free;

end;

function TDataModule1.getMutiMeterUserId(cldbh: string): string;
var
  sSql: string;
  aQuery: TAdoquery;
begin
  sSql := 'select * from [多表用户] where [测量点编号] = ' + #39 + cldbh + #39;
  aQuery := runSql_access(sSql);
  result := aQuery.fieldbyname('索引值').AsString;
end;


function TDataModule1.isMutiMeterUserYichange(cldbh: string; aDay: TDate; rate: real): boolean;
var
  userId: string;
  dianliang_aday: real;
  dianliang_avg: real;
  dianliang_avg_count: integer;
begin
  userId := getMutiMeterUserId(cldbh);
  get_mutliUser_dianliang(userId, aday, aDay - 6);
  dianliang_aday := 0;
  dianliang_avg := 0;
  dianliang_avg_count := 0;
//  result := false;
  with query_mutilUser_dianliang do
  begin
    first;
    while not eof do
    begin
      if (fieldbyname('日期').AsString = formatdatetime('yyyy-mm-dd', aday)) then
        dianliang_aday := fieldbyname('电量').AsFloat
      else
      begin
        dianliang_avg := dianliang_avg + fieldbyname('电量').AsFloat;
        inc(dianliang_avg_count);
      end;
      {
      syslog.writeln('aday = ' + formatdatetime('yyyy-mm-dd', aday) +
        ' 日期='+ fieldbyname('日期').AsString +
        ' 电量='+ fieldbyname('电量').AsString +
        ' 平均电量=' + floattostr(dianliang_avg) +
        ' 总加天数=' + inttostr(dianliang_avg_count) +
        ' aDay电量=' + floattostr(dianliang_aday));
       }
      next;
    end;
  end;
  if (dianliang_avg_count > 0) then
  begin
    if (dianliang_aday < ((dianliang_avg / dianliang_avg_count) * rate)) then
      result := true
    else
      result := false;
  end
  else
    result := true;
end;

function TDataModule1.getDeparts: TStrings;
var
  sSql: string;
  aQuery: TADOQuery;
begin
  sSql := 'select distinct([部门名称]) from [电量异常]';
  aQuery := runSql_access(sSql);
  result := tstringlist.Create;
  while not aQuery.Eof do
  begin
    result.Add(aquery.Fields[0].asString);
    aQuery.Next;
  end;
end;

function TDataModule1.getYichangeFlags: Tstrings;
var
  sSql: string;
  aQuery: TADOQuery;
begin
  sSql := 'select distinct([异常标记]) from [电量异常]';
  aQuery := runSql_access(sSql);
  result := tstringlist.Create;
  while not aQuery.Eof do
  begin
    result.Add(aquery.Fields[0].asString);
    aQuery.Next;
  end;
end;

procedure TDataModule1.get_access_yichange(userName, departName,
  yichangFlag: string; userId: string; industries: string);
var
  sSql: string;
  userId_strs: TStrings;
  i: integer;
begin
  sSql := 'select * from [电量异常] where 1=1 ';
  if (userName <> '') then
    sSql := sSql + ' and [客户名称] like ' + #39 + '%' + userName + '%' + #39;
  if (departName <> '') then
    sSql := sSql + ' and [部门名称] = ' + #39 + departName + #39;
  if (yichangFlag <> '') then
  begin
    if (yichangFlag = 'Null') then
      sSql := sSql + ' and ([异常标记] is null or [异常标记] =' + #39#39 + ')'
    else
      sSql := sSql + ' and [异常标记] = ' + #39 + yichangFlag + #39;
  end;
  if (industries <> '') then
    sSql := sSql + ' and [行业] = ' + #39 + industries + #39;
  if (userId <> '') then
  begin
    sSql := sSql + ' and ( 1=0 ';
    userId_strs := TStringList.Create;
    userId_strs.Delimiter := ',';
    userId_strs.DelimitedText := userId;
    for i := 0 to userId_strs.Count - 1 do
    begin
      sSql := sSql + ' or [客户局号] = ' + #39 + userId_strs[i] + #39;
    end;
    userId_strs.Free;
    sSql := sSql + ' )';
  end;
  table_yichang_now.Close;
  table_yichang_now.SQL.Text := sSql;
  table_yichang_now.Open;
end;

procedure TDataModule1.update_always_normal;
var
  sSql: string;
begin
  sSql := 'update [电量异常] set [异常标记] = ' + #39 + '正常' + #39 +
    ' where  [客户局号] = ' + #39 + '5105124343' + #39 +
    '  or  [客户局号] = ' + #39 + '5104102014' + #39 +
    '  or  [客户局号] = ' + #39 + '5104000145' + #39 +   
    '  or  [客户局号] = ' + #39 + '5104000144' + #39;
  Conn_acess.Execute(sSql);
end;

function TDataModule1.getTianRep(cldbh: string; beginDay, endDay: TDate): string;
var
  sSql: string;
  aQuery: TAdoQuery;
  magnification: real;
begin
  sSql := 'select ctbb*ptbb from '+ aIniConfig.V_NCYHXX + 
    ' where vn.cldbh = ' + #39 + cldbh + #39;
  aquery := runSql(sSql);
  magnification := 0;
  if(not aQuery.IsEmpty)then
    magnification := aquery.Fields[0].AsFloat;

  sSql := 'SELECT Max(dd.YGGL), Avg(dd.YGGL), Min(dd.YGGL) ' +
    ' FROM gruser.DATA_sslsd dd ' +
    ' WHERE (dd.CLDBH=' + #39 + cldbh + #39 + ')' +
    '         AND (dd.SJSJ>to_date(' + #39 + formatdatetime('yyyy-mm-dd', beginDay - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ' )' +
    '         And dd.SJSJ<to_date(' + #39 + formatdatetime('yyyy-mm-dd', endday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + '))';

  aquery := runSql(sSql);
  if(not aQuery.IsEmpty) then
    result := floattostr(aQuery.Fields[0].asfloat * magnification) + ' ' +
      floattostr(aQuery.Fields[1].asfloat * magnification) + ' ' +
      floattostr(aQuery.Fields[2].asfloat * magnification)
  else
    result :='';
end;

procedure TDataModule1.getAvgYichang(aDay: TDate; aPercent, cldbh: string);
var
  sSql: string;
begin
  sSql := 'SELECT  vn.khjh as 客户局号,vn.KHMC as 客户名称,vn.BMMC 部门名称,' +
    ' vn.zdljdz 终端逻辑地址, vn.cldbh as 测量点编号, ' +
    ' vn.DBJH as 电表局号,tj_dlxx.kssj as 时间,tj_dlxx.zxzdl 电量,' +
    ' t1.avg_zxzdl as 平均电量,vn.sbrl as 容量,vn.xydj as 信用等级,' +
    ' vn.HY as 行业, vn.KXMC 线路 ' +
    ' FROM gruser.tj_dlxx, ' +
    ' (select avg(zxzdl) as avg_zxzdl,cldbh from gruser.tj_dlxx ' +
    ' where (tj_dlxx.kssj > to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + '  - 5) and ' +
    'tj_dlxx.kssj < to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + '  - 1 and ' +
    'tj_dlxx.SJLX=20 ' +
    ' and cldbh = ' + #39 + cldbh + #39 +
    ' group by cldbh) ' +
    't1,' + aIniConfig.V_NCYHXX + 
    'WHERE (tj_dlxx.cldbh = t1.cldbh and ' +
    'tj_dlxx.zxzdl < t1.avg_zxzdl* ' + aPercent + ' ' +
    'and vn.CLDBH = tj_dlxx.cldbh  and t1.avg_zxzdl>99 ' +
    'and vn.CLDBH = t1.cldbh ' +
    'and vn.CLDBH = ' + #39 + cldbh + #39 +
    'and tj_dlxx.kssj = to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + ' and ' +
    ' tj_dlxx.SJLX=20 ) ' +
    'order by vn.xydj,vn.BMMC,tj_dlxx.zxzdl';
  query_yichang_avg.Close;
  query_yichang_avg.SQL.Text := sSql;
  query_yichang_avg.Open;
end;

function TDataModule1.getIndustries: TStrings;
var
  sSql: string;
  aQuery: TADOQuery;
begin
  sSql := 'select distinct([行业]) from [电量异常]';
  aQuery := runSql_access(sSql);
  result := tstringlist.Create;
  while not aQuery.Eof do
  begin
    result.Add(aquery.Fields[0].asString);
    aQuery.Next;
  end;
end;

function TDataModule1.getAlarmContent: string;
var
  sSql: string;
  aQuery: TADOQuery;
  contentStr: string;
begin
  sSql := 'select * from [告警对照]';
  aQuery := runSql_access(sSql);
  while not aQuery.Eof do
  begin
    contentStr := contentStr +
      #39 + aquery.Fields[0].asString + #39 + ',' + #39 + aquery.Fields[1].asString + #39 + ',';
    aQuery.Next;
  end;
  result := contentStr;
end;

function TDataModule1.Have_doorOpened(cldbh: string; aDay: TDate): string;
var
  sSql: string;
  query1: TadoQuery;
begin
  sSql := 'select ycbm, ' +
    ' to_char(ycfssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ycfssj, ' +
    ' to_char(ycjssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ycjssj' +
    ' from gruser.yccl_ycsj where zdljdz = ' +
    // #39 +
  '(select zdljdz from ' + aIniConfig.V_NCYHXX + 
    #39 + cldbh + #39 + ')'
    //+ #39
  + ' and ycfssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') -20'
    //+ ' and ycjssj <  to_date('
    //+#39 + formatdatetime('yyyy-mm-dd',aday )+ #39 + ','
    //+#39 +'yyyy-mm-dd'+#39+') +1'
  + ' and (ycbm = ' + #39 + '81' + #39 + 'or ycbm = ' + #39 + '01' + #39 + ')'
    + ' order by ycfssj desc';
  query1 := runSql(sSql);
  if(not query1.IsEmpty)then
    result := query1.Fieldbyname('ycfssj').AsString
  else
    result := '';
end;

function TDataModule1.Have_powerOff(cldbh: string; aDay: TDate): string;
var
  sSql: string;
  query1: TadoQuery;
begin
  sSql := 'select ycbm, ' +
    ' to_char(ycfssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ycfssj, ' +
    ' to_char(ycjssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ycjssj' +
    ' from gruser.yccl_ycsj where zdljdz = ' +
    // #39 +
  '(select zdljdz from '+ aIniConfig.V_NCYHXX + ' where cldbh = ' +
    #39 + cldbh + #39 + ')'
    //+ #39
  + ' and ycfssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') -20'
    //+ ' and ycjssj <  to_date('
    //+#39 + formatdatetime('yyyy-mm-dd',aday )+ #39 + ','
    //+#39 +'yyyy-mm-dd'+#39+') +1'
  + ' and (ycbm = ' + #39 + '95' + #39 + ')'
    + ' order by ycfssj desc';
  query1 := runSql(sSql);
  result := '';
  if(not query1.IsEmpty)then
    result := query1.Fieldbyname('ycfssj').AsString;
end;




{
function TDataModule1.getRunCounts: Integer;
var
  sSql: string;
  query1: TadoQuery;
begin
  if(isTableExist('运行日志')= false)then
  begin
    sSql := 'Create Table [运行日志]' +
  '(' +
    '[时间]                   Integer' +
    ')';
  end;
end;

function TDataModule1.isTableExist(tableName: string): Boolean;
var
  mytables: tstringlist;
begin
  mytables := tstringlist.Create;
  adoconnect.GetTableNames(mytables);
  if not (mytables.IndexOf(findtablename) = -1) then
    result := true
  else
    result := false;
  mytables.Free;
end;
}

function TDataModule1.Have_MeterStop(cldbh: string; aDay: Tdate): string;
var
  sSql: string;
  query1: TadoQuery;
begin
  sSql := 'select ycbm, ' +
    '             to_char(ycfssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ycfssj, ' +
    '             to_char(ycjssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ycjssj' +
    '        from gruser.yccl_ycsj ' +
    '        where zdljdz = ' +
    '              (select zdljdz from '+ aIniConfig.V_NCYHXX + 
    '                  where cldbh = ' + #39 + cldbh + #39 +
    '                      and ptbb > 1' +
    '              )'
    + '         and ycfssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') -20'
    + '         and (ycbm = ' + #39 + '21' + #39 + ')'
    + '      order by ycfssj desc';
  query1 := runSql(sSql);
  result := '';
  if(not query1.IsEmpty)then  
  result := query1.Fieldbyname('ycfssj').AsString;
  {
  if (rsult <> '') then
  begin
    //如果不是高供高计用户就算了
    if (not isPTBBaboveOne(cldbh)) then
      result := '';
  end;
  }
end;



function TDataModule1.have_CTcut(cldbh: string; aDay: TDate): string;
var
  sSql: string;
  query1: TadoQuery;
begin
  sSql := 'select ycbm, ' +
    '             to_char(ycfssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ycfssj, ' +
    '             to_char(ycjssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ycjssj' +
    '        from gruser.yccl_ycsj ' +
    '        where zdljdz = ' +
    '              (select zdljdz from '+ aIniConfig.V_NCYHXX + 
    '                  where cldbh = ' + #39 + cldbh + #39 +
   // '                      and ptbb > 1' +
  '              )'
    + '         and ycfssj > to_date('
    + #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ','
    + #39 + 'yyyy-mm-dd' + #39 + ') -20'
    + '         and (ycbm = ' + #39 + '16' + #39
    + '               or ycbm = ' + #39 + '17' + #39
    + '               or ycbm = ' + #39 + '18' + #39
    + '              )'
    + '      order by ycfssj desc';
  query1 := runSql(sSql);
  result := '';
  if(not query1.IsEmpty)then  
  result := query1.Fieldbyname('ycfssj').AsString;

end;

procedure TDataModule1.runSql_access(str: string; aQuery: TAdoQuery);
begin
  try
    if (Conn_acess.Connected = false) then
      Conn_acess.Connected := true;
    aQuery.Close;
    aquery.Connection := Conn_acess;
    aQuery.SQL.Text := str;
    aQuery.Open;
  except
    on E: Exception do sysLog.writeln(E.Message); //+ ' inttostr(E.HelpContext));

  end;

end;

procedure TDataModule1.getAvgYichang(aDay: TDate; aPercent, cldbh,
  avgdays: string);
var
  sSql: string;
begin
  sSql := 'SELECT  vn.khjh as 客户局号,vn.KHMC as 客户名称,vn.BMMC 部门名称,' +
    ' vn.zdljdz 终端逻辑地址, vn.cldbh as 测量点编号, ' +
    ' vn.DBJH as 电表局号,tj_dlxx.kssj as 时间,tj_dlxx.zxzdl 电量,' +
    ' t1.avg_zxzdl as 平均电量,vn.sbrl as 容量,vn.xydj as 信用等级,' +
    ' vn.HY as 行业, vn.KXMC 线路 ' +
    ' FROM gruser.tj_dlxx, ' +
    ' (select avg(zxzdl) as avg_zxzdl,cldbh from gruser.tj_dlxx ' +
    ' where (tj_dlxx.kssj > to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + '  - ' + avgdays + ') and ' +
    'tj_dlxx.kssj < to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + '  - 1 and ' +
    'tj_dlxx.SJLX=20 ' +
    ' and cldbh = ' + #39 + cldbh + #39 +
    ' group by cldbh) ' +
    't1,' + aIniConfig.V_NCYHXX + ' vn ' +
    'WHERE (tj_dlxx.cldbh = t1.cldbh and ' +
    'tj_dlxx.zxzdl < t1.avg_zxzdl* ' + aPercent + ' ' +
    'and vn.CLDBH = tj_dlxx.cldbh  and t1.avg_zxzdl>99 ' +
    'and vn.CLDBH = t1.cldbh ' +
    'and vn.CLDBH = ' + #39 + cldbh + #39 +
    'and tj_dlxx.kssj = to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') ' + ' and ' +
    ' tj_dlxx.SJLX=20 ) ' +
    'order by vn.xydj,vn.BMMC,tj_dlxx.zxzdl';
  query_yichang_avg.Close;
  query_yichang_avg.SQL.Text := sSql;
  query_yichang_avg.Open;
end;

procedure TDataModule1.addRespondInYichang(userId, respond,yichangFlag: String);
var
  sInsert:String;
begin
  if(respond = '')then
    exit;
  sInsert := 'update  [电量异常] '+
             '  set [反馈] = ' +#39 + respond + #39 + ',' ;
  if((yichangFlag = 'c')or(yichangFlag = 'C'))then
     sInsert := sInsert +
               '      [异常标记] = ' + #39 + '处理中' + #39
  else if((yichangFlag = 'f')or(yichangFlag = 'F'))then
     sInsert := sInsert +
               '      [异常标记] = ' + #39 + '异常' + #39
  else
     sInsert := sInsert +
               '      [异常标记] = ' + #39 + '正常' + #39 ;

   sInsert := sInsert +
               '  where ([客户局号] = ' + #39+ userId + #39 + ') and' +
               '        ([异常标记] <>' + #39 + '恢复正常' + #39 +
               '             or [异常标记] is null)';
   execSqu_access(sInsert);
end;

procedure TDataModule1.execSqu_access(str: String);
begin
  if(aIniConfig.isSqlLog = '1')then
    syslog.writeln('execute sql in access :' + str);
  Conn_acess.Execute(str);
end;

end.

