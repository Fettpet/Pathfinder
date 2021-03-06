unit TPathfinding_Algos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TFeld, math;

type
  TSchritt = record
    x: Integer;
    y: Integer;
  end;

  TKnoten = record
    kosten_hierher: Integer;
    kosten_ziel: Integer;
    Gesamtkosten: Integer;
    Pos_x, Pos_y: Integer;
  end;


  TPathfinding = class
  private
    Karte: ^TKarte;
    Start_x, Start_y: Integer;
    Ziel_x, Ziel_y: Integer;
     Schritt: Array of Tschritt;
    Schritte_Anzahl: Integer;
    function errechneter_weg(x, y: integer): Integer;

  public
    constructor create(var Karte_par: TKarte);
    function Anzahl_schritte(): Integer;
    function Ziel_anpassen(x, y: Integer): Boolean;
    function Start_Anpassen(x, y: Integer): Boolean;
    function AStern_schnell(): Integer;
    function AStern_kurz(): Integer;

    Function read_Ziel_x(): Integer;
    Function read_Ziel_y(): Integer;
    Function read_Start_x(): Integer;
    Function read_Start_y(): Integer;

    function schritt_x(nummer: Integer): Integer;
    function schritt_y(nummer: Integer): Integer;
end;

implementation

{ TPathfinding.schritt_x(nummer: Integer)
  *Liefert die Position in x richtung des gegebenen schrittes zur�ck
  *Sie liefert -1 zur�ck falls dieser Schritt noch nicht vorhanden ist
  *damit sie �berhaupt was zur�ckliefert muss AStern_schnell oder AStern_kurz eine 0 zur�ckgeben
}

function TPathfinding.schritt_x(nummer: Integer): Integer;
  begin
    if(nummer > 0) and (nummer <= Schritte_anzahl) then
      result :=  Schritt[nummer].x
    else
      result := -1;
  end;

{ TPathfinding.schritt_y(nummer: Integer)
  *Liefert die Position in y richtung des gegebenen schrittes zur�ck
  *Sie liefert -1 zur�ck falls dieser Schritt noch nicht vorhanden ist
  *damit sie �berhaupt was zur�ckliefert muss AStern_schnell oder AStern_kurz eine 0 zur�ckgeben
}
function TPathfinding.schritt_y(nummer: Integer): Integer;
  begin
    if(nummer > 0) and (nummer <= Schritte_anzahl) then
      result :=  Schritt[nummer].y
    else
      result := -1;
  end;

{ TPathfinding.read_Ziel_x
  *Diese Funktion gibt den X wert des Zieles zur�ck
}
function TPathfinding.read_Ziel_x(): Integer;
  begin
    result := Ziel_x;
  end;

{ TPathfinding.read_Ziel_y
  *Diese Funktion gibt den y wert des Zieles zur�ck
}
function TPathfinding.read_Ziel_y(): Integer;
  begin
    result := Ziel_y;
  end;

{ TPathfinding.read_Start_x
  *Diese Funktion gibt den X wert des Startes zur�ck
}
function TPathfinding.read_Start_x(): Integer;
  begin
    result := Start_x;
  end;
{ TPathfinding.read_Start_y
  *Diese Funktion gibt den y wert des Startes zur�ck
}

function TPathfinding.read_Start_y(): Integer;
  begin
    result := Start_y;
  end;

