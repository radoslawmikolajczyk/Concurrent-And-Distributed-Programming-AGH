with Ada.Text_IO, Ada.Numerics.Float_Random;
use Ada.Text_IO, Ada.Numerics.Float_Random;

package body pak3 is
	procedure PrintArray(A: Float_Array) is
	begin
		for I in A'First .. A'Last loop
			Put_Line("Tab("& I'Img & ") = " & A (I)'Img);
		end loop;
	end PrintArray;

	procedure FillRandom(A: out Float_Array) is
	Generator: Ada.Numerics.Float_Random.Generator;
	begin
		for I in A'First .. A'Last loop
			A(I):= Random(Generator);
			Put_Line("Tab("& I'Img & ") = " & A (I)'Img);
		end loop;
	end FillRandom;

	function IsSorted (A : Float_Array) return Boolean is
        begin
        	return (for all I in A'First .. (A'Last - 1) => A (I + 1) >= A (I));
        end IsSorted;

	procedure Sort(A: in out Float_Array) is
	Tmp: Float;
	begin
	for I in A'First .. A'Last loop
		for J in A'First .. A'Last loop
			if A (I) < A (J) then
                		Tmp := A (I);
				A (I) := A (J);
				A (J) := Tmp;
                	end if;
		end loop;
	end loop;
	end Sort;

end pak3;
