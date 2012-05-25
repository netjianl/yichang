object mutliUserList_form: TmutliUserList_form
  Left = 131
  Top = 161
  Width = 1060
  Height = 679
  Caption = #22810#34920#29992#25143#26597#30475
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #26032#23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 888
    Top = 496
    Width = 84
    Height = 12
    Caption = #22810#34920#29992#25143#32034#24341#20540
  end
  object Label2: TLabel
    Left = 888
    Top = 536
    Width = 48
    Height = 12
    Caption = #24320#22987#26102#38388
  end
  object Label3: TLabel
    Left = 888
    Top = 572
    Width = 48
    Height = 12
    Caption = #32467#26463#26102#38388
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1052
    Height = 441
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 954
      Height = 439
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 0
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 952
        Height = 437
        Align = alClient
        DataSource = DataModule1.dsMultiUserList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 0
        TitleFont.Charset = GB2312_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #26032#23435#20307
        TitleFont.Style = []
        OnCellClick = DBGrid1CellClick
        Columns = <
          item
            Expanded = False
            FieldName = #32034#24341#20540
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = #20998#23616
            Visible = True
          end
          item
            Expanded = False
            FieldName = #23458#25143#21517#31216
            Width = 350
            Visible = True
          end
          item
            Expanded = False
            FieldName = #27979#37327#28857#32534#21495
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = #25143#21495
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = #34920#21495
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = #32456#31471#36923#36753#22320#22336
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = #21452#30005#28304#26631#24535
            Visible = True
          end>
      end
    end
    object Panel3: TPanel
      Left = 955
      Top = 1
      Width = 96
      Height = 439
      Align = alRight
      TabOrder = 1
      object Button4: TButton
        Left = 6
        Top = 24
        Width = 75
        Height = 25
        Caption = #26597#25214
        TabOrder = 0
        OnClick = Button4Click
      end
      object Button3: TButton
        Left = 6
        Top = 136
        Width = 75
        Height = 25
        Caption = #32534#36753
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button2: TButton
        Left = 6
        Top = 96
        Width = 75
        Height = 25
        Caption = #21024#38500
        TabOrder = 2
        OnClick = Button2Click
      end
      object Button1: TButton
        Left = 6
        Top = 56
        Width = 75
        Height = 25
        Caption = #22686#21152
        TabOrder = 3
        OnClick = Button1Click
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 441
    Width = 873
    Height = 211
    ActivePage = tsLines
    Align = alLeft
    TabOrder = 1
    object sumDianliang: TTabSheet
      Caption = #21512#35745#30005#37327
      object DBGrid2: TDBGrid
        Left = 8
        Top = 8
        Width = 377
        Height = 161
        DataSource = DataModule1.dsMutliUser_dianliang
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 0
        TitleFont.Charset = GB2312_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #26032#23435#20307
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = #30005#37327
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = #26085#26399
            Width = 80
            Visible = True
          end>
      end
      object DBGrid3: TDBGrid
        Left = 408
        Top = 8
        Width = 337
        Height = 161
        DataSource = DataModule1.ds_mutilUser_dianliang_lastyear
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 1
        TitleFont.Charset = GB2312_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #26032#23435#20307
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = #30005#37327
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = #26085#26399
            Width = 80
            Visible = True
          end>
      end
    end
    object tsLines: TTabSheet
      Caption = #21512#35745#30005#37327#26354#32447
      ImageIndex = 1
      object DBChart1: TDBChart
        Left = 0
        Top = 0
        Width = 641
        Height = 184
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Text.Strings = (
          'TDBChart')
        Title.Visible = False
        BottomAxis.Inverted = True
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMinimum = False
        View3D = False
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object Series1: TLineSeries
          Marks.ArrowLength = 8
          Marks.Style = smsXValue
          Marks.Visible = False
          DataSource = DataModule1.query_mutilUser_dianliang
          SeriesColor = clRed
          Title = #26412#26399#25968#25454
          XLabelsSource = #26085#26399
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
          YValues.ValueSource = #30005#37327
        end
        object Series2: TLineSeries
          Marks.ArrowLength = 8
          Marks.Style = smsXValue
          Marks.Visible = False
          DataSource = DataModule1.query_mutilUser_dianliang_lastyear
          SeriesColor = clLime
          Title = #19978#24180#21516#26399
          XLabelsSource = #26085#26399
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
          YValues.ValueSource = #30005#37327
        end
      end
      object DBChart2: TDBChart
        Left = 641
        Top = 0
        Width = 224
        Height = 184
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Text.Strings = (
          'TDBChart')
        Title.Visible = False
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 45.000000000000000000
        LeftAxis.Minimum = -10.000000000000000000
        Legend.Visible = False
        View3D = False
        View3DWalls = False
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Series3: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          DataSource = wetherdm.queryWether
          SeriesColor = clRed
          XLabelsSource = #26085#26399
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          XValues.ValueSource = #26085#26399
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
          YValues.ValueSource = #26368#39640#27668#28201
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = #22791#27880
      ImageIndex = 2
      object DBMemo1: TDBMemo
        Left = 0
        Top = 0
        Width = 865
        Height = 177
        Align = alClient
        DataField = #22791#27880
        DataSource = DataModule1.dsMultiUserList
        TabOrder = 0
      end
    end
  end
  object Edit1: TEdit
    Left = 978
    Top = 491
    Width = 55
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
    Text = 'Edit1'
  end
  object dtpBegin: TDateTimePicker
    Left = 952
    Top = 528
    Width = 89
    Height = 20
    Date = 39562.848564444440000000
    Time = 39562.848564444440000000
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 3
  end
  object dtpEnd: TDateTimePicker
    Left = 952
    Top = 568
    Width = 89
    Height = 20
    Date = 39562.848723043980000000
    Time = 39562.848723043980000000
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 4
  end
  object FindDialog1: TFindDialog
    OnFind = FindDialog1Find
    Left = 816
    Top = 8
  end
end
