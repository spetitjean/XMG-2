:- module(xmg_avm, [avm/2, const_avm/2]).

:- use_module(library(atts)).
:- use_module(library(rbtrees)).

:- attribute avmfeats/2.

verify_attributes(Var, Other, Goals) :-
	get_atts(Var, avmfeats(T1,U)), !,
	var(Other),
	( get_atts(Other, avmfeats(T2,U)) ->
	  rb_visit(T1,Pairs),
	  unify_entries(T2,Pairs,T3),
	  put_atts(Other, avmfeats(T3,U)),
	  Goals=[]
	; \+ attvar(Other), Goals=[], put_atts(Other, avmfeats(T1,U))).

verify_attributes(_, _, []).

unify_entries(T,[],T).
unify_entries(T1,[K-V0|L],T3) :-
	(rb_lookup(K,V1,T1) -> V0=V1, T1=T2; rb_insert(T1,K,V0,T2)),
	unify_entries(T2,L,T3).

avm(X, L) :- var(L), !,
	get_atts(X, avmfeats(T,_)),
	rb_visit(T,L).

avm(X, L) :-
	list_to_rbtree(L,T),
	put_atts(Y, avmfeats(T,_)),
	X = Y.

const_avm(A,C) :-
	get_atts(A, avmfeats(_, C)).
	
print_avm(AVM):-
	avm(AVM,LAVM),!,
	xmg_compiler:send_nl(info),	
	xmg_compiler:send(info,'['),	
	print_inside(LAVM),
	xmg_compiler:send(info,']'),	
	xmg_compiler:send_nl(info),!.
print_avm(const(AVM,T)):-
	xmg_adisj:adisj(AVM,LAVM),
	xmg_compiler:send(info,'const('),
	xmg_compiler:send(info,LAVM),
	xmg_compiler:send(info,','),	
	xmg_compiler:send(info,T),
	xmg_compiler:send(info,')'),!.
print_avm(AVM):-
	xmg_compiler:send(info,AVM),!.

print_inside([]):- !.
print_inside([A-V|T]):-
	xmg_compiler:send(info,A),
	xmg_compiler:send(info,':'),
	print_avm(V),
	print_inside(T),!.

attribute_goal(Var, avm(Var,L)) :-
	get_atts(Var, avmfeats(T,_)),
	rb_visit(T,L).
