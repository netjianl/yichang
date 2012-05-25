object hourcount_viewForm: Thourcount_viewForm
  Left = 227
  Top = 95
  Width = 551
  Height = 643
  Caption = #32570#28857#32479#35745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DateTimePicker1: TDateTimePicker
    Left = 40
    Top = 16
    Width = 97
    Height = 21
    Date = 39942.859912314820000000
    Time = 39942.859912314820000000
    TabOrder = 0
    OnChange = DateTimePicker1Change
  end
  object Chart1: TChart
    Left = 216
    Top = 56
    Width = 321
    Height = 473
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    Legend.Visible = False
    View3D = False
    TabOrder = 1
    object Series1: TBarSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Bar'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object Button1: TButton
    Left = 424
    Top = 568
    Width = 75
    Height = 25
    Caption = #20851#38381
    ModalResult = 1
    TabOrder = 2
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 56
    Width = 185
    Height = 473
    DataSource = DataSource1
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = hourcount_dm.sumInDay
    Left = 72
    Top = 104
  end
end
