-module(babelkowe).
-export([sort/1]).

sort(L) when length(L) =< 1 -> L;
sort(L) ->
    SL = sort2(L),
    sort(lists:sublist(SL,1,length(SL)-1)) ++ [lists:last(SL)].

sort2([]) -> [];
sort2([F]) -> [F];
sort2([F,G|T]) when F > G -> [G|sort2([F|T])];
sort2([F,G|T]) -> [F|sort2([G|T])].

