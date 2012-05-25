//------------------------------------------------------------------------------
//   模块名称:  multiMeterUserUnit
//   功能:     多表用户的编辑界面
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------

unit multiMeterUserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids;

type
  TmultiMeterUserForm = class(TForm)
    DBGrid1: TDBGrid;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    editMutliName: TEdit;
    Button2: TButton;
    FindDialog1: TFindDialog;
    Label4: TLabel;
    Button3: TButton;
    DBGrid2: TDBGrid;
    Button4: TButton;
    cbDoublePower: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbDoublePowerClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    FuserId: string;
    { Private declarations }
  public
    { Public declarations }
    property userId:string read FuserId write FUserId;
    procedure new;
    procedure view(userId:String);
  end;

var
  multiMeterUserForm: TmultiMeterUserForm;

implementation

uses dm, DB;

{$R *.dfm}

{ TmultiMeterUserForm }

procedure TmultiMeterUserForm.new;
begin
   DataModule1.user_query.Open;
   userId := DataModule1.get_multi_nextId;
   editMutliName.Text := userID;
   DataModule1.open_multi_data(userID);
   cbDoublePower.Checked := false;
   self.Showmodal;
end;

procedure TmultiMeterUserForm.Button2Click(Sender: TObject);
begin
  self.FindDialog1.Execute;
end;

procedure TmultiMeterUserForm.FindDialog1Find(Sender: TObject);
begin
  if datamodule1.user_query.Active = false then
    exit;
  datamodule1.user_query.DisableControls;    
  with datamodule1.user_query do
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
  datamodule1.user_query.EnableControls;  
end;

procedure TmultiMeterUserForm.Button1Click(Sender: TObject);
//var
//  aItem:TListItem;
begin
  if datamodule1.user_query.Active = false then
    exit;
  with DataModule1.mutliUser_query do
  begin
    insert;
    fieldbyname('测量点编号').AsString :=
      datamodule1.user_query.fieldbyname('测量点编号').AsString;
    fieldbyname('客户名称').AsString :=
      datamodule1.user_query.fieldbyname('客户名称').AsString;
    fieldbyname('索引值').AsString :=  userID;
    fieldbyname('户号').AsString :=
      datamodule1.user_query.fieldbyname('户号').AsString;
    fieldbyname('表号').AsString :=
      datamodule1.user_query.fieldbyname('表号').AsString;
    fieldbyname('终端逻辑地址').AsString :=
      datamodule1.user_query.fieldbyname('终端逻辑地址').AsString;
    fieldbyname('分局').AsString :=
      datamodule1.user_query.fieldbyname('分局').AsString;
    if(cbDoublePower.Checked)then
      fieldbyname('双电源标志').AsString := '是'
    else
      fieldbyname('双电源标志').AsString := '否';
    post;
  end;
  {
  aItem := lvMutiUser.Items.Add;
  aitem.Caption := datamodule1.user_query.fieldbyname('测量点编号').AsString;
  aitem.SubItems.Add(datamodule1.user_query.fieldbyname('客户名称').AsString);
  if  editMutliName.Text = '加入一个用户后得到' then
    editMutliName.Text := datamodule1.user_query.fieldbyname('客户名称').AsString;
  }
end;

procedure TmultiMeterUserForm.Button3Click(Sender: TObject);
begin
  with DataModule1.mutliUser_query do
  begin
    delete;
    post;
  end;
end;

procedure TmultiMeterUserForm.view(userId: String);
begin
   DataModule1.user_query.Open;
   self.userId :=userId;
   editMutliName.Text := userID;
   DataModule1.open_multi_data(userID);
   if(DataModule1.mutliUserList_query.FieldByName('双电源标志').AsString = '是')then
     cbDoublePower.Checked := true
   else
     cbDoublePower.Checked := false;
   self.Showmodal;
end;

procedure TmultiMeterUserForm.Button4Click(Sender: TObject);
begin
  close;
end;

procedure TmultiMeterUserForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  self.FindDialog1.CloseDialog;
end;

procedure TmultiMeterUserForm.cbDoublePowerClick(Sender: TObject);
begin
  with DataModule1.mutliUser_query do
  begin
    first;
    while not eof do
    begin
      edit;
      if(cbDoublePower.Checked)then
        fieldbyname('双电源标志').AsString := '是'
      else
        fieldbyname('双电源标志').AsString := '否';
      post;
      next;
    end;
  end;
end;

procedure TmultiMeterUserForm.DBGrid1DblClick(Sender: TObject);
begin
  Button1Click(sender);
end;

end.
