object Form1: TForm1
  Left = 238
  Top = 181
  AutoSize = True
  Caption = 'Form1'
  ClientHeight = 494
  ClientWidth = 521
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
  object Image1: TImage
    Left = 200
    Top = 152
    Width = 321
    Height = 321
  end
  object Image2: TImage
    Left = 8
    Top = 0
    Width = 512
    Height = 145
  end
  object Button1: TButton
    Left = 312
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    Visible = False
  end
  object Button2: TButton
    Left = 240
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    Visible = False
  end
  object Button3: TButton
    Left = 392
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    Visible = False
  end
  object Button4: TButton
    Left = 312
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    Visible = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 152
    Width = 185
    Height = 321
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 475
    Width = 521
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer2Timer
    Left = 304
    Top = 232
  end
end
