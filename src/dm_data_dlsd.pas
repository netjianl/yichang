//------------------------------------------------------------------------------
//   模块名称:  dm_data_dlsd
//   功能:     对于orcle中的data_dlsd这个表进行的一些操作
//   编写人：  简亮                                    时间： 2009-4
//------------------------------------------------------------------------------

unit dm_data_dlsd;

interface

uses
  SysUtils, Classes, DB, ADODB,Controls;

type
  Tdlsd_dm = class(TDataModule)
    ADOQuery1: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function getValidHour(cldbh:String;aDay:TDate):integer;
  end;

var
  dlsd_dm: Tdlsd_dm;

implementation

uses dm;

{$R *.dfm}

{ Tdlsd_dm }

function Tdlsd_dm.getValidHour(cldbh: String; aDay: TDate): integer;
var
  str:String;
begin
  str := 'select count(sjsj) ' +
         '  from gruser.data_dlsd ' +
         '  where (cldbh = ' + #39 + cldbh + #39 + ')' +
         '        and  (sjsj >= to_date('+
                       #39 + formatdatetime('yyyy-mm-dd 00:00:00', aday ) + #39 + ',' +
                       #39 + 'yyyy-mm-dd hh24:mi:ss' + #39 + '))' +
         '        and  (sjsj <= to_date('+
                       #39 + formatdatetime('yyyy-mm-dd 23:00:00', aday  ) + #39 + ',' +
                       #39 + 'yyyy-mm-dd  hh24:mi:ss' + #39 + '))';
  DataModule1.runSql(str, ADOQuery1);
  result := 0;
  if(not ADOQuery1.IsEmpty)then
    result := adoquery1.Fields[0].AsInteger;
end;

end.
