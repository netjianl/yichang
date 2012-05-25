//------------------------------------------------------------------------------
//   ģ������:  dm_unbalance
//   ����:      �����ѹ��������ѹ��ѹ����ѹ��ѹ����ѹ������4����ƽ�ⱨ��
//              �����˲�ƽ����ʷ�� 2009-9
//   ��д�ˣ�  ����                                    ʱ�䣺 2008-2
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
    //�õ���ѹ��ѹ�쳣���û�
    procedure copyUnnormalByVoltageInHighVoltage(aDay: TDate); //��ѹ��ѹ
    procedure copyUnnormalbyVoltageInLowVoltage(aDay: TDate); //��ѹ��ѹ
    procedure copyUnnormalByCurrentInHighVoltage(aDay: TDate);
    procedure copyUnnormalByCurrentInLowVoltage(aDay: TDate);
    //ɾ����Щָ��Ϊ�������û����ڡ���ƽ�ⱨ���ų��û�������
    procedure deleteCheckUser;
    procedure deleteLowVolNot3Day(day:integer);

    //����ǰ�û�������ݲ��뵽��ʷ����
    procedure copyCurDay2History;
    //�õ���ʷ���е������û���
    procedure get_all_names(namelist:tstrings);
    //�õ���ʷ����ĳ���û��ļ�¼��������queryHistory��
    procedure getHistoryByName(aname:String);
    //���ڵ�ѹ�쳣�û�����������������������
    procedure updateHistoryDay;overload;
    //�õ���ʷ�������һ������һ��
    function getLastProcDay:Tdate;

    procedure updateCheckUserNames;
    //�������û�
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
    '����������dd.SJSJ<to_date(' +
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
    '����������dd.SJSJ<to_date(' +
                               #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
                               #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB>1) ' +
    '        OR ' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
                                #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
                                #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '����������dd.SJSJ<to_date(' +
                                #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
                                #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB>1) AND ' +
    '          (dd.CXDY<90)' +
    '     ORDER BY vn.XYDJ, vn.BMMC, vn.KHJH';
 }
  query1 := DataModule1.runSql(sSql);

  QueryAccess := TADOQuery.Create(self);
  QueryAccess.Connection := DataModule1.Conn_acess;
  sSql := 'delete * from [��ѹ��ѹ]';
  DataModule1.Conn_acess.Execute(sSql);
  sSql := 'select * from [��ѹ��ѹ]';
  QueryAccess.SQL.Text := sSql;
  QueryAccess.Open;

  if (query1.Active = true) then
  begin
    with query1 do
    begin
      first;
      while not eof do
      begin
        if (pos('·��', FieldbyName('KXMC').AsString) = 0) then
        begin
          QueryAccess.Append;
          QueryAccess.FieldByName('����').AsString := FieldbyName('KHJH').AsString;
          QueryAccess.FieldByName('��·').AsString := FieldbyName('KXMC').AsString;
          QueryAccess.FieldByName('�ͻ�����').AsString := FieldbyName('KHMC').AsString;
          QueryAccess.FieldByName('��������').AsString := FieldbyName('BMMC').AsString;
          QueryAccess.FieldByName('���ֺ�').AsString := FieldbyName('DBJH').AsString;
          QueryAccess.FieldByName('����ʱ��').AsString := FieldbyName('SJSJ').AsString;
          QueryAccess.FieldByName('A���ѹ').AsString := FieldbyName('AXDY').AsString;
          QueryAccess.FieldByName('B���ѹ').AsString := FieldbyName('BXDY').AsString;
          QueryAccess.FieldByName('C���ѹ').AsString := FieldbyName('CXDY').AsString;
          QueryAccess.FieldByName('A�����').AsString := FieldbyName('AXDL').AsString;
          QueryAccess.FieldByName('B�����').AsString := FieldbyName('BXDL').AsString;
          QueryAccess.FieldByName('C�����').AsString := FieldbyName('CXDL').AsString;
          QueryAccess.FieldByName('���õȼ�').AsString := FieldbyName('XYDJ').AsString;
          QueryAccess.Post;
        end;
        next;
      end;
    end;
  end;
  QueryAccess.Free;

  //ɾ����Щ����Ϊ0�ļ�¼
  //sSql := 'delete from [��ѹ��ѹ] '
  //       +'   where [A�����]+[B�����]+[C�����] < 0.001';
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
    '����������dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB=1) ' +
    '        OR ' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '����������dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB=1) AND ' +
    '          (dd.BXDY<180)' +
    '        OR ' +
    '          (dd.CLDBH=vn.CLDBH) AND ' +
    '          (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '����������dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '          (dd.PTBB=1) AND ' +
    '          (dd.CXDY<180)' +
    '     ORDER BY vn.XYDJ, vn.BMMC, vn.KHJH';
  query1 := DataModule1.runSql(sSql);

  QueryAccess := TADOQuery.Create(self);
  QueryAccess.Connection := DataModule1.Conn_acess;
  sSql := 'delete * from [��ѹ��ѹ]';
  DataModule1.Conn_acess.Execute(sSql);
  sSql := 'select * from [��ѹ��ѹ]';
  QueryAccess.SQL.Text := sSql;
  QueryAccess.Open;

  if (query1.Active = true) then
    with query1 do
    begin
      first;
      while not eof do
      begin
        if (pos('·��', FieldbyName('KXMC').AsString) = 0) then
        begin
          QueryAccess.Append;
          QueryAccess.FieldByName('����').AsString := FieldbyName('KHJH').AsString;
          QueryAccess.FieldByName('�ͻ�����').AsString := FieldbyName('KHMC').AsString;
          QueryAccess.FieldByName('��·').AsString := FieldbyName('KXMC').AsString;
          QueryAccess.FieldByName('��������').AsString := FieldbyName('BMMC').AsString;
          QueryAccess.FieldByName('���ֺ�').AsString := FieldbyName('DBJH').AsString;
          QueryAccess.FieldByName('����ʱ��').AsString := FieldbyName('SJSJ').AsString;
          QueryAccess.FieldByName('A���ѹ').AsString := FieldbyName('AXDY').AsString;
          QueryAccess.FieldByName('B���ѹ').AsString := FieldbyName('BXDY').AsString;
          QueryAccess.FieldByName('C���ѹ').AsString := FieldbyName('CXDY').AsString;
          QueryAccess.FieldByName('A�����').AsString := FieldbyName('AXDL').AsString;
          QueryAccess.FieldByName('B�����').AsString := FieldbyName('BXDL').AsString;
          QueryAccess.FieldByName('C�����').AsString := FieldbyName('CXDL').AsString;
          QueryAccess.FieldByName('���õȼ�').AsString := FieldbyName('XYDJ').AsString;
          QueryAccess.FieldByName('�ն˵�ַ').AsString := FieldbyName('ZDLJDZ').AsString;
          QueryAccess.Post;
        end;
        next;
      end;
    end;
  QueryAccess.Free;

  //ɾ����Щ����Ϊ0�ļ�¼
  //sSql := 'delete from [��ѹ��ѹ] '
  //      + '   where [A�����]+[B�����]+[C�����] < 0.001' ;
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
    '��������dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '        (abs(dd.AXDl/(dd.CXDL+0.00001)-1)>1) AND ' +
    '        (dd.PTBB>1) AND ' +
    '        ((dd.CXDL+dd.BXDL+dd.AXDL)*dd.CTBB>2)' +
    '      OR (dd.CLDBH=vn.CLDBH) AND ' +
    '        (dd.SJSJ>= to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday - 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ') and ' +
    '��������dd.SJSJ<to_date(' +
    #39 + formatdatetime('yyyy-mm-dd', aday + 1) + #39 + ',' +
    #39 + 'yyyy-mm-dd' + #39 + ')) and ' +
    '         (dd.PTBB>1) AND ' +
    '         ((dd.CXDL+dd.BXDL+dd.AXDL)*dd.CTBB>2) AND ' +
    '         (abs(dd.CXDl/(dd.AXDL+0.00001)-1)>1)' +
    '  ORDER BY vn.XYDJ, vn.BMMC, vn.KHJH';

  query1 := DataModule1.runSql(sSql);

  QueryAccess := TADOQuery.Create(self);
  QueryAccess.Connection := DataModule1.Conn_acess;
  sSql := 'delete * from [��ѹ����]';
  DataModule1.Conn_acess.Execute(sSql);
  sSql := 'select * from [��ѹ����]';
  QueryAccess.SQL.Text := sSql;
  QueryAccess.Open;

  if (query1.Active = true) then
    with query1 do
    begin
      first;
      while not eof do
      begin
        if (pos('·��', FieldbyName('KXMC').AsString) = 0) then
        begin
          QueryAccess.Append;
          QueryAccess.FieldByName('����').AsString := FieldbyName('KHJH').AsString;
          QueryAccess.FieldByName('�ͻ�����').AsString := FieldbyName('KHMC').AsString;
          QueryAccess.FieldByName('��·').AsString := FieldbyName('KXMC').AsString;
          QueryAccess.FieldByName('���ֺ�').AsString := FieldbyName('DBJH').AsString;
          QueryAccess.FieldByName('����ʱ��').AsString := FieldbyName('SJSJ').AsString;
          QueryAccess.FieldByName('��������').AsString := FieldbyName('BMMC').AsString;
          QueryAccess.FieldByName('A�����').AsString := FieldbyName('AXDL').AsString;
          QueryAccess.FieldByName('B�����').AsString := FieldbyName('BXDL').AsString;
          QueryAccess.FieldByName('C�����').AsString := FieldbyName('CXDL').AsString;
          QueryAccess.FieldByName('���õȼ�').AsString := FieldbyName('XYDJ').AsString;
          QueryAccess.Post;
        end;
        next;
      end;
    end;
  QueryAccess.Free;

  //ɾ����Щ�����澯�Ƚ��ټ�¼��
  sSql := 'delete from [��ѹ����] ' +
    '   where [����]  in ( select [����] from [��ѹ����] ' +
    '                         group by [����]' +
    '                         having count([����])<4)';
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
          '��������dd.SJSJ<to_date('+
                   #39 + formatdatetime('yyyy-mm-dd',aday+1 )+ #39 + ','+
                   #39 +'yyyy-mm-dd'+#39+')) and '+
          '        (abs(dd.AXDl/(dd.CXDL+0.00001)-1)>1) AND ' +
          '        (dd.PTBB=1) AND '+
          '        ((dd.CXDL+dd.BXDL+dd.AXDL)*dd.CTBB>40)'+
          '      OR (dd.CLDBH=vn.CLDBH) AND ' +
          '        (dd.SJSJ>= to_date('+
                   #39 + formatdatetime('yyyy-mm-dd',aday-1 )+ #39 + ','+
                   #39 +'yyyy-mm-dd'+#39+') and '+
          '��������dd.SJSJ<to_date('+
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
    '��������dd.SJSJ<to_date(' +
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
  sSql := 'delete * from [��ѹ����]';
  DataModule1.Conn_acess.Execute(sSql);
  sSql := 'select * from [��ѹ����]';
  QueryAccess.SQL.Text := sSql;
  QueryAccess.Open;

  if (query1.Active = true) then
    with query1 do
    begin
      first;
      while not eof do
      begin
        if (pos('·��', FieldbyName('KXMC').AsString) = 0) then
        begin
          QueryAccess.Append;
          QueryAccess.FieldByName('����').AsString := FieldbyName('KHJH').AsString;
          QueryAccess.FieldByName('�ͻ�����').AsString := FieldbyName('KHMC').AsString;
          QueryAccess.FieldByName('��·').AsString := FieldbyName('KXMC').AsString;
          QueryAccess.FieldByName('���ֺ�').AsString := FieldbyName('DBJH').AsString;
          QueryAccess.FieldByName('����ʱ��').AsString := FieldbyName('SJSJ').AsString;
          QueryAccess.FieldByName('��������').AsString := FieldbyName('BMMC').AsString;
          QueryAccess.FieldByName('A�����').AsString := FieldbyName('AXDL').AsString;
          QueryAccess.FieldByName('B�����').AsString := FieldbyName('BXDL').AsString;
          QueryAccess.FieldByName('C�����').AsString := FieldbyName('CXDL').AsString;
          QueryAccess.FieldByName('���õȼ�').AsString := FieldbyName('XYDJ').AsString;
          QueryAccess.Post;
        end;
        next;
      end;
    end;
  QueryAccess.Free;

  //ɾ����Щ�����澯�Ƚ��ټ�¼��
  sSql := 'delete from [��ѹ����] ' +
    '   where [����]  in ( select [����] from [��ѹ����] ' +
    '                         group by [����]' +
    '                         having count([����])<4)';
  DataModule1.Conn_acess.Execute(sSql);

