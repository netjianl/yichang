//参考TDBGridEh的导入导出方法修改而来。

//用法：用DBGridExport方法倒出一个DBGrid的数据，用DataSetExport方法倒出一个DataSe的数据
//说明：只倒出数据，不倒出或设置格式信息。


{*******************************************************}
{                                                       }
{                      TDBGrid导出                      }
{                                                       }
{*******************************************************}
//导出TDBGrid的数据到excel中
//根据TDBGridEh的相应方法修改而来
//by chengxb
//

unit DBGridExp;

interface

uses
  Windows, SysUtils, Classes, Graphics, Dialogs, Grids, DBGrids, Controls,
  Db;

type

{ TColumnsList }
  TColumnsList = class(TList)
  private
    function GetColumn(Index: Integer): TColumn;
    procedure SetColumn(Index: Integer; const Value: TColumn);
  public
    property Items[Index: Integer]: TColumn read GetColumn write SetColumn; default;
  end;

{ TDBGridExport }

  TDBGridExport = class(TObject)
  private
    FVisibleColumns: TColumnsList;
    FDBGrid: TDBGrid;
    FExpCols: TColumnsList;
    FStream: TStream;
    procedure SetDBGrid(ADBGrid: TDBGrid);
  protected
    procedure WritePrefix; virtual;
    procedure WriteSuffix; virtual;
    procedure WriteTitle(ColumnsList: TColumnsList); virtual;
    procedure WriteRecord(ColumnsList: TColumnsList); virtual;
    procedure WriteDataCell(Column: TColumn); virtual;
    property Stream: TStream read FStream write FStream;
    property ExpCols: TColumnsList read FExpCols write FExpCols;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ExportToStream(AStream: TStream; IsExportAll: Boolean); virtual;
    procedure ExportToFile(FileName: string; IsExportAll: Boolean); virtual;
    property DBGrid: TDBGrid read FDBGrid write SetDBGrid;
  end;

  TDBGridExportClass = class of TDBGridExport;

  { TDBGridExportAsXLS }

  TDBGridExportAsXLS = class(TDBGridExport)
  private
    FCol, FRow: Word;
    procedure WriteIntegerCell(const AValue: Integer);
    procedure WriteFloatCell(const AValue: Double);
    procedure WriteStringCell(const AValue: string);
    procedure IncColRow;
  protected
    procedure WritePrefix; override;
    procedure WriteSuffix; override;
    procedure WriteTitle(ColumnsList: TColumnsList); override;
    procedure WriteDataCell(Column: TColumn); override;
  public
    procedure ExportToStream(AStream: TStream; IsExportAll: Boolean); override;
  end;


procedure SaveDBGridToExportFile(ExportClass: TDBGridExportClass;
  DBGrid: TDBGrid; const FileName: string; IsSaveAll: Boolean);
procedure WriteDBGridToExportStream(ExportClass: TDBGridExportClass;
  DBGrid: TDBGrid; Stream: TStream; IsSaveAll: Boolean);
procedure DBGridExport(AGrid: TDBGrid);
procedure DataSetExport(ADataSet: TDataSet);

implementation


procedure WriteDBGridToExportStream(ExportClass: TDBGridExportClass;
  DBGrid: TDBGrid; Stream: TStream; IsSaveAll: Boolean);
var DBGridExport: TDBGridExport;
begin
  DBGridExport := ExportClass.Create;
  try
    DBGridExport.DBGrid := DBGrid;
    DBGridExport.ExportToStream(Stream, IsSaveAll);
  finally
    DBGridExport.Free;
  end;
end;

procedure SaveDBGridToExportFile(ExportClass: TDBGridExportClass;
  DBGrid: TDBGrid; const FileName: string; IsSaveAll: Boolean);
var DBGridExport: TDBGridExport;
begin
  DBGridExport := ExportClass.Create;
  try
    DBGridExport.DBGrid := DBGrid;
    DBGridExport.ExportToFile(FileName, IsSaveAll);
  finally
    DBGridExport.Free;
  end;
end;

procedure DBGridExport(AGrid: TDBGrid);
var
  SaveDialog: TSaveDialog;
  ExpClass: TDbGridExportClass;
  Ext: string;
begin
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'Excel文件(*.xls)|*.XLS'; //|逗号分隔文本(*.csv)|*.csv|超文本文件(*.htm)|*.HTM|Rtf格式文件(*.rtf)|*.RTF|文本文件(*.txt)|*.TXT';
    if SaveDialog.Execute then
    begin
      case SaveDialog.FilterIndex of
        1: begin ExpClass := TDBGridExportAsXLS; Ext := 'xls'; end;
//        2: begin ExpClass := TDBGridEhExportAsCSV; Ext := 'csv'; end;
//        3: begin ExpClass := TDBGridEhExportAsHTML; Ext := 'htm'; end;
//        4: begin ExpClass := TDBGridEhExportAsRTF; Ext := 'rtf'; end;
//        5: begin ExpClass := TDbGridEhExportAsText; Ext := 'txt'; end;
      else
        ExpClass := nil; Ext := '';
      end;
      if ExpClass <> nil then
      begin
        if UpperCase(Copy(SaveDialog.FileName, Length(SaveDialog.FileName) - 2, 3)) <>
          UpperCase(Ext) then
          SaveDialog.FileName := SaveDialog.FileName + '.' + Ext;
        SaveDBGridToExportFile(ExpClass, AGrid, SaveDialog.FileName, true);
      end;
    end;
  finally
    FreeAndNil(SaveDialog);
  end;
end;

procedure DataSetExport(ADataSet: TDataSet);
var
  AGrid: TDBGrid;
  ADataSource: TDataSource;
