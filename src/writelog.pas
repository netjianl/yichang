{------------------------------------------------------------------------------
   模块名称:  writelog
   功能:      具有缓存功能的写日志模块。
   使用：     创建：
                var sysLog :TLog;
                sysLog := TLog.Create;
                sysLog.fileNameStart := 'cnfg';//日志文件名的前半部分
              使用：
                sysLog.writeln(...);
              销毁：
                sysLog.free
   编写人：   简亮                                    时间：2003-11-18
------------------------------------------------------------------------------}
//procedure writeln(strStream: TStringStream); overload;还没有调试
{   属性说明：
     SingleFileSize:每个log文件的大小，当文件超过这个值，将新建下一个文件
     fileNameStart: log文件名格式是：fileNameStart + 5位的数字  + .log
     InBusy: 正在写文件
     Enabled: 使能写文件功能，如果为false，写文件过程将被忽略
     writeInterval: 两次写文件的时间间隔
     BusyTime: 写文件花费的时间
     Compressed: 是否使用压缩，如果为真，文件将以zip压缩
}
unit writelog;

interface

uses Classes, SysUtils, ExtCtrls, windows, Dialogs, zlib;

const
  MAXCACHELINE = 100000;
type
  TLog = class (TObject)
  private
    aTimer: TTimer;
    FBusyTime: Int64;
    FCacheStr: array[1..MAXCACHELINE] of string;
    FCompressed: Boolean;
    FEnabled: Boolean;
    FFileNameStart: string;
    FHead: Integer;
    FInBusy: Boolean;
    FLogfileName: string;
    FLogPath: string;
    FSingleFileSize: Integer;
    FTail: Integer;
    FwriteInterval: Integer;
    procedure ChangeFileNameStart(const Value: string);
    function getLastFileName: string;
    procedure onTimer(sender: TObject);
    function ReadSinglefileSize: Integer;
    procedure SetCompressed(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure setSingleFileSize(const Value: Integer);
    procedure SetwriteInterval(const Value: Integer);
    procedure writeCache;
  public
    constructor Create;
    destructor Destroy; override;
    procedure writeln(str: string); overload;
    procedure writeln(strStream: TStringStream); overload;
    property BusyTime: Int64 read FBusyTime;
    property Compressed: Boolean read FCompressed write SetCompressed;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property fileNameStart: string read FFileNameStart write 
            ChangeFileNameStart;
    property InBusy: Boolean read FInBusy;
    property SingleFileSize: Integer read ReadSinglefileSize write 
            setSingleFileSize;
    property writeInterval: Integer read FwriteInterval write SetwriteInterval;
  end;
  
var
  sysLog: TLog;
  errorLog: TLog;

implementation

uses iniConfig;

//uses   

{ TLog }

{
************************************* TLog *************************************
}
constructor TLog.Create;
var
  currPath: string;
begin
  FSingleFileSize := 6400;
  FFileNameStart := 'b2t';
  currPath := extractfilepath(paramstr(0));
  if not DirectoryExists(currPath + 'log') then
    CreateDir(currPath + 'log');
  FLogPath := currPath + 'log\';
  FLogfileName := getLastFileName;
  aTimer := TTimer.Create(nil);
  aTimer.OnTimer := onTimer;
  //aTimer.Interval := 11000;
  FHead := 1;
  FTail := 1;
end;

destructor TLog.Destroy;
begin
  inherited;
  aTimer.Free;
  writeCache;
end;

procedure TLog.ChangeFileNameStart(const Value: string);
begin
  FFileNameStart := Value;
  FLogfileName := getLastFileName;
end;

function TLog.getLastFileName: string;
var
  FindData: TWin32FindData;
  hf: THandle;
  b: Boolean;
  MaxNum, currNum: Integer;
  i: Integer;
  lastFileIsZip: Boolean;
begin
  lastFileIsZip := false;
  hf := Windows.FindFirstFile(PChar(FLogPath + FFileNameStart + '*.log'),
    FindData);
  if hf = INVALID_HANDLE_VALUE then
  begin
    hf := Windows.FindFirstFile(PChar(FLogPath + FFileNameStart + '*.log.zip'),
      FindData);
    lastFileIsZip := true;
    if hf = INVALID_HANDLE_VALUE then
    begin
      result := FLogPath + FFileNameStart + '00001.log';
      exit;
    end;
  end;
  MaxNum := 1;
  b := true;
  while b do
  begin
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      try
        currNum := StrToInt(system.copy(FindData.cFileName,
          length(FFileNameStart) + 1,
          5));
      except
        currNum := 0;
      end;
      if MaxNum < currNum then
        MaxNum := currNum;
    end;
    b := windows.FindNextFile(hf, FindData);
  end;
  if lastFileIsZip then inc(MaxNum);
  result := inttoStr(MaxNum);
  
  for i := 0 to 5 - length(IntToStr(MaxNum)) - 1 do
  begin
    result := '0' + result;
  end;
  result := FLogPath + FFileNameStart + result + '.log'
end;

procedure TLog.onTimer(sender: TObject);
var
  currTick: Int64;
  delayTick: Integer;
begin
  if FInBusy then
    exit;
  FInBusy := true;
  currTick := GetTickCount;
  try
    writeCache;
  except
  
  end;
  delayTick := GetTickCount - currTick;
  if (delayTick > 0) then
    inc(FBusyTime, delayTick);
  FInBusy := false;
end;

function TLog.ReadSinglefileSize: Integer;
begin
  result := FSingleFileSize * 128;
end;

procedure TLog.SetCompressed(const Value: Boolean);
begin
  FCompressed := Value;
end;

procedure TLog.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TLog.setSingleFileSize(const Value: Integer);
begin
  FSingleFileSize := Value div 128;
end;

procedure TLog.SetwriteInterval(const Value: Integer);
begin
  FWriteInterval := Value;
  aTimer.Interval := value;
end;

procedure TLog.writeCache;
var
  f: TextFile;
  i, maxNum: Integer;
  str: string;
  orgName: string;
  
  //  aZip:TZip;
  //  files:TStrings;
  
begin
  if (FHead = FTail) then
    exit;
  //  FEnabled := GetRegbool(fileNameStart + 'log');
  if not FEnabled then
    exit;
  assignfile(f, fLogFileName);
  try
    if FileExists(fLogFileName) then
    begin
      reset(f);
      append(f);
    end
    else
      rewrite(f);
    while (FHead <> FTail) do
    begin
      system.writeln(f, FCacheStr[FTail]);
          // + FormatDateTime(' yyyy/mm/dd hh:mm:ss',      Now));
      inc(FTail);
      if (FTail > MAXCACHELINE) then
        FTail := 1;
    end;
      //flush(f);
    if FileSize(f) > FSingleFileSize then
    begin
      orgName := FLogfileName;
      maxNum := StrToInt(system.copy(ExtractFileName(FLogfileName), 4, 5));
      inc(maxNum);
      str := IntToStr(MaxNum);
      for i := 0 to 5 - length(str) - 1 do
      begin
        str := '0' + str;
      end;
      FLogfileName := FLogPath + FFileNameStart + str + '.log';
    end;
  finally
    closefile(f);
  end;
  
  FCompressed := false;//GetRegbool(FFileNameStart + 'logzip');
  {
  if (orgName <> '') and FCompressed then
  begin
    MakeZip(orgName + '.zip', ExtractFilePath(orgName));
    AddZip(orgName);
    CloseZip;
    DeleteFile(Pchar(orgName));
  end;
  }
end;

procedure TLog.writeln(str: string);
begin
  FCacheStr[FHead] := str + ',' + FormatDateTime(' yyyy/mm/dd hh:mm:ss:zzz',
    Now);
  inc(FHead);
  if (FHead > MAXCACHELINE) then
    FHead := 1;
  //if udpMsg <> nil then
  //  udpMsg.addMsg(str);
end;

procedure TLog.writeln(strStream: TStringStream);
var
  aStrings: TStrings;
  i: Integer;
begin
  aStrings := TStringList.Create;
  aStrings.LoadFromStream(strStream);
  for i := 0 to aStrings.Count - 1 do
    self.writeln(aStrings[i]);
  aStrings.Free;
end;

initialization
  sysLog := TLog.Create;
  sysLog.Enabled := true;

finalization
  syslog.Free;   

end.

