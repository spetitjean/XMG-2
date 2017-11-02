:- module(typeinf, [typeinf/3]).
:- use_module(avm).

%% ==================================================================
%% integer literals have type int
%% ==================================================================

typeinf(I, T, _) :- integer(I), !, T=int.

%% ==================================================================
%% avms have a constrained variable type
%%==================================================================

typeinf([], T, _) :-
    !, avm(TT, []), T=TT.
typeinf([F=E|FS], T, L) :-
    !, typeinf(E, TE, L),
    avm(TT, [F-TE]), T=TT,
    typeinf(FS, T, L).

%% ==================================================================
%% lambdas have a monomorphic functional type
%%==================================================================

typeinf(lambda(X,E), T, L) :-
    !, atom(X),
    typeinf(E, TE, [X-TX|L]),
    T=(TX->TE).

%% ==================================================================
%% let performs polymorphic generalization over non-escaping type
%% variables.  A polymorphic type is written poly(TypeVars, Type)
%% where TypeVars is the list of non-escaping type variables of Type.
%% ==================================================================

typeinf(let(X,E,B), T, L) :-
    !, typeinf(E, TE, [X-TE|L]),
    term_variables(L , LVars),
    term_variables(TE, EVars),
    keep_in(EVars, LVars, KVars),
    keep_not_in(EVars, LVars, AVars),
    copy_term((KVars,AVars,TE),(KVars2,AVars2,TE2)),
    KVars=KVars2,
    PTE=poly(AVars2,TE2),
    typeinf(B, T, [X-PTE|L]).

%% ==================================================================
%% function application
%% ==================================================================

typeinf(call(F,E), T, L) :-
    !,
    typeinf(F, (TI->TO), L),
    typeinf(E, TE, L), TI=TE,
    T=TO.

%% ==================================================================
%% constructor application (special case of function application).
%% a constructor foo is made known to typeinf through an assertion:
%%
%% global_cons_decl(foo, A, T)
%%
%% where A is the type of the constructor's argument and T is the
%% type of the constructed value.
%% ==================================================================

typeinf((C#E), T, L) :-
    !, nonvar(C),
    global_cons_decl(C, TArg, T),
    typeinf(E, TArg, L).

%% ==================================================================
%% conjunction and disjunction. these are statements and when used
%% outside a dimension should have type void, and when used inside a
%% dimension it should have the dimension's literal type.
%% ==================================================================

typeinf(conj(A,B), T, L) :-
    !,
    typeinf(A, T, L),
    typeinf(B, T, L).

typeinf(disj(A,B), T, L) :-
    !,
    typeinf(A, T, L),
    typeinf(B, T, L).

%% ==================================================================
%% equality should have a variable "literal" type (polymorphic).
%% ==================================================================

typeinf((A=B), _, L) :-
    !,
    typeinf(A, T, L),
    typeinf(B, T, L).

%% ==================================================================
%% tuples
%% ==================================================================

typeinf(R, T, L) :-
    R =.. [','|Es],
    typeinf_list(Es,Ts,L),
    T =.. [','|Ts].

%% ==================================================================
%% identifiers in the dynamic context
%% ==================================================================

typeinf(X, T, L) :-
    atom(X),
    lookup(X,L,TX), !,
    instantiate_polytype(TX, TX2), T=TX2.

%% ==================================================================
%% identifiers in the global context
%% ==================================================================

typeinf(X, T, _) :-
    ground(X),
    global_type(X, TF), !,
    instantiate_polytype(TF, TF2), T=TF2.

%% ==================================================================
%% global context
%% ==================================================================

global_type(dot(F), (TX->TE)) :-
    avm(TX, [F-TE]).
global_type(true, bool).
global_type(false, bool).

%% ==================================================================
%% utilities
%% ==================================================================

typeinf_args([], T, TT, _) :- !, T=TT.
typeinf_args([E|Es], (TX->TB), TT, L) :-
    typeinf(E, TX, L),
    typeinf_args(Es, TB, TT, L).

typeinf_list([],[],_).
typeinf_list([E|Es],[T|Ts],L) :-
    typeinf(E,T,L),
    typeinf_list(Es,Ts,L).

keep_in([], _, []).
keep_in([H|T], LVars, KVars) :-
    (is_in(H, LVars) -> KVars=[H|KVars2] ; KVars=KVars2),
    keep_in(T, LVars, KVars2).

keep_not_in([], _, []).
keep_not_in([H|T], LVars, KVars) :-
    (is_in(H, LVars) -> KVars=KVars2 ; KVars=[H|KVars2]),
    keep_not_in(T, LVars, KVars2).

is_in(_, []).
is_in(X, [H|T]) :- X==H -> true ; is_in(X, T).

lookup(X, [Y-T|L], TT) :-
    X=Y -> T=TT ; lookup(X,L,TT).

instantiate_polytype(T, TT) :-
    nonvar(T), T=poly(AVars, TE), !,
    term_variables(TE, TVars),
    keep_not_in(TVars, AVars, KVars),
    copy_term((KVars,TE),(KVars2,TE2)),
    KVars=KVars2,
    TT=TE2.
instantiate_polytype(T, T).


%% typeinf(let(f,lambda(x,x),[a=call(f,1),b=call(f,true)]),T,[]).
%% typeinf(lambda(x,call(dot(a),x)),T,[]).

%% ==================================================================
%% exemple
%% ==================================================================

%% global_cons_decl(dom,(node,node),literal).
%% global_cons_decl(doms,(node,node),literal).
%% global_cons_decl(domp,(node,node),literal).
%% global_cons_decl(prec,(node,node),literal).
%% global_cons_decl(precs,(node,node),literal).
%% global_cons_decl(precp,(node,node),literal).
%% global_cons_decl(new,(node,Props,Feats),literal) :-
%%     global_type_plug(props, Props),
%%     global_type_plug(feats, Feats).

%% %% type color = {red,black,white}
%% global_type(red, color).
%% global_type(black, color).
%% global_type(white, color).

%% %% type cat = {d,n,np,v,vp,s}
%% global_type(d, cat).
%% global_type(n, cat).
%% global_type(np, cat).
%% global_type(v, cat).
%% global_type(vp, cat).
%% global_type(s, cat).

%% global_type_plug(props, A) :-
%%     avm(A, [color=color]).
%% global_type_plug(feats, A) :-
%%     avm(A, [cat=cat]).
