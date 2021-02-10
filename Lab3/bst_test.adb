
   with Ada.Text_IO;                        use Ada.Text_IO;
   with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
   with Ada.Exceptions;                     use Ada.Exceptions;
   with Ada.Numerics.Discrete_Random;
   with Ada.Unchecked_Deallocation;

   with Binary_Search_Tree;

   procedure BST_Test is

      function Identity(Element : in Integer) return Integer is
         begin 
            return Element;
         end Identity;

      package BT is new Binary_Search_Tree(Integer, Integer, Identity, "=","<");    use BT;
      package Boolean_IO is new Ada.Text_IO.Enumeration_IO (enum => Boolean);

      A, B, C, D : aliased BST;
      m : Integer := 0;
      ns : array(1..8) of Integer := (11, 8, 10, 17, 3, 1, 4, 13);
      na : array(1..8) of Integer := (12, 9, 11, 16, 5, 18, 7, 14);

      procedure Process(I : in Integer; Cont : out Boolean) is
      begin 
         begin
            Cont := True;
            BT.Insert(1, D);
            Put_Line("Failed insert during traversal test.");
         exception
            when Error : State_Error =>
               Put("The exception was: ");
               Put_Line(Exception_Name(Error));
               Put("The exception message is: ");
               Put_Line(Exception_Message(Error));
               Put_Line("Insert during traversal test passed.");
         end;
         New_Line;
         begin
            BT.Remove(1, D, M);
            Put_Line("Failed remove during traversal test.");
         exception
            when Error : State_Error =>
               Put("The exception was: ");
               Put_Line(Exception_Name(Error));
               Put("The exception message is: ");
               Put_Line(Exception_Message(Error));
               Put_Line("Remove during traversal test passed.");
         end;
      end Process;

      procedure Tr is new Traverse(Process);

      procedure Put(I : in Integer; Cont : out Boolean) is
      begin 
         Put_Line(Integer'Image(I));
         Cont := True;
      end Put;

      procedure Write_List is new Traverse(Put);

   begin

      BT.Insert(Item => 1, Tree => D);
      Put_Line("Beginning traversal exception tests...");
      New_Line;
      Tr(D'access, In_Order);
      BT.Remove(1, D, m);
      New_Line;

      Put_Line("Creating empty trees...");
      Put_Line("Count(A) = " & Natural'Image(BT.Count(A)));
      Put_Line("Count(B) = " & Natural'Image(BT.Count(B)));
      Put_Line("Count(C) = " & Natural'Image(BT.Count(C)));
      New_Line;

      Put_Line("Checking empty status...");
      Put("Empty(A) = "); Boolean_IO.Put(BT.Empty(A)); New_Line;
      Put("Empty(B) = "); Boolean_IO.Put(BT.Empty(B)); New_Line;
      Put("Empty(C) = "); Boolean_IO.Put(BT.Empty(C)); New_Line;
      New_Line;

      Put_Line("Adding known values to D.");
      for I in 1..8 loop
         BT.Insert(ns(I), D);
      end loop;
      Put("Empty(D) = "); Boolean_IO.Put(BT.Empty(D)); New_Line;
      Put_Line("Contents of D (In_Order):");
      Write_List(D'access, In_Order);
      New_Line;
      Put_Line("Dumping contents of D (Pre_Order traversal)...");
      Write_List(D'access, Pre_Order);
      New_Line;
      Put_Line("Dumping contents of D (Post_Order traversal)...");
      Write_List(D'access, Post_Order);
      New_Line;
      Put_Line("Adding the value 20 to D.");
      BT.Insert(20, D);
      Put_Line("Count(D) = " & Natural'Image(BT.Count(D)));
      Put_Line("Contents of D (In_Order):");
      Write_List(D'access, In_Order);
      New_Line;
      Put_Line("Removing the value 20 from D.");
      BT.Remove(20, D, m);
      Put_Line("Item removed: " & Natural'Image(m));
      Put_Line("Count(D) = " & Natural'Image(BT.Count(D)));
      New_Line;
      Put_Line("Retriving 10 from D.");
      M := BT.Retrieve(10, D);
      Put_Line("Item retrieved: " & Natural'Image(m));
      New_Line;
      Put_Line("Removing all values from D.");
      for I in 1..8 loop
         BT.Remove(ns(I), D, m);
         Put_Line("Item removed: " & Natural'Image(m));
      end loop;
      New_Line;

      Put_Line("Filling more trees with known values...");
      for I in 1..8 loop
         BT.Insert(na(I), A);
         BT.Insert(ns(I), B);
         BT.Insert(na(I), C);
      end loop;
      New_Line;

      Put_Line("Dumping tree contents (In_Order traversal)...");
      Put_Line("Contents of A:");
      Write_List(A'access, In_Order);
      Put_Line("Contents of B:");
      Write_List(B'access, In_Order);
      Put_Line("Contents of C:");
      Write_List(C'access, In_Order);
      New_Line;

      Put_Line("Adding the value 30 to A.");
      BT.Insert(30, A);
      New_Line;

      Put_Line("Count(A) = " & Natural'Image(BT.Count(A)));
      Put_Line("Count(B) = " & Natural'Image(BT.Count(B)));
      Put_Line("Count(C) = " & Natural'Image(BT.Count(C)));
      New_Line;

      Put_Line("Clearing C.");
      Clear(C);
      New_Line;

      Put_Line("Beginning exception tests...");
      begin
         Put_Line("Inserting 30 into A (again).");
         BT.Insert(30, A);
         Put_Line("Insert test failed.");

         exception
            when Error : Key_Error =>
               Put("The exception was: ");
               Put_Line(Exception_Name(Error));
               Put("The exception message is: ");
               Put_Line(Exception_Message(Error));
               Put_Line("Insert test passed.");
      end;
      New_Line;

      begin
         Put_Line("Removing 30 from A.");
         BT.Remove(30, A, m);
         Put_Line("Removing 30 from A (again).");
         BT.Remove(30, A, m);
         Put_Line("Remove test failed.");

         exception
            when Error : Key_Error =>
               Put("The exception was: ");
               Put_Line(Exception_Name(Error));
               Put("The exception message is: ");
               Put_Line(Exception_Message(Error));
               Put_Line("Remove test passed.");
      end;
      New_Line;

      begin
         Put_Line("Retriving 30 from A.");
         M := BT.Retrieve(30, A);
         Put_Line("Retrieve test failed.");

         exception
            when Error : Key_Error =>
               Put("The exception was: ");
               Put_Line(Exception_Name(Error));
               Put("The exception message is: ");
               Put_Line(Exception_Message(Error));
               Put_Line("Retrieve test passed.");
      end;
      New_Line;

      New_Line;
      New_Line;
      Put_Line("All tests passed!");
      New_Line;
      New_Line;

      exception

         when Error : others =>

            Put_Line("Something is terribly wrong. There was an unanticipated exception: ");
            Put_Line(Exception_Name(Error));
            Put_Line(Exception_Message(Error));

    end BST_Test;
