-module(pola_list).
-import(pola, [pole/1]).
-export([zwroc/1]).

zwroc([H|T]) -> [one(H) | zwroc(T)];
zwroc([]) -> [].

one(H) -> pole(H).