end;

{
procedure Tunbalance_dm.getAntiPolarUser;
var
  sSql: string;
  aQuery, aQueryTmp: Tadoquery;

begin
  sSql := 'SELECT vn.cldbh, vn.KHJH, vn.KHMC, vn.DBJH, vn.BMMC, td.KSSJ, td.ZXZDL, td.FXZDL' +
    '��FROM gruser.tj_dlxx td, ' + aIniConfig.V_NCYHXX + ' vn ' +
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
  aSql := 'delete from [��ѹ����] ' +
          '  where [����] in (select [����] from [��ƽ�ⱨ���ų��û�]'+
          '                      where [����״̬] = '+ #39 + '����' + #39 + ') ';
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'delete from [��ѹ����] ' +
          '  where [����] in (select [����] from [��ƽ�ⱨ���ų��û�]'+
          '                      where [����״̬] = '+ #39 + '����' + #39 + ') ';
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'delete from [��ѹ��ѹ] ' +
          '  where [����] in (select [����] from [��ƽ�ⱨ���ų��û�]'+
          '                      where [����״̬] = '+ #39 + '����' + #39 + ') ';
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'delete from [��ѹ��ѹ] ' +
          '  where [����] in (select [����] from [��ƽ�ⱨ���ų��û�]'+
          '                      where [����״̬] = '+ #39 + '����' + #39 + ') ';
  datamodule1.Conn_acess.Execute(aSql);

  aSql := 'update [��ѹ����] a, [��ƽ�ⱨ���ų��û�] b  ' +
          '   set a.[���˵��] = b.[���˵��]'+
          '   where a.[����] = b.[����] ';// +
          //'      and b.[����״̬] <> '+ #39 + '����' + #39;
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'update [��ѹ��ѹ] a, [��ƽ�ⱨ���ų��û�] b  ' +
          '   set a.[���˵��] = b.[���˵��]'+
          '   where a.[����] = b.[����] ';// +
          //'      and b.[����״̬] <> '+ #39 + '����' + #39;
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'update [��ѹ����] a, [��ƽ�ⱨ���ų��û�] b  ' +
          '   set a.[���˵��] = b.[���˵��]'+
          '   where a.[����] = b.[����] ';// +
          //'      and b.[����״̬] <> '+ #39 + '����' + #39;
  datamodule1.Conn_acess.Execute(aSql);
  aSql := 'update [��ѹ��ѹ] a, [��ƽ�ⱨ���ų��û�] b  ' +
          '   set a.[���˵��] = b.[���˵��]'+
          '   where a.[����] = b.[����] ';// +
          //'      and b.[����״̬] <> '+ #39 + '����' + #39;
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
        strName := dm_userInfo.getName_byUserId_oracle(fieldbyname('����').AsString);
        if(strName <> '')then
        begin
          edit;
          fieldbyname('�ͻ�����').AsString := strName;
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
  sSql := 'insert into [��ƽ����ʷ��]([����],[�ͻ�����],[����],[����])' +
          '      SELECT [����],max([�ͻ�����]) as [�ͻ�����1], '+
          '             min([����ʱ��]) as ����,"����" as [����]'+
          '         from [��ѹ����]' +
          '         group by [����]';
  datamodule1.Conn_acess.Execute(sSql);

  sSql := 'insert into [��ƽ����ʷ��]([����],[�ͻ�����],[����],[����])' +
          '      SELECT [����],max([�ͻ�����]) as [�ͻ�����1], '+
          '             min([����ʱ��]) as ����,"����" as [����]'+
          '         from [��ѹ����]' +
          '         group by [����]';
  datamodule1.Conn_acess.Execute(sSql);

  sSql := 'insert into [��ƽ����ʷ��]([����],[�ͻ�����],[����],[����])' +
          '      SELECT [����],max([�ͻ�����]) as [�ͻ�����1], '+
          '             min([����ʱ��]) as ����,"��ѹ" as [����]'+
          '         from [��ѹ��ѹ]' +
          '         group by [����]';
  datamodule1.Conn_acess.Execute(sSql);

  sSql := 'insert into [��ƽ����ʷ��]([����],[�ͻ�����],[����],[����])' +
          '      SELECT [����],max([�ͻ�����]) as [�ͻ�����1], '+
          '             min([����ʱ��]) as ����,"��ѹ" as [����]'+
          '         from [��ѹ��ѹ]' +
          '         group by [����]';
  datamodule1.Conn_acess.Execute(sSql);

end;

procedure Tunbalance_dm.get_all_names(namelist: tstrings);
var
  sSql :string;
  aQuery :TADOQuery;
begin
  sSql := 'select distinct([�ͻ�����]) from [��ƽ����ʷ��]';
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
  sSql := 'select * from [��ƽ����ʷ��]' +
          '  where [�ͻ�����] = ' + #39 + aName + #39;
  DataModule1.runSql_access(sSql, queryHistory);
end;

procedure Tunbalance_dm.updateHistoryDay;
begin
  //updateHistoryDay('��ѹ��ѹ');
  //updateHistoryDay('��ѹ��ѹ');
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
  sSql := 'select [�ͻ�����],min(DateValue([����ʱ��])) from [' + voltype + ']'
         +'  group by [�ͻ�����]';
  DataModule1.runSql_access(sSql, aQuery);
  aQuery.First;
  while not aQuery.Eof do
  begin
    aName := aQuery.Fields[0].AsString;
    aDate := aQuery.Fields[1].AsDatetime;
    sSql := 'select * from ( select distinct(DateValue([����])) as ��������'
           +'                  from  [��ƽ����ʷ��]'
           +'                 where [�ͻ�����] = ' + #39 + aName + #39
           +'                 and [����] = ' + #39 + '��ѹ' + #39
           +'              )'
           +'order by  �������� desc';
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
    sSql := 'update [' + voltype + '] set [��������]= '
           +   inttostr(count)
           +'  where [�ͻ�����] = ' + #39 + aName + #39;
    DataModule1.execSqu_access(sSql);
    aHistoryQuery.Next;
    aQuery.Next;
  end;

  aQuery.Free;
  aHistoryQuery.Free;
end;
}


