:- module(xmg_brick_syn_polarity,[polarity/2]).

:- use_module(library(atts)).
:- attribute polval/1.

attribute_goal(Var, polval(Var, P)) :-
	get_atts(Var, polval(PP)), PP=P.

polarity(X, P) :- var(P), !,
	get_atts(X, polval(PP)), PP=P.
polarity(X, P) :-
	put_atts(Y, polval(P)),
	X = Y.

unify_polarities('=~',Y,Y) :- !.
unify_polarities(Y,'=~',Y) :- !.
unify_polarities('=',Y,Y) :- !.
unify_polarities(Y,'=',Y) :- !.
unify_polarities('=+','=+','=+') :- !.
unify_polarities('=-','=-','=+') :- !.

verify_attributes(V1, V2, Goals) :-
	get_atts(V1, polval(P1)), !,
	var(V2),
	( get_atts(V2, polval(P2)) ->
	  unify_polarities(P1, P2, P),
	  put_atts(V2, polval(P)), Goals=[]
	; \+ attvar(V2), Goals=[], put_atts(V2, polval(P1))).
verify_attributes(_, _, []).
