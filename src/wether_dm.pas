//------------------------------------------------------------------------------
//   模块名称:  wether_dm
//   功能:     气象信息处理的数据模块
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------

unit wether_dm;

interface

uses
  SysUtils, Classes, DB, ADODB,Controls;

type
  Twetherdm = class(TDataModule)
    tableWether: TADOTable;
    dsWether: TDataSource;
    queryWether: TADOQuery;
    queryWetherLastyear: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure getWether(beginDay, endDay:Tdate);

  end;

var
  wetherdm: Twetherdm;

implementation

uses dm;

{$R *.dfm}

{ Twetherdm }

procedure Twetherdm.getWether(beginDay, endDay: Tdate);
var
  sSql:String;
begin
  queryWether.Close;
  sSql := 'select * from [气象信息] where [日期] > #' +
    formatdatetime('yyyy-mm-dd', beginDay-1) +
    '# and [日期] < #' +
    formatdatetime('yyyy-mm-dd', endDay + 1)+'#';
  queryWether.SQL.Text := sSql;
  queryWether.Open;

  queryWetherLastyear.Close;
  sSql := 'select * from [气象信息] where [日期] > #' +
    formatdatetime('yyyy-mm-dd', beginDay-1 -365) +
    '# and [日期] < #' +
    formatdatetime('yyyy-mm-dd', endDay + 1-365)+'#';
  queryWetherLastyear.SQL.Text := sSql;
  queryWetherLastyear.Open;

end;

end.
