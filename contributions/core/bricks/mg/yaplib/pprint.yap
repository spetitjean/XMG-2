:- module(xmg_brick_mg_pprint, [pprint/1, pprint/2]).

:- use_module('xmg/brick/mg/spprint').
%%:- use_module('xmg/brick/mg/dpprint').

pprint(T, simon) :- !, xmg_brick_mg_spprint:pprint(T).
pprint(T, denys) :- !, xmg_brick_mg_dpprint:pprint(T).
pprint(T, denys(N)) :- !, xmg_brick_mg_dpprint:pprint(T, N).
pprint(T, N) :- integer(N), !, dpprint(T, N).

%% global pprint default

set_default(T) :-
	eraseall(pprint),
	recorda(pprint, T, _).

:- set_default(simon).

get_default(T) :-
	recorded(pprint, T, _), !.

%% use global pprint default

pprint(T) :-
	get_default(D),
	pprint(T, D).
