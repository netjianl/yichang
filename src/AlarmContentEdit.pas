//------------------------------------------------------------------------------
//   模块名称:  AlarmContentEdit
//   功能:      对告警编码-内容对照表进行编辑查看
//   返回值:
//   编写人：  简亮                                    时间：2009-2
//------------------------------------------------------------------------------

unit AlarmContentEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, DB, ADODB;

type
  TFormAlarmContent = class(TForm)
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAlarmContent: TFormAlarmContent;

implementation

uses dm;

{$R *.dfm}

procedure TFormAlarmContent.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFormAlarmContent.DBGrid1TitleClick(Column: TColumn);
begin
  self.ADOTable1.Sort := column.FieldName;
end;

end.
