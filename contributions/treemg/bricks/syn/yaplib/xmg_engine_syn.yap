:- module(xmg_brick_syn_engine,[]).

:- use_module(xmg_polarity).
:- use_module(xmg_nodename).

:- edcg:thread(cname,edcg:counter).

:- edcg:weave( [cname],
		 [gensym/1]).

gensym(Name) :--
	cname::incr,
	cname::get(N),
	atomic_concat(['XMGC',N],Name).

%% inode(X,N) :-
%% 	xmg_avm:avm(P,[]),
%% 	xmg_avm:avm(T,[]),
%% 	nb_getval(suffix,Number),
%% 	Number1 is Number + 1,
%% 	nb_setval(suffix,Number1),
%% 	atomic_concat([N,'_',Number1],N1),
%% 	xmg_nodename:nodename(I,N1),
%% 	X = node(P,T,I),!. 
inode(X,N) :-
	xmg_avm:avm(P,[]),
	xmg_avm:avm(F,[]),
	xmg_nodename:nodename(I,N),
	X = node(P,F,I),!. 

inodeprops(X,P) :-
	X=node(P,_,_),!.

inodefeats(X,F) :-
	X=node(_,F,_),!.


feat(F,A,B,P) :-
	xmg_avm:avm(N,[A-value(B,P)]),
	F=N,
	!.

dot(B,assoc(E),A):-
	get_assoc(E,A,B),!.
dot(B,F,A) :-
	feat(F,A,B,_),
	!.

get_assoc([],A,nil):- 
		atomic_concat(['Identifier ', A, ' not found when importing'],Mess),
		print_message(warning,Mess),
		!.

get_assoc([A-B|_],A,B) :- !.

get_assoc([_-_|T],A,B) :-
	get_assoc(T,A,B),!.


