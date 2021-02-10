-module(server_utils).
-include("prime_server.hrl").

-export([ping/1, check_if_neighbour_known/2, update_rt_with_inl/2,
	 update_routes/3, multicast_RT/3, 
	 try_to_forward_request/6, try_to_forward_response/7]).

-define(PING_TIMEOUT, 1000).
-define(HOPS_LIMIT, 15).

ping(TargetPID) ->
    try gen_server:call(TargetPID, ping, ?PING_TIMEOUT) of
	{ping_received, Nickname} -> 
	    {ok, Nickname}
    catch
	exit:{timeout, {gen_server, call, _CallParams}} ->
	    io:format("Pinging ~p timed out! ~n", [TargetPID]),
	    timeout;
	exit:{noproc, {gen_server, call, _CallParams}} ->
	    io:format("Cannot ping ~p, does not exist! ~n", [TargetPID]),
	    noproc
    end.

check_if_neighbour_known(NewIN, State=#state{inl=INL}) ->
    case lists:member(NewIN, INL) of
	true ->
	    io:format("New neighbour ~p is already in the list! Not adding... ~n", [NewIN]),
	    {noreply, State};
	false ->
	    add_new_neighbour(NewIN, State)
    end.

update_rt_with_inl(INL, RT) ->
    NeighbourRoutes = [{Nickname, Nickname, 1} || {Nickname, _PID} <- INL],
    _NewRT = lists:foldl(fun update_route/2, RT, NeighbourRoutes).


update_routes(OriginName, ForeignRT, LocalRT) ->
    RouteUpdates = [{DestName, OriginName, Distance + 1} || 
		       {DestName, _NeighbourName, Distance} <- ForeignRT],
    _NewRT = lists:foldl(fun update_route/2, LocalRT, RouteUpdates).


multicast_RT(_IN={_Nickname, PID}, LocalNickname, RT) ->
    gen_server:cast(PID, {broadcastRT, LocalNickname, RT}).


try_to_forward_request(N, DestinationNickname, SenderNickname, Hops, INL, RT) ->
    case Hops >= ?HOPS_LIMIT of
	true ->
	    io:format("Limit of maximum hops ~p reached!", [?HOPS_LIMIT]),
	    io:format(" Destination considered unreachable! ~n");
	false ->
	    case [{DestName, _NN, _D} || {DestName, _NN, _D} <- RT, 
					 DestName == DestinationNickname] of
		[] ->
		    io:format("Destination ~p unknown! ~n", [DestinationNickname]);
		[Route] ->
		    forward_request(N, Route, SenderNickname, Hops, INL)
	    end
    end.


try_to_forward_response(N, M, DestinationNickname, SenderNickname, Hops, INL, RT) ->
    case Hops >= ?HOPS_LIMIT of
	true ->
	    io:format("Limit of maximum hops ~p reached!", [?HOPS_LIMIT]),
	    io:format(" Destination considered unreachable! ~n");
	false ->
	    case [{DestName, _NN, _D} || {DestName, _NN, _D} <- RT, 
					 DestName == DestinationNickname] of
		[] ->
		    io:format("Destination ~p unknown! ~n", [DestinationNickname]);
		[Route] ->
		    forward_response(N, M, Route, SenderNickname, Hops, INL)
	    end
    end.

add_new_neighbour(NewIN, State=#state{inl=INL}) ->
    NewINL = case length(INL) < 3 of
		 true ->
		     INL ++ [NewIN];
		 false ->
		     io:format("Max only 3 immediate neighbours allowed!"),
		     io:format("New neighbour not added ... ~n"),
		     INL
	     end,
    {noreply, State#state{inl=NewINL}}.

update_route(NewRoute={DestName, _NeighbourName, _Distance}, RT) ->
    case [{DestNameInRT, _NN, _D} || 
	     {DestNameInRT, _NN, _D} <- RT, DestName == DestNameInRT] of

	[] ->
	    _NewRT = [NewRoute | RT];
	[OriginalRoute] ->
	    _NewRT = update_route_if_better(NewRoute, OriginalRoute, RT)
    end.

update_route_if_better(NewRoute={DestName, _NN, Distance}, 
		       OriginalRoute={DestName, _ONN, OriginDistance}, RT) ->

    case Distance < OriginDistance of
	true ->
	    RTWithoutOriginal = lists:delete(OriginalRoute, RT),
	    _NewRT = [NewRoute | RTWithoutOriginal];
	_ ->
	    RT
    end.


forward_request(N, _Route={DestName, NeighbourName, Distance}, SenderName, Hops, INL) ->
    case Distance >= ?HOPS_LIMIT of
	true ->
	    io:format("Destination ~p is further away in routing table than 15 hops!", [Distance]),
	    io:format(" It is considered unreachable! ~n");
	false ->
	    [NeighbourPID] = [PID || {Nickname, PID} <- INL, NeighbourName == Nickname],
	    io:format("Forwarding request to ~p, from ~p to destination ~p ... ~n",
		      [NeighbourName, SenderName, DestName]),
	    io:format("Total hops for this request: ~p ~n", [Hops]),
	    gen_server:cast(NeighbourPID, 
			    {computeNthPrime, N, DestName, SenderName, Hops+1})
    end.


forward_response(N, M, _Route={DestName, NeighbourName, Distance}, SenderName, Hops, INL) ->
    case Distance >= ?HOPS_LIMIT of
	true ->
	    io:format("Destination ~p is further away in routing table than 15 hops!",
		      [Distance]),
	    io:format(" It is considered unreachable! ~n");
	false ->
	    [NeighbourPID] = [PID || {Nickname, PID} <- INL, NeighbourName == Nickname],
	    io:format("Forwarding response to ~p, from ~p to destination ~p ... ~n",
		      [NeighbourName, SenderName, DestName]),
	    io:format("Total hops for this response: ~p ~n", [Hops]),
	    gen_server:cast(NeighbourPID, 
			    {receiveAnswer, N, M, DestName, SenderName, Hops+1})
    end.
