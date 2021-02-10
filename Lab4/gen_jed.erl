-module(gen_jed).
-export([gen/1]).

gen(N) when N > 0 -> [1 | gen(N-1)];
gen(_) -> [].
