with Text_IO;
use Text_IO;
 
with Ada.Numerics.Generic_Elementary_Functions;
 
procedure Sito is
j,dokad: Integer;
zakres   : Integer := 100;
tablica  : array (1..zakres) of Integer;
package Math is new Ada.Numerics.Generic_Elementary_Functions(Float);   
begin
 
dokad := Integer(Math.sqrt(Float(zakres)));
 
-- inicjuj tablice
for i in 1..zakres loop
tablica(i) := i;
end loop;  
 
-- algorytm - sito eratostenesa
for i in 2..dokad loop
if tablica(i) /= 0 then
j:= i + i;
while j <= zakres loop
tablica(j) := 0;
j := j + i;
end loop;
end if;
end loop;
 
-- wypisz wynik
Put_Line("Liczby pierwsze z zakresu od 1 do " & Integer'Image(zakres));
for i in 2 .. zakres loop
if tablica(i) /=0 then
Put(Integer'Image(i) & ", ");
end if;
end loop;
 
end;
