:- module(xmg_most,[most/2]).

:- use_module(library(atts)).
:- attribute mostval/1.

attribute_goal(Var, mostval(Var, P)) :-
	get_atts(Var, mostval(PP)), PP=P.

most(X, P) :- var(P), !,
	get_atts(X, mostval(PP)), PP=P.
most(X, P) :-
	put_atts(Y, mostval(P)),
	X = Y.

unify_mosts(A,A,A) :- !.
unify_mosts(none,A,A) :- !.
unify_mosts(A,none,A) :- !.
unify_mosts(right,left,both) :- !.
unify_mosts(left,right,both) :- !.


verify_attributes(V1, V2, Goals) :-
	get_atts(V1, mostval(P1)), !,
	var(V2),
	( get_atts(V2, mostval(P2)) ->
	  unify_mosts(P1, P2, P),
	  put_atts(V2, mostval(P)), Goals=[]
	; \+ attvar(V2), Goals=[], put_atts(V2, mostval(P1))).
verify_attributes(_, _, []).
