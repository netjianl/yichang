//------------------------------------------------------------------------------
//   ģ������:  dm
//   ����:      �������Ӻ�Sql���ѵĵط�
//   ��д�ˣ�  ����                                    ʱ�䣺 2008-2
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
    //��������򵥵�ִ��һЩ����Ҫ�������ݵ�sql,��Ȼupdate,delete��
    procedure execSqu_access(str:String);

    procedure copyAYiChangeRecord; //���Ƶ�ǰoracle�еļ�¼��access��
    //���ӷ������쳣��������
    procedure addRespondInYichang(userId, respond,yichangFlag:String);

    function getYestedayDianliang(huhao: string): real; //�õ����µ��յ���ֵ
    function getYesterdayDianliang_CDLBH(cldbh: string; aDay: TDate): real; //�õ����µ��յ���ֵ,��ʹ�ò���������Ϊ����
    procedure getAvgYichang(aDay: TDate); overload;
    procedure getAvgYichang(aDay: TDate; aPercent: string); overload;
    procedure getAvgYichang(aDay: TDate; aPercent: string; cldbh: string); overload;
    procedure getAvgYichang(aDay: TDate; aPercent, cldbh, avgdays: string); overload;

    //�õ�һ��ʱ��ĵ������ݣ����Ը�������
    procedure getYichange(cldbh: string; beginDay, endDay: TDate);

    function getLastYichangeDate: TDate; //�õ������쳣����
    function getOracleDate: TDate;

    //ͣ����Ϣ
    function Have_alarm_record(cldbh: string; aDay: TDate): boolean;
    function get_alarm(cldbh: string): TAdoQuery;
    //�Ƿ���ڼ���װ���Ŵ򿪵ļ�¼
    function Have_doorOpened(cldbh: string; aDay: TDate): string;
    //�Ƿ����ͣ���¼
    function Have_powerOff(cldbh: string; aDay: TDate): string;
    //�Ƿ���ڸ߹��߼� ���ͣ��
    function Have_MeterStop(cldbh: string; aDay: Tdate): string;
    //�Ƿ����ct���β��·��¼
    function have_CTcut(cldbh: string; aDay: TDate): string;


    //�򿪱����쳣������
    procedure get_access_yichange(flag: string); overload;
    procedure get_access_yichange(userName: string; departName: string;
      yichangFlag: string; userId: string; industries: string); overload;

    //�Ա��ض���û��Ĵ���
    function get_multi_nextId: string;
    procedure open_multi_data(userId: string);
    function isMutiMeterUser(cldbh: string): Boolean;
    function getMutiMeterUserId(cldbh: string): string;

    //����û���oracle���ִ���
    procedure get_mutliUser_dianliang(userId: string); overload;
    procedure get_mutliUser_dianliang(userId: string; beginDay, endDay: Tdate); overload;
    function isMutiMeterUserYichange(cldbh: string; aDay: TDate; rate: real): boolean;

    //�õ����еķ־��б�
    function getDeparts: TStrings;
    function getYichangeFlags: Tstrings;
    function getIndustries: TStrings;

    //update someting
    procedure update_always_normal;



    //����ר�Ÿ��õ��С��ı���
    function getTianRep(cldbh: string; beginDay, endDay: TDate): string;

    //�õ��澯�쳣�����
    function getAlarmContent: string;


    //�õ����д���
    //function getRunCounts: Integer;

    //�жϱ��Ƿ����
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
  table_yichang_now.FieldByName('�ͻ��ֺ�').AsString :=
    query_yichang_avg.fieldbyname('�ͻ��ֺ�').AsString;
  table_yichang_now.FieldByName('�ͻ�����').AsString :=
    query_yichang_avg.fieldbyname('�ͻ�����').AsString;
  table_yichang_now.FieldByName('��������').AsString :=
    query_yichang_avg.fieldbyname('��������').AsString;
  table_yichang_now.FieldByName('���ֺ�').AsString :=
    query_yichang_avg.fieldbyname('���ֺ�').AsString;
  table_yichang_now.FieldByName('ʱ��').AsString :=
    query_yichang_avg.fieldbyname('ʱ��').AsString;
  table_yichang_now.FieldByName('���յ���').AsString :=
    query_yichang_avg.fieldbyname('����').AsString;
  table_yichang_now.FieldByName('ƽ������').AsString :=
    query_yichang_avg.fieldbyname('ƽ������').AsString;
  table_yichang_now.FieldByName('����').AsString :=
    query_yichang_avg.fieldbyname('����').AsString;
  table_yichang_now.FieldByName('���õȼ�').AsString :=
    query_yichang_avg.fieldbyname('���õȼ�').AsString;
  table_yichang_now.FieldByName('��������').AsString :=
    query_yichang_avg.fieldbyname('��������').AsString;
  table_yichang_now.FieldByName('��ҵ').AsString :=
    query_yichang_avg.fieldbyname('��ҵ').AsString;
  table_yichang_now.FieldByName('��·').AsString :=
    query_yichang_avg.fieldbyname('��·').AsString;
  table_yichang_now.Post;
