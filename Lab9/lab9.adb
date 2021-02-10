with Ada;
use Ada;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with Ada.Streams.Stream_IO;
use Ada.Streams.Stream_IO;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;


procedure Lab9 is
 type My_Array is array (Integer range <>, Integer range <>) of Float;

 Plik         : Stream_IO.File_Type;
 Nazwa        : String := "macierz.txt";
 Strumien     : Stream_Access;
 G            : Generator;

 procedure Wypisz (Tab : in My_Array);
 procedure Read (S : access Root_Stream_Type'Class; NTab : out My_Array);
 procedure Write (S : access Root_Stream_Type'Class; NTab : in My_Array);
 for My_Array'Read use Read;
 for My_Array'Write use Write;

 Row          : Integer := 4;
 Col          : Integer := 3;
 Macierz      : My_Array(1..Row, 1..Col);
 Macierz2     : My_Array(1..Row, 1..Col);

 procedure Wypisz (Tab : in My_Array) is
  R : Integer := Tab'Length(1);
  C : Integer := Tab'Length(2);
 begin
  Put("[");
  for I in 1..R loop
      Put("[");
      for J in 1..C-1 loop
            Put(Float'Image(Tab(I,J)) & ", ");
      end loop;
      Put(Float'Image(Tab(I,C)) & "]");
      if I /= R then
            New_Line;
      end if;
  end loop;
  Put("]");
  New_Line;
  New_Line;
 end Wypisz;

 procedure Read (S : access Root_Stream_Type'Class; NTab : out My_Array) is
 begin
    for I in 1..NTab'Length(1) loop
         for J in 1..NTab'Length(2) loop
            Float'Read(S, NTab(I,J));
         end loop;
    end loop;
  end Read;

  procedure Write (S : access Root_Stream_Type'Class; NTab : in My_Array) is
  begin
    for I in 1..NTab'Length(1) loop
         for J in 1..NTab'Length(2) loop
            Float'Write(S, NTab(I,J));
         end loop;
    end loop;
  end Write;

begin
 for I in 1..Row loop
      for J in 1..Col loop
            Reset(G);
            Macierz(I,J) := Random(G);
      end loop;
 end loop;

 Put_Line("* Zapis do pliku -> "&Nazwa);
 Create(Plik, Out_File, Nazwa);
 Strumien := Stream(Plik);
 Put_Line("* Zapisuje tablice:");
 Wypisz(Macierz);
 My_Array'Write(Strumien, Macierz);
 Close(Plik);

 Put_Line("* Odczyt z pliku <- "&Nazwa);
 Open(Plik, In_File, Nazwa);
 Strumien := Stream(Plik);
 My_Array'Read(Strumien, Macierz2);
 Put_Line("* Odczytano tablice:");
 Wypisz(Macierz2);
 Close(Plik);
 Put_Line("* Koniec");
end Lab9;
