with Ada.Exceptions ;
with Ada.Unchecked_Deallocation ;

package body Binary_Search_Tree is

   procedure Free is new Ada.Unchecked_Deallocation(Tree_Node, Tree_Node_Ptr) ;

   procedure Insert(Item : in Element_Type; Tree : in out BST) is

      New_item : Tree_Node_Ptr := null;
      Parent   : Tree_Node_Ptr := null;
      Target   : Tree_Node_Ptr := Tree.Root;

   begin 

      if Tree.Traversing then
         Ada.Exceptions.Raise_Exception (State_Error'identity,
                         "Error using Insert.  Tree is already in a traversal.");
      end if;

      while Target /= null loop
         Parent := Target;
         if Key(Item) = Key(Target.Data) then
            Ada.Exceptions.Raise_Exception (Key_Error'identity,
                            "Error using Insert.  Key already exists.");
         elsif Key(Item) < Key(Target.Data) then
            Target := Target.Child(Left);
         else
            Target := Target.Child(Right);
         end if;
      end loop;

      begin
         New_Item := new Tree_Node'(Item, (others => null));
      exception
         when Storage_Error =>
            Ada.Exceptions.Raise_Exception (Overflow'identity,
                         "Error using Insert.  Not eneough free memory.");
      end;

      if Parent = null then
         Tree.Root := New_Item;
      elsif Key(Item) < Key(Parent.Data) then
         Parent.Child(Left) := New_Item;
      else
         Parent.Child(Right) := New_Item;
      end if;
      Tree.Count := Natural'Succ(Tree.Count);
   end Insert;

   procedure Remove(K : in Key_Type; Tree : in out BST; Item : out Element_Type) is

      Original : Tree_Node_Ptr := null;
      Parent   : Tree_Node_Ptr := null;
      Target   : Tree_Node_Ptr := Tree.Root;
      Name     : Child_Name;

   begin 
      if Tree.Traversing then
         Ada.Exceptions.Raise_Exception (State_Error'identity,
                         "Error using Remove.  Tree is already in a traversal.");
      else 
         while Target /= null loop
            exit when K = Key(Target.Data);
            Parent := Target;
            if K < Key(Target.Data) then
               Name := Left;
            else
               Name := Right;
            end if;
            Target := Parent.Child(Name);
         end loop;

         if Target = null then
            Ada.Exceptions.Raise_Exception (Key_Error'identity,
                            "Error using Remove.  Key not found.");
         end if;

         Item := Target.Data;

         if Target.Child(Right) = null then
            if Target = Tree.Root then
               Tree.Root := Target.Child(Left);
            else
               Parent.Child(Name) := Target.Child(Left);
            end if;
         elsif Target.Child(Left) = null then
            if Target = Tree.Root then
               Tree.Root := Target.Child(Right);
            else
               Parent.Child(Name) := Target.Child(Right);
            end if;
         else
            Original := Target;
            Parent   := Target;
            Name     := Right;
            Target   := Target.Child(Name);
            while Target.Child(Left) /= null loop
               Parent := Target;
               Name := Left;
               Target := Target.Child(Name);
            end loop;
            Original.Data := Target.Data;
            Parent.Child(Name) := Target.Child(Right);
         end if;
         Tree.Count := Natural'Pred(Tree.Count);
         Free(Target);
      end if;
   end Remove;

   function Exists(K : in Key_Type; Tree : in BST) return Boolean is

      Ptr : Tree_Node_Ptr := Tree.Root;

   begin 
      while Ptr /= null loop
         if K = Key(Ptr.Data) then
            return True;
         elsif K < Key (Ptr.Data) then
            Ptr := Ptr.Child(Left);
         else
            Ptr := Ptr.Child(Right);
         end if;
      end loop;
      return False;
   end Exists;

   function Retrieve(K : in Key_Type; Tree : in BST) return Element_Type is

      Ptr : Tree_Node_Ptr := Tree.Root;

   begin 
      if Tree.Traversing then
         Ada.Exceptions.Raise_Exception (State_Error'identity,
                         "Error using Retrieve.  Tree is already in a traversal.");
      elsif not Exists(K, Tree) then
         Ada.Exceptions.Raise_Exception (Key_Error'identity,
                         "Error using Retrieve.  Key not found.");
      else
         while Ptr /= null loop
            exit when K = Key(Ptr.Data);
            if K < Key (Ptr.Data) then
               Ptr := Ptr.Child(Left);
            else
               Ptr := Ptr.Child(Right);
            end if;
         end loop;
         return Ptr.Data;
      end if;
   end Retrieve;

   function Empty(Tree : in BST) return Boolean is

   begin
      return Tree.Count = 0;
   end Empty;

   function Count(Tree : in BST) return Natural is

   begin  
      return Tree.Count;
   end Count;

   procedure Clear(Tree : in out BST) is
         procedure PostClear( P : in out Tree_Node_Ptr) is
         begin 
            if P /= null then
               PostClear(P.Child(Left));
               PostClear(P.Child(Right));
               Free(P);
            end if;
         end PostClear;
   begin 
      if Tree.Count > 0 then
         if Tree.Traversing then
            Ada.Exceptions.Raise_Exception (State_Error'identity,
                            "Error using Clear.  Tree is already in a traversal.");
         else
            Postclear(Tree.Root);
            Tree.Count := 0;
         end if;
      end if;
   end Clear;

   procedure Traverse(Tree : access BST; Order : in Traversal) is

      Continue : Boolean := True;

      procedure Inorder( P : in Tree_Node_Ptr) is
      begin -- Inorder
         if P /= null then
            Inorder(P.Child(Left));
            if Continue then
               Process(P.Data, Continue);
            end if;
            Inorder(P.Child(Right));
         end if;
      end Inorder;

      procedure Preorder( P : in Tree_Node_Ptr) is
      begin -- Preorder
         if P /= null then
            if Continue then
               Process(P.Data, Continue);
            end if;
            Preorder(P.Child(Left));
            Preorder(P.Child(Right));
         end if;
      end Preorder;

      procedure Postorder( P : in Tree_Node_Ptr) is
      begin -- Postorder
         if P /= null then
            Postorder(P.Child(Left));
            Postorder(P.Child(Right));
            if Continue then
               Process(P.Data, Continue);
            end if;
         end if;
      end Postorder;


   begin -- Traverse
      if Tree.Count > 0 then
          if Tree.Traversing then
            Ada.Exceptions.Raise_Exception (State_Error'identity,
                            "Error using Traverse.  Tree is already in a traversal.");
          else
             begin
                Tree.Traversing := True;
                case Order is
                   when In_Order => Inorder(Tree.Root);

                   when Pre_Order => Preorder(Tree.Root);

                   when Post_Order => Postorder(Tree.Root);
                end case;
                Tree.Traversing := False;
             exception
                when State_Error =>
                   Tree.Traversing := False;
                   raise State_Error;
             end;
          end if;
      end if;
   end Traverse;
end Binary_Search_Tree;