begin
  AGrid := TDBGrid.Create(nil);
  try
    ADataSource := TDataSource.Create(nil);
    try
      AGrid.DataSource := ADataSource;
      ADataSource.DataSet := ADataSet;
      DBGridExport(AGrid);
    finally
      ADataSource.free;
    end;
  finally
    AGrid.Free;
  end;
end;
{ TColumnsList }

function TColumnsList.GetColumn(Index: Integer): TColumn;
begin
  Result := Get(Index);
end;

procedure TColumnsList.SetColumn(Index: Integer; const Value: TColumn);
begin
  Put(Index, Value);
end;


{ TDBGridExport }


procedure TDBGridExport.SetDBGrid(ADBGrid: TDBGrid);
var
  I: integer;
begin
  FDBGrid := ADBGrid;
  with ADBGrid do
  begin
    for I := 0 to Columns.Count - 1 do
      if Columns[I].Showing then FVisibleColumns.Add(Columns[I]);
  end;
end;

procedure TDBGridExport.ExportToFile(FileName: string; IsExportAll: Boolean);
var FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    ExportToStream(FileStream, IsExportAll);
  finally
    FileStream.Free;
  end;
end;

procedure TDBGridExport.ExportToStream(AStream: TStream; IsExportAll: Boolean);
//var i: Integer;
begin
  Stream := AStream;
  try
    with DBGrid do
    begin
      with DataSource.Dataset do
      begin
        DisableControls;
        try
          ExpCols := FVisibleColumns;
          WritePrefix;
          if dgTitles in Options then WriteTitle(FVisibleColumns);
          First;
          while Eof = False do
          begin
            WriteRecord(FVisibleColumns);
            Next;
          end;
        finally
          EnableControls;
        end;
      end;
    end;
    WriteSuffix;
  finally
  //
  end;
end;

procedure TDBGridExport.WriteTitle(ColumnsList: TColumnsList);
begin
end;

procedure TDBGridExport.WriteRecord(ColumnsList: TColumnsList);
var
  i: Integer;
begin
  try
    for i := 0 to ColumnsList.Count - 1 do
    begin
      WriteDataCell(ColumnsList[i]);
    end;
  finally
    //
  end;
end;


procedure TDBGridExport.WritePrefix;
begin
end;

procedure TDBGridExport.WriteSuffix;
begin
end;

procedure TDBGridExport.WriteDataCell(Column: TColumn);
begin
end;


constructor TDBGridExport.Create;
begin
  inherited Create;
  FVisibleColumns := TColumnsList.Create;
end;

destructor TDBGridExport.Destroy;
begin
  FVisibleColumns.Free;
  inherited Destroy;
end;


{ TDBGridExportAsXLS }

var
  CXlsBof: array[0..5] of Word = ($809, 8, 0, $10, 0, 0);
  CXlsEof: array[0..1] of Word = ($0A, 00);
  CXlsLabel: array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
  CXlsNumber: array[0..4] of Word = ($203, 14, 0, 0, 0);
  CXlsRk: array[0..4] of Word = ($27E, 10, 0, 0, 0);

procedure TDBGridExportAsXLS.WriteFloatCell(const AValue: Double);
begin
  CXlsNumber[2] := FRow;
  CXlsNumber[3] := FCol;
  Stream.WriteBuffer(CXlsNumber, SizeOf(CXlsNumber));
  Stream.WriteBuffer(AValue, 8);
  IncColRow;
end;

procedure TDBGridExportAsXLS.WriteIntegerCell(const AValue: Integer);
var
  V: Integer;
begin
  CXlsRk[2] := FRow;
  CXlsRk[3] := FCol;
  Stream.WriteBuffer(CXlsRk, SizeOf(CXlsRk));
  V := (AValue shl 2) or 2;
  Stream.WriteBuffer(V, 4);
  IncColRow;
end;

procedure TDBGridExportAsXLS.WriteStringCell(const AValue: string);
var
  L: Word;
begin
  L := Length(AValue);
  CXlsLabel[1] := 8 + L;
  CXlsLabel[2] := FRow;
  CXlsLabel[3] := FCol;
  CXlsLabel[5] := L;
  Stream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel));
  Stream.WriteBuffer(Pointer(AValue)^, L);
  IncColRow;
end;

procedure TDBGridExportAsXLS.WritePrefix;
begin
  Stream.WriteBuffer(CXlsBof, SizeOf(CXlsBof));
end;

procedure TDBGridExportAsXLS.WriteSuffix;
begin
  Stream.WriteBuffer(CXlsEof, SizeOf(CXlsEof));
end;

procedure TDBGridExportAsXLS.WriteTitle(ColumnsList: TColumnsList);
var i: Integer;
begin
  for i := 0 to ColumnsList.Count - 1 do
  begin
    WriteStringCell(ColumnsList[i].Title.Caption);
  end;
end;

procedure TDBGridExportAsXLS.WriteDataCell(Column: TColumn);
begin
  if Column.Field = nil then
    WriteStringCell('')
  else
    with Column.Field do
      case DataType of
        ftSmallint, ftInteger, ftWord, ftAutoInc, ftBytes:
          WriteIntegerCell(AsInteger);
        ftFloat, ftCurrency, ftBCD:
          WriteFloatCell(AsFloat);
      else
        WriteStringCell(DisplayText);
      end;
end;


procedure TDBGridExportAsXLS.ExportToStream(AStream: TStream;
  IsExportAll: Boolean);
begin
  FCol := 0;
  FRow := 0;
  inherited ExportToStream(AStream, IsExportAll);
end;

procedure TDBGridExportAsXLS.IncColRow;
begin
  if FCol = ExpCols.Count - 1 then
  begin
    Inc(FRow);
    FCol := 0;
  end else
    Inc(FCol);
end;


end. 


 