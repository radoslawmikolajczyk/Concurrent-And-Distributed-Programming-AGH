-module(binaryTree).
-compile([export_all]).
-import(rand,[uniform/1]).

empty() -> {node, 'nil'}.
get_key({K, _}) -> K.
get_value({_, V}) -> V.


% wstawianie elementu do drzewa
insert(K, V, {node, 'nil'}) -> {node, {K, V, empty(), empty()}};
insert(K, V, {node, {Key, Value, Smaller, Larger}}) when K < Key -> {node, {Key, Value, insert(K, V, Smaller), Larger}};
insert(K, V, {node, {Key, Value, Smaller, Larger}}) when K >= Key -> {node, {Key, Value, Smaller, insert(K, V, Larger)}}.


%generacja losowego drzewa + funkcje pomocnicze
find_key(Key, Tree) ->
	try find_key_helper(Key, Tree) of
		false -> false
	catch
		true -> true
	end.
	
find_key_helper(_, {node, 'nil'}) -> false;
find_key_helper(Key, {node, {Key, _, _, _}}) -> throw(true);
find_key_helper(Key, {node, {_, _, Left, Right}})->
	find_key_helper(Key, Left),
	find_key_helper(Key, Right).

gen_unique_key(Tree, Range) ->
	X = uniform(Range),
	case find_key(X, Tree) of
		true ->
			gen_unique_key(Tree, Range);
		false -> X
	end.

random(N, Range) ->
	K = uniform(Range), 					
	V = uniform(Range + 50),				
	Tree = insert(K, V, empty()),  			
	random_helper(N - 1, Range, Tree). 

random_helper(0, _, Tree) -> Tree;
random_helper(N, Range, Tree) ->		
	K = gen_unique_key(Tree, Range),		
	V = uniform(Range + 50),				
	New = insert(K, V, Tree),					
	random_helper(N - 1, Range, New).	

%generacja drzewa z listy
list_to_tree([H | T], {node, 'nil'}) ->
	Base = insert(get_key(H), get_value(H), empty()),	
	list_to_tree(T, Base);							

list_to_tree([H | T], Tree) ->
	New = insert(get_key(H), get_value(H), Tree),
	list_to_tree(T, New);

list_to_tree([], Tree) -> Tree.

%zwinięcie drzewa do listy
tree_to_list({node, 'nil'}) -> [];
tree_to_list({node, {K, V, Left, Right}}) -> tree_to_list(Left) ++ [{K,V}] ++ tree_to_list(Right). 


% szukanie elementu w drzewie
find(Key, Tree) ->
	try find1(Key, Tree) of
		false -> false 
	catch
		Val -> Val 
	end.
	
find1(_, {node, 'nil'}) -> false; 
find1(Key, {node, {Key, Val, _, _}}) -> throw(Val); 
find1(Key, {node, {_, _, Left, Right}})->
	find1(Key, Left),
	find1(Key, Right).