{ TPathfinding.AStern_kurz
  *Diese Funktion beschreibt den k�rzesten Weg vom Start zum Ziel
  *sie hat folgende R�ckgabe werte:
  0: alles hat funktioniert
  1: kein Weg gefunden
  2: ziel nicht definiert
 	3: ziel liegt au�erhalb des Intervalls
 	4: Start nicht definiert
  5: Start liegt au�erhalb des Intervalls
  6: Start  = Zeile
  7: Start ist Hindernis
  8: Ziel ist Hindernis

}
function TPathfinding.AStern_kurz(): Integer;
  var
    i, j, u, k, bestes_Kosten, bestes_nummer: Integer;
    offene_liste, abgearbeitete_Liste, buffer_Liste: Array of TKnoten;
    aktueller_Knoten, abgearbeitete_Knoten, neuer_Knoten: TKnoten;
    ziel_gefunden, schon_vorhanden: Boolean;
    Anzahl_offen, Anzahl_abgearbeitet: Integer;
    Buffer_schritte: Array of TSchritt;
  begin
    Schritte_Anzahl := 0;
    Setlength(Schritt, 0);
    //�berpr�fen ob Start Definiert ist;
    if((Start_x = -1) Or (Start_y = -1)) then
    begin
        result := 4;
        exit;
    end;

    //�berpr�fen ob Start im Intervall liegt
    if((Start_x >= Karte.read_grosse_x()) Or (Start_y >= Karte.read_grosse_y())) then
    begin
        result := 5;
        exit;
    end;

    //�berpr�fen ob Ziel Definiert ist;
    if((Ziel_x = -1) Or (Ziel_y = -1)) then
    begin
        result := 2;
        exit;
    end;

    //�berpr�fen ob Ziel im Intervall liegt
    if((Ziel_x >= Karte.read_grosse_x()) Or (Ziel_y >= Karte.read_grosse_y())) then
    begin
        result := 3;
        exit;
    end;

    // Die Start Information anlegen
      neuer_Knoten.Pos_x := Start_x;
      neuer_Knoten.Pos_y := Start_y;
      neuer_Knoten.kosten_ziel := errechneter_weg(neuer_Knoten.Pos_x, neuer_Knoten.Pos_y);
      neuer_Knoten.kosten_hierher := 0;
      Setlength(offene_Liste, 2);
      Anzahl_offen := 1;
      offene_liste[1] := neuer_Knoten;
      anzahl_abgearbeitet := 0;
    // Hier gehts jetzt Richtig los^^
      ziel_gefunden := FALSE;
      Repeat
        // Rausfinden welches die geringsten gesamtkosten hat
        //dazu wird das erste Element aus der liste genommen
        aktueller_Knoten := Offene_Liste[1];
        bestes_kosten := aktueller_Knoten.Gesamtkosten;
        bestes_nummer := 1;

        // und dann werden die gesamtkosten mit allen andern ELementen aus der offenen Liste verglichen
        for i:=1 to anzahl_offen do
        begin
          aktueller_Knoten := offene_liste[i];
         // Form1.Memo1.Lines.Add('Nummer: ' + inttostr(i) + ' Kosten: ' + inttostr(offene_liste[i].Gesamtkosten));

          if(aktueller_Knoten.Gesamtkosten < bestes_kosten) then
          begin
            bestes_kosten := aktueller_Knoten.Gesamtkosten;
            bestes_nummer := i;
          end;
        end;

        aktueller_Knoten := offene_liste[bestes_nummer];
        //Das Beste ist gefunden
        //Nun wird das ELement �berpr�ft ob es schon das Ziel ist
   //     Form1.Memo1.Lines.Add('x:' + inttostr(aktueller_Knoten.Pos_x) + 'y:' + inttostr(aktueller_Knoten.Pos_y));

        if(aktueller_Knoten.kosten_ziel = 0) then
        begin
          Ziel_gefunden := TRUE;
          break;
        end;

        // Das Ziel wurde noch nicht gefunden
        // die 8 rundherum in die offene Liste aufnehmen
        for i:= -1 to +1 do
        begin
          for j:= -1 to +1 do
          begin
            // �berpr�fen ob die Elemente schon in der abgearbeiten Liste sind
            // Position �berpr�fen
            if(aktueller_Knoten.Pos_x + i < 1) OR (aktueller_Knoten.Pos_x + i > Karte.read_grosse_x) then
              continue;
            if(aktueller_Knoten.Pos_y + j < 1) OR (aktueller_Knoten.Pos_y + j > Karte.read_grosse_y) then
              continue;
            // Testen ob das Feld Passierbar ist
            if(Karte.read_kosten_feld(aktueller_Knoten.Pos_x + i, aktueller_Knoten.Pos_y + j) = 0) then
                continue;

            schon_vorhanden := FALSE;
            for u:= 1 to anzahl_abgearbeitet do
            begin
              abgearbeitete_Knoten := abgearbeitete_Liste[u];
              if(abgearbeitete_Knoten.Pos_x = aktueller_Knoten.Pos_x + i) and (abgearbeitete_Knoten.Pos_y = aktueller_Knoten.Pos_y + j) then
              begin
                //Falls das Element schon vorhanden ist, seine Kosten dahin aber kleiner sind
                if( abs(i + j) = 1) then
                  k :=  2
                else
                  k :=  3;
                if(abgearbeitete_Knoten.kosten_hierher > aktueller_Knoten.kosten_hierher +k) then
                begin
                  abgearbeitete_Liste[u].kosten_hierher := aktueller_Knoten.kosten_hierher +k;
                end;
                schon_vorhanden := TRUE;
                break;
              end;
            end;

            for u:=1 to anzahl_offen do
            begin
              abgearbeitete_Knoten := offene_liste[u];
              if(abgearbeitete_Knoten.Pos_x = aktueller_Knoten.Pos_x + i) and (abgearbeitete_Knoten.Pos_y = aktueller_Knoten.Pos_y + j) then
              begin
              //Falls das Element schon vorhanden ist, seine Kosten dahin aber kleiner sind
                if( abs(i + j) = 1) then
                  k :=  2
                else
                  k :=  3;
                if(abgearbeitete_Knoten.kosten_hierher > aktueller_Knoten.kosten_hierher +k) then
                begin
                  offene_liste[u].kosten_hierher := aktueller_Knoten.kosten_hierher +k;
                end;
                schon_vorhanden := TRUE;
                break;
              end;
            end;

            // Das Element ist schon vorhanden
            if(schon_vorhanden = TRUE) then
              continue;

            //Die Position hinzuf�gen

            neuer_Knoten.Pos_x := aktueller_Knoten.Pos_x + i;
            neuer_Knoten.Pos_y := aktueller_Knoten.Pos_y + j;

            // Die kosten dahin bestimmen
            if( abs(i + j) = 1) then
              neuer_Knoten.kosten_hierher := aktueller_Knoten.kosten_hierher + 2
            else
              neuer_Knoten.kosten_hierher := aktueller_Knoten.kosten_hierher + 3;

              neuer_Knoten.kosten_ziel := errechneter_weg(neuer_Knoten.Pos_x, neuer_Knoten.Pos_y);
              neuer_Knoten.Gesamtkosten := neuer_Knoten.kosten_hierher + neuer_Knoten.kosten_ziel;
            //Zur Offenen Liste hinzuf�gen
            // erstmal alles in einen Buffer schreiben da bei Setlength der Inhalt gel�scht wird
            Setlength(Buffer_liste, anzahl_offen+1);
            for u:=1 to anzahl_offen do
              Buffer_liste[u] := offene_Liste[u];

            anzahl_offen := anzahl_offen + 1;
            Setlength(offene_Liste, anzahl_offen+1);
            for u:=1 to anzahl_offen-1 do
              offene_Liste[u] :=Buffer_liste[u];

            offene_Liste[anzahl_offen] := neuer_Knoten;

          end;
        end;
        // das benutzte Element in die Abgearbeite Liste schieben
        Setlength(Buffer_liste, anzahl_abgearbeitet+1);
        for u:=1 to anzahl_abgearbeitet do
          Buffer_liste[u] := Abgearbeitete_Liste[u];

        anzahl_abgearbeitet := anzahl_abgearbeitet + 1;
        Setlength(Abgearbeitete_Liste, anzahl_abgearbeitet+1);
        for u:=1 to anzahl_abgearbeitet-1 do
          Abgearbeitete_Liste[u] :=Buffer_liste[u];

        Abgearbeitete_Liste[anzahl_abgearbeitet] := offene_Liste[bestes_nummer];

        //Es aus der offenen Liste l�schen
        for u:= bestes_nummer to anzahl_offen-1 do
        begin
          Offene_liste[u] := Offene_liste[u+1];
        end;

        Setlength(Buffer_liste, anzahl_offen);
        for u:=1 to anzahl_offen-1 do
          Buffer_liste[u] := offene_Liste[u];

        anzahl_offen := anzahl_offen - 1;
        Setlength(offene_Liste, anzahl_offen+1);

        for u:=1 to anzahl_offen do
          offene_Liste[u] :=Buffer_liste[u];

      Until (anzahl_offen = 0) or (Ziel_gefunden = True);

