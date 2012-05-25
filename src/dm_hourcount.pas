//------------------------------------------------------------------------------
//   ģ������:  dm_hourcount
//   ����:     ����access�е�����ɼ�ͳ���������е�һЩ����
//   ��д�ˣ�  ����                                    ʱ�䣺 2009-4
//------------------------------------------------------------------------------

unit dm_hourcount;

interface

uses
  SysUtils, Classes, DB, ADODB,controls;

type
  Thourcount_dm = class(TDataModule)
    ADOQuery1: TADOQuery;
    hourCountQuery: TADOQuery;
    dsHourCount: TDataSource;
    sumInDay: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure addrecord(cldbh:String; bh:String; aDay:tdate; count:Integer);
    function getHourCountDay(cldbh:String):String;
    function getHourCountSum(aDay:TDate):Tadoquery;
  end;

var
  hourcount_dm: Thourcount_dm;

implementation

uses dm;

{$R *.dfm}

{ Thourcount_dm }

procedure Thourcount_dm.addrecord(cldbh, bh: String; aDay: tdate;
  count: Integer);
var
  sSql:String;
begin
  sSql := 'select * from [����ɼ�ͳ��] where 1=0';
  //sSql := 'select * from [����ɼ�ͳ��] ' +
  //        '   where [��������] = '+ #39 + cldbh + #39;
  DataModule1.runSql_access(sSql, ADOQuery1);
  //ADOQuery1.Edit;
  //if(adoquery1.RecordCount = 0)then
  begin
    adoquery1.Insert;
    adoquery1.FieldByName('��������').AsString := cldbh;
  end;
  adoquery1.FieldByName('���').AsString := bh;
  adoquery1.FieldByName('����').asstring := datetostr(aday);
  adoquery1.FieldByName('����ɼ���').AsInteger := count;
  adoquery1.Post;
end;

//�������µ�һ��ȱ�ɼ������Ϣ
function Thourcount_dm.getHourCountDay(cldbh: String): String;
var
  sSql:String;
begin
  sSql := 'select * from [����ɼ�ͳ��] '+
          '   where [��������] = '+ #39 + cldbh + #39 +
          '   order by [����] desc';
  DataModule1.runSql_access(sSql, ADOQuery1);
  if(adoquery1.RecordCount > 0)then
    result := ADOQuery1.fieldbyname('����').asstring + '�ɼ�������' +
      ADOQuery1.fieldbyName('����ɼ���').AsString + '��'
  else
    result := '';
end;

function Thourcount_dm.getHourCountSum(aDay: TDate):tadoquery;
var
  sSql:string;
begin
  sSql := 'select [����ɼ���],count([��������]) as �û��� from [����ɼ�ͳ��] ' +
          '   where [����] = #' + formatdatetime('yyyy-mm-dd', aDay) + '#' +
          '   group by  [����ɼ���]' ;
         // '   ordery by  [����ɼ���]';
  DataModule1.runSql_access(sSql, sumInDay);
  result := sumInDay;
end;

end.
