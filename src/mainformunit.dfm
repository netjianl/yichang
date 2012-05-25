object Form1: TForm1
  Left = 194
  Top = 113
  Width = 1024
  Height = 726
  Caption = #24322#24120#20998#26512'--'#21016#29618
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1016
    Height = 680
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #25968#25454#33719#21462
      object Memo1: TMemo
        Left = 8
        Top = 16
        Width = 801
        Height = 561
        ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
        Lines.Strings = (
          'Memo1')
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Button1: TButton
        Left = 848
        Top = 72
        Width = 91
        Height = 25
        Caption = #24320#22987#20998#26512
        TabOrder = 1
        OnClick = Button1Click
      end
      object editPercent: TLabeledEdit
        Left = 832
        Top = 40
        Width = 57
        Height = 20
        EditLabel.Width = 48
        EditLabel.Height = 12
        EditLabel.Caption = #31361#38477#27604#29575
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 2
        Text = '0.7'
        OnDblClick = editPercentDblClick
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 634
        Width = 1008
        Height = 19
        Panels = <
          item
            Width = 50
          end>
      end
      object editAvgDays: TLabeledEdit
        Left = 904
        Top = 40
        Width = 57
        Height = 20
        EditLabel.Width = 72
        EditLabel.Height = 12
        EditLabel.Caption = #24179#22343#30005#37327#22825#25968
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20998#26512
      ImageIndex = 1
      object DBGrid1: TDBGrid
        Left = 0
        Top = 33
        Width = 1008
        Height = 431
        Align = alClient
        DataSource = DataSource1
        ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
        PopupMenu = pmYichang
        TabOrder = 0
        TitleFont.Charset = GB2312_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #23435#20307
        TitleFont.Style = []
        OnCellClick = DBGrid1CellClick
        OnTitleClick = DBGrid1TitleClick
        Columns = <
          item
            Expanded = False
            FieldName = #23458#25143#23616#21495
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = #23458#25143#21517#31216
            Width = 160
            Visible = True
          end
          item
            Expanded = False
            FieldName = #37096#38376#21517#31216
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = #30005#34920#23616#21495
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = #26102#38388
            Title.Caption = #31361#38477#26102#38388
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = #20170#26085#30005#37327
            Title.Caption = #30446#21069#30005#37327
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = #24179#22343#30005#37327
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = #23481#37327
            Width = 35
            Visible = True
          end
          item
            Expanded = False
            FieldName = #20449#29992#31561#32423
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = #22825#25968
            Width = 26
            Visible = True
          end
          item
            Expanded = False
            FieldName = #20998#26512
            Width = 84
            Visible = True
          end
          item
            Expanded = False
            FieldName = #21453#39304
            Width = 84
            Visible = True
          end
          item
            Expanded = False
            FieldName = #24322#24120#26631#35760
            PickList.Strings = (
              ''
              #27491#24120
              #24322#24120
              #37325#22823#24322#24120
              #24674#22797#27491#24120
              #22788#29702#20013)
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = #26159#21542#26377#20572#30005#35760#24405
            Title.Caption = #20572#30005'?'
            Width = 35
            Visible = True
          end
          item
            Expanded = False
            FieldName = #26159#21542#26159#22810#34920#29992#25143
            Title.Caption = #22810#34920'?'
            Width = 35
            Visible = True
          end
          item
            Expanded = False
            FieldName = #32447#36335
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = #34892#19994
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = #37319#38598#32570#28857#20449#24687
            Width = 160
            Visible = True
          end>
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1008
        Height = 33
        Align = alTop
        TabOrder = 1
        object DBNavigator1: TDBNavigator
          Left = 56
          Top = 0
          Width = 240
          Height = 25
          DataSource = DataSource1
          TabOrder = 0
        end
        object Button3: TButton
          Left = 552
          Top = 0
          Width = 75
          Height = 25
          Caption = #25628#32034
          TabOrder = 1
          OnClick = Button3Click
        end
        object Button2: TButton
          Left = 640
          Top = 0
          Width = 75
          Height = 25
          Caption = #25171#24320
          PopupMenu = PopupMenu1
          TabOrder = 2
          OnClick = Button2Click
        end
        object btnComboSort: TButton
          Left = 392
          Top = 0
          Width = 75
          Height = 25
          Caption = #32452#21512#25490#24207
          TabOrder = 3
          OnClick = btnComboSortClick
        end
        object Button4: TButton
          Left = 472
          Top = 0
          Width = 75
          Height = 25
          Caption = #32452#21512#31579#36873
          TabOrder = 4
          OnClick = Button4Click
        end
        object Button5: TButton
          Left = 720
          Top = 0
          Width = 75
          Height = 25
          Caption = #25442#34920#26816#27979
          TabOrder = 5
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 808
          Top = 0
          Width = 81
          Height = 25
          Caption = #23548#20837#21453#39304#25968#25454
          TabOrder = 6
          OnClick = Button6Click
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 464
        Width = 1008
        Height = 189
        Align = alBottom
        Caption = 'Panel2'
        TabOrder = 2
        object pcDetail: TPageControl
          Left = 1
          Top = 1
          Width = 1006
          Height = 187
          ActivePage = tsPowerOff
          Align = alClient
          TabOrder = 0
          object TabSheet3: TTabSheet
            Caption = #20998#26512#20869#23481
            object DBMemo1: TDBMemo
              Left = 0
              Top = 0
              Width = 998
              Height = 160
              Align = alClient
              DataField = #20998#26512
              DataSource = DataSource1
              ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
              TabOrder = 0
            end
          end
          object TabSheet5: TTabSheet
            Caption = #21453#39304
            ImageIndex = 2
            object DBMemo2: TDBMemo
              Left = 0
              Top = 0
              Width = 998
              Height = 160
              Align = alClient
              DataField = #21453#39304
              DataSource = DataSource1
              ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
              TabOrder = 0
            end
          end
          object tsPowerOff: TTabSheet
            Caption = #20572#30005#24773#20917
            ImageIndex = 1
            object DBGrid2: TDBGrid
              Left = 0
              Top = 0
              Width = 833
              Height = 160
              Align = alLeft
              DataSource = dsPowerOff
              ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
              TabOrder = 0
              TitleFont.Charset = GB2312_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -12
              TitleFont.Name = #23435#20307
              TitleFont.Style = []
            end
            object btnAlarmContent: TButton
              Left = 864
              Top = 24
              Width = 75
              Height = 25
              Caption = #32534#36753#23545#29031#34920
              TabOrder = 1
              OnClick = btnAlarmContentClick
            end
          end
          object tsLines: TTabSheet
            Caption = #26354#32447
            ImageIndex = 3
            object Label1: TLabel
              Left = 760
              Top = 14
              Width = 12
              Height = 12
              Caption = #20174
            end
            object Label2: TLabel
              Left = 896
              Top = 13
              Width = 12
              Height = 12
              Caption = #21040
            end
            object dtpBegin: TDateTimePicker
              Left = 776
              Top = 8
              Width = 89
              Height = 20
              Date = 39532.711819108790000000
              Time = 39532.711819108790000000
              ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
              TabOrder = 0
              OnChange = dtpBeginChange
            end
            object dtpEnd: TDateTimePicker
              Left = 920
              Top = 8
              Width = 89
              Height = 20
              Date = 39532.711819108790000000
              Time = 39532.711819108790000000
              ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
              TabOrder = 1
              OnChange = dtpBeginChange
            end
            object DBChart1: TDBChart
              Left = 0
              Top = 0
              Width = 689
              Height = 160
              BackWall.Brush.Color = clWhite
              BackWall.Brush.Style = bsClear
              Title.Text.Strings = (
                'TDBChart')
              Title.Visible = False
              LeftAxis.ExactDateTime = False
              View3D = False
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 2
              object SeriesDianliang: TLineSeries
                Marks.ArrowLength = 8
                Marks.Visible = False
                SeriesColor = clRed
                Title = #26412#26399#25968#25454
                Pointer.InflateMargins = True
                Pointer.Style = psRectangle
                Pointer.Visible = True
                XValues.DateTime = True
                XValues.Name = 'X'
                XValues.Multiplier = 1.000000000000000000
                XValues.Order = loNone
                YValues.DateTime = False
                YValues.Name = 'Y'
                YValues.Multiplier = 1.000000000000000000
                YValues.Order = loNone
              end
              object SeriesDianliangLastYear: TLineSeries
                Marks.ArrowLength = 8
                Marks.Visible = False
                SeriesColor = clLime
                Title = #19978#24180#21516#26399
                Pointer.InflateMargins = True
                Pointer.Style = psRectangle
                Pointer.Visible = True
                XValues.DateTime = True
                XValues.Name = 'X'
                XValues.Multiplier = 1.000000000000000000
                XValues.Order = loNone
                YValues.DateTime = False
                YValues.Name = 'Y'
                YValues.Multiplier = 1.000000000000000000
                YValues.Order = loNone
              end
            end
            object ChartWether: TChart
              Left = 680
              Top = 40
              Width = 353
              Height = 113
              BackWall.Brush.Color = clWhite
              BackWall.Brush.Style = bsClear
              Title.Text.Strings = (
                'TChart')
              Title.Visible = False
              Legend.Visible = False
              View3D = False
              TabOrder = 3
              object SeriesWether: TLineSeries
                Marks.ArrowLength = 8
                Marks.Visible = False
                SeriesColor = clRed
                Pointer.InflateMargins = True
                Pointer.Style = psRectangle
                Pointer.Visible = False
                XValues.DateTime = False
                XValues.Name = 'X'
                XValues.Multiplier = 1.000000000000000000
                XValues.Order = loAscending
                YValues.DateTime = False
                YValues.Name = 'Y'
                YValues.Multiplier = 1.000000000000000000
                YValues.Order = loNone
              end
              object SeriesWehterLastYear: TLineSeries
                Marks.ArrowLength = 8
                Marks.Visible = False
                SeriesColor = clGreen
                Pointer.InflateMargins = True
                Pointer.Style = psRectangle
                Pointer.Visible = False
                XValues.DateTime = False
                XValues.Name = 'X'
                XValues.Multiplier = 1.000000000000000000
                XValues.Order = loAscending
                YValues.DateTime = False
                YValues.Name = 'Y'
                YValues.Multiplier = 1.000000000000000000
                YValues.Order = loNone
              end
            end
          end
        end
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = DataModule1.table_yichang_now
    Left = 20
    Top = 23
  end
  object FindDialog1: TFindDialog
    OnFind = FindDialog1Find
    Left = 620
    Top = 79
  end
  object dsPowerOff: TDataSource
    DataSet = DataModule1.poweroff_query
    Left = 25
    Top = 133
  end
  object PopupMenu1: TPopupMenu
    Left = 636
    Top = 23
    object N1: TMenuItem
      Caption = #26222#36890#30340
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #24674#22797#27491#24120#30340
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = #20840#37096#30340
      OnClick = N1Click
    end
    object N13: TMenuItem
      Caption = #26410#26631#35760#30340
      OnClick = N1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 772
    Top = 127
    object N4: TMenuItem
      Caption = #25991#20214
      object menuViewBackup: TMenuItem
        Caption = #22791#20221#25991#20214#22841'...'
        OnClick = menuViewBackupClick
      end
      object N6: TMenuItem
        Caption = #36864#20986
        OnClick = N6Click
      end
    end
    object N5: TMenuItem
      Caption = #22810#30005#34920#29992#25143
      object N7: TMenuItem
        Caption = #26597#30475
        OnClick = N7Click
      end
      object N8: TMenuItem
        Caption = #26032#22686
        OnClick = N8Click
      end
    end
    object N17: TMenuItem
      Caption = #25968#25454#34920
      object N12: TMenuItem
        Caption = #22825#27668
        OnClick = N12Click
      end
      object menuHourCount: TMenuItem
        Caption = #37319#38598#32570#28857
        OnClick = menuHourCountClick
      end
    end
    object N14: TMenuItem
      Caption = #29992#25143#25253#34920
      object N15: TMenuItem
        Caption = #30000
        OnClick = N15Click
      end
      object N16: TMenuItem
        Caption = #30005#21387#30005#27969#19981#24179#34913#25253#34920
        OnClick = N16Click
      end
      object N18: TMenuItem
        Caption = #19981#24179#34913#21382#21490
        OnClick = N18Click
      end
      object menuDePolar: TMenuItem
        Caption = #21453#26497#24615#29992#25143#25253#34920
        Enabled = False
        OnClick = menuDePolarClick
      end
    end
  end
  object pmYichang: TPopupMenu
    Left = 692
    Top = 183
    object N9: TMenuItem
      Caption = #21382#21490#25968#25454
      OnClick = N9Click
    end
    object N10: TMenuItem
      Caption = #22810#34920#21512#35745#25968#25454
      OnClick = N10Click
    end
    object N11: TMenuItem
      Caption = #22797#21046#21517#31216
      OnClick = N11Click
    end
  end
  object Timer1: TTimer
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 916
    Top = 135
  end
end