end;

procedure TDataModule1.getAvgYichang(aDay: TDate);
var
  sSql: string;
begin
  sSql := 'SELECT  vn.khjh as �ͻ��ֺ�,vn.KHMC as �ͻ�����,vn.BMMC ��������,' +
    ' vn.zdljdz �ն��߼���ַ, vn.cldbh as ��������, ' +
    ' vn.DBJH as ���ֺ�,tj_dlxx.kssj as ʱ��,tj_dlxx.zxzdl ����,' +
    ' t1.avg_zxzdl as ƽ������,vn.sbrl as ����,vn.xydj as ���õȼ�' +
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
  sSql := 'select tj_dlxx.zxzdl ���� from gruser.tj_dlxx tj_dlxx, '+ aIniConfig.V_NCYHXX + ' v_ncyhxx' + 
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

  //����û���sql��Ϊ�����еı���
  self.user_query.close;
  self.user_query.SQL.Text :=
    'select khjh ����,dbjh ���,zdljdz �ն��߼���ַ, '+
    '       cldbh ��������, khmc �ͻ�����,bmmc �־� ' +
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
  sSql := 'select max([ʱ��]) from [�����쳣]';
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
  sSql := 'select tj_dlxx.zxzdl ���� from gruser.tj_dlxx ' +
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
        #39+'01'+#39+','+#39+'����װ���Źر�'+#39+','+
        #39+'21'+#39+','+#39+'���ͣ��'+#39+','+
        #39+'81'+#39+','+#39+'����װ�ô�'+#39+','+
        #39+'95'+#39+','+#39+'ͣ��'+#39+','+
        #39+'138'+#39+','+#39+'ͨѶ����'+#39+','+
        #39+'146'+#39+','+#39+'A���ѹ����'+#39+','+
        #39+'147'+#39+','+#39+'B���ѹ����'+#39+','+
        #39+'148'+#39+','+#39+'C���ѹ����'+#39+','+
        #39+'0149'+#39+','+#39+'A���ѹȱ��'+#39+','+
        #39+'014A'+#39+','+#39+'B���ѹȱ��'+#39+','+
        #39+'014B'+#39+','+#39+'C���ѹȱ��'+#39+','+
        #39+'01B8'+#39+','+#39+'ͨѶ���ϻָ�'+#39+','+
        #39+'01C6'+#39+','+#39+'A���ѹ����ָ�'+#39+','+
        #39+'01C7'+#39+','+#39+'B���ѹ����ָ�'+#39+','+
        #39+'01C8'+#39+','+#39+'C���ѹ����ָ�'+#39+','+
        #39+'01C9'+#39+','+#39+'A���ѹȱ��ָ�'+#39+','+
        #39+'01CA'+#39+','+#39+'B���ѹȱ��ָ�'+#39+','+
        #39+'01CC'+#39+','+#39+'C���ѹȱ��ָ�'+#39+','+
        #39+'A1'+#39+','+#39+'���ͣ�߻ָ�'+#39+','+
        #39+'15'+#39+','+#39+'����'+#39+','+
        }
  getAlarmContent +
    ' ycbm) �쳣���, ' +
    ' to_char(tj.ycfssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ����ʱ��, ' +
    ' to_char(tj.ycjssj,' + #39 + 'yyyy-mm-dd hh24:mi' + #39 + ') ����ʱ��,' +
    ' yhxx.khmc �ͻ����� ' +
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
  //��ȥ��ͬ�ڵ�����
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
  if (pos('��ͨ��', flag) > 0) then
    sSql := 'select * from [�����쳣] where [�쳣���] <>'
      + #39 + '�ָ�����' + #39 +
      'or [�쳣���] is null'
  else if (pos('�ָ�������', flag) > 0) then
    sSql := 'select * from [�����쳣] where [�쳣���] ='
      + #39 + '�ָ�����' + #39
  else if (pos('δ��ǵ�', flag) > 0) then
    sSql := 'select * from [�����쳣] where [�쳣���] is null' +
      ' or   [�쳣���] = ' + #39#39
  else
    sSql := 'select * from [�����쳣]';
  table_yichang_now.Close;
  table_yichang_now.SQL.Text := sSql;
  table_yichang_now.Open;
