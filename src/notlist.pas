//------------------------------------------------------------------------------
//   模块名称:  notlist
//   功能:      不进行处理的用户列表编辑
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------


unit notlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, DB, ADODB;

type
  TnoListForm = class(TForm)
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    function isInNameList(cldbh:String):boolean;
    procedure showdata;
  end;

var
  noListForm: TnoListForm;

implementation

uses dm;

{$R *.dfm}

{ TnoListForm }

function TnoListForm.isInNameList(cldbh: String): boolean;
begin
  ADOQuery1.Close;
  ADOQuery1.Open;
  result := false;
  while not adoquery1.Eof do
  begin
    if(cldbh = adoquery1.Fields[0].asstring)then
      result := true;
    adoquery1.next;
  end;
end;

procedure TnoListForm.showdata;
begin
  ADOQuery1.Close;
  ADOQuery1.Open;
  showmodal;
end;

end.
