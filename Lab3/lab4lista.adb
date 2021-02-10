with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Float_Random;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Float_Random;

procedure Lab4Lista is

  type Node is record
    Data : Integer     := 0;
    Next : access Node := null;
  end record;

  type Node_Pointer is access all Node;

  procedure Print (List : Node_Pointer) is
    Element : Node_Pointer := List;
  begin
    -- Null check for empty argument
    if List = null then
      Put_Line ("List is null");
    else
      Put_Line ("List content:");
    end if;
    -- Go through each node until the end of linked list
    while Element /= null loop
      Put_Line(Element.Data'Img);
      Element := Element.Next;
    end loop;
  end Print;

  -- ex. 1
  procedure Insert (List : in out Node_Pointer; Value : in Integer) is
    New_Node : Node_Pointer := new Node'(Value, List);
    C: Node_Pointer := List;
  begin
    -- If the list is not initialized, return new node
    if List = null then
      List := New_Node;
      return;
    end if;

    -- Traverse the linked list until we find an element with successor that  
    -- holds bigger value then the inserted one and keep its reference.
    while C.Next /= null loop
      exit when C.Next.Data > Value;
      C := C.Next;
    end loop;

    -- If the found element still has bigger value, that meant that successor
    -- was not found, and we won't insert the element after it, but before.
    if C.Data > Value then
      New_Node.Next := C;
      List := New_Node;
    -- Otherwise insert the node between the found element and its successor,
    -- the inserted node is at least of the same value as the previous one.
    else
      New_Node.Next := C.Next;
      C.Next := New_Node;
    end if;
  end Insert;


  -- ex. 2
  function Create_Random_List(Length: in Integer) return Node_Pointer is
      Gen: Generator;
      Value: Integer;
      List: Node_Pointer := null;
  begin
      for Idx in 1..Length loop
        -- Generate a random float between 0 and 1 and extend it between
        -- the 0 .. 100 range by multiplication.
        Value := Integer(Random(Gen) * 100.0);
        -- Create the list if it was empty, otherwise insert random element.
        if List = null then
          List := new Node'(Value, List);
        else
          Insert(List, Value);
        end if; 
      end loop;
      return List;
  end Create_Random_List;

  -- ex. 3
  function Find_Value (List : in out Node_Pointer; Value : in Integer) return Node_Pointer is
    Temp: Node_Pointer := null;
  begin
    -- Nothing to search through, terminate the function
    if List = null then
      return null;
    end if;

    -- Traverse the list until we meet the requested value, or until
    -- we go to the end. If the number is found, return early.
    Temp := List.Next;
    while Temp /= null loop
      if Temp.Data = Value then
        return Temp;
      end if;
      Temp := Temp.Next;
    end loop;

    -- We traversed the list and found nothing, so we end with null
    return null;
  end Find_Value;

  -- ex.4 
  procedure Delete_Element(List: in out Node_Pointer; Value: in Integer) is
      Current_Node: Node_Pointer := List;
      Parent_Node: Node_Pointer := null;
  begin
      -- If the first element is the deleted one, just move the head of the list by one
      if List.Data = Value then
          List := List.Next;
      else
          -- Traverse the list until desired element or the end of the list
          while Current_Node /= null loop
              -- Remove the found element, by reconnecting nodes
              if Current_Node.Data = Value then
                  Parent_Node.Next := Current_Node.Next;
                  exit;
              else
              -- If nothing is found in this iteration, we traverse further, by updating references
                  Parent_Node := Current_Node;
                  Current_Node := Current_Node.Next;
              end if;
          end loop;
      end if;
  end Delete_Element;


  --ex. 5
  procedure Remove_Duplicated_Elements(List: Node_Pointer) is
      Current_Node: Node_Pointer := List;
      Temp: Node_Pointer := null;
  begin
      -- Exactly the sane as last time, loop until the end of list
      while Current_Node /= null loop
          Temp := Current_Node;

          -- Loop until there is a duplicate
          while Temp /= null and then Temp.Data = Current_Node.Data loop
              Temp := Temp.Next;
          end loop;

          -- Update the references like in the previous exercise
          Current_Node.Next := Temp;
          Current_Node := Current_Node.next;
      end loop;
  end Remove_Duplicated_Elements;

  List : Node_Pointer := null;

begin
  Put_Line("Random list of length 5");
  Print(Create_Random_List(5));

  Put_Line("Example list - 2,3,5,8,10,10");
  Insert(List, 5);
  Insert(List, 2);
  Insert(List, 3);
  Insert(List, 10);
  Insert(List, 10);
  Insert(List, 8);
  Print(List);

  Put_Line("Find number 11, but it is not present");
  Print(Find_Value(List, 11));
  Put_Line("Find number 3, and print the list from its position");
  Print(Find_Value(List, 3));

  Put_Line("List without number 2 and duplicates");
  Delete_Element(List, 2);
  Remove_Duplicated_Elements(List);
  Print(List);
end Lab4Lista;
