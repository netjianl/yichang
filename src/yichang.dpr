program yichang;

uses
  fastMM4,
  Forms,
  mainformunit in 'mainformunit.pas' {Form1},
  dm in 'dm.pas' {DataModule1: TDataModule},
  DBGridExp in 'DBGridExp.pas',
  multiMeterUserUnit in 'multiMeterUserUnit.pas' {multiMeterUserForm},
  multiMeterUserListUnit in 'multiMeterUserListUnit.pas' {mutliUserList_form},
  oneUserYichange in 'oneUserYichange.pas' {oneUserYichangeForm},
  dualList in 'dualList.pas' {DualListDlg},
  yichangeFilterEdit in 'yichangeFilterEdit.pas' {yichangeFilterEditForm},
  wetherInput in 'wetherInput.pas' {wetherForm},
  wether_dm in 'wether_dm.pas' {wetherdm: TDataModule},
  passInput in 'passInput.pas' {passInputForm},
  notlist in 'notlist.pas' {noListForm},
  iniConfig in 'iniConfig.pas',
  ElAES in 'ElAES.pas',
  TrepTianUnit in 'TrepTianUnit.pas' {repTianForm},
  AlarmContentEdit in 'AlarmContentEdit.pas' {FormAlarmContent},
  writelog in 'writelog.pas',
  MessageBoxUnit in 'MessageBoxUnit.pas',
  BZip2 in 'bzip2\BZIP2.PAS',
  dm_data_dlsd in 'dm_data_dlsd.pas' {dlsd_dm: TDataModule},
  dm_hourcount in 'dm_hourcount.pas' {hourcount_dm: TDataModule},
  form_hourcount in 'form_hourcount.pas' {hourCountForm},
  dm_unbalance in 'dm_unbalance.pas' {unbalance_dm: TDataModule},
  houtcount_view in 'houtcount_view.pas' {hourcount_viewForm},
  fm_unblance in 'fm_unblance.pas' {unbalanceForm},
  importRespUnit in 'importRespUnit.pas' {importRespForm},
  wait in 'wait.pas' {waitBaseForm},
  form_unblance_history in 'form_unblance_history.pas' {fm_unbance_history},
  V_NCYHXX_unit in 'V_NCYHXX_unit.pas' {dm_userInfo: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  //sysLog := TLog.Create;
  //sysLog.Enabled := true;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(Twetherdm, wetherdm);
  Application.CreateForm(TnoListForm, noListForm);
  Application.CreateForm(Tdlsd_dm, dlsd_dm);
  Application.CreateForm(Thourcount_dm, hourcount_dm);
  Application.CreateForm(Tunbalance_dm, unbalance_dm);
  Application.CreateForm(Tdm_userInfo, dm_userInfo);
  Application.Run;
  //sysLog.Free;
end.
