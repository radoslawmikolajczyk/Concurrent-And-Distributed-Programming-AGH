with Ada.Text_IO;
use Ada.Text_IO;

procedure Ekran2 is

protected Ekran is
  procedure Pisz(S: String);
end Ekran;

protected body Ekran is
  procedure Pisz(S: String) is
  begin
    Put_Line("# Wypisany tekst:");
    Put_Line("$ " & S);
  end Pisz;
end Ekran;
  
task type Zadanie(N: Integer := 1); 
type Wsk_Zadanie is access Zadanie;

task body Zadanie is
begin
  Ekran.Pisz("Jestem w zadaniu " & N'Img);
end Zadanie;

Z1 : Zadanie(1);
Z2 : Zadanie(2);
Z3 : Zadanie(3);
WZX : Wsk_Zadanie;

begin
  WZX := new Zadanie(4);
  Ekran.Pisz("PROCEDURA GŁÓWNA");
end Ekran2;  
