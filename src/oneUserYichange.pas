//------------------------------------------------------------------------------
//   ģ������:  oneUserYichange
//   ����:      �����û�����ʷ�쳣��¼
//   ��д�ˣ�  ����                                    ʱ�䣺 2008-2
//------------------------------------------------------------------------------


unit oneUserYichange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DB, ADODB;

type
  ToneUserYichangeForm = class(TForm)
    ADOQuery1: TADOQuery;
    DBGrid2: TDBGrid;
    Button1: TButton;
    DataSource1: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Fcldbh: string;
    { Private declarations }
  public
    { Public declarations }
    property cldbh:string read Fcldbh write Fcldbh;
  end;

var
  oneUserYichangeForm: ToneUserYichangeForm;

implementation

uses dm;

{$R *.dfm}

procedure ToneUserYichangeForm.Button1Click(Sender: TObject);
begin
  close;
end;

procedure ToneUserYichangeForm.FormShow(Sender: TObject);
begin
  adoquery1.Close;
  ADOQuery1.Parameters[0].Value := cldbh;
  adoquery1.Open;
end;

end.
