-module(pola).
-export([pole/1,obj/1]).
-import(math,[pi/0]).
 
pole({kwadrat,X,Y}) ->  X*Y;
pole({kolo,X}) -> pi()*X*X;
pole({trapez,A,B,H}) -> ((A+B)*H)/2;
pole({kula,R}) -> 4*pi()*R*R;
pole({szescian,X}) -> 6*X*X;
pole({stozek,R,L}) -> pi()*R*R + pi()*R*L.

obj({kula,R}) -> 4/3*pi()*R*R*R;
obj({szescian,R}) -> R*R*R;
obj({stozek,R,H}) -> (pi()*R*R*H)/3.
