with Ada.Text_IO,Ada.Float_Text_IO, Ada.Calendar, pak3;
use Ada.Text_IO,Ada.Float_Text_IO, Ada.Calendar, pak3;

procedure lab3 is
Arr: pak3.Float_Array := (1..10 =>5.2);
T1, T2: Time;
D: Duration;
begin
	T1 := Clock;
	pak3.PrintArray(Arr);
  	pak3.FillRandom(Arr);
  	Put_Line(pak3.IsSorted(Arr)'Img);  
  	pak3.Sort(Arr);
  	pak3.PrintArray(Arr);
  	Put_Line(pak3.IsSorted(Arr)'Img);
	T2 := Clock;
	D := T2 - T1;
  	Put_Line("Czas wykonania programu = " & D'Img & "[s]");  
end lab3;