(*delete from [��ѹ��ѹ] where [����] not in
(
  select [����] from
  (
    select  [����],count( * ) as c1
    from (      SELECT distinct [����],[����]
                FROM ��ƽ����ʷ��
               WHERE (((��ƽ����ʷ��.����)="��ѹ") AND ((��ƽ����ʷ��.����)>#7/13/2009# And (��ƽ����ʷ��.����)<#10/15/2009#))
         )
    group by [����]
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
    'SELECT distinct [����],[����]   '+
    '  FROM [��ƽ����ʷ��] ' +
    '  WHERE (([����]="��ѹ") '+
    '    AND  ([����]<=#'+FormatDateTime('m/d/yyyy', now -1 ) + '# '+
    '               And [����]>=#'+FormatDateTime('m/d/yyyy', now - 1 - day)+'#)'+
    '        )';
  strCountTable :=
    'select   [����],count( * ) as c1 ' +
    '  from (' +  strDistinctTable + ')' +
    '  group by [����]';
  strIdTable :=
    'select  [����] ' +
    '  from (' + strCountTable + ')' +
    '  where c1 >= ' + inttostr(day) ;
  strDelete :=
    'delete * from  [��ѹ��ѹ]' +
    '  where [����] not in (' + strIdTable + ')';
  datamodule1.Conn_acess.Execute(strDelete);
end;

function Tunbalance_dm.getLastProcDay: Tdate;
Var
  sSql:String;
  aQuery :TAdoQuery;
begin
  sSql :=
    'SELECT max([����]) '+
    '  FROM [��ƽ����ʷ��] ';
  aQuery := DataModule1.runSql_access(sSql);
  result := EncodeDate(2000,1,1);
  if(not aQuery.IsEmpty)then
    result := aQuery.Fields[0].AsDateTime;
end;

end.