end;

function TDataModule1.get_multi_nextId: string;
var
  sSql: string;
  aQuery: TADOQuery;
begin
  sSql := 'select max([����ֵ]) from [����û�]';
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
  sSql := 'SELECT  vn.khjh as �ͻ��ֺ�,vn.KHMC as �ͻ�����,vn.BMMC ��������,' +
    ' vn.zdljdz �ն��߼���ַ, vn.cldbh as ��������, ' +
    ' vn.DBJH as ���ֺ�,tj_dlxx.kssj as ʱ��,tj_dlxx.zxzdl ����,' +
    ' t1.avg_zxzdl as ƽ������,vn.sbrl as ����,vn.xydj as ���õȼ�,' +
    ' vn.HY as ��ҵ, vn.KXMC ��· ' +
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
  sSql := 'select * from [����û�] where [��������] = ' + #39 + cldbh + #39;
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
  sSql := 'select [��������] from [����û�] where [����ֵ] = '
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
  sSql := 'select  sum(zxzdl) ����,  kssj ���� from  ' +
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
  sSql := 'select [��������] from [����û�] where [����ֵ] = '
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
  sSql := 'select  sum(zxzdl) ����,  kssj ���� from  ' +
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

  //������ͬ�ڵ�Ҳquery��������
  sSql := 'select  sum(zxzdl) ����,  kssj ���� from  ' +
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
  sSql := 'select * from [����û�] where [��������] = ' + #39 + cldbh + #39;
  aQuery := runSql_access(sSql);
  result := aQuery.fieldbyname('����ֵ').AsString;
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
      if (fieldbyname('����').AsString = formatdatetime('yyyy-mm-dd', aday)) then
        dianliang_aday := fieldbyname('����').AsFloat
      else
      begin
        dianliang_avg := dianliang_avg + fieldbyname('����').AsFloat;
        inc(dianliang_avg_count);
      end;
      {
      syslog.writeln('aday = ' + formatdatetime('yyyy-mm-dd', aday) +
        ' ����='+ fieldbyname('����').AsString +
        ' ����='+ fieldbyname('����').AsString +
        ' ƽ������=' + floattostr(dianliang_avg) +
        ' �ܼ�����=' + inttostr(dianliang_avg_count) +
        ' aDay����=' + floattostr(dianliang_aday));
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
  sSql := 'select distinct([��������]) from [�����쳣]';
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
  sSql := 'select distinct([�쳣���]) from [�����쳣]';
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
  sSql := 'select * from [�����쳣] where 1=1 ';
  if (userName <> '') then
    sSql := sSql + ' and [�ͻ�����] like ' + #39 + '%' + userName + '%' + #39;
  if (departName <> '') then
    sSql := sSql + ' and [��������] = ' + #39 + departName + #39;
  if (yichangFlag <> '') then
  begin
    if (yichangFlag = 'Null') then
      sSql := sSql + ' and ([�쳣���] is null or [�쳣���] =' + #39#39 + ')'
    else
      sSql := sSql + ' and [�쳣���] = ' + #39 + yichangFlag + #39;
  end;
  if (industries <> '') then
    sSql := sSql + ' and [��ҵ] = ' + #39 + industries + #39;
  if (userId <> '') then
  begin
    sSql := sSql + ' and ( 1=0 ';
    userId_strs := TStringList.Create;
    userId_strs.Delimiter := ',';
    userId_strs.DelimitedText := userId;
    for i := 0 to userId_strs.Count - 1 do
    begin
      sSql := sSql + ' or [�ͻ��ֺ�] = ' + #39 + userId_strs[i] + #39;
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
  sSql := 'update [�����쳣] set [�쳣���] = ' + #39 + '����' + #39 +
    ' where  [�ͻ��ֺ�] = ' + #39 + '5105124343' + #39 +
    '  or  [�ͻ��ֺ�] = ' + #39 + '5104102014' + #39 +
    '  or  [�ͻ��ֺ�] = ' + #39 + '5104000145' + #39 +   
    '  or  [�ͻ��ֺ�] = ' + #39 + '5104000144' + #39;
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
  sSql := 'SELECT  vn.khjh as �ͻ��ֺ�,vn.KHMC as �ͻ�����,vn.BMMC ��������,' +
    ' vn.zdljdz �ն��߼���ַ, vn.cldbh as ��������, ' +
    ' vn.DBJH as ���ֺ�,tj_dlxx.kssj as ʱ��,tj_dlxx.zxzdl ����,' +
    ' t1.avg_zxzdl as ƽ������,vn.sbrl as ����,vn.xydj as ���õȼ�,' +
    ' vn.HY as ��ҵ, vn.KXMC ��· ' +
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
  sSql := 'select distinct([��ҵ]) from [�����쳣]';
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
  sSql := 'select * from [�澯����]';
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
  if(isTableExist('������־')= false)then
  begin
    sSql := 'Create Table [������־]' +
  '(' +
    '[ʱ��]                   Integer' +
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
    //������Ǹ߹��߼��û�������
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
  sSql := 'SELECT  vn.khjh as �ͻ��ֺ�,vn.KHMC as �ͻ�����,vn.BMMC ��������,' +
    ' vn.zdljdz �ն��߼���ַ, vn.cldbh as ��������, ' +
    ' vn.DBJH as ���ֺ�,tj_dlxx.kssj as ʱ��,tj_dlxx.zxzdl ����,' +
    ' t1.avg_zxzdl as ƽ������,vn.sbrl as ����,vn.xydj as ���õȼ�,' +
    ' vn.HY as ��ҵ, vn.KXMC ��· ' +
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
  sInsert := 'update  [�����쳣] '+
             '  set [����] = ' +#39 + respond + #39 + ',' ;
  if((yichangFlag = 'c')or(yichangFlag = 'C'))then
     sInsert := sInsert +
               '      [�쳣���] = ' + #39 + '������' + #39
  else if((yichangFlag = 'f')or(yichangFlag = 'F'))then
     sInsert := sInsert +
               '      [�쳣���] = ' + #39 + '�쳣' + #39
  else
     sInsert := sInsert +
               '      [�쳣���] = ' + #39 + '����' + #39 ;

   sInsert := sInsert +
               '  where ([�ͻ��ֺ�] = ' + #39+ userId + #39 + ') and' +
               '        ([�쳣���] <>' + #39 + '�ָ�����' + #39 +
               '             or [�쳣���] is null)';
   execSqu_access(sInsert);
end;

procedure TDataModule1.execSqu_access(str: String);
begin
  if(aIniConfig.isSqlLog = '1')then
    syslog.writeln('execute sql in access :' + str);
  Conn_acess.Execute(str);
end;

end.

