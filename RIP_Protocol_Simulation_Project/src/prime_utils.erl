-module(prime_utils).

-export([compute_nth_prime/1]).


compute_nth_prime(N) when N =:= 0 ->
    arg_invalid;

compute_nth_prime(N) when not is_integer(N) ->
    arg_invalid;

compute_nth_prime(N) ->
    PrimeList = list_primes(N, 0, []),
    lists:last(PrimeList).


list_primes(N, Index, List) when N == Index ->
    List;

list_primes(N, Index, List) ->
    NewList = append_next_prime(List),
    list_primes(N, Index + 1, NewList).

append_next_prime([]) ->
    [2];

append_next_prime([2]) ->
    [2,3];

append_next_prime(PrimeList) ->
    append_next_prime(PrimeList, lists:last(PrimeList)).

append_next_prime(PrimeList, PrevCandidate) ->

    Candidate = PrevCandidate + 2,
    case is_prime(PrimeList, Candidate) of
	false ->
	    append_next_prime(PrimeList, Candidate);
	true ->
	    PrimeList ++ [Candidate]
    end.


is_prime(PrimeList, Candidate) ->
    PrimesToCheck = [X || X <- PrimeList, X =< math:sqrt(Candidate)],
    not lists:any(fun(X) -> Candidate rem X =:= 0 end, PrimesToCheck).
