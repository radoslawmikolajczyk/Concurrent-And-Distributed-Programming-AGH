with Ada.Text_IO;
use Ada.Text_IO;

procedure wyjatki is
	Input : File_Type;
	name: String(1..100) := (others => ' ');	
	length : Integer := 0;
	line : Character;
	begin
  		loop
		Put_Line("Podaj nazwe pliku do otwarcia: ");
		Get_Line(name, length);
    			begin  	
	  		Open(Input, In_File, name(1..length));
	  		exit;
			exception
	  		when Name_Error => Put_Line("Bledna nazwa pliku <" & name(1..length) & "> !");
			end;  
  		end loop;
  
	Put_Line("Otwieram plik: " & name(1..length));
	while not End_Of_File (Input) loop
		Get(File => Input, Item => line);
		Put(Item => line);
	end loop;
	New_Line;
  	Put_Line("Zamykam plik");
  	Close(Input);
end wyjatki;
