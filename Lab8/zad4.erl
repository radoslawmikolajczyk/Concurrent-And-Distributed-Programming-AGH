-module(zad4).
-export([start/0,sort/1,subsort/2]).

sort(Mother) ->
  receive
    {sort,List} ->
      io:format("~p~n",[List]),
      SORT = spawn(zad4,subsort,[[],self()]),
      SORT ! {sort,List},
      sort(Mother);
    {sorted,List} ->
      io:format("~p~n",[List])
  end.

subsort(List1,Mother) ->
  receive
    {sort,List} ->
      if
        length(List) < 2 ->
          Mother ! {sorted, List};
        true ->
          SUBSORT1 = spawn(zad4,subsort,[[],self()]),
          SUBSORT2 = spawn(zad4,subsort,[[],self()]),

          {SubList1,SubList2} = lists:split(length(List) div 2,List),
          SUBSORT1 ! {sort,SubList1},
          SUBSORT2 ! {sort,SubList2},
          subsort(List1,Mother)
      end;

    {sorted,List} ->
      if
        length(List1) > 0 ->
          Mother ! {sorted,lists:merge(List1,List)};
        true ->
          subsort(List,Mother)
      end

  end.

start() ->
  L = [200,1999,-1,2,0,3,55,50,16,201,5,6,6],
  PID0 = spawn(zad4,sort,[self()]),
  PID0 ! {sort, L}.
