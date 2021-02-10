with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;
with Ada.Exceptions;
use Ada.Exceptions;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Calendar;
use Ada.Calendar;

procedure A is
    G       : Generator;
    Address : Sock_Addr_Type;
    Socket  : Socket_Type;
    Channel : Stream_Access;

    Rand    : Float;
    N       : Integer := 17;
    Diff    : Integer := 20 - N;
    type Float_Array is array (Integer range <>) of Float;
    Tab     : Float_Array := (1..20 => 0.0);
    Result  : Float_Array := (1..N => 0.0);

    Start_Time : Time := Clock;
    Finis_Time : Time;
    Result_Time : Duration;

begin
    Reset(G);
    Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
    Address.Port := 5876;
    Put_Line("Host: "&Host_Name);
    Put_Line("Adres:port => ("&Image(Address)&")");
    Create_Socket (Socket);
    Set_Socket_Option (Socket, Socket_Level, (Reuse_Address, True));
    Connect_Socket (Socket, Address);
    for I in 1..N+1 loop
      Channel := Stream (Socket);
      Put_Line("A: -> wysy³am dane ...");
      Rand := Random(G);
      if I = N+1 then
         Rand := 0.0;
         Float'Output (Channel, Rand );
         exit;
      end if;
      Float'Output (Channel, Rand );
      Put_Line ("A: <-" & String'Input (Channel));
   end loop;
   Tab := Float_Array'Input (Channel);
   for I in 1..N loop
         Result(I) := Tab(I+Diff);
   end loop;
   Put_Line ("Posortowane:");
   for I in Result'First .. Result'Last loop
	    Put_Line ("Result("& I'Img & ") = " & Result (I)'Img);
	end loop;
   Finis_Time := Clock;
   Result_Time := Finis_Time - Start_Time;
   Put_Line("Proces A zakonczy³ sie po:"&Result_Time'Img);
  exception
    when E:others =>
      Close_Socket (Socket);
      Put_Line("Error: Zadanie A");
      Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
   null;
end A;
