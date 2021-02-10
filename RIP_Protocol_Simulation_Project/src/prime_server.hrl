%% Defining state record with immediate neighbour list and routing table.
%% Nickname and a timer handler for the regular update is also stored here.
-record(state, {nickname, 
		timer, 
		inl=[], 
		rt=[]}).
