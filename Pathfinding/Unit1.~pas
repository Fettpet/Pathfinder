unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TPathfinding_Algos, StdCtrls, ExtCtrls, TFeld, math;

type
  TForm1 = class(TForm)
    Feld: TImage;
    RG_Wegbeschaffenheit: TRadioGroup;
    RG_Weg: TRadioGroup;
    Button_Weg_einzeichnen: TButton;
    Button_Weg_entfernen: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit_Ziel_X: TEdit;
    Label3: TLabel;
    Edit_Ziel_Y: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit_Start_x: TEdit;
    Label6: TLabel;
    Edit_start_y: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FeldMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FeldMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FeldMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_Weg_einzeichnenClick(Sender: TObject);
    procedure Button_Weg_entfernenClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  Maus_gedrueckt: Boolean;
  A_Stern: TPathfinding;
  Karte: TKarte;

implementation


{$R *.dfm}
// Damit man nicht jeden Punkt einzeln anklicken muss, werden folgende 3 Prozeduren dafür verwendet
// Das man bequem Zeichnen kann ohne jedes Mal neu klicken zu müssen

// Diese Funktion ändert die Globale Variable Maus_gedrückt, falls man auf dem Bild die Linke Maustaste drückt
// In Wahr

procedure TForm1.FeldMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    if(Button = mbleft) then
      begin
      maus_gedrueckt := True;
      FeldMouseMove(Sender, Shift, X, Y);
    end;
  end;

// Falls die Globale Maus_Gedrückt Wahr ist, wird ein 20x20px großes Viereck gezeichnet
// es wird erst geteilt und gerundet und dann Multipliziert, damit nur aller 20px ein Viereck kommzt
// und nicht jedes PX
procedure TForm1.FeldMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

  var
    zeichnen_x, zeichnen_y: Integer;
  begin
    if(Maus_gedrueckt = True) then
    begin
       zeichnen_x := floor(x/20);
       zeichnen_y := floor(y/20);
       Karte.Set_Kosten_Feld(zeichnen_x+1, zeichnen_y+1, RG_Wegbeschaffenheit.ItemIndex);

       if(RG_Wegbeschaffenheit.ItemIndex = 0) then
       begin
          Feld.Canvas.pen.Color := clblack;
          Feld.Canvas.Brush.Color := clblack;
       end
       else if(RG_Wegbeschaffenheit.ItemIndex = 1) then
       begin
          Feld.Canvas.pen.Color := $00ff00;
          Feld.Canvas.Brush.Color := $00ff00;
       end
       else if(RG_Wegbeschaffenheit.ItemIndex = 2) then
       begin
          Feld.Canvas.pen.Color := $ff0000;
          Feld.Canvas.Brush.Color := $ff0000;
       end
       else if(RG_Wegbeschaffenheit.ItemIndex = 3) then
       begin
          Feld.Canvas.pen.Color := clyellow ;
          Feld.Canvas.Brush.Color := clyellow;
       end
       else if(RG_Wegbeschaffenheit.ItemIndex = 4) then
       begin
          Feld.Canvas.pen.Color := clred;
          Feld.Canvas.Brush.Color := clred;
       end;


       zeichnen_x := zeichnen_x *20;
       zeichnen_y := zeichnen_y *20;
       Feld.Canvas.Rectangle(Zeichnen_x, Zeichnen_y, Zeichnen_x + 20, Zeichnen_y + 20);

    end;
  end;
//Falls die Linke Maustaste losgelassen wird, springt die Globale Maus_gedruckt wieder auf FAlse
procedure TForm1.FeldMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    if(Button = mbleft) then
      maus_gedrueckt := False
  end;

procedure TForm1.FormCreate(Sender: TObject);
  begin
    Feld.Canvas.Brush.Color := $00ff00;
    Feld.Canvas.Pen.Color := $00ff00;
    Feld.Canvas.Rectangle(0,0,800,600);
    Maus_gedrueckt := False;

    Karte := TKarte.create(40, 30, 1);
    A_stern := TPathfinding.create(Karte);

    A_stern.Ziel_anpassen(25, 15);
    A_stern.Start_Anpassen(5, 15);
    Feld.Canvas.Brush.Color := $FFFFFF;
    Feld.Canvas.Pen.Color := $FFFFFF;
    Feld.Canvas.Rectangle(480,280,500,300);
    Feld.Canvas.Rectangle(80,280,100,300);
  end;