// Hier beginnt die Zer�ckfolgung des Weges
      if(Ziel_gefunden = True) then
      begin
        repeat
          Schritte_Anzahl := Schritte_Anzahl + 1;
          for i:= -1 to +1 do
          begin
            for j:= -1 to +1 do
            begin
              //Erstmal schauen welches Element angrenzt
              if(i = 0) and (j = 0) then
                continue;
              begin
                for u:= 1 to Anzahl_abgearbeitet do
                begin
                  if(abgearbeitete_Liste[u].Pos_x = aktueller_Knoten.Pos_x + i) and (abgearbeitete_Liste[u].Pos_y = aktueller_Knoten.Pos_y + j) then
                  begin
                    if(Karte.read_kosten_feld(abgearbeitete_Liste[u].Pos_x, abgearbeitete_Liste[u].Pos_y) > 0) then
                    begin
                      // schauen welches Element die geringsten kosten haben
                      if(abgearbeitete_Liste[u].kosten_hierher < neuer_Knoten.kosten_hierher ) then
                      begin

                        neuer_Knoten := abgearbeitete_Liste[u];
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
          // schritte dazuz�hlen
          Setlength(Buffer_Schritte, Schritte_anzahl);
          For i:= 1 to Schritte_anzahl-1 do
            Buffer_Schritte[i] := Schritt[i];

          Setlength(Schritt, Schritte_Anzahl+1);
          For i:= 1 to Schritte_anzahl-1 do
            Schritt[i] := Buffer_Schritte[i];

          Schritt[Schritte_anzahl].x := aktueller_Knoten.Pos_x;
          Schritt[Schritte_anzahl].y := aktueller_Knoten.Pos_y;

          aktueller_Knoten := neuer_Knoten;

        Until aktueller_Knoten.kosten_hierher = 0;
        result := 0;
      end
      else
        result := 1;
  end;

