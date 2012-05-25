//------------------------------------------------------------------------------
//   ģ������:  wether_dm
//   ����:     ������Ϣ���������ģ��
//   ��д�ˣ�  ����                                    ʱ�䣺 2008-2
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
  sSql := 'select * from [������Ϣ] where [����] > #' +
    formatdatetime('yyyy-mm-dd', beginDay-1) +
    '# and [����] < #' +
    formatdatetime('yyyy-mm-dd', endDay + 1)+'#';
  queryWether.SQL.Text := sSql;
  queryWether.Open;

  queryWetherLastyear.Close;
  sSql := 'select * from [������Ϣ] where [����] > #' +
    formatdatetime('yyyy-mm-dd', beginDay-1 -365) +
    '# and [����] < #' +
    formatdatetime('yyyy-mm-dd', endDay + 1-365)+'#';
  queryWetherLastyear.SQL.Text := sSql;
  queryWetherLastyear.Open;

end;

end.
