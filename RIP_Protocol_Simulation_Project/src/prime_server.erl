-module(prime_server).

-behaviour(gen_server).
-include("prime_server.hrl").

%% API
-export([start_link/1, add_IN/1, compute_prime/2, 
	 print_INL/0, print_RT/0, update_RT/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(TIMER_PERIOD_BASE, 50000).
-define(TIMER_RANDOM_RANGE, 20000).


start_link(Nickname) ->
    case is_atom(Nickname) of
	true ->
	    gen_server:start_link({local, ?SERVER}, ?MODULE, [Nickname], []);
	_ ->
	    io:format("The process nickname ~p has to be an atom! ~n", [Nickname])
    end.


add_IN({Ref, Node}) ->
    case net_kernel:connect_node(Node) of
	true ->
	    am_i_alive(),
	    gen_server:cast(?SERVER, {addImmediateNeighbour, {Ref, Node}});
	false ->
	    io:format("Node ~p is unreachable! ~n", [Node]),
	    error
    end;

add_IN(Node) ->
    add_IN({?SERVER, Node}).


compute_prime(N, DestName) ->
    gen_server:cast(?SERVER, {request_compute, N, DestName}).


print_INL() ->
    INL = gen_server:call(?SERVER, print_neighbours),
    io:format("~p ~n", [INL]).

print_RT() ->
    RT = gen_server:call(?SERVER, print_routing_table),
    io:format("~p ~n", [RT]).

update_RT() ->
    ok = gen_server:cast(?SERVER, updateRoutingTable).


init([Nickname]) ->
    process_flag(trap_exit, true),
    Timer = erlang:send_after(?TIMER_PERIOD_BASE, ?SERVER, timer_tick),
    SelfRoute = {Nickname, Nickname, 0},
    {ok, #state{nickname=Nickname, timer=Timer, rt=[SelfRoute]}}.


handle_call(ping, _From, State=#state{nickname=Nickname}) ->
    Reply = {ping_received, Nickname},
    {reply, Reply, State};

handle_call(print_neighbours, _From, State=#state{inl=INL}) ->
    Reply = INL,
    {reply, Reply, State};


handle_call(print_routing_table, _From, State=#state{rt=RT}) ->
    Reply = RT,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    Reply = unknown_call,
    {reply, Reply, State}.


handle_cast({request_compute, N, DestName}, State=#state{nickname=SenderNickname}) ->
    gen_server:cast(?SERVER, {computeNthPrime, N, DestName, SenderNickname, 0}),
    {noreply, State};


handle_cast({computeNthPrime, N, DestinationNickname, SenderNickname, Hops}, 
	    State=#state{nickname=LocalNickname, inl=INL, rt=RT}) ->
    case DestinationNickname == LocalNickname of
	true ->
	    M = prime_utils:compute_nth_prime(N),
	    io:format("Destination of request reached, the prime requested is ~p ! ~n", [M]),

	    case DestinationNickname == SenderNickname of
		true ->
		    gen_server:cast(?SERVER, 
				    {receiveAnswer, N, M, LocalNickname, LocalNickname, -1});
		false ->
		    server_utils:try_to_forward_response(N, M, SenderNickname, 
							 DestinationNickname, 0, INL, RT)
	    end;
	false ->
	    server_utils:try_to_forward_request(N, DestinationNickname, SenderNickname, 
						Hops, INL, RT)
    end,
    {noreply, State};

handle_cast({receiveAnswer, N, M, DestinationNickname, SenderNickname, Hops},
	    State=#state{nickname=LocalNickname, inl=INL, rt=RT}) ->
    case DestinationNickname == LocalNickname of
	true ->
	    io:format("Answer received, the prime requested is ~p ! ~n~n", [M]);
	false ->
	    server_utils:try_to_forward_response(N, M, DestinationNickname, SenderNickname, 
						Hops, INL, RT)
    end,
    {noreply, State};

handle_cast({addImmediateNeighbour, PID}, State) ->
    case server_utils:ping(PID) of
	{ok, Nickname} ->
	    server_utils:check_if_neighbour_known({Nickname, PID}, State);
	timeout ->
	    cannot_add_neighbour(State);
	noproc ->
	    cannot_add_neighbour(State)
    end;

handle_cast(updateRoutingTable, State=#state{nickname=LocalName, inl=INL, rt=RT}) ->
    NewRT = server_utils:update_rt_with_inl(INL, RT),
    io:format("Multicasting update routing table message ... ~n"),
    lists:map(fun(IN) -> server_utils:multicast_RT(IN, LocalName, NewRT) end, INL),
    {noreply, State#state{rt=NewRT}};


handle_cast({broadcastRT, OriginNickname, ForeignRT}, 
	    State=#state{nickname=LocalNickname, inl=INL, rt=RT}) ->
    io:format("Update routing table message received from ~p ... ~n", [OriginNickname]),
    CanIReachOrigin = [{Nickname, PID} || {Nickname, PID} <- INL, Nickname == OriginNickname],

    case CanIReachOrigin of
	[] ->
	    io:format("~p is unreacable from this process,", [OriginNickname]),
	    io:format("ignoring its rounting table, not replying ... ~n"),
	    {noreply, State};
	[{OriginName, OriginPID}] ->
	    NewRT = server_utils:update_routes(OriginName, ForeignRT, RT),
	    gen_server:cast(OriginPID, {responseRT, LocalNickname, RT}),
	    {noreply, State#state{rt=NewRT}}
    end;


handle_cast({responseRT, OriginNickname, ForeignRT}, State=#state{rt=RT}) ->
    io:format("RT received from ~p as response to our broadcast. ~n", [OriginNickname]),
    NewRT = server_utils:update_routes(OriginNickname, ForeignRT, RT),
    {noreply, State#state{rt=NewRT}};


handle_cast(_Msg, State) ->
    io:format("unknown cast"),
    {noreply, State}.

handle_info(timer_tick, State=#state{timer=OldTimer}) ->
    erlang:cancel_timer(OldTimer),
    gen_server:cast(?SERVER, updateRoutingTable),

    Random = rand:uniform(?TIMER_RANDOM_RANGE),
    Timer = erlang:send_after(?TIMER_PERIOD_BASE + Random, ?SERVER, timer_tick),
    {noreply, State#state{timer=Timer}};
    
handle_info(_Info, State) ->
    io:format("unexpected info"),
    {noreply, State}.



terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


am_i_alive() ->
    case whereis(?SERVER) of
	undefined ->
	    io:format("~p is down! ~n", [?SERVER]),
	    error;
	_ ->
	    ok
    end.


cannot_add_neighbour(State) ->
    io:format("New neighbour is unreachable, failed to add! ~n"),
    {noreply, State}.
