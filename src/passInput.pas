//------------------------------------------------------------------------------
//   模块名称:   passInput
//   功能:      密码输入界面
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------

unit passInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TpassInputForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    function run:boolean;
    
  end;

var
  passInputForm: TpassInputForm;

implementation

{$R *.dfm}

{ TForm2 }

function TpassInputForm.run: boolean;
begin
  if(showmodal=mrok)then
  begin
    if(edit1.Text = 'swifts')then
      result := true
    else
      result := false;
  end
  else
    result := false;
end;

end.
