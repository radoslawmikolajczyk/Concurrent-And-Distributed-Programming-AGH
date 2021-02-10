-module(lista_malejaca).
-export([ret_list/1]).

ret_list(H) when H > 0 -> [H | ret_list(H-1)];
ret_list(_) -> [].





