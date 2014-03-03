:- module(xmg_brick_syn_nodename,[nodename/2]).

:- use_module(library(atts)).
:- attribute nameval/1.

attribute_goal(Var, nameval(Var, P)) :-
	get_atts(Var, nameval(PP)), PP=P.

nodename(X, P) :- var(P), !,
	get_atts(X, nameval(PP)), PP=P.
nodename(X, P) :-
	put_atts(Y, nameval(P)),
	X = Y.

unify_nodenames(A,B,C) :-
	atom_concat(A,B,C),				   
	%atom_concat(CA,CB,C),
	!.
unify_nodenames(A,B,_) :-
	xmg:send(info,'\nUnification failed:\n'),
	xmg:send(info,A),
	xmg:send(info,B),
	fail.



verify_attributes(V1, V2, Goals) :-
	get_atts(V1, nameval(P1)), !,
	var(V2),
	( get_atts(V2, nameval(P2)) ->
	  unify_nodenames(P1, P2, P),
	  put_atts(V2, nameval(P)), Goals=[]
	; \+ attvar(V2), Goals=[], put_atts(V2, nameval(P1))).
verify_attributes(_, _, []).