{ TPathfinding.AStern_schnell
  *Diese Funktion beschreibt den schnellsten Weg vom Start zum Ziel
  *sie hat folgende R�ckgabe werte:
  0: alles hat funktioniert
  1: kein Weg gefunden
  2: ziel nicht definiert
  3: ziel liegt ausserhalb des intevalls
  4: start nicht definiert
  5: start liegt ausserhalb des intervalls
  6: Start  = Zeile
  7: Start ist Hinderniss
  8: Ziel ist Hinderniss
}
                                                       
function TPathfinding.AStern_schnell(): Integer;
  var
    i, j, u, bestes_Kosten, bestes_nummer: Integer;
    offene_liste, abgearbeitete_Liste, hinderniss_Liste, buffer_Liste: Array of TKnoten;
    aktueller_Knoten, abgearbeitete_Knoten, neuer_Knoten: TKnoten;
    ziel_gefunden, schon_vorhanden: Boolean;
    Anzahl_offen, Anzahl_abgearbeitet: Integer;
    Buffer_schritte: Array of TSchritt;
  begin
    Schritte_Anzahl := 0;
    Setlength(Schritt, 0);
    //�berpr�fen ob Start Definiert ist;
    if((Start_x = -1) Or (Start_y = -1)) then
    begin
        result := 4;
        exit;
    end;

    //�berpr�fen ob Start im Intervall liegt
    if((Start_x >= Karte.read_grosse_x()) Or (Start_y >= Karte.read_grosse_y())) then
    begin
        result := 5;
        exit;
    end;

    //�berpr�fen ob Ziel Definiert ist;
    if((Ziel_x = -1) Or (Ziel_y = -1)) then
    begin
        result := 2;
        exit;
    end;

    //�berpr�fen ob Ziel im Intervall liegt
    if((Ziel_x >= Karte.read_grosse_x()) Or (Ziel_y >= Karte.read_grosse_y())) then
    begin
        result := 3;
        exit;
    end;

    // Die Start Information anlegen
      neuer_Knoten.Pos_x := Start_x;
      neuer_Knoten.Pos_y := Start_y;
      neuer_Knoten.kosten_ziel := errechneter_weg(neuer_Knoten.Pos_x, neuer_Knoten.Pos_y);
      neuer_Knoten.kosten_hierher := 0;
      Setlength(offene_Liste, 2);
      Anzahl_offen := 1;
      offene_liste[1] := neuer_Knoten;
      anzahl_abgearbeitet := 0;
    // Hier gehts jetzt Richtig los^^
      ziel_gefunden := FALSE;
      Repeat
        // Rausfinden welches die geringsten gesamtkosten hat
        //dazu wird das erste Element aus der liste genommen
        aktueller_Knoten := Offene_Liste[1];
        bestes_kosten := aktueller_Knoten.Gesamtkosten;
        bestes_nummer := 1;

        // und dann werden die gesamtkosten mit allen andern ELementen aus der offenen Liste verglichen
        for i:=1 to anzahl_offen do
        begin
          aktueller_Knoten := offene_liste[i];
         // Form1.Memo1.Lines.Add('Nummer: ' + inttostr(i) + ' Kosten: ' + inttostr(offene_liste[i].Gesamtkosten));

          if(aktueller_Knoten.Gesamtkosten < bestes_kosten) then
          begin
            bestes_kosten := aktueller_Knoten.Gesamtkosten;
            bestes_nummer := i;
          end;
        end;

        aktueller_Knoten := offene_liste[bestes_nummer];
        //Das Beste ist gefunden
        //Nun wird das ELement �berpr�ft ob es schon das Ziel ist
   //     Form1.Memo1.Lines.Add('x:' + inttostr(aktueller_Knoten.Pos_x) + 'y:' + inttostr(aktueller_Knoten.Pos_y));

        if(aktueller_Knoten.kosten_ziel = 0) then
        begin
          Ziel_gefunden := TRUE;
          break;
        end;

        // Das Ziel wurde noch nicht gefunden
        // die 8 rundherum in die offene Liste aufnehmen
        for i:= -1 to +1 do
        begin
          for j:= -1 to +1 do
          begin
            // �berpr�fen ob die Elemente schon in der abgearbeiten Liste sind
            // Position �berpr�fen
            if(aktueller_Knoten.Pos_x + i < 1) OR (aktueller_Knoten.Pos_x + i > Karte.read_grosse_x) then
              continue;
            if(aktueller_Knoten.Pos_y + j < 1) OR (aktueller_Knoten.Pos_y + j > Karte.read_grosse_y) then
              continue;
            // Testen ob das Feld Passierbar ist
            if(Karte.read_kosten_feld(aktueller_Knoten.Pos_x + i, aktueller_Knoten.Pos_y + j) = 0) then
                continue;

            schon_vorhanden := FALSE;
            for u:= 1 to anzahl_abgearbeitet do
            begin
              abgearbeitete_Knoten := abgearbeitete_Liste[u];
              if(abgearbeitete_Knoten.Pos_x = aktueller_Knoten.Pos_x + i) and (abgearbeitete_Knoten.Pos_y = aktueller_Knoten.Pos_y + j) then
              begin
                schon_vorhanden := TRUE;
                break;
              end;
            end;

            for u:=1 to anzahl_offen do
            begin
              abgearbeitete_Knoten := offene_liste[u];
              if(abgearbeitete_Knoten.Pos_x = aktueller_Knoten.Pos_x + i) and (abgearbeitete_Knoten.Pos_y = aktueller_Knoten.Pos_y + j) then
              begin
                schon_vorhanden := TRUE;
                break;
              end;
            end;

            // Das Element ist schon vorhanden
            if(schon_vorhanden = TRUE) then
              continue;

            //Die Position hinzuf�gen

            neuer_Knoten.Pos_x := aktueller_Knoten.Pos_x + i;
            neuer_Knoten.Pos_y := aktueller_Knoten.Pos_y + j;

            // Die kosten dahin bestimmen
            if( abs(i + j) = 1) then
              neuer_Knoten.kosten_hierher := aktueller_Knoten.kosten_hierher + 2*Karte.read_kosten_feld(neuer_Knoten.Pos_x, neuer_Knoten.Pos_y)
            else
              neuer_Knoten.kosten_hierher := aktueller_Knoten.kosten_hierher + 3*Karte.read_kosten_feld(neuer_Knoten.Pos_x, neuer_Knoten.Pos_y);

              neuer_Knoten.kosten_ziel := errechneter_weg(neuer_Knoten.Pos_x, neuer_Knoten.Pos_y);
              neuer_Knoten.Gesamtkosten := neuer_Knoten.kosten_hierher + neuer_Knoten.kosten_ziel;
            //Zur Offenen Liste hinzuf�gen
            // erstmal alles in einen Buffer schreiben da bei Setlength der Inhalt gel�scht wird
            Setlength(Buffer_liste, anzahl_offen+1);
            for u:=1 to anzahl_offen do
              Buffer_liste[u] := offene_Liste[u];

            anzahl_offen := anzahl_offen + 1;
            Setlength(offene_Liste, anzahl_offen+1);
            for u:=1 to anzahl_offen-1 do
              offene_Liste[u] :=Buffer_liste[u];

            offene_Liste[anzahl_offen] := neuer_Knoten;

          end;
        end;
        // das benutzte Element in die Abgearbeite Liste schieben
        Setlength(Buffer_liste, anzahl_abgearbeitet+1);
        for u:=1 to anzahl_abgearbeitet do
          Buffer_liste[u] := Abgearbeitete_Liste[u];

        anzahl_abgearbeitet := anzahl_abgearbeitet + 1;
        Setlength(Abgearbeitete_Liste, anzahl_abgearbeitet+1);
        for u:=1 to anzahl_abgearbeitet-1 do
          Abgearbeitete_Liste[u] :=Buffer_liste[u];

        Abgearbeitete_Liste[anzahl_abgearbeitet] := offene_Liste[bestes_nummer];

        //Es aus der offenen Liste l�schen
        for u:= bestes_nummer to anzahl_offen-1 do
        begin
          Offene_liste[u] := Offene_liste[u+1];
        end;

        Setlength(Buffer_liste, anzahl_offen);
        for u:=1 to anzahl_offen-1 do
          Buffer_liste[u] := offene_Liste[u];

        anzahl_offen := anzahl_offen - 1;
        Setlength(offene_Liste, anzahl_offen+1);

        for u:=1 to anzahl_offen do
          offene_Liste[u] :=Buffer_liste[u];
      //form1.Memo1.Lines.Add(inttostr(Anzahl_offen));
      Until (anzahl_offen = 0) or (Ziel_gefunden = True);



      if(Ziel_gefunden = True) then
      begin
        repeat
          Schritte_Anzahl := Schritte_Anzahl + 1;
          for i:= -1 to +1 do
          begin
            for j:= -1 to +1 do
            begin
              //Erstmal schauen welches Element angrenzt
              if(i = 0) and (j = 0) then
                continue;
              begin
                for u:= 1 to Anzahl_abgearbeitet do
                begin


                  if(abgearbeitete_Liste[u].Pos_x = aktueller_Knoten.Pos_x + i) and (abgearbeitete_Liste[u].Pos_y = aktueller_Knoten.Pos_y + j) then
                  begin
                    //showmessage('x: ' + inttostr(abgearbeitete_Liste[u].Pos_x ) + ' y:' + inttostr(abgearbeitete_Liste[u].Pos_y) + ' kosten: ' + inttostr(Karte.read_kosten_feld(abgearbeitete_Liste[u].Pos_x, abgearbeitete_Liste[u].Pos_y)));
                    if(Karte.read_kosten_feld(abgearbeitete_Liste[u].Pos_x, abgearbeitete_Liste[u].Pos_y) > 0) then
                    begin
                      // schauen welches Element die geringsten kosten haben
                      if(abgearbeitete_Liste[u].kosten_hierher < neuer_Knoten.kosten_hierher ) then
                      begin
                        //Form1.Memo1.Lines.Add('Kosten Karte: '+inttostr(Karte.read_kosten_feld(abgearbeitete_Liste[u].Pos_x, abgearbeitete_Liste[u].Pos_y)));
                        neuer_Knoten := abgearbeitete_Liste[u];
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
          // schritte dazuz�hlen
          Setlength(Buffer_Schritte, Schritte_anzahl);
          For i:= 1 to Schritte_anzahl-1 do
            Buffer_Schritte[i] := Schritt[i];

          Setlength(Schritt, Schritte_Anzahl+1);
          For i:= 1 to Schritte_anzahl-1 do
            Schritt[i] := Buffer_Schritte[i];

          Schritt[Schritte_anzahl].x := aktueller_Knoten.Pos_x;
          Schritt[Schritte_anzahl].y := aktueller_Knoten.Pos_y;

          aktueller_Knoten := neuer_Knoten;
        //  Form1.Memo1.Lines.Add(inttostr(anzahl_abgearbeitet));

        Until aktueller_Knoten.kosten_hierher = 0;
        result := 0;
      end
      else
        result := 1;
  end;

