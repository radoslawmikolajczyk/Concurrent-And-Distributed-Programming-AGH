generic
   type Element_Type is private;
   type Key_Type     is private;
   with function Key(Item : in Element_Type) return Key_Type;
   with function "="(Left, Right : in Key_Type) return Boolean is <>;
   with function "<"(Left, Right : in Key_Type) return Boolean is <>;

package Binary_Search_Tree is

   type BST is limited private;
   type Traversal is (In_Order, Pre_Order, Post_Order);

   Overflow     :  exception;  
   Key_Error    :  exception;  
   State_Error  :  exception;  

   procedure Insert(Item : in Element_Type; Tree : in out BST);

   procedure Remove(K : in Key_Type; Tree : in out BST; Item : out Element_Type);

   function Exists(K : in Key_Type; Tree : in BST) return Boolean;

   function Retrieve(K : in Key_Type; Tree : in BST) return Element_Type;

   function Empty(Tree : in BST) return Boolean;

   function Count(Tree : in BST) return Natural;

   procedure Clear(Tree : in out BST);

   generic
      with procedure Process(Item : in Element_Type; Continue : out boolean) ;
   procedure Traverse(Tree : access BST; Order : in Traversal) ;


private

   type Tree_Node;
   type Tree_Node_Ptr is access Tree_Node;

   type Child_Name is (Left, Right);
   type Children is array(Child_Name) of Tree_Node_Ptr;

   type Tree_Node is
      record
         Data  : Element_Type;
         Child : Children := (others => null);
      end record;

   type BST is
      record
         Root       : Tree_Node_Ptr := null;
         Count      : Natural       := 0;
         Traversing : Boolean       := False;
      end record ;

end Binary_Search_Tree;
