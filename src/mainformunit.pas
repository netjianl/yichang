//------------------------------------------------------------------------------
//   ģ������:  mainformunit
//   ����:      �����ڽ���
//   ��д�ˣ�  ����                                    ʱ�䣺 2007-2
//------------------------------------------------------------------------------


unit mainformunit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, Grids, DBGrids, DB, ComCtrls,
  TeEngine, Series, TeeProcs, Chart, DbChart, Menus, clipbrd, DateUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Button2: TButton;
    DBMemo1: TDBMemo;
    Button3: TButton;
    FindDialog1: TFindDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    pcDetail: TPageControl;
    TabSheet3: TTabSheet;
    tsPowerOff: TTabSheet;
    TabSheet5: TTabSheet;
    DBMemo2: TDBMemo;
    DBGrid2: TDBGrid;
    dsPowerOff: TDataSource;
    tsLines: TTabSheet;
    dtpBegin: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    MainMenu1: TMainMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    editPercent: TLabeledEdit;
    pmYichang: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    btnComboSort: TButton;
    N11: TMenuItem;
    Button4: TButton;
    N12: TMenuItem;
    Timer1: TTimer;
    Button5: TButton;
    DBChart1: TDBChart;
    SeriesDianliang: TLineSeries;
    SeriesDianliangLastYear: TLineSeries;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    btnAlarmContent: TButton;
    StatusBar1: TStatusBar;
    N16: TMenuItem;
    menuViewBackup: TMenuItem;
    N17: TMenuItem;
    menuHourCount: TMenuItem;
    editAvgDays: TLabeledEdit;
    ChartWether: TChart;
    SeriesWether: TLineSeries;
    SeriesWehterLastYear: TLineSeries;
    menuDePolar: TMenuItem;
    Button6: TButton;
    N18: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Button3Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure btnComboSortClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure dtpBeginChange(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure editPercentDblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure btnAlarmContentClick(Sender: TObject);
    procedure menuViewBackupClick(Sender: TObject);
    procedure menuHourCountClick(Sender: TObject);
    procedure menuDePolarClick(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
  private
    { Private declarations }
    FdoubleClickTime: integer;
    FLastSortFieldName: string;
    FSource: TStream;
    FOldBeginDay, FOldEndDay: Tdate;
    procedure YichangeFenxi(aDay: TDate);
    procedure backupDB;
    procedure DoCompress(ASource, ADest: TStream); overload;
    procedure DoCompress(const ASource, ADest: TFileName); overload;
    procedure onBz2Process(sender: Tobject);
    procedure fill_hourcount(cldbh: string; aDay: TDate);
    procedure drawDianliangSeries;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses dm, multiMeterUserUnit, multiMeterUserListUnit, oneUserYichange,
  dualList, yichangeFilterEdit, wetherInput, wether_dm, passInput, notlist,
  TrepTianUnit, iniConfig, AlarmContentEdit, DBGridExp, MessageBoxUnit,
  BZip2, shellapi, dm_data_dlsd, dm_hourcount, form_hourcount, ADODB,
  dm_unbalance, houtcount_view, fm_unblance, importRespUnit,
  form_unblance_history, V_NCYHXX_unit;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  endDay, currDay: TDate;
begin
  //���ж�һ��oracle���ݿ������Ƿ�����
  self.Button1.Enabled := false;
  if(DataModule1.conn_oracle.Connected = false)then
  begin
    memo1.Lines.Add('oracle����δ���ӣ����飡');
    button1.Enabled := true;
    exit;
  end;
  ainiconfig.fall_precent := self.editPercent.Text;
  aIniConfig.avg_days := editAvgDays.Text;
  memo1.Lines.Clear;
  //����һ������
  backupDB;

  currDay := datamodule1.getLastYichangeDate + 1;
  //�����Ҫ����̫�࣬��ô��ֻ��ֻ�����������ˡ�
  if(currDay < (now - 4)) then
    currDay := now - 3;
  //currDay := encodedate(2008,9,12);
  endday := datamodule1.getOracleDate;
  while (currDay < endday - 1) do
  begin
    //memo1.Lines.Add('���ڵõ�'+datetostr(currDay)+'�����쳣����... ');
    YichangeFenxi(currDay);
    currDay := CurrDay + 1;
  end;
  memo1.Lines.Add('���㶼��������');
  datamodule1.update_always_normal;
  button1.Enabled := true;
end;

procedure TForm1.DBGrid1TitleClick(Column: TColumn);
begin
  if (FLastSortFieldName = column.FieldName) then
    datamodule1.table_yichang_now.Sort := column.FieldName + ' DESC'
  else
    datamodule1.table_yichang_now.Sort := column.FieldName;
  FLastSortFieldName := column.FieldName;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  self.FindDialog1.Execute;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
begin
  if datamodule1.table_yichang_now.Active = false then
    exit;
  datamodule1.table_yichang_now.DisableControls;

  with datamodule1.table_yichang_now do
  begin
    while true do
    begin
      if (frDown in finddialog1.Options) then
        next
      else
        Prior;

      if (pos(finddialog1.FindText, fieldbyname('�ͻ��ֺ�').asstring) > 0) then
        break;
      if (pos(finddialog1.FindText, fieldbyname('�ͻ�����').asstring) > 0) then
        break;

      if (frDown in finddialog1.Options) then
      begin
        if (eof) then break;
      end
      else
      begin
        if (bof) then break;
      end;

    end;
  end;
  datamodule1.table_yichang_now.EnableControls;

end;

procedure TForm1.YichangeFenxi(aDay: TDate);
var
  dianliang_now: real;
  userId: TStrings;
  i: integer;
  doorOpenTimeStr: string;
  access_process_count, access_process_sum: integer;
  hourcountStr: string;
begin
  memo1.Lines.Add('���ڵõ�' + datetostr(aday) + '�����쳣����... ');
  self.Update;
  userId := TStringList.Create;
  dm_userInfo.getAllCldbh(userId);
  datamodule1.table_yichang_now.open;
  memo1.Lines.Add('��ʼ�������쳣����');

  for i := 0 to userId.count - 1 do
  begin
    StatusBar1.Panels[0].Text := inttostr(i + 1) + '/' + inttostr(userId.count);
    //��ȱ������ݼ�¼��¼һ��
    fill_hourcount(userid[i], aDay);

    application.ProcessMessages;

    //DataModule1.getAvgYichang(aday, editPercent.text);
    //�ĳ���һ���û�һ���û��ķ�ʽ
    //DataModule1.getAvgYichang(aday, editPercent.text, userId[i]);
    //�����˶�ȡƽ������
    DataModule1.getAvgYichang(aday, editPercent.text, userId[i], editAvgDays.Text);

    with datamodule1.query_yichang_avg do
    begin
      first;

      while not eof do
      begin
        if (datamodule1.table_yichang_now.Locate('��������',
          fieldbyname('��������').asstring, [])) then
        begin
          memo1.Lines.Add(fieldbyname('�ͻ�����').asstring + '�Ѿ�����,����');
        end
        else
        begin
          if (nolistform.isInNameList(fieldbyname('��������').AsString)) then
          begin
            datamodule1.copyAYiChangeRecord;
            datamodule1.table_yichang_now.FieldByName('�쳣���').AsString := '����';
          end
          else
          begin
            memo1.Lines.Add(fieldbyname('�ͻ�����').asstring + '������,����');
            datamodule1.copyAYiChangeRecord;
          end;
        end;
        next;
      end;
    end;
  end;

  with datamodule1.table_yichang_now do
  begin
    close;
    open;
    memo1.Lines.Add('��ʼ����access����');
    access_process_count := 0;
    access_process_sum := datamodule1.table_yichang_now.RecordCount;
    last;
    while not bof do
    begin
      StatusBar1.Panels[0].Text := inttostr(access_process_count + 1) + '/' + inttostr(access_process_sum);
      inc(access_process_count);
      application.ProcessMessages;
      //��ȱ���¼����
      hourcountStr := hourcount_dm.getHourCountDay(fieldbyname('��������').asstring);
      if (hourcountStr <> '') then
      begin
        edit;
        fieldbyname('�ɼ�ȱ����Ϣ').AsString := hourcountStr;
        {
        if (fieldbyname('����').AsString = '') then
          fieldbyname('����').AsString := hourcountStr
        else
          fieldbyname('����').AsString := fieldbyname('����').AsString + #13#10 +
              hourcountStr;
        //fieldbyname('�쳣���').AsString := '�쳣';
        }
        post;
      end;

      if (fieldbyname('ʱ��').AsDateTime = aDay) then
      begin
        memo1.Lines.Add(fieldbyname('�ͻ�����').asstring + ' ' + fieldbyname('��������').asstring + ' ' + 'Ϊ������¼������');
        edit;
        if (datamodule1.Have_alarm_record(fieldbyname('��������').asstring, aday)) then
        begin
          fieldbyname('�Ƿ���ͣ���¼').AsString := '����';
        end;
        fieldbyname('�쳣���').AsString := ''; //���¼���ʱҪ��������־λ���������ٴν�����޷����Σ��
        post;

        //�ж�һ�¼���װ���Ŵ򿪹ر�
        doorOpenTimeStr := datamodule1.Have_doorOpened(fieldbyname('��������').asstring, aday);
        if (doorOpenTimeStr <> '') then
        begin
          edit;
          if (fieldbyname('����').AsString = '') then
            fieldbyname('����').AsString := '���ڼ���װ���ſ��ϼ�¼��ʱ�䣺' + doorOpenTimeStr
          else
            fieldbyname('����').AsString := fieldbyname('����').AsString + #13#10 +
              '���ڼ���װ���ſ��ϼ�¼��ʱ�䣺' + doorOpenTimeStr;
          fieldbyname('�쳣���').AsString := '�쳣';
          post;
        end;
        //�ж��Ƿ���ͣ��ĸ澯��¼
        doorOpenTimeStr := datamodule1.Have_powerOff(fieldbyname('��������').asstring, aday);
        if (doorOpenTimeStr <> '') then
        begin
          edit;
          if (fieldbyname('����').AsString = '') then
            fieldbyname('����').AsString := '����ͣ��澯��¼��ʱ�䣺' + doorOpenTimeStr
          else
            fieldbyname('����').AsString := fieldbyname('����').AsString + #13#10 +
              '����ͣ��澯��¼��ʱ�䣺' + doorOpenTimeStr;
          post;
        end;
        //�жϸ߹��߼��û��Ƿ��е��ͣ�߼�¼
        doorOpenTimeStr := datamodule1.Have_MeterStop(fieldbyname('��������').asstring, aday);
        if (doorOpenTimeStr <> '') then
        begin
          edit;
          if (fieldbyname('����').AsString = '') then
            fieldbyname('����').AsString := '���ڵ��ͣ�߼�¼��ʱ�䣺' + doorOpenTimeStr
          else
            fieldbyname('����').AsString := fieldbyname('����').AsString + #13#10 +
              '����ͣ��澯��¼��ʱ�䣺' + doorOpenTimeStr;
          post;
        end;
        //�жϸ߹��߼��û��Ƿ�CT���β��·��¼
        doorOpenTimeStr := datamodule1.have_CTcut(fieldbyname('��������').asstring, aday);
        if (doorOpenTimeStr <> '') then
        begin
          edit;
          if (fieldbyname('����').AsString = '') then
            fieldbyname('����').AsString := '����CT���β��·��¼��ʱ�䣺' + doorOpenTimeStr
          else
            fieldbyname('����').AsString := fieldbyname('����').AsString + #13#10 +
              '����CT���β��·��¼��ʱ�䣺' + doorOpenTimeStr;
          post;
        end;


        //���ڶ���û���Ҫ���һ���Ƿ�ȫ����ͻ��
        if (dataModule1.isMutiMeterUser(fieldbyname('��������').AsString)) then
        begin
          memo1.Lines.Add('���û��Ƕ���û�');
          edit;
          fieldbyname('�Ƿ��Ƕ���û�').AsString := '��';
          post;
          //ȡ������û�������
          if (dataModule1.isMutiMeterUserYichange(fieldbyname('��������').AsString,
            aday, strtofloat(editPercent.text))) then
          begin
            memo1.Lines.Add('���û��Ķ���ܻ�Ҳ��ͻ����������');
          end
          else
          begin
            memo1.Lines.Add('���û��Ķ���ܻ�û��ͻ��');
            edit;
            fieldbyname('�쳣���').AsString := '�ܼ�����';
            post;
          end;
        end;

      end
      else
      begin
        memo1.Lines.Add(fieldbyname('�ͻ�����').asstring + ' ' + fieldbyname('��������').asstring + ' ' + 'Ϊԭ�м�¼');
        //dianliang_now := datamodule1.getYestedayDianliang(fieldbyname('�ͻ��ֺ�').asstring);
        dianliang_now := datamodule1.getYesterdayDianliang_CDLBH(
          fieldbyname('��������').asstring, aDay);
        memo1.Lines.Add('ǰһ�յ���Ϊ:' + floattostr(dianliang_now));
        if (dianliang_now < 0) then
        begin
          memo1.Lines.Add('����û�û�вɼ���ǰһ�յ����ݡ�');
          edit;
          fieldbyname('���յ���').AsFloat := -1;
          fieldbyname('����').asinteger := Trunc(now - fieldbyname('ʱ��').asdatetime) - 1;
          post;
        end
        else if (dianliang_now < fieldbyname('ƽ������').AsFloat * strtofloat(editPercent.text)) then
        begin
          memo1.Lines.Add('��Ȼ�������ƽ��ֵ��' + editPercent.text + '��,����');
          edit;
          fieldbyname('���յ���').AsFloat := dianliang_now;
          fieldbyname('����').asinteger := Trunc(now - fieldbyname('ʱ��').asdatetime) - 1;
          post;
        end
        else
        begin
          //edit;
          memo1.Lines.Add('�Ѿ��ָ�,����һ��ɾ�����');
          //delete;
          edit;
          fieldbyname('�쳣���').AsString := '�ָ�����';
          fieldbyname('���յ���').AsFloat := dianliang_now;
          post;
          //prior;
        end;
      end;
      if (dataModule1.isMutiMeterUser(fieldbyname('��������').AsString)) then
      begin
        memo1.Lines.Add('���û��Ƕ���û�');
        edit;
        fieldbyname('�Ƿ��Ƕ���û�').AsString := '��';
        post;
          //ȡ������û�������
        if (dataModule1.isMutiMeterUserYichange(fieldbyname('��������').AsString,
          aday, strtofloat(editPercent.text))) then
        begin
          memo1.Lines.Add('���û��Ķ���ܻ�Ҳ��ͻ����������');
        end
        else
        begin
          memo1.Lines.Add('���û��Ķ���ܻ�û��ͻ��');
          edit;
          fieldbyname('�쳣���').AsString := '�ܼ�����';
          post;
        end;
      end;
      prior;
    end;
  end;
end;

procedure TForm1.btnComboSortClick(Sender: TObject);
var
  comList: TStrings;
  i: integer;
  sortString: string;
begin
  if(DataModule1.table_yichang_now.Active = false) then
  begin
    InformationBox('������ʾ����');
    exit;
  end;
  comList := tstringlist.create;
  for i := 0 to dbgrid1.Columns.Count - 1 do
    comList.Add(dbgrid1.Columns.Items[i].Title.caption);
  if (DualListDlg = nil) then
    DualListDlg := TDualListDlg.Create(self);
  DualListDlg.inList := comList;
  dualListDlg.ShowModal;
  sortString := DualListDlg.outList.Text;
  sortString := stringreplace(sortString, #13#10, ',', [rfReplaceAll]);
  DataModule1.table_yichang_now.Sort := sortString;
{
  memo1.Lines.Clear;
  with datamodule1.table_yichang_now do
  begin
    close;
    open;
    memo1.Lines.Add('��ʼ�����޸Ĳ������ţ��˹���ֻ��Ҫ����һ��');
    first;
    while not eof do
    begin
      memo1.Lines.Add('���ڲ���'+fieldbyname('�ͻ��ֺ�').AsString + ' ' +
        fieldbyname('�ͻ�����').AsString);
      edit ;
      fieldbyname('��������').AsString :=
        datamodule1.get_cldbh(fieldbyname('�ͻ��ֺ�').AsString);
      post;
      memo1.Lines.Add('���������ǣ�'+
        fieldbyname('��������').AsString);
      next;
    end;
  end;
  memo1.Lines.Add('������ϣ������������ȱʧ�ĺ��ظ��ļ�¼�ٽ����Ժ�Ĳ���');
  }
end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
begin
  if (datamodule1.table_yichang_now.Active = true) then
  begin
    if (self.pcDetail.ActivePage = tsPowerOff) then
    begin
      datamodule1.get_alarm(datamodule1.table_yichang_now.Fieldbyname('��������').AsString);
    end
    else if (self.pcDetail.ActivePage = self.tsLines) then
    begin
      self.drawDianliangSeries;
    end;

  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  count_str: string;
  should_inputpass: boolean;
  count: integer;
begin
  should_inputpass := true;
  count_str := aIniConfig.run_count;
  if (TryStrToInt(count_str, count)) then
  begin
    if (count < 300) then
    begin
      should_inputpass := false;
      aIniConfig.run_count := inttostr(count + 1);
    end;
  end;
  if (should_inputpass) then
  begin
    if (passInputForm = nil) then
      passInputForm := TpassInputForm.Create(self);
    passInputForm.Caption := '������ע����';
    if (passInputForm.run) then
      aIniConfig.run_count := '0'
    else
    begin
      Application.Terminate;
      exit;
    end;
  end;
  self.dtpBegin.Date := now - 31;
  self.dtpEnd.Date := now-1;
  FdoubleClickTime := 0;
  self.editPercent.Text := ainiconfig.fall_precent;
  editAvgDays.Text := aIniConfig.avg_days;
end;

procedure TForm1.dtpBeginChange(Sender: TObject);
begin
  if ((FOldBeginDay = dtpBegin.Date) and
    (FOldEndDay = dtpEnd.Date)) then
    exit;
  drawDianliangSeries;
{
  if (datamodule1.table_yichang_now.Active = true) then
  begin
    datamodule1.getYichange(datamodule1.table_yichang_now.Fieldbyname('��������').AsString,
      self.dtpBegin.Date,
      self.dtpEnd.Date);
    wetherdm.getWether(self.dtpBegin.Date,
      self.dtpEnd.Date);
  end;
  }
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  datamodule1.get_access_yichange((sender as TMenuItem).Caption);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  PopupMenu1.Popup(button2.Left + self.left, button2.top + self.top);
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  if( multiMeterUserForm = nil)then
    multiMeterUserForm := TmultiMeterUserForm.Create(self);
  multiMeterUserForm.new;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  if (mutliUserList_form = nil) then
    mutliUserList_form := tmutliUserList_form.Create(self);
  DataModule1.mutliUserList_query.Open;
  mutliUserList_form.ShowModal;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
  if (oneUserYichangeForm = nil) then
    oneUserYichangeForm := ToneUserYichangeForm.Create(self);
  oneUserYichangeForm.cldbh := datamodule1.table_yichang_now.Fieldbyname('��������').AsString;
  oneUserYichangeForm.ShowModal;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  if (mutliUserList_form = nil) then
    mutliUserList_form := tmutliUserList_form.Create(self);
  mutliUserList_form.locate(datamodule1.table_yichang_now.Fieldbyname('��������').AsString);
end;

procedure TForm1.N11Click(Sender: TObject);
begin
  Clipboard.asText := datamodule1.table_yichang_now.Fieldbyname('�ͻ�����').AsString
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if (yichangeFilterEditForm = nil) then
  begin
    yichangeFilterEditForm := TyichangeFilterEditForm.Create(self);
    yichangeFilterEditForm.departs := DataModule1.getDeparts;
    yichangeFilterEditForm.yichangeFlags := DataModule1.getYichangeFlags;
    yichangeFilterEditForm.Industries := DataModule1.getIndustries;
  end;
  if (yichangeFilterEditForm.ShowModal = mrok) then
  begin
    DataModule1.get_access_yichange(
      yichangeFilterEditForm.userName,
      yichangeFilterEditForm.departName,
      yichangeFilterEditForm.yichangeFlag,
      yichangeFilterEditForm.userID,
      yichangeFilterEditForm.IndustriesName);
  end;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
  if (wetherForm = nil) then
    wetherform := twetherform.Create(self);
  wetherform.showdata;
end;

procedure TForm1.editPercentDblClick(Sender: TObject);
begin
  inc(FdoubleClickTime);
  if (FdoubleClickTime > 1) then
  begin
    FdoubleClickTime := 0;
    if (passInputForm = nil) then
      passInputForm := TpassInputForm.Create(self);
    if (passInputForm.run) then
    begin
      if (noListForm = nil) then
        noListform := TnoListForm.Create(self);
      nolistform.showdata;
    end;
  end;
end;








procedure TForm1.Timer1Timer(Sender: TObject);
begin
  try
    if (DataModule1.conn_oracle.Connected) then
      datamodule1.getOracleDate();
  except
    try
      datamodule1.conn_oracle.Connected := false;
      DataModule1.conn_oracle.Connected := true;
    except
    end;
  end;
  if ((hourof(now) = 7) and (minuteof(now) < 1)) then
  begin
    Button1Click(self);
    N16Click(self);
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  old_meterId: string;
begin
  if (DataModule1.table_yichang_now.active = false) then
    exit;
  with DataModule1.table_yichang_now do
  begin
    try
      DisableControls;
      first;
      while not eof do
      begin
        if (fieldbyname('���յ���').AsInteger = -1) and
          (fieldbyname('�쳣���').asstring <> '����') then
        begin
          old_meterId := dm_userInfo.getMeterNum_oracle(fieldbyname('�ͻ��ֺ�').AsString);
          //���û���ҵ���Ӧ�ļ�¼Ӧ�þ�û������û��ļ�¼��
          if (old_meterId = '') then
          begin
            edit;
            fieldbyname('�쳣���').AsString := '����';
            fieldbyname('����').AsString := '����   ' + fieldbyname('����').AsString;
            post;
          end
          else if (old_meterId <> fieldbyName('���ֺ�').AsString) then
          begin
            edit;
            fieldbyname('�쳣���').AsString := '����';
            fieldbyname('����').AsString := '����   ' + fieldbyname('����').AsString;
            post;
          end;
        end;
        next;
      end;
    except
    end;
    enableControls;
  end;
end;

procedure TForm1.N15Click(Sender: TObject);
begin
  if (repTianForm = nil) then
    repTianForm := trepTianForm.Create(self);
  repTianForm.ShowModal;
end;

procedure TForm1.btnAlarmContentClick(Sender: TObject);
begin
  if (FormAlarmContent = nil) then
  begin
    FormAlarmContent := tFormAlarmContent.Create(self);
  end;
  FormAlarmContent.ADOTable1.Open;
  FormAlarmContent.ShowModal;
end;

procedure TForm1.DoCompress(const ASource, ADest: TFileName);
var
  Source, Dest: TStream;
begin
  Source := TFileStream.Create(ASource, fmOpenRead + fmShareDenyWrite);
  try
    Dest := TFileStream.Create(ADest, fmCreate);
    try
      DoCompress(Source, Dest);
    finally
      Dest.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TForm1.DoCompress(ASource, ADest: TStream);
var
  Comp: TBZCompressionStream;
begin
  FSource := ASource;
  Comp := TBZCompressionStream.Create(bs9, ADest);
  try
    Comp.OnProgress := onBz2Process;
    Comp.CopyFrom(ASource, 0);
  finally
    Comp.Free;
    FSource := nil;
  end;
end;

procedure TForm1.backupDB;
var
  dbFileName: string;
  dbFileBakName: string;
begin
  try
    memo1.Lines.Add('���ڱ�������...');
    if not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'backup') then
      CreateDir(ExtractFilePath(ParamStr(0)) + 'backup');
    DataModule1.Conn_acess.Connected := false;
    dbFileName := ExtractFilePath(ParamStr(0)) + 'yichang.mdb';
    dbFileBakName := ExtractFilePath(ParamStr(0)) + 'backup\yichang' +
      formatdatetime('yyyymmdd_hhmmss', now) + '.mdb.bz2';
    DoCompress(dbFileName, dbFileBakName);
  except

  end;
  DataModule1.Conn_acess.Connected := true;
  StatusBar1.Panels[0].Text := '';
  memo1.Lines.Add('������' + dbFileBakName);
end;

procedure TForm1.onBz2Process(sender: Tobject);
begin
  StatusBar1.Panels[0].Text := inttostr((FSource.Position + 1) * 100 div FSource.Size) + '%';
  self.Update;
end;

procedure TForm1.menuViewBackupClick(Sender: TObject);
begin
  winexec(pchar('explorer ' + ExtractFilePath(ParamStr(0)) + 'backup'), sw_show);
 //ShellExecute(0,'explore',pchar(ExtractFilePath(ParamStr(0)) + 'backup'),nil,nil,SW_SHOW);
end;

procedure TForm1.fill_hourcount(cldbh: string; aDay: TDate);
var
  hourcount: Integer;
  meterId: string;
begin
  hourcount := dlsd_dm.getValidHour(cldbh, aDay);
  //memo1.Lines.Add(cldbh + '�ɼ���'+ inttostr(hourcount) + '����������');
  if ((hourcount >= 24)) then //or (hourcount < 21))then
    exit;
  meterId := dm_userInfo.getMeterNum_by_cldbh(cldbh);
  hourcount_dm.addrecord(cldbh, meterId, aday, hourcount);
end;

procedure TForm1.menuHourCountClick(Sender: TObject);
begin
  {
  if (hourCountForm = nil) then
    hourCountForm := ThourCountForm.Create(self);
  hourCountForm.ShowModal;}
  if(hourcount_viewForm = nil)then
    hourcount_viewForm := thourcount_viewForm.create(self);
  hourcount_viewForm.showmodal;
end;

procedure TForm1.drawDianliangSeries;
var
  aDay, aDay_lastyear: Tdate;
begin
  SeriesDianliang.Clear;
  SeriesDianliangLastYear.Clear;
  SeriesWether.Clear;
  SeriesWehterLastYear.Clear;

  FOldBeginDay := dtpBegin.Date;
  FOldEndDay := dtpEnd.Date;

  if (aIniConfig.noOracle <> '1') then
    datamodule1.getYichange(datamodule1.table_yichang_now.Fieldbyname('��������').AsString,
      self.dtpBegin.Date,
      self.dtpEnd.Date);
  wetherdm.getWether(self.dtpBegin.Date,
    self.dtpEnd.Date);
  aDay := EncodeDate(yearof(dtpBegin.Date), monthof(dtpBegin.Date), dayof(dtpBegin.Date));
  while aDay < dtpEnd.Date do
  begin
    try
      aDay_lastyear := EncodeDate(yearof(aday) - 1, monthof(aday), dayof(aDay));
    except
      aDay_lastyear := 0;
    end;
    with DataModule1.dianliang_query do
    begin
      if (Active = true) then
      begin
        if (Locate('kssj', FormatDateTime('yyyy-mm-dd', aDay), [])) then
          SeriesDianliang.Add(fieldbyName('zxzdl').AsInteger,
            FormatDateTime('yyyy-mm-dd', aDay))
        else
          SeriesDianliang.Add(0, FormatDateTime('yyyy-mm-dd', aDay));
      end;
    end;

    with DataModule1.dianliang_lastyear do
    begin
      if (aDay_lastyear > 0) then
      begin
        if (Active = true) then
        begin
          if (Locate('kssj', FormatDateTime('yyyy-mm-dd', aDay_lastyear), [])) then
            SeriesDianliangLastYear.Add(fieldbyName('zxzdl').AsInteger,
              FormatDateTime('yyyy-mm-dd', aDay))
          else
            SeriesDianliangLastYear.Add(0, FormatDateTime('yyyy-mm-dd', aDay));
        end;
      end;
    end;

    with wetherdm.queryWether do
    begin
      if (Locate('����', FormatDateTime('yyyy-mm-dd', aDay), []	)) then
        SeriesWether.Add(fieldbyName('�������').AsInteger,
          FormatDateTime('yyyy-mm-dd', aDay))
      else
        SeriesWether.Add(0, FormatDateTime('yyyy-mm-dd', aDay));
    end;

    with wetherdm.queryWetherLastyear do
    begin
      if (aDay_lastyear > 0) then
        if (Locate('����',  FormatDateTime('yyyy-mm-dd', aDay_lastyear), [])) then
          SeriesWehterLastYear.Add(fieldbyName('�������').AsInteger,
            FormatDateTime('yyyy-mm-dd', aDay))
        else
          SeriesWehterLastYear.Add(0, FormatDateTime('yyyy-mm-dd', aDay));
    end;
    aDay := aDay + 1;
  end;
end;

procedure TForm1.menuDePolarClick(Sender: TObject);
begin
 //
end;

procedure TForm1.N16Click(Sender: TObject);
begin
  with tunbalanceForm.Create(self) do
  begin
    try
      dbgrid1.DataSource.dataset.Active := true;
      showmodal;
    finally
      free;
    end;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  with TimportRespForm.Create(self) do
  begin
    try
      showmodal;
    finally
      free;
    end;
  end;
end;

procedure TForm1.N18Click(Sender: TObject);
begin
  with tfm_unbance_history.Create(self) do
  try
    init;
    ShowModal;
  finally
    free;
  end;
end;


end.