{Konstruktor
  *erwartet einen Zeiger einer TKarte als Parameter
  *Setzt alle Variablen auf ihre Startwerte
}
constructor TPathfinding.create(var Karte_par: TKarte);
  begin
    Karte := @Karte_par;
    Ziel_x := -1;
    Ziel_y := -1;
    Start_x := -1;
    Start_y := -1;
  end;
{ TPathfinding.errechneter_weg
  *errechnet Die gesch�tzten Kosten bis zum Ziel
  * Erwartet eine Positionsangabe als Parameter
}
function TPathfinding.errechneter_weg(x, y: Integer): Integer;
  begin
    result := abs(Ziel_x - x) * 2 + Abs(Ziel_y - y) * 2;
  end;

{ TPathfinding.Anzahl_schritte
  * Liefert die anzahl der schritte, die man vom Start zum Ziel ben�tigt
}
function TPathfinding.Anzahl_schritte(): Integer;
  begin
      result := Schritte_anzahl;
  end;

{ TPathfinding.Ziel_anpassen
  * Erwartete eine Positionsangabe als Parameter
  * �ndert die Zielposition in die Parameter Position
  * Liefert True Zur�ck falls es geklappt hat
}
function TPathfinding.Ziel_anpassen(x, y: Integer): Boolean;
  begin
    if((x >= 0) and (x < Karte.read_grosse_x)) then
      if((y >= 0) and (y < Karte.read_grosse_y)) then
      begin
        Ziel_x := x;
        Ziel_y := y;
        result := TRUE;
        exit;
      end;
    result := False;
  end;

{ TPathfinding.Start_anpassen
  * Erwartete eine Positionsangabe als Parameter
  * �ndert die Startposition in die Parameter Position
  * Liefert True Zur�ck falls es geklappt hat
}
function TPathfinding.Start_anpassen(x, y: Integer): boolean;
  begin
    if((x >= 0) and (x < Karte.read_grosse_x)) then
      if((y >= 0) and (y < Karte.read_grosse_y)) then
      begin
        Start_x := x;
        Start_y := y;
        result := TRUE;
        exit;
      end;
    result := False;
  end;

end.
