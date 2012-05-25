//------------------------------------------------------------------------------
//   模块名称:  MessageBoxUnit
//   功能:      存放出错提示信息函数。
//   返回值:
//   编写人：   龚治家                                    时间：2002-12-1
//------------------------------------------------------------------------------

unit MessageBoxUnit;

interface

uses
  windows,forms;

  function QuestionBox(info:string):integer;
  procedure InformationBox(info:string);
  procedure ErrorBox(info:string);

implementation

function QuestionBox(info:string):integer;
begin

  Result:=application.MessageBox(pchar(info),'提问',MB_OKCANCEL+mb_iconquestion);

end;

procedure InformationBox(info:string);
begin
  application.MessageBox(pchar(info),'提示',MB_OK+mb_iconinformation);
end;

procedure ErrorBox(info:string);
begin
  application.MessageBox(pchar(info),'错误',MB_OK+mb_iconerror);
end;

end.
