package pak3 is

type Float_Array is array (Integer range <>) of Float;
procedure PrintArray(A: Float_Array);
procedure FillRandom(A: out Float_Array);
function IsSorted(A: Float_Array) return boolean;
procedure Sort(A: in out Float_Array);

end pak3;


