with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Exceptions;
use Ada.Exceptions;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Calendar; use Ada.Calendar;

procedure B is
    Address  : Sock_Addr_Type;
    Server   : Socket_Type;
    Socket   : Socket_Type;
    Channel  : Stream_Access;
    Dane     : Float := 0.0;

    type Float_Array is array (Integer range <>) of Float;
    Tab      : Float_Array := (1..20 => 0.0);
    Index    : Integer := 1;

    procedure Sort (T : in out Float_Array) is
      First : Natural := T'First;
      Last : Natural := T'Last;
      Elem : Float;
      J : Integer;
    begin
      for I in (First + 1) .. Last loop
         Elem := T(I);
         J := I - 1;
         while J in T'range and then T(J) > Elem loop
		     T(J + 1) := T(J);
		     J := J - 1;
	     end loop;
	     T(J+1) := Elem;
      end loop;
    end Sort; 

    Start_Time : Time := Clock;
    Finis_Time : Time;
    Result_Time : Duration;
begin
    Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
    Address.Port := 5876;
    Put_Line("Host: "&Host_Name);
    Put_Line("Adres:port = ("&Image(Address)&")");
    Create_Socket (Server);
    Set_Socket_Option (Server, Socket_Level, (Reuse_Address, True));
    Bind_Socket (Server, Address);
    Listen_Socket (Server);
    Put_Line ( "B: czekam na A ....");
    Accept_Socket (Server, Socket, Address);
    Channel := Stream (Socket);
    -- Odbieranie danych od A
    loop
      Dane := Float'Input (Channel);
      if Dane = 0.0 then
         Sort(Tab);
         Float_Array'Output (Channel, Tab);
         exit;
      end if;
      Tab(Index) := Dane;
      Put_Line ("B: -> dane =" & Dane'Img);
      String'Output (Channel, "OK: " & Dane'Img);
      Index := Index + 1;
   end loop; 
   Finis_Time := Clock;
   Result_Time := Finis_Time - Start_Time;
   Put_Line("Proces B zakonczy³ sie po:"&Result_Time'Img);
exception
    when E:others => Put_Line("Error: Zadanie B");
      Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
end B;
