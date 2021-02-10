-module(konwert).
-export([temp_conv/2]).

c2f(C) -> {f, (C *9/5) + 32}.
f2c(F) -> {c, (F - 32) * 5/9}.

c2k(C) -> {k, 273.15 + C}.
k2c(K) -> {c, K - 273.15}.

k2f(K) -> {f, (K-273.15)*1.8+32.0}.
f2k(F) -> {k, ((F-32)/1.8) +273.15}.

c2r(C) -> {r, (C+273.15)*1.8}.
r2c(R) -> {c, (R/1.8) - 273.15}.

temp_conv({Skala, Wartosc}, Skala_docelowa) ->
	case {Skala, Skala_docelowa} of
		{c, f} -> c2f(Wartosc);
		{f, c} -> f2c(Wartosc);
		{c, k} -> c2k(Wartosc);
		{k, c} -> k2c(Wartosc);
		{k, f} -> k2f(Wartosc);
		{f, k} -> f2k(Wartosc);
		{c, r} -> c2r(Wartosc);
		{r, c} -> r2c(Wartosc);

		{_, _}    -> io:format("BLAD~n")
	end.
