object repTianForm: TrepTianForm
  Left = 224
  Top = 151
  Width = 708
  Height = 663
  Caption = #30000'1#'#25253#34920
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 12
    Height = 12
    Caption = #20174
  end
  object Label2: TLabel
    Left = 159
    Top = 24
    Width = 12
    Height = 12
    Caption = #21040
  end
  object dtpBegin: TDateTimePicker
    Left = 48
    Top = 18
    Width = 89
    Height = 20
    Date = 39630.653550706020000000
    Time = 39630.653550706020000000
    TabOrder = 0
  end
  object dtpEnd: TDateTimePicker
    Left = 174
    Top = 19
    Width = 91
    Height = 20
    Date = 39721.653550706020000000
    Time = 39721.653550706020000000
    TabOrder = 1
  end
  object Button1: TButton
    Left = 344
    Top = 16
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 264
    Top = 48
    Width = 417
    Height = 561
    Lines.Strings = (
      #25143#21495' '#21517#31216' '#25152#23646#20998#23616' '#21464#21387#22120#23481#37327' '#26368#22823#36127#33655' '#24179#22343#36127#33655)
    TabOrder = 3
  end
  object ListBox1: TListBox
    Left = 16
    Top = 48
    Width = 233
    Height = 561
    ItemHeight = 12
    MultiSelect = True
    TabOrder = 4
  end
end
