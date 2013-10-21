:- module(xmg_brick_mg_dpprint, []).

:- use_module(library('xmg/xmg_logthreads')).
:- use_module(library(charsio)).
:- include('xmg/brick/mg/accu').

:- thread_pred(mkboxes/1, [queue]).

mkbox(T,B) :--
	T=[]       -> B=tok(2,'[]') ;
	is_list(T) -> (B=lbox(N,tok(1,'['),L,tok(1,']')),
		       mkboxes(T) with queue([_|L],[]),
		       wdlist(L,0,M), N is 2+M) ;
	atomic(T)  -> (write_to_chars(T,L), length(L,N), B=str(N,L)) ;
	(T =.. [F|As], mkbox(F,Fbox), B=hbox(N,[Fbox,Abox]),
	 mkboxes(As) with queue([_|L],[]),
	 Abox=lbox(N2,tok(1,'('),L,tok(1,')')),
	 wdlist(L,0,N3), N2 is 2+N3, arg(1,Fbox,N1), N is N1+N2).

wdlist([],N,N).
wdlist([H|T],N1,N3) :- arg(1,H,K), N2 is K+N1, wdlist(T,N2,N3).

mkboxes([]) :-- [].
mkboxes([H|T]) :--
	mkbox(H,B), queue::enq(tok(1,',')), queue::enq(B), mkboxes(T).

%%% tok(N,A)
%%% str(N,S)
%%% hbox(N,L)
%%% lbox(N,T1,L,T2)

:- thread( margin, [get, set, inc, dec, incn, decn] ).
:- thread( width , [get, set, inc, dec, incn, decn] ).

:- thread_pred(indent/0, [col, margin]).

indent :--
	margin::get(M),
	col::get(C),
	(C>M -> nl, CC=0 ; CC=C),
	\+ \+ mkindent(CC,M),
	col::set(M).

mkindent(I,N) :-
	I<N -> (write(' '), J is I+1, mkindent(J,N)); true.

:- thread_pred( ppbox/1, [col, margin, width]).
:- thread_pred(pphbox/1, [col, margin, width]).
:- thread_pred(pplbox/1, [col, margin, width]).

ppbox(tok(N,A)) :-- write(A), col::incn(N).
ppbox(str(N,S)) :-- format("~s",[S]), col::incn(N).
ppbox(hbox(N,L)) :-- pphbox(L).
ppbox(lbox(N,T1,L,T2)) :--
	ppbox(T1), margin::get(M), col::get(C),
	margin::set(C),	pplbox(L), ppbox(T2),
	margin::set(M).

pplbox([]) :-- [].
pplbox([H|T]) :--
	col::get(C), margin::get(M),
	(C=M -> true;
	 arg(1,H,N), C2 is C+N, width::get(W),
	 C2>W -> nl, col::set(0), indent ; true),
	ppbox(H), pplbox(T).

pphbox([]) :-- [].
pphbox([H|T]) :-- ppbox(H), pphbox(T).

pprint(T) :- pprint(T,80).
pprint(T,W) :--
	mkbox(T,B),
	ppbox(B) with (col(0,_), margin(0,_), width(W,_)),
	nl.
