//------------------------------------------------------------------------------
//   模块名称: TrepTianUnit
//   功能:    给用电科小田做的报表
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------

unit TrepTianUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TrepTianForm = class(TForm)
    dtpBegin: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  repTianForm: TrepTianForm;

implementation

uses dm, V_NCYHXX_unit;

{$R *.dfm}

procedure TrepTianForm.Button1Click(Sender: TObject);
var
   i:integer;
   //aQuery:TAdoQuery;
   str:String;
begin
  //for i:=0  to cldbhs.Count -1 do
  if(listbox1.selcount = -1)then
  begin
    memo1.Lines.Add('请选择用户');
    exit;
  end;

  for i:=0 to listbox1.items.Count -1 do
  begin
    if(listbox1.Selected[i])then
    begin
      str := dm_userInfo.getUserInfo(listbox1.Items[i]) +
             DataModule1.getTianRep(listbox1.Items[i],
                 dtpBegin.Date, dtpEnd.Date);
      memo1.Lines.Add(str);
    end;
  end;
  memo1.Lines.SaveToFile('.\tian.txt');
end;

procedure TrepTianForm.FormShow(Sender: TObject);
var
   cldbhs:TStrings;
 //  i:integer;
begin
  try
  cldbhs := tstringlist.Create;
  dm_userInfo.getAllCldbh_zb(cldbhs);
  listbox1.Items.AddStrings(cldbhs);
  cldbhs.Free;
  except
  end;
end;

end.
