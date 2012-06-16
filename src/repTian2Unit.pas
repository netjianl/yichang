unit repTian2Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids;

type
  TrepTian2Form = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    dtpBegin: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    Button1: TButton;
    Memo1: TMemo;
    cldbhMemo: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DBGrid1: TDBGrid;
    Button2: TButton;
    FindDialog1: TFindDialog;
    Button3: TButton;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  repTian2Form: TrepTian2Form;

implementation

uses V_NCYHXX_unit, dm;

{$R *.dfm}

procedure TrepTian2Form.Button1Click(Sender: TObject);
var
   i:integer;
   //aQuery:TAdoQuery;
   str:String;
begin
  //for i:=0  to cldbhs.Count -1 do
  if(cldbhMemo.Text = '')then
  begin
    memo1.Lines.Add('请选择用户');
    exit;
  end;

  try
    Button1.Enabled := false;
    for i:=0 to cldbhMemo.Lines.Count -1 do
    begin
        str := dm_userInfo.getUserInfo(cldbhMemo.lines[i]) +
               DataModule1.getTianRep(cldbhMemo.lines[i],
                   dtpBegin.Date, dtpEnd.Date);
        memo1.Lines.Add(str);
        StatusBar1.Panels[0].Text := inttostr(i) + '/' + inttostr(cldbhMemo.Lines.Count);
        Application.ProcessMessages;
    end;
    memo1.Lines.SaveToFile('.\tian2.txt');
  finally
    button1.Enabled := true;
  end;
end;

procedure TrepTian2Form.FormShow(Sender: TObject);
begin
  DataModule1.user_query.Open;
end;

procedure TrepTian2Form.Button2Click(Sender: TObject);
begin
 self.FindDialog1.Execute;
end;

procedure TrepTian2Form.FindDialog1Find(Sender: TObject);
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

procedure TrepTian2Form.Button3Click(Sender: TObject);
begin
  cldbhMemo.Lines.Add(datamodule1.user_query.fieldbyname('测量点编号').AsString);
end;

end.
