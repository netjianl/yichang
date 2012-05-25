//------------------------------------------------------------------------------
//   模块名称:  form_unblance_history
//   功能:      不平衡历史记录查看
//   编写人：   简亮                                    时间： 2009-9-10
//------------------------------------------------------------------------------
unit form_unblance_history;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls;

type
  Tfm_unbance_history = class(TForm)
    ListBox1: TListBox;
    DBGrid1: TDBGrid;
    Button1: TButton;
    FindDialog1: TFindDialog;
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Button1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
  private
    { Private declarations }
    FLastSortFieldName:string;
  public
    { Public declarations }
    procedure init;
  end;

var
  fm_unbance_history: Tfm_unbance_history;

implementation

uses dm_unbalance;

{$R *.dfm}

{ Tfm_unbance_history }

procedure Tfm_unbance_history.init;
begin
  unbalance_dm.get_all_names(ListBox1.Items);
end;

procedure Tfm_unbance_history.ListBox1Click(Sender: TObject);
begin
  if(listbox1.ItemIndex >=0 )then
    unbalance_dm.getHistoryByName(listbox1.Items[listbox1.itemindex]);
end;

procedure Tfm_unbance_history.ListBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if(listbox1.ItemIndex >=0 )then
    unbalance_dm.getHistoryByName(listbox1.Items[listbox1.itemindex]);

end;

procedure Tfm_unbance_history.DBGrid1TitleClick(Column: TColumn);
begin
  if(unbalance_dm.queryHistory.Active = false)then
    exit;
  if (FLastSortFieldName = column.FieldName) then
    unbalance_dm.queryHistory.Sort := column.FieldName + ' DESC'
  else
    unbalance_dm.queryHistory.Sort := column.FieldName;
  FLastSortFieldName := column.FieldName;
end;

procedure Tfm_unbance_history.Button1Click(Sender: TObject);
begin
  self.FindDialog1.Execute;
end;

procedure Tfm_unbance_history.FindDialog1Find(Sender: TObject);
var
  index:integer;
begin
  index := ListBox1.ItemIndex;
  if(index = -1)then
    index := 0;
  if(frdown in FindDialog1.Options)then
  begin
    inc(index);
    while index < listBox1.Count do
    begin
      if(pos(FindDialog1.FindText, ListBox1.Items[index])>0) then
      begin
        ListBox1.ItemIndex := index;
        ListBox1Click(self);
        break;
      end;
      inc(index);
    end;
  end
  else
  begin
    dec(index);
    while index >0 do
    begin
      if(pos(FindDialog1.FindText, ListBox1.Items[index])>0) then
      begin
        ListBox1.ItemIndex := index;
        ListBox1Click(self);
        break;
      end;
      dec(index);
    end;
  end;
end;

end.
