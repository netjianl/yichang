//------------------------------------------------------------------------------
//   ģ������:  V_NCYHXX_unit
//   ����:      ��V_NCYHXX���������ȡ���ָ���������
//   ��д�ˣ�  ����                                    ʱ�䣺 2009-9-15
//------------------------------------------------------------------------------
unit V_NCYHXX_unit;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  Tdm_userInfo = class(TDataModule)
    ADOQuery1: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    //--�û�������Ϣ��
    //�ӻ��ŵõ��������ţ�ԭ��������Ϊ��Ψһ�ֶ��ɻ��Ÿ�Ϊ��������
    function get_cldbh(huhao: string): string;
    //�õ���ǰ�û��ı��
    function getMeterNum_oracle(userId: string): string;
    //�Ƿ��Ǹ߹��߼��û� pbbb>1
    function isPTBBaboveOne(cldbh: string): Boolean;
    //�Ӳ������ŵõ��û����
    function getMeterNum_by_cldbh(cldbh: string): string;
    //�ӻ��ŵõ��û�����
    function getName_byUserId_oracle(userId:String):String;
    //�õ����е��û���������
    function getAllCldbh_zb(var cldbhs: tstrings): boolean; //ר���û�
    function getAllCldbh(var cldbhs: tstrings): boolean;
    //�õ��û���Ϣ,���ض��ĸ�ʽ�����ض�����Ϣ
    function getUserInfo(cldbh: string): string;

  end;

var
  dm_userInfo: Tdm_userInfo;

implementation

uses dm, iniConfig;

{$R *.dfm}

{ Tdm_userInfo }

function Tdm_userInfo.get_cldbh(huhao: string): string;
var
  sSql: string;
  query1: TadoQuery;
begin
  sSql := 'select cldbh from '+ aIniConfig.V_NCYHXX + ' where khjh = ' +
    #39 + huhao + #39;
  query1 := DataModule1.runSql(sSql);
  result := '';
  with query1 do
  begin
    first;
    while not eof do
    begin
      if (result = '') then
        result := query1.Fields[0].AsString
      else
        result := result + ',' + query1.Fields[0].AsString;
      next;
    end;
  end;
end;

function Tdm_userInfo.getMeterNum_by_cldbh(cldbh: string): string;
var
  sSql: string;
  aQuery: TAdoQuery;
begin
  sSql := 'select dbjh from '+ aIniConfig.V_NCYHXX + ' where cldbh = '
    + #39 + cldbh + #39;
  aQuery := DataModule1.runSql(ssql);
  if(not aQuery.IsEmpty)then
    result := aQuery.Fields[0].AsString;
end;

function Tdm_userInfo.getMeterNum_oracle(userId: string): string;
var
  sSql: string;
  aQuery: TAdoQuery;
begin
  sSql := 'select dbjh from ' + aIniConfig.V_NCYHXX + '  where khjh = '
    + #39 + userId + #39;
  aQuery := DataModule1.runSql(ssql);
  if(not aQuery.IsEmpty)then
    result := aQuery.Fields[0].AsString;
end;

function Tdm_userInfo.getName_byUserId_oracle(userId: String): String;
var
  sSql:String;
  aQuery:TADOQuery;
begin
  sSql := 'SELECT  vn.khjh ,vn.KHMC ' +
          '  from '+ aIniConfig.V_NCYHXX + ' vn'+
          '  where vn.khjh = '+#39+userId+#39;
  aQuery := DataModule1.runSql(sSql);
  if(aquery.Active = true)then
    result := aQuery.fieldbyName('KHMC').AsString;
end;

function Tdm_userInfo.isPTBBaboveOne(cldbh: string): Boolean;
var
  sSql: string;
  query1: TadoQuery;
  str: string;
  ptbb: integer;
begin
  sSql := 'select ptbb from ' + aIniConfig.V_NCYHXX + ' where cldbh = ' +
    #39 + cldbh + #39;
  query1 := DataModule1.runSql(sSql);
  if(not query1.IsEmpty)then
    str := query1.Fields[0].asstring;
  result := false;
  if (trystrtoint(str, ptbb)) then
  begin
    if (ptbb > 1) then
      result := true;
  end
end;

function Tdm_userInfo.getAllCldbh(var cldbhs: tstrings): boolean;
var
  sSql: string;
  aQuery: TAdoQuery;
begin
  sSql := 'select cldbh from '+ aIniConfig.V_NCYHXX ;
  aquery := DataModule1.runSql(sSql);
  aQuery.First;
  while not aQuery.Eof do
  begin
    cldbhs.Add(aQuery.Fields[0].asstring);
    aQuery.Next;
  end;
  result := true;
end;

function Tdm_userInfo.getAllCldbh_zb(var cldbhs: tstrings): boolean;
var
  sSql: string;
  aQuery: TAdoQuery;
begin
  sSql := 'select cldbh from ' + aIniConfig.V_NCYHXX +
    ' where JLFS=10 or JLFS=20';
  aquery := DataModule1.runSql(sSql);
  aQuery.First;
  while not aQuery.Eof do
  begin
    cldbhs.Add(aQuery.Fields[0].asstring);
    aQuery.Next;
  end;
  result := true;
end;

function Tdm_userInfo.getUserInfo(cldbh: string): string;
var
  sSql: string;
  aQuery: TAdoQuery;
begin // vn.cldbh,
  sSql := 'select vn.khjh, vn.khmc, vn.bmmc,vn.sbrl from '+ aIniConfig.V_NCYHXX + ' vn ' +
    'where vn.cldbh = ' + #39 + cldbh + #39;
  aquery := DataModule1.runSql(sSql);
  if(not aquery.IsEmpty)then
    result := aquery.Fields[0].AsString + ' ' +
      aQuery.Fields[1].AsString + ' ' +
      aQuery.Fields[2].AsString + ' ' +
      aQuery.Fields[3].AsString + ' ';
end;

end.
