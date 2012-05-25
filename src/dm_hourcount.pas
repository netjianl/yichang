//------------------------------------------------------------------------------
//   模块名称:  dm_hourcount
//   功能:     对于access中的整点采集统计这个表进行的一些操作
//   编写人：  简亮                                    时间： 2009-4
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
  sSql := 'select * from [整点采集统计] where 1=0';
  //sSql := 'select * from [整点采集统计] ' +
  //        '   where [测量点编号] = '+ #39 + cldbh + #39;
  DataModule1.runSql_access(sSql, ADOQuery1);
  //ADOQuery1.Edit;
  //if(adoquery1.RecordCount = 0)then
  begin
    adoquery1.Insert;
    adoquery1.FieldByName('测量点编号').AsString := cldbh;
  end;
  adoquery1.FieldByName('表号').AsString := bh;
  adoquery1.FieldByName('日期').asstring := datetostr(aday);
  adoquery1.FieldByName('整点采集数').AsInteger := count;
  adoquery1.Post;
end;

//返回最新的一条缺采集点的信息
function Thourcount_dm.getHourCountDay(cldbh: String): String;
var
  sSql:String;
begin
  sSql := 'select * from [整点采集统计] '+
          '   where [测量点编号] = '+ #39 + cldbh + #39 +
          '   order by [日期] desc';
  DataModule1.runSql_access(sSql, ADOQuery1);
  if(adoquery1.RecordCount > 0)then
    result := ADOQuery1.fieldbyname('日期').asstring + '采集到数据' +
      ADOQuery1.fieldbyName('整点采集数').AsString + '次'
  else
    result := '';
end;

function Thourcount_dm.getHourCountSum(aDay: TDate):tadoquery;
var
  sSql:string;
begin
  sSql := 'select [整点采集数],count([测量点编号]) as 用户数 from [整点采集统计] ' +
          '   where [日期] = #' + formatdatetime('yyyy-mm-dd', aDay) + '#' +
          '   group by  [整点采集数]' ;
         // '   ordery by  [整点采集数]';
  DataModule1.runSql_access(sSql, sumInDay);
  result := sumInDay;
end;

end.
