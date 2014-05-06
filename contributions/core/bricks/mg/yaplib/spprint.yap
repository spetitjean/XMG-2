:- module(xmg_brick_mg_spprint, []).
:- xmg:edcg.

indente(0) :-- !.

indente(L) :--
	xmg_brick_mg_compiler:send(info,' '),
	NL is L-1,
	indente(NL).

pprint_nolist([],_):--!.

pprint_nolist([A],L):--
	pprint(A,L),!.

pprint_nolist([H|T],L):--
	pprint(H,L),
	xmg_brick_mg_compiler:send(info,','),
	xmg_brick_mg_compiler:send(info,'\n'),
	pprint_nolist(T,L),!.

pprint([H|T],L):--
	indente(L),
	xmg_brick_mg_compiler:send(info,'['),
	xmg_brick_mg_compiler:send(info,'\n'),
	NL is L+3,
	pprint_nolist([H|T],NL),
	xmg_brick_mg_compiler:send(info,'\n'),
	indente(L),
	xmg_brick_mg_compiler:send(info,']'),!.

pprint(A,L):--
	atom(A),
	indente(L),
	xmg_brick_mg_compiler:send(info,A).

pprint(A,L):--
	integer(A),
	indente(L),
	xmg_brick_mg_compiler:send(info,A).

pprint(A,L):--
	A=coord(_,_,_),
	indente(L),
	xmg_brick_mg_compiler:send(info,A).

pprint(A,L) :--
	A=..[H|T],
	T=[T1,T2],
	atom(T1),
	atom(T2),
	indente(L),
	xmg_brick_mg_compiler:send(info,H),		
	xmg_brick_mg_compiler:send(info,'('),
	xmg_brick_mg_compiler:send(info,T1),
	xmg_brick_mg_compiler:send(info,','),
	xmg_brick_mg_compiler:send(info,T2),
	xmg_brick_mg_compiler:send(info,')').

pprint(A,L) :--
	A=..[H|T],
	T=[T1,T2],
	integer(T1),
	integer(T2),
	indente(L),
	xmg_brick_mg_compiler:send(info,H),		
	xmg_brick_mg_compiler:send(info,'('),
	xmg_brick_mg_compiler:send(info,T1),
	xmg_brick_mg_compiler:send(info,','),
	xmg_brick_mg_compiler:send(info,T2),
	xmg_brick_mg_compiler:send(info,')').

pprint(A,L) :--
	A=..[H|T],
	T=[T1],
	atom(T1),
	indente(L),
	xmg_brick_mg_compiler:send(info,H),		
	xmg_brick_mg_compiler:send(info,'('),
	xmg_brick_mg_compiler:send(info,T1),
	xmg_brick_mg_compiler:send(info,')').

pprint(A,L) :--
	A=..[H|T],
	indente(L),
	xmg_brick_mg_compiler:send(info,H),
	xmg_brick_mg_compiler:send(info,'\n'),
	indente(L),
	xmg_brick_mg_compiler:send(info,'('),
	xmg_brick_mg_compiler:send(info,'\n'),
	NL is L+3,
	pprint_nolist(T,NL),
	xmg_brick_mg_compiler:send(info,'\n'),
	indente(L),
	xmg_brick_mg_compiler:send(info,')').

pprint(A) :- pprint(A,0).
