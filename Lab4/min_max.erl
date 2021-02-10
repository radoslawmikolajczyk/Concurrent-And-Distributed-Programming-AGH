-module(min_max).
-export([amin/1, amax/1, tmin_max/1, lmin_max/1]).

amin([]) -> io:format("Lista pusta~n");
amin([H|T]) ->
    min1(H, T).

min1(M, [H|T]) when M < H ->
    min1(M, T);
min1(M, [H|T]) when M >= H ->
    min1(H, T);
min1(M, []) -> M.



amax([]) -> io:format("Lista pusta~n");
amax([H|T]) ->
    max1(H, T).

max1(M, [H|T]) when M >= H ->
    max1(M, T);
max1(M, [H|T]) when M < H ->
    max1(H, [H|T]);
max1(M, []) -> M.


tmin_max([]) -> io:format("Lista pusta~n");
tmin_max([H|T]) -> {amin([H|T]), amax([H|T])}.


lmin_max([]) -> io:format("Lista pusta~n");
lmin_max([H|T]) -> {amax([H|T]), amin([H|T])}.
