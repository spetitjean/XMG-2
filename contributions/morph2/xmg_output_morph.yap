:-module(xmg_output_morph).

output(L):-
	%%xmg_compiler:send(info,' ordering list ! '),
	xmg_compiler:send(info,' MORPHOLOGY : '),xmg_compiler:send_nl(info),
	order_list(L,L1,L2),
	output_feats(L1),
	xmg_compiler:send_nl(info),
	order_fields(L2,L3),
	output_fields(L3),
	xmg_compiler:send(info,'_______________________________________________'),
	xmg_compiler:send_nl(info),xmg_compiler:send_nl(info).

order_list([],[],[]).
order_list([H|T],[H|T1],T2):-
	H=..['=',var(A),B],
	not(var(A)),
	xmg_typer:feat(A,_),
	order_list(T,T1,T2).
order_list([H|T],T1,[N-H|T2]):-
	H=..['=',var(A),B],
	not(var(A)),
	xmg_typer:field(A,N),
	order_list(T,T1,T2).
order_list([H|T],T1,T2):-
	H=..['=',var(A),B],
	var(A),
	order_list(T,T1,T2).

order_fields(F,OF):-
	lists:keysort(F,OF).

output_feats([]).
output_feats([H|T]):-
	xmg_compiler:send(info,H),xmg_compiler:send_nl(info),
	output_feats(T).

output_fields([]).
output_fields([_-H|T]):-
	xmg_compiler:send(info,H),xmg_compiler:send_nl(info),
	output_fields(T).

