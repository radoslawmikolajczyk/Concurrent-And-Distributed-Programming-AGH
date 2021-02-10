-module(zad3).
-export([generator/0,dataProcessor/1,receiveBufor/0,start/0]).

computations(0) -> 0;
computations(Num) ->
  math:log(Num).

generator() ->
  receive
    {generate,Destination} ->
        Destination ! {data,rand:uniform(100)},
        generator();
    _ ->
      generator()
  end.

dataProcessor(ReceiveBufor) ->
  receive
    {data,Num} ->
      N = computations(Num),
      ReceiveBufor ! {computed,Num,N},
      dataProcessor(ReceiveBufor);
    _ ->
      dataProcessor(ReceiveBufor)
  end.

receiveBufor() ->
  receive
    {computed,StartValue,EndValue} ->
      io:format("Value ~p = e^~f~n",[StartValue, EndValue]),
      receiveBufor();
    _ ->
      receiveBufor()
  end.

start() ->
  PID1 = erlang:spawn(zad3, generator, []),
  PID3 = erlang:spawn(zad3,receiveBufor,[]),
  L = [erlang:spawn(zad3, dataProcessor, [PID3]),
    erlang:spawn(zad3, dataProcessor, [PID3])],
  lists:foreach(fun(X) -> PID1 ! {generate,X} end,L),
  lists:foreach(fun(X) -> PID1 ! {generate,X} end,L),
  lists:foreach(fun(X) -> PID1 ! {generate,X} end,L).