procedure TForm1.Button_Weg_einzeichnenClick(Sender: TObject);
  var
    test, i, schritte: Integer;
  begin
    // den alten weg entfernen
    Button_Weg_entfernenClick(Sender);
    if(RG_weg.ItemIndex = 0) then
      test := A_Stern.AStern_kurz()
    else
      test := A_Stern.AStern_schnell();

    case test of
      1: showmessage('Kein Weg gefunden');
      2: showmessage('Es ist kein Ziel definiert');
      3: showmessage('Ziel liegt ausserhalb der Karte');
      4: showmessage('Der Start ist nicht definiert');
      5: showmessage('Start liegt ausserhalb der Karte');
      6: showmessage('Start und Ziel sind identisch');
      7: showmessage('Start liegt auf einem Hinderniss');
      8: showmessage('Ziel liegt auf einem Hinderniss');
    end;
    schritte := A_stern.Anzahl_schritte();
    Feld.Canvas.Brush.Color := $FF00FF;
    Feld.Canvas.pen.Color := $FF00FF;
    for i := 2 to schritte do
    begin
      Feld.Canvas.Ellipse((A_Stern.schritt_x(i)-1) * 20, (A_Stern.schritt_y(i)-1) * 20,A_Stern.schritt_x(i)  * 20, A_Stern.schritt_y(i) * 20);

    end;
  end;

procedure TForm1.Button_Weg_entfernenClick(Sender: TObject);
  var
    i, schritte: Integer;
  begin
    For i:= 2 to A_stern.Anzahl_schritte() do
    begin
       if(Karte.read_kosten_feld(A_Stern.schritt_x(i), A_Stern.schritt_y(i)) = 0) then
       begin
          Feld.Canvas.pen.Color := clblack;
          Feld.Canvas.Brush.Color := clblack;
       end
       else if(Karte.read_kosten_feld(A_Stern.schritt_x(i), A_Stern.schritt_y(i)) = 1) then
       begin
          Feld.Canvas.pen.Color := $00ff00;
          Feld.Canvas.Brush.Color := $00ff00;
       end
       else if(Karte.read_kosten_feld(A_Stern.schritt_x(i), A_Stern.schritt_y(i)) = 2) then
       begin
          Feld.Canvas.pen.Color := $ff0000;
          Feld.Canvas.Brush.Color := $ff0000;
       end
       else if(Karte.read_kosten_feld(A_Stern.schritt_x(i), A_Stern.schritt_y(i)) = 3) then
       begin
          Feld.Canvas.pen.Color := clyellow ;
          Feld.Canvas.Brush.Color := clyellow;
       end
       else if(Karte.read_kosten_feld(A_Stern.schritt_x(i), A_Stern.schritt_y(i)) = 4) then
       begin
          Feld.Canvas.pen.Color := clred;
          Feld.Canvas.Brush.Color := clred;
       end;

       Feld.Canvas.Rectangle((A_Stern.schritt_x(i)-1) * 20, (A_Stern.schritt_y(i)-1) * 20,A_Stern.schritt_x(i)  * 20, A_Stern.schritt_y(i) * 20);
    end;
  end;

