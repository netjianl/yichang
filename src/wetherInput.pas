//------------------------------------------------------------------------------
//   ģ������:  wetherInput
//   ����:      ������Ϣ���������
//   ��д�ˣ�  ����                                    ʱ�䣺 2008-2
//------------------------------------------------------------------------------

unit wetherInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, Grids, DBGrids, StdCtrls;

type
  TwetherForm = class(TForm)
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure showdata;
  end;

var
  wetherForm: TwetherForm;

implementation

uses wether_dm;

{$R *.dfm}

procedure TwetherForm.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TwetherForm.showdata;
begin
  wetherdm.tableWether.close;

  wetherdm.tableWether.Open;
  wetherdm.tableWether.Sort := '���� DESC';
  showmodal;
end;

end.
