//------------------------------------------------------------------------------
//   模块名称:  form_hourcount
//   功能:      显示整点采集缺点的数据 ，但并似乎没有使用这个窗口。
//   编写人：  简亮                                    时间： 
//------------------------------------------------------------------------------

unit form_hourcount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids;

type
  ThourCountForm = class(TForm)
    DBGrid1: TDBGrid;
    findButton: TButton;
    FindDialog1: TFindDialog;
    Button1: TButton;
    procedure findButtonClick(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  hourCountForm: ThourCountForm;

implementation

uses dm_hourcount;

{$R *.dfm}

procedure ThourCountForm.findButtonClick(Sender: TObject);
begin
  self.FindDialog1.Execute;
end;

procedure ThourCountForm.FindDialog1Find(Sender: TObject);
begin
  if DBGrid1.DataSource.DataSet.Active = false then
    exit;
  DBGrid1.DataSource.DataSet.DisableControls;    
  with DBGrid1.DataSource.DataSet do
  begin
    while true do
    begin
      if(frDown	in finddialog1.Options) then
          next
      else
        Prior;
      if(pos(finddialog1.FindText,fieldbyname('测量点编号').asstring)>0)then
        break;
      if(pos(finddialog1.FindText,fieldbyname('表号').asstring)>0)then
        break;
      if(pos(finddialog1.FindText,fieldbyname('日期').asstring)>0)then
        break;
      if(pos(finddialog1.FindText,fieldbyname('整点采集数').asstring)>0)then
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
  DBGrid1.DataSource.DataSet.EnableControls;

end;

procedure ThourCountForm.FormShow(Sender: TObject);
begin
  DBGrid1.DataSource.DataSet.Open;
end;

end.
