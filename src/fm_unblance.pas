//------------------------------------------------------------------------------
//   模块名称:  fm_unblance
//   功能:      不平衡电压和电流报表操作界面
//   编写人：  简亮                                    时间： 2009-8-22
//------------------------------------------------------------------------------
unit fm_unblance;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, DBCtrls, Spin, ComCtrls;

type
  TunbalanceForm = class(TForm)
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Button1: TButton;
    DBNavigator1: TDBNavigator;
    DBMemo1: TDBMemo;
    Button3: TButton;
    dayEdit: TSpinEdit;
    Label2: TLabel;
    Button2: TButton;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  unbalanceForm: TunbalanceForm;

implementation

uses dm_unbalance, dm, MessageBoxUnit, iniConfig;

{$R *.dfm}

procedure TunbalanceForm.Button1Click(Sender: TObject);
var
  aDay: TDate;
  aLastProcDay :Tdate;
begin
  aDay := DataModule1.getOracleDate;
  aLastProcDay := unbalance_dm.getLastProcDay;
  if((aDay - aLastProcDay) > 3)then
     aLastProcDay := aDay - 3;
  button1.Enabled := false;
  try
    while(aLastProcDay <= aDay) do
    begin
      StatusBar1.Panels[0].Text := DateToStr(aLastProcDay) + '高压电压';
      Application.ProcessMessages;
      unbalance_dm.copyUnnormalByVoltageInHighVoltage(aLastProcDay);
      StatusBar1.Panels[0].Text := DateToStr(aLastProcDay) + '低压电压';
      Application.ProcessMessages;
      unbalance_dm.copyUnnormalbyVoltageInLowVoltage(aLastProcDay);
      StatusBar1.Panels[0].Text := DateToStr(aLastProcDay) + '高压电流';
      Application.ProcessMessages;
      unbalance_dm.copyUnnormalByCurrentInHighVoltage(aLastProcDay);
      StatusBar1.Panels[0].Text := DateToStr(aLastProcDay) + '低压电流';
      Application.ProcessMessages;
      unbalance_dm.copyUnnormalByCurrentInLowVoltage(aLastProcDay);
      StatusBar1.Panels[0].Text := DateToStr(aLastProcDay) + '加入历史表';
      Application.ProcessMessages;
      unbalance_dm.copyCurDay2History;
     aLastProcDay := aLastProcDay + 1;
    end;
    StatusBar1.Panels[0].Text := '处理例外';
    Application.ProcessMessages;
    unbalance_dm.deleteCheckUser;
    //删除在历史表中没有最近连续三天出现的记录
    StatusBar1.Panels[0].Text := '删除在历史表中没有最近连续三天出现的记录';
    Application.ProcessMessages;
    if(strtoint(aIniConfig.lowVolNoReportDay) > 0)  then
      unbalance_dm.deleteLowVolNot3Day(strtoint(aIniConfig.lowVolNoReportDay));
  finally
    button1.Enabled := true;
  end;
  InformationBox('好了');
end;

procedure TunbalanceForm.Button2Click(Sender: TObject);
begin
  //unbalance_dm.deleteCheckUser;
  //unbalance_dm.updateHistoryDay;
  if(strtoint(aIniConfig.lowVolNoReportDay) > 0)  then
    unbalance_dm.deleteLowVolNot3Day(strtoint(aIniConfig.lowVolNoReportDay));
  
end;

procedure TunbalanceForm.Button3Click(Sender: TObject);
begin
//
  unbalance_dm.updateCheckUserNames;
end;

procedure TunbalanceForm.FormShow(Sender: TObject);
begin
  dayEdit.Text := aIniConfig.lowVolNoReportDay;
end;

procedure TunbalanceForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  aIniConfig.lowVolNoReportDay := dayEdit.Text;
end;

end.