procedure TForm1.Button1Click(Sender: TObject);
  var
    x, y: Integer;
  begin
   if(Edit_Start_x.text <> '') and (Edit_Start_y.text <> '')  then
   begin
    x := strtoint(Edit_Start_x.text);
    y := strtoint(Edit_Start_y.text);
    if(x >= 1) And (x <= 40) then
    if(y >= 1) and (y <= 30) then
    begin
      // DAs Alte Start x aus der Karte entfernen
       if(Karte.read_kosten_feld(A_stern.read_Start_x, A_stern.read_Start_y) = 0) then
       begin
          Feld.Canvas.pen.Color := clblack;
          Feld.Canvas.Brush.Color := clblack;
       end
       else if(Karte.read_kosten_feld(A_stern.read_Start_x, A_stern.read_Start_y) = 1) then
       begin
          Feld.Canvas.pen.Color := $00ff00;
          Feld.Canvas.Brush.Color := $00ff00;
       end
       else if(Karte.read_kosten_feld(A_stern.read_Start_x, A_stern.read_Start_y) = 2) then
       begin
          Feld.Canvas.pen.Color := $ff0000;
          Feld.Canvas.Brush.Color := $ff0000;
       end
       else if(Karte.read_kosten_feld(A_stern.read_Start_x, A_stern.read_Start_y) = 3) then
       begin
          Feld.Canvas.pen.Color := clyellow ;
          Feld.Canvas.Brush.Color := clyellow;
       end
       else if(Karte.read_kosten_feld(A_stern.read_Start_x, A_stern.read_Start_y) = 4) then
       begin
          Feld.Canvas.pen.Color := clred;
          Feld.Canvas.Brush.Color := clred;
       end;
      Feld.Canvas.Rectangle((A_stern.read_Start_x-1)*20, (A_stern.read_Start_y-1)*20, A_stern.read_Start_x*20, A_stern.read_Start_y*20);
      A_stern.Start_Anpassen(x, y);
      Feld.Canvas.Brush.Color := $FFFFFF;
      Feld.Canvas.Pen.Color := $FFFFFF;
      Feld.Canvas.Rectangle((x-1)*20,(y-1)*20,x*20,y*20);
    end
    else
      showmessage('Überprüfen sie ihre eingabewerte');
   end
   else
    showmessage('Bitte machen sie bei Start eine Eingabe');


// DAs Ziel anpassen
   if(Edit_Start_x.text <> '') and (Edit_Start_y.text <> '')  then
   begin
    x := strtoint(Edit_Ziel_x.text);
    y := strtoint(Edit_Ziel_y.text);
    if(x >= 1) And (x <= 40) then
    if(y >= 1) and (y <= 30) then
    begin
      // DAs Alte Start x aus der Karte entfernen
       if(Karte.read_kosten_feld(A_stern.read_Ziel_x, A_stern.read_Ziel_y) = 0) then
       begin
          Feld.Canvas.pen.Color := clblack;
          Feld.Canvas.Brush.Color := clblack;
       end
       else if(Karte.read_kosten_feld(A_stern.read_Ziel_x, A_stern.read_Ziel_y) = 1) then
       begin
          Feld.Canvas.pen.Color := $00ff00;
          Feld.Canvas.Brush.Color := $00ff00;
       end
       else if(Karte.read_kosten_feld(A_stern.read_Ziel_x, A_stern.read_Ziel_y) = 2) then
       begin
          Feld.Canvas.pen.Color := $ff0000;
          Feld.Canvas.Brush.Color := $ff0000;
       end
       else if(Karte.read_kosten_feld(A_stern.read_Ziel_x, A_stern.read_Ziel_y) = 3) then
       begin
          Feld.Canvas.pen.Color := clyellow ;
          Feld.Canvas.Brush.Color := clyellow;
       end
       else if(Karte.read_kosten_feld(A_stern.read_Ziel_x, A_stern.read_Ziel_y) = 4) then
       begin
          Feld.Canvas.pen.Color := clred;
          Feld.Canvas.Brush.Color := clred;
       end;
       Feld.Canvas.Rectangle((A_stern.read_Ziel_x-1)*20, (A_stern.read_Ziel_y-1)*20, A_stern.read_Ziel_x*20, A_stern.read_Ziel_y*20);
       A_stern.Ziel_Anpassen(x, y);
       Feld.Canvas.Brush.Color := $FFFFFF;
       Feld.Canvas.Pen.Color := $FFFFFF;
       Feld.Canvas.Rectangle((x-1)*20,(y-1)*20,x*20,y*20);
    end
    else
      showmessage('Überprüfen sie ihre eingabewerte');
   end
   else
    showmessage('Bitte machen sie bei Start eine Eingabe');
  end;

end.
