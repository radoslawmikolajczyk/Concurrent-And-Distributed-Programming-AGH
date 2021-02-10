with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Elementary_Functions, Ada.Numerics.Discrete_Random;
use Ada.Text_IO, Ada.Numerics.Elementary_Functions;

procedure Lab6 is

   -- Zadanie 1

   type Punkt is record
      x: Float;
      y: Float;
   end record;

   type PunktPtr is access all Punkt;

   task type ReceiverTask(N: Integer := 1) is
      entry AcceptPoint(Point: PunktPtr);
      entry Stop;
   end ReceiverTask;

   type ReceiverTaskPtr is access ReceiverTask;

   type PunktArray is array (Integer range<>) of PunktPtr;

   task type GeneratorTask(receiver: ReceiverTaskPtr; N: Integer );

   type GeneratorTaskPtr is access GeneratorTask;

   task body GeneratorTask is
      Gen: Ada.Numerics.Float_Random.Generator;
      Point: PunktPtr;
   begin
      Ada.Numerics.Float_Random.Reset(Gen);
      for I in 1..N loop
         Point := new Punkt;
         Point.x := Ada.Numerics.Float_Random.Random(Gen)*10.0;
         Point.y := Ada.Numerics.Float_Random.Random(Gen)*10.0;
         receiver.AcceptPoint(Point);
      end loop;
      receiver.Stop;
   end GeneratorTask;

   task body ReceiverTask is
      Points: PunktArray(1..N);
      CurrentIndex: Integer := 1;
      distanceFrom00 : Float;
      distanceFromPrevious: Float;
      xDiff: Float;
      yDiff: Float;
   begin
      loop
         select
            accept AcceptPoint (Point : PunktPtr) do
               Points(CurrentIndex) := Point;
               Put_Line("Point(" & Point.x'Image & ", " & Point.y'Image & ")");
               distanceFrom00 := Sqrt(Point.x*Point.x + Point.y*Point.y);
               Put_Line("Distance from (0, 0): " & distanceFrom00'Image);
               if(CurrentIndex > 1) then
                  xDiff := Points(CurrentIndex).x-Points(CurrentIndex-1).x;
                  yDiff := Points(CurrentIndex).y-Points(CurrentIndex-1).y;
                  distanceFromPrevious := Sqrt(xDiff*xDiff + yDiff*yDiff);
                  Put_Line("Distance from previous point: " & distanceFromPrevious'Image);
               end if;
               Put_Line("");
               CurrentIndex := CurrentIndex + 1;
            end AcceptPoint;
         or
            accept Stop;
            exit;
         end select;
      end loop;
   end;

   -- Zadanie 2
   task Task1 is
      entry returnNumer05(a: in out Float);
      entry Stop;
   end Task1;

   task body Task1  is
      Gen: Ada.Numerics.Float_Random.Generator;
   begin
      Ada.Numerics.Float_Random.Reset(Gen);
      loop
         select
            accept returnNumer05 (a : in out Float) do
               a := Ada.Numerics.Float_Random.Random(Gen)*5.0;
            end returnNumer05;
         or
            accept Stop; exit;
         end select;
      end loop;
   end;

   type Color is (Red, Green, Blue, Yellow, Gold, Silver, Black, White );
   type DayOfWeek is (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);

   type IntegerArray is array(Integer range<>) of Integer;

   task Task2 is
      entry returnNumer05(a: in out Float);
      entry returnColor(colorVar: in out Color);
      entry returnDay(dayVar: in out DayOfWeek);
      entry return6Numbers149(intArray: in out IntegerArray);
      entry Stop;
   end Task2;

   task body Task2 is
      package Rand_Int is new ada.numerics.discrete_random(Integer);
      Gen1: Ada.Numerics.Float_Random.Generator;
      Gen2: Rand_Int.Generator;
   begin
      Ada.Numerics.Float_Random.Reset(Gen1);
      Rand_Int.Reset(Gen2);
      loop
         select
            accept returnNumer05 (a : in out Float) do
               a := Ada.Numerics.Float_Random.Random(Gen1)*5.0;
            end returnNumer05;
         or
            accept returnColor (colorVar : in out Color) do
               colorVar := Color'Val(Rand_Int.Random(Gen2) mod 8);
            end returnColor;
         or
            accept returnDay (dayVar : in out DayOfWeek) do
               dayVar := DayOfWeek'Val(Rand_Int.Random(Gen2) mod 7);
            end returnDay;
         or
            accept return6Numbers149 (intArray : in out IntegerArray) do
               for i in 1..6 loop
                  intArray(i) := (Rand_Int.Random(Gen2) mod 49) + 1;
               end loop;
            end return6Numbers149;
         or
              accept Stop; exit;
         end select;
      end loop;
   end Task2;

   -- Zadanie 3 (Zegar zliczajacy czas)

   task MyClock is
      entry Zeruj;
      entry Zegar(a: in out Integer);
      entry Stop;
   end MyClock;

   task body MyClock is
      time: Integer := -1;
   begin
      loop
         time := time + 1;
         select
            accept Zeruj do
              time := -1;
            end Zeruj;
         or
            accept Zegar(a: in out Integer)  do
               a := time;
         end Zegar;
         or
            accept Stop; exit;
         or
              delay 1.0;
         end select;
      end loop;
   end MyClock;


   N: Integer := 10;
   recTask: ReceiverTaskPtr;
   genTask: GeneratorTaskPtr;

   number1: Float := 1.0;

   number2: Float := 1.0;
   colorVar: Color := Red;
   day: DayOfWeek := Monday;
   numbers: IntegerArray(1..6);

   time: Integer := 0;

begin
   recTask := new ReceiverTask(N);
   genTask := new GeneratorTask(recTask, N);
   delay 1.0;
   Put_Line("Task 1 TEST:");
   Task1.returnNumer05(number1);
   Put_Line(number1'Image);
   Task1.Stop;
   Put_Line("Task 2 TEST:");
   Task2.returnNumer05(number2);
   Put_Line(number2'Image);
   Task2.returnColor(colorVar);
   Put_Line(colorVar'Image);
   Task2.returnDay(day);
   Put_Line(day'Image);
   Task2.return6Numbers149(numbers);
   for i in 1..6 loop
      Put_Line(numbers(i)'Image);
   end loop;
   Task2.Stop;
   Put_Line("TEST Zegara");
   MyClock.Zeruj;
   MyClock.Zegar(time);
   Put_Line("Aktualny czas to: " & time'Image);
   delay 6.0;
   MyClock.Zegar(time);
   Put_Line("Aktualny czas to: " & time'Image);
   MyClock.Zeruj;
   delay 10.0;
   MyClock.Zegar(time);
   Put_Line("Aktualny czas to: " & time'Image);
   MyClock.Stop;
end Lab6;
