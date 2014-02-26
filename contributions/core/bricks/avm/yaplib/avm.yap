:- module(xmg_brick_avm_avm, [avm/2, const_avm/2]).

:- use_module(library(atts)).
:- use_module(library(rbtrees)).

:- attribute avmfeats/2.

verify_attributes(Var, Other, Goals) :-
    get_atts(Var, avmfeats(T1,U)), !,
    (var(Other)
     -> ( get_atts(Other, avmfeats(T2,U))
	  ->
	      rb_visit(T1,Pairs),
	      unify_entries(T2,Pairs,T3),
	      put_atts(Other, avmfeats(T3,U))
	  ;   \+ attvar(Other),
	      put_atts(Other, avmfeats(T1,U)))
     ; Other=cavm(T2),
       rb_visit(T1, Pairs),
       cunify_entries(Pairs, T2)),
    Goals = [].

verify_attributes(_, _, []).

unify_entries(T,[],T).
unify_entries(T1,[K-V0|L],T3) :-
	(rb_lookup(K,V1,T1) -> V0=V1, T1=T2; rb_insert(T1,K,V0,T2)),
	unify_entries(T2,L,T3).

avm(X, L) :-
    var(L), !,
    get_atts(X, avmfeats(T,_)),
    rb_visit(T,L).

avm(X, L) :-
    list_to_rbtree(L,T),
    put_atts(Y, avmfeats(T,_)),
    X = Y.

attribute_goal(Var, avm(Var,L)) :-
    get_atts(Var, avmfeats(T,_)),
    rb_visit(T,L).

const_avm(A,C) :-
    get_atts(A, avmfeats(_, C)).
	
%% ============================================================================
%% CONSTANT AVMs (e.g. for export records)
%% ============================================================================

cavm(X, L) :-
    var(L), !, \+ var(X), X=cavm(T), rb_visit(T, L).

cavm(X, L) :-
    list_to_rbtree(L,T),
    X=cavm(T).

cunify_entries([],_).
cunify_entries([K-V|L], T) :-
    rb_lookup(K,VV,T), V=VV, cunify_entries(L,T).

%% ============================================================================
%% DOT ACCESS
%% ============================================================================

dot(X,F,V) :-
    var(X) -> avm_dot(X,F,V) ; cavm_dot(X,F,V).

avm_dot(X,F,V) :-
    get_atts(X, avmfeats(T,C)), %% should signal an error if not applicable
    (rb_lookup(F,VV,T)
     -> V=VV
     ;  rb_insert(T,F,V,TT),
	put_atts(X, avmfeats(TT,C))).

cavm_dot(cavm(T),F,V) :-        %% should signal an error if not applicable
    rb_lookup(F,V,T).

%% ============================================================================
%% DEBUGGING
%% ============================================================================

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
