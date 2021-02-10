-module(len_list).
-export([len/1]).

len([]) -> 0;
len([_]) -> 1;
len([_|T]) -> 1 + len(T).
