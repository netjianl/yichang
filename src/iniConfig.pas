//------------------------------------------------------------------------------
//   模块名称:  iniConfig
//   功能:      将配置按照ini文件的方式保存
//   编写人：  简亮                                    时间： 2008-2
//------------------------------------------------------------------------------

unit iniConfig;

interface

uses windows, IniFiles, SysUtils, dateutils, Classes;

type
  TIniConfig = class(tobject)
  private
    FIniFile: TIniFile;
    iniFileName: string;
    //FlowVolNoReportDay: string;
    function decodePass(const Str: string): string;
    function encodePass(const pass: string): string;
    function getDebug: string;
    procedure setDebug(const Value: string);
    function getFall_precent: string;
    procedure setFall_precent(const Value: string);
    function getRunCount: string;
    procedure setRunCount(const Value: string);
    function getIsSqlLog: string;
    procedure setIsSqlLog(const Value: string);
    function getAvg_days: string;
    procedure setAvg_days(const Value: string);
    function getNoOracle: String;
    procedure setNoOracle(const Value: String);
    procedure SetlowVolNoReportDay(const Value: string);
    function getlowVolNoReportDay: string;
    procedure SetV_NCYHXX(const Value: string);
    function getFV_NCYHXX: string;
  public
    constructor create;
    destructor Destroy; override;
    property debug: string read getDebug write setDebug;
    property fall_precent: string read getFall_precent write setFall_precent;
    property avg_days:string read getAvg_days write setAvg_days;
    property run_count: string read getRunCount write setRunCount;
    property isSqlLog:string read getIsSqlLog write setIsSqlLog;
    property noOracle:String read getNoOracle write setNoOracle;
    property lowVolNoReportDay: string  read getlowVolNoReportDay write SetlowVolNoReportDay;
    property V_NCYHXX:string read getFV_NCYHXX write SetV_NCYHXX;
  end;

var
  aIniConfig: TIniConfig;

implementation

uses ElAES, Registry;


{ TIniConfig }


constructor TIniConfig.create;
begin
  iniFileName := ExtractFilePath(ParamStr(0));
  FIniFile := TiniFile.Create(iniFileName + '\config.ini');
end;

function TIniConfig.decodePass(const Str: string): string;
var
//  str:String;
  inStr, outStr: TStringstream;
  Key: TAESKey128;
  password: string;
  hexStr: string;
begin
  password := '1234567890';
  inStr := TStringStream.Create(Str);
  setlength(hexStr, inStr.size div 2);
  hextobin(pchar(inStr.DataString), pchar(hexStr), inStr.size);
  inStr.Free;
  inStr := TStringStream.Create(hexStr);
  outStr := TStringStream.Create('');
  FillChar(Key, SizeOf(Key), 0);
  Move(PChar(password)^, Key, Min(SizeOf(Key),
    Length(password)));
  try
  DecryptAESStreamECB(inStr, 0, Key, outStr);
  except
  end;
  result := pchar(outStr.DataString);
  inStr.Free;
  outStr.Free;
end;



destructor TIniConfig.destroy;
begin
  inherited;
  FIniFile.Free;
end;

function TIniConfig.encodePass(const pass: string): string;
var
  inStr, outStr: TStringstream;
  Key: TAESKey128;
  password: string;
  hexStr: string;
begin
  password := '1234567890';
  inStr := TStringStream.Create(pass);
  outStr := TStringStream.Create('');
  FillChar(Key, SizeOf(Key), 0);
  Move(PChar(password)^, Key, Min(SizeOf(Key),
    Length(password)));
  EncryptAESStreamECB(inStr, 0, Key, outStr);
  SetLength(hexStr, outStr.Size * 2 + 1);

  BinToHex(pchar(outStr.DataString), pchar(hexStr), outStr.Size);
  //FIniFile.WriteString('ats', 'pass', hexStr);
  result := hexStr;
  inStr.Free;
  outStr.Free;
end;


function TIniConfig.getAvg_days: string;
begin
  result := FIniFile.readString('normal', 'avg_days', '');
  if (result = '') then
  begin
    self.avg_days := '14';
    result := '14';
  end;
end;

function TIniConfig.getDebug: string;
begin
  result := FIniFile.ReadString('normal', 'debug', '');
  if (result = '') then
  begin
    result := '0';
    FIniFile.WriteString('normal', 'debug', result);
  end;
end;

function TIniConfig.getFall_precent: string;
begin
  result := FIniFile.readString('normal', 'fall_precent', '');
  if (result = '') then
  begin
    self.fall_precent := '0.6';
    result := '0.6';
  end;
end;

function TIniConfig.getFV_NCYHXX: string;
begin
  result := FIniFile.ReadString('normal', 'V_NCYHXX', '');
  if(result = '')then
  begin
    self.V_NCYHXX := 'gruser.V_NCYHXX';
    result := 'gruser.V_NCYHXX';
  end;
end;

function TIniConfig.getIsSqlLog: string;
begin
  result := FIniFile.ReadString('normal', 'isSqlLog', '');
  if(result = '')then
  begin
    self.isSqlLog := '0';
    result := '0';
  end;
end;

function TIniConfig.getlowVolNoReportDay: string;
begin
  result := FIniFile.ReadString('normal', 'lowVolNoReportDay', '');
  if(result = '')then
  begin
    //self.noOracle := '3';
    result := '3';
  end;
end;

function TIniConfig.getNoOracle: String;
begin
  result := FIniFile.ReadString('normal', 'noOracle', '');
  if(result = '')then
  begin
    self.noOracle := '0';
    result := '0';
  end;
end;

function TIniConfig.getRunCount: string;
var
  encode_str:string;
begin
  encode_str := FIniFile.readString('normal', 'delay', '');
  if (encode_str = '') then
  begin
    result := '';
  end
  else
  begin
    result := decodePass(encode_str);
  end;
end;

procedure TIniConfig.setAvg_days(const Value: string);
begin
  FIniFile.WriteString('normal', 'avg_days', value);
end;

procedure TIniConfig.setDebug(const Value: string);
begin
  FIniFile.WriteString('normal', 'debug', value);
end;

procedure TIniConfig.setFall_precent(const Value: string);
begin
  FIniFile.WriteString('normal', 'fall_precent', value);
end;

procedure TIniConfig.setIsSqlLog(const Value: string);
begin
  FIniFile.WriteString('normal', 'isSqlLog', value);
end;

procedure TIniConfig.SetlowVolNoReportDay(const Value: string);
begin
  //FlowVolNoReportDay := Value;
  FIniFile.WriteString('normal', 'lowVolNoReportDay', value);
end;

procedure TIniConfig.setNoOracle(const Value: String);
begin
  FIniFile.WriteString('normal', 'noOracle', value);
end;

procedure TIniConfig.setRunCount(const Value: string);
begin
  FIniFile.WriteString('normal', 'delay', encodePass(Value));
end;


procedure TIniConfig.SetV_NCYHXX(const Value: string);
begin
  FIniFile.WriteString('normal', 'V_NCYHXX', Value);
end;

initialization
  aIniConfig := TIniConfig.create;

Finalization
  aIniConfig.Free;  

end.

