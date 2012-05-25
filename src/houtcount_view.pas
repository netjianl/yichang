//------------------------------------------------------------------------------
//   模块名称:  houtcount_view
//   功能:      显示缺少采集点的界面
//   编写人：  简亮                                    时间： 2009-5-18
//------------------------------------------------------------------------------
unit houtcount_view;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, ComCtrls, StdCtrls, Series,
  DB, ADODB, Grids, DBGrids;

type
  Thourcount_viewForm = class(TForm)
    DateTimePicker1: TDateTimePicker;
    Chart1: TChart;
    Button1: TButton;
    Series1: TBarSeries;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure DateTimePicker1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    oldDate:Tdate;
  public
    { Public declarations }
  end;

var
  hourcount_viewForm: Thourcount_viewForm;

implementation

uses dm_hourcount;

{$R *.dfm}

procedure Thourcount_viewForm.DateTimePicker1Change(Sender: TObject);
var
  aQuery :TADoquery;
  i:integer;
begin
  if(oldDate = DateTimePicker1.Date)then
    exit;

  oldDate := DateTimePicker1.Date;
  aQuery := hourcount_dm.getHourCountSum(oldDate);
  if(aQuery.Active = false)then
    exit;

  Series1.Clear;
  with aQuery do
  begin
    for i:= 0 to 23 do
    begin
      if(aQuery.Locate('整点采集数', i, []))then
        series1.Add(fieldbyName('用户数').AsInteger, inttostr(i))
      else
        series1.Add(0, inttostr(i));
    end;
  end;
end;

procedure Thourcount_viewForm.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := now -1;
end;

end.
