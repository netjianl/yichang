//------------------------------------------------------------------------------
//                          用电营销管理系统
//                        南昌电力科技开发公司
//
//   单元名称:   wait
//   功能:      等待类型窗口的父窗口
//   编写人：   简亮                                    时间：2002-12-23
//------------------------------------------------------------------------------

unit wait;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TwaitBaseForm = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Timer1: TTimer;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCancelNow:Boolean;
    procedure setCurrText(const Value: String);
    function getCancelNow: boolean;
    { Private declarations }
  public
    { Public declarations }
    property currText:String write setCurrText;
    property cancelNow: boolean read getCancelNow;
  end;

var
  waitBaseForm: TwaitBaseForm;

implementation

{$R *.dfm}

{ TwaitForm }


{ TwaitBaseForm }

function TwaitBaseForm.getCancelNow: boolean;
begin
  result := FCancelNow;
end;

procedure TwaitBaseForm.setCurrText(const Value: String);
begin
  label2.Caption := value;
  application.ProcessMessages;
end;

procedure TwaitBaseForm.Button1Click(Sender: TObject);
begin
  FCancelNow := true;
end;

procedure TwaitBaseForm.FormShow(Sender: TObject);
begin
  FCancelNow := false;
end;

end.
