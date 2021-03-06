unit TFeld;

interface
Type

  TKarte = Class
    private
        grosse_x, grosse_y: Integer;
        Karte: Array of Array of Integer;
    public
        constructor create(breite, hoehe, inhalt: Integer);
        function Set_Kosten_Feld(x, y, feld: Integer): Boolean;
        function read_kosten_feld(x,y: Integer): Integer;
        function read_grosse_x(): Integer;
        function read_grosse_y(): Integer;
        function Grosse_anpassen(breite, Hoehe: Integer): Boolean;
  end;


implementation

{ TKarte.read_grosse_x
  *Lie�t die L�nge der Karte aus
}
function TKarte.read_grosse_x(): Integer;
  begin
    result := grosse_x;
  end;

{ TKarte.read_grosse_x
  *Lie�t die H�he der Karte aus
}

function TKarte.read_grosse_y(): Integer;
  begin
    result := grosse_y;
  end;

{ TKarte.read_kosten_feld
  *Erwartet eine Positionsangabe als Parameter
  *gibt den Aufwand zur�ck den man betreiben muss um das Feld zu passieren
}
function TKarte.read_kosten_feld(x, y: Integer): Integer;
  begin
    if(x >= 1) and (x <= grosse_x) then
      if(y >= 1) and (y <= grosse_y) then
        result := Karte[x, y];
  end;

{ TKarte.Set_Kosten_Feld(x, y, feld: Integer)
  *Erwartet eine Positionsangabe und den inhalt des feldes als Parameter
  *Setzt den Inhalt des Feldes auf den gegebenen Inhalt
  *Liefert True zur�ck falls es geklappt hat
}
function TKarte.Set_Kosten_Feld(x, y, feld: Integer): Boolean;
  begin
    if(x >= 1) and (x <= grosse_x) then
      if(y >= 1) and (y <= grosse_y) then
      begin
        Karte[x, y] := feld;
        result := TRUE;
        exit;
      end;
    result := FALSE;
  end;
{TKarte.create
  *Erwartet H�he, Breite und INhalt der Karte
  *Erstellt eine Karte mit der Gegebenen H�he und Breite
  *Jedes Feld erh�lt den gegebenen Inhalt
}
constructor TKarte.create(breite, hoehe, inhalt: Integer);
  var
    i, j: Integer;
  begin
    if((breite > 0) and (hoehe > 0)) then
    begin
       grosse_x := breite;
       grosse_y := hoehe;
       Setlength(Karte, breite+1, hoehe+1);

       for i:= 1 to grosse_x do
        for j := 1 to grosse_y do
         Karte[i,j] := inhalt;
    end;
  end;
{TKarte.Grosse_anpassen(breite, hoehe: Integer)
 * Erwartet eine H�he und eine Breite als Parameter
 * �ndert die Gr��e der Karte in die gegeben H�he und Breite
 * Liefert True zur�ck falls es geklappt hat
}

function TKarte.Grosse_anpassen(breite, hoehe: Integer): Boolean;
  begin
    if((breite >= 1) and (hoehe >= 1)) then
    begin
     grosse_x := breite;
     grosse_y := hoehe;
     Setlength(Karte, breite+1, hoehe+1);
     result := TRUE;
     exit;
    end;
    result := FALSE;
  end;
end.
