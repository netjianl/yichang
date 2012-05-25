//------------------------------------------------------------------------------
//   ģ������:  MessageBoxUnit
//   ����:      ��ų�����ʾ��Ϣ������
//   ����ֵ:
//   ��д�ˣ�   ���μ�                                    ʱ�䣺2002-12-1
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

  Result:=application.MessageBox(pchar(info),'����',MB_OKCANCEL+mb_iconquestion);

end;

procedure InformationBox(info:string);
begin
  application.MessageBox(pchar(info),'��ʾ',MB_OK+mb_iconinformation);
end;

procedure ErrorBox(info:string);
begin
  application.MessageBox(pchar(info),'����',MB_OK+mb_iconerror);
end;

end.
