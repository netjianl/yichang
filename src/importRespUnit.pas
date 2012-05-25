//------------------------------------------------------------------------------
//   模块名称:  importRespUnit
//   功能:      从电子表格中导入反馈数据
//   编写人：  简亮                                    时间： 2009-8-23
//------------------------------------------------------------------------------

unit importRespUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids, Buttons;

type
  TimportRespForm = class(TForm)
    EditExcelFile: TEdit;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    ADOTable1: TADOTable;
    Memo1: TMemo;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
  private
    { Private declarations }
    FLastSortFieldName:string;
  public
    { Public declarations }
  end;

var
  importRespForm: TimportRespForm;

implementation

uses dm, MessageBoxUnit, wait;

{$R *.dfm}
//使用这样的方式，可能有些数据是无法导入的，特别是数字类型的数据
procedure TimportRespForm.SpeedButton1Click(Sender: TObject);
var
  connStr:String;
  i:integer;
begin
  try
    if OpenDialog1.Execute then
    begin
      ADOTable1.Active := false;
      EditExcelFile.Text := OpenDialog1.FileName;
      connstr := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
        'Data Source=' + OpenDialog1.FileName + ';';
      if(pos('.xls', OpenDialog1.FileName)>0)then
      begin
        connstr := connstr + 'Extended Properties="Excel 8.0;IMEX=1";';
        adotable1.TableName := 'Sheet1$';
      end
      else if(pos('.csv', OpenDialog1.FileName)> 0)then
        connstr := connstr + 'Extended Properties=TEXT;';

      connstr := connstr +  'Persist Security Info=False';
      ADOTable1.ConnectionString := connstr;
      adotable1.Active := true;
    end;
    for i:=0 to DBGrid1.Columns.Count -1 do
    begin
      if DBGrid1.Columns[i].Width > 180 then
        DBGrid1.Columns[i].Width := 180;
    end;
  except
     on E: Exception do InformationBox(E.Message); //+ ' inttostr(E.HelpContext));

  end;
end;

procedure TimportRespForm.Button1Click(Sender: TObject);
begin
  if(waitBaseForm = nil)then
    waitBaseForm := TwaitBaseForm.Create(self);
  with ADOTable1 do
  begin
    if Active = false then
      exit;
    try
      DisableControls;
      first;
      waitBaseForm.Show;
      while not eof do
      begin
        waitBaseForm.currText := '正在导入' + fields[1].AsString;
        DataModule1.addRespondInYichang(fields[0].AsString, fields[2].AsString, fields[3].AsString);
        next;
      end;
    finally
      EnableControls;
      waitBaseForm.Close;
    end;
  end;
end;

procedure TimportRespForm.DBGrid1TitleClick(Column: TColumn);
begin
  if ADOTable1.Active = false then
    exit;
  if (FLastSortFieldName = column.FieldName) then
    ADOTable1.Sort := column.FieldName + ' DESC'
  else
    ADOTable1.Sort := column.FieldName;
  FLastSortFieldName := column.FieldName;    
end;

end.
