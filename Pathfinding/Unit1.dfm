object Form1: TForm1
  Left = 163
  Top = 236
  Width = 1008
  Height = 634
  Caption = 'Pathfinding'
  Color = clBtnFace
  Constraints.MaxHeight = 634
  Constraints.MaxWidth = 1008
  Constraints.MinHeight = 252
  Constraints.MinWidth = 332
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Feld: TImage
    Left = 200
    Top = 0
    Width = 800
    Height = 600
    OnMouseDown = FeldMouseDown
    OnMouseMove = FeldMouseMove
    OnMouseUp = FeldMouseUp
  end
  object Label1: TLabel
    Left = 16
    Top = 360
    Width = 17
    Height = 13
    Caption = 'Ziel'
  end
  object Label2: TLabel
    Left = 24
    Top = 376
    Width = 7
    Height = 13
    Caption = 'X'
  end
  object Label3: TLabel
    Left = 24
    Top = 416
    Width = 7
    Height = 13
    Caption = 'Y'
  end
  object Label4: TLabel
    Left = 16
    Top = 264
    Width = 22
    Height = 13
    Caption = 'Start'
  end
  object Label5: TLabel
    Left = 24
    Top = 280
    Width = 7
    Height = 13
    Caption = 'X'
  end
  object Label6: TLabel
    Left = 24
    Top = 320
    Width = 7
    Height = 13
    Caption = 'Y'
  end
  object RG_Wegbeschaffenheit: TRadioGroup
    Left = 8
    Top = 0
    Width = 185
    Height = 137
    Caption = 'Wegbeschaffenheit'
    ItemIndex = 0
    Items.Strings = (
      'Hinderniss'
      'Gras'
      'Seichtes Wasser'
      'Sand'
      'Gebirge')
    TabOrder = 0
  end
  object RG_Weg: TRadioGroup
    Left = 8
    Top = 144
    Width = 185
    Height = 81
    Caption = 'Weg'
    ItemIndex = 0
    Items.Strings = (
      'K'#252'rzester Weg'
      'schnellster Weg')
    TabOrder = 1
  end
  object Button_Weg_einzeichnen: TButton
    Left = 0
    Top = 448
    Width = 105
    Height = 25
    Caption = 'Weg einzeichnen'
    TabOrder = 2
    OnClick = Button_Weg_einzeichnenClick
  end
  object Button_Weg_entfernen: TButton
    Left = 104
    Top = 448
    Width = 89
    Height = 25
    Caption = 'Weg entfernen'
    TabOrder = 3
    OnClick = Button_Weg_entfernenClick
  end
  object Edit_Ziel_X: TEdit
    Left = 48
    Top = 376
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '25'
  end
  object Edit_Ziel_Y: TEdit
    Left = 48
    Top = 408
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '15'
  end
  object Edit_Start_x: TEdit
    Left = 48
    Top = 280
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '5'
  end
  object Edit_start_y: TEdit
    Left = 48
    Top = 312
    Width = 121
    Height = 21
    TabOrder = 7
    Text = '15'
  end
  object Button1: TButton
    Left = 32
    Top = 496
    Width = 137
    Height = 25
    Caption = 'Positionen neu bestimmen'
    TabOrder = 8
    OnClick = Button1Click
  end
end
