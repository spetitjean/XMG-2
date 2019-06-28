:- module(xmg_brick_adisj_adisj).

:- use_module(library(atts)).
:- use_module(library(ordsets)).

:- attribute adisjset/2.

attribute_goal(Var, adisj(Var,L)) :-
	get_atts(Var, adisjset(S,_)), L=S.

adisj(X, L) :- var(L), !,
	get_atts(X, adisjset(S,_)), L=S.
adisj(X, L) :-
	list_to_ord_set(L, S),
	put_atts(Y, adisjset(S,_)),
	X = Y.

verify_attributes(Var1, Var2, Goals) :-
	get_atts(Var1, adisjset(S1,U)), !,
	( var(Var2) ->
	  ( get_atts(Var2, adisjset(S2,U)) ->
	    ord_intersection(S1, S2, S),
	    ( S=[ ] -> fail
	    ; S=[V] -> Goals=[Var2=V]
	    ; put_atts(Var2, adisjset(S,U)), Goals=[])
	  ; \+ attvar(Var2), Goals=[], put_atts(Var2, adisjset(S1,U)))
	; Goals=[Var1=Var2], ord_intersect(S1, [Var2])).
verify_attributes(_, _, []).

const_adisj(A,C) :-
	get_atts(A, adisjset(_, C)).

