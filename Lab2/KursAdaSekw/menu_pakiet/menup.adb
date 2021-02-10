-- menup.adb

with Ada.Text_IO, Ada.Calendar, Opcje, Ada.Calendar.Formatting, Ada.Calendar.Time_Zones;
use Ada.Text_IO, Ada.Calendar, Opcje, Ada.Calendar.Formatting, Ada.Calendar.Time_Zones;

procedure MenuP is
  FileName: String := "dziennik.txt";
  File: File_Type;
  Now : Time := Clock;
  Zn: Character := ' '; 
  
  procedure Pisz_Menu is
  begin
	New_Line;  
	Put_Line("Menu:");  
    Put_Line(" s - opcja s");
	Put_Line(" c - opcja c");
	Put_Line(" p - opcja p");
	Put_Line("ESC -Wyjscie");
	Put_Line("Wybierz (s,c,p, ESC-koniec):");
  end Pisz_Menu;
  
begin
  Create(File, Out_File, FileName);
  Put_Line(File, ("START PROGRAMU   " & Image(Date => Now, Time_Zone => 2*60)));  
  loop
    Pisz_Menu;
	Get_Immediate(Zn);
	Now := Clock;
	exit when Zn = ASCII.ESC;
	case Zn is
	  when 's' => Opcja_S; Put_Line(File, ("OPCJA S   " & Image(Date => Now, Time_Zone => 2*60)));
	  when 'c' => Opcja_C; Put_Line(File, ("OPCJA C   " & Image(Date => Now, Time_Zone => 2*60)));
	  when 'p' => Opcja_P; Put_Line(File, ("OPCJA P   " & Image(Date => Now, Time_Zone => 2*60)));
      when others => Put_Line("Blad!!"); Put_Line(File, ("Blad!!   " & Image(Date => Now, Time_Zone => 2*60)));
	end case;
  end loop;
  Put_Line("Koniec");
  Now := Clock;
  Put_Line(File, ("KONIEC PROGRAMU   " & Image(Date => Now, Time_Zone => 2*60)));
  Close(File);
end MenuP;
  	 
  
