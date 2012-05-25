//------------------------------------------------------------------------------
//   模块名称:  yichangeFilterEdit
//   功能:      组合筛选选择界面
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------

unit yichangeFilterEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TyichangeFilterEditForm = class(TForm)
    editUserName: TLabeledEdit;
    Label1: TLabel;
    cbDepart: TComboBox;
    Label2: TLabel;
    cbYichangFlag: TComboBox;
    Button1: TButton;
    Button2: TButton;
    editUserId: TLabeledEdit;
    Label3: TLabel;
    cbIndustries: TComboBox;
  private
    function getUserName: String;
    procedure setUserName(const Value: String);
    procedure setDeparts(const Value: TStrings);
    function getDepartName: String;
    procedure setDepartName(const Value: String);
    procedure setYiChangeFlags(const Value: TStrings);
    function getYichangeFlag: String;
    procedure setyichagneFalg(const Value: String);
    function getUserId: String;
    procedure setUserID(const Value: String);
    procedure setIndustries(const Value: TStrings);
    function getIndustriesName: String;
    procedure setIndustriesName(const Value: String);
    { Private declarations }
  public
    { Public declarations }
    property userName:String read getUserName write setUserName;
    property departs:TStrings write setDeparts;
    property departName:String read getDepartName write setDepartName;
    property yichangeFlags:TStrings write setYiChangeFlags;
    property yichangeFlag:String read getYichangeFlag write setyichagneFalg;
    property userID:String read getUserId write setUserID;
    property Industries:TStrings write setIndustries;
    property IndustriesName:String read getIndustriesName write setIndustriesName;
  end;

var
  yichangeFilterEditForm: TyichangeFilterEditForm;

implementation

{$R *.dfm}

function TyichangeFilterEditForm.getDepartName: String;
begin
  result := cbDepart.Text;
end;

function TyichangeFilterEditForm.getIndustriesName: String;
begin
  result := self.cbIndustries.Text;
end;

function TyichangeFilterEditForm.getUserId: String;
begin
  result := self.editUserId.Text;
end;

function TyichangeFilterEditForm.getUserName: String;
begin
  result := editUserName.Text;
end;

function TyichangeFilterEditForm.getYichangeFlag: String;
begin
  result := cbYichangFlag.Text;
end;

procedure TyichangeFilterEditForm.setDepartName(const Value: String);
begin
  cbDepart.Text := value;
end;

procedure TyichangeFilterEditForm.setDeparts(const Value: TStrings);
begin
   cbDepart.Items := value;
   cbDepart.ItemIndex := -1;
end;

procedure TyichangeFilterEditForm.setIndustries(const Value: TStrings);
begin
  self.cbIndustries.Items := value;
  self.cbIndustries.ItemIndex := -1;
end;

procedure TyichangeFilterEditForm.setIndustriesName(const Value: String);
begin
  self.cbIndustries.Text := value;
end;

procedure TyichangeFilterEditForm.setUserID(const Value: String);
begin
   editUserId.Text := value;
end;

procedure TyichangeFilterEditForm.setUserName(const Value: String);
begin
  editUserName.Text := value;
end;

procedure TyichangeFilterEditForm.setyichagneFalg(const Value: String);
begin
  cbYichangFlag.Text := value;
end;

procedure TyichangeFilterEditForm.setYiChangeFlags(const Value: TStrings);
begin
  cbYichangFlag.Items := value;
  cbYichangFlag.Items.Add('Null');
  cbYichangFlag.ItemIndex := -1;
end;


end.
