//------------------------------------------------------------------------------
//   模块名称:  iniConfig
//   功能:      多表用户的查看界面
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------

unit multiMeterUserListUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ComCtrls, ExtCtrls, TeEngine, Series,
  TeeProcs, Chart, DbChart, DBCtrls;

type
  TmutliUserList_form = class(TForm)
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    FindDialog1: TFindDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PageControl1: TPageControl;
    sumDianliang: TTabSheet;
    tsLines: TTabSheet;
    DBGrid2: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    dtpBegin: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    DBChart1: TDBChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    DBGrid3: TDBGrid;
    TabSheet1: TTabSheet;
    DBMemo1: TDBMemo;
    DBChart2: TDBChart;
    Series3: TLineSeries;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure locate(cldbh:String);
  end;

var
  mutliUserList_form: TmutliUserList_form;

implementation

uses dm, multiMeterUserUnit, wether_dm;

{$R *.dfm}

procedure TmutliUserList_form.Button2Click(Sender: TObject);
begin
  // DataModule1.mutliUserList_query.Edit;
  DataModule1.mutliUserList_query.Delete;
  //DataModule1.mutliUserList_query.post;
end;

procedure TmutliUserList_form.Button1Click(Sender: TObject);
begin
  multiMeterUserForm.new;
  datamodule1.mutliUserList_query.Close;
  datamodule1.mutliUserList_query.open;
end;

procedure TmutliUserList_form.Button3Click(Sender: TObject);
begin
  multiMeterUserForm.view(datamodule1.mutliUserList_query.fieldbyname('索引值').AsString);
  datamodule1.mutliUserList_query.Close;
  datamodule1.mutliUserList_query.open;
end;

procedure TmutliUserList_form.Button4Click(Sender: TObject);
begin
  self.FindDialog1.Execute;

end;

procedure TmutliUserList_form.FindDialog1Find(Sender: TObject);
begin
  if datamodule1.mutliUserList_query.Active = false then
    exit;
  datamodule1.mutliUserList_query.DisableControls;
  with datamodule1.mutliUserList_query do
  begin
    while true do
    begin
      if(frDown	in finddialog1.Options) then
          next
      else
        Prior;
      if(pos(finddialog1.FindText,fieldbyname('测量点编号').asstring)>0)then
        break;
      if(pos(finddialog1.FindText,fieldbyname('客户名称').asstring)>0)then
        break;
      if(pos(finddialog1.FindText,fieldbyname('户号').asstring)>0)then
        break;
      if(pos(finddialog1.FindText,fieldbyname('表号').asstring)>0)then
        break;
      if(pos(finddialog1.FindText,fieldbyname('终端逻辑地址').asstring)>0)then
        break;
      if(frDown	in finddialog1.Options) then
      begin
        if(eof)then break;
      end
      else
      begin
        if(bof)then break;
      end;
      //next;
    end;
  end;
  datamodule1.mutliUserList_query.EnableControls;

end;

procedure TmutliUserList_form.DBGrid1CellClick(Column: TColumn);
begin
  if((PageControl1.ActivePage = sumDianliang)
    or(PageControl1.ActivePage = tsLines))then
  begin
   edit1.Text :=  datamodule1.mutliUserList_query.fieldbyname('索引值').AsString;
    DataModule1.get_mutliUser_dianliang(
      datamodule1.mutliUserList_query.fieldbyname('索引值').AsString,
      dtpBegin.Date,
      dtpEnd.Date);
     wetherdm.getWether(dtpBegin.Date,
      dtpEnd.Date);
  end;
end;

procedure TmutliUserList_form.FormShow(Sender: TObject);
begin
  self.dtpBegin.Date := now -30;
  self.dtpEnd.Date := now;

end;

procedure TmutliUserList_form.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  self.FindDialog1.CloseDialog;
end;

procedure TmutliUserList_form.locate(cldbh: String);
begin
  datamodule1.mutliUserList_query.Active := true;
  datamodule1.mutliUserList_query.Locate('测量点编号', cldbh, []);
  DBGrid1CellClick(dbgrid1.Columns[0]);
  self.ShowModal;
end;

end.
