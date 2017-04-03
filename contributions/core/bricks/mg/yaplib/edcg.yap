%% -*- prolog -*-
%%=============================================================================
%% Copyright (C) 2011 by Denys Duchier
%%
%% This program is free software: you can redistribute it and/or modify it
%% under the terms of the GNU Lesser General Public License as published by the
%% Free Software Foundation, either version 3 of the License, or (at your
%% option) any later version.
%% 
%% This program is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
%% more details.
%% 
%% You should have received a copy of the GNU Lesser General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%=============================================================================

:- module(edcg, [op(1200, xfx, '-->>'),
		 op(1200, xfx, ':--' ),
		 op( 850, xfx, '::'  ),
		 op( 850, xfy, 'with'),
		 op( 500, xfy, '=>'  ),
		 op( 500, xfy, ':='  )]).
:- load_files([library(lists), 'table.yap'],[silent(true)]).

:- dynamic edcg_info/2.

:- op(1200, xfx, '-->>').   % Same as ':-'.
:- op(1200, xfx, ':--' ).   % Same as ':-'.
:- op( 850, xfx, '::'  ).   % Slightly tighter than ',' and '\+'.
:- op( 850, xfy, 'with').   % Slightly tighter than ',' and '\+'.
:- op( 500, xfy, '=>'  ).
:- op( 500, xfy, ':='  ).

:- source.

%% ============================================================================
%% TERM EXPANSION
%% ============================================================================

term_expansion( (:- edcg:method(Method, Old, New, Joiner)), [] ) :- !,
    edcg_method(Method, Old, New, Joiner).

term_expansion( (:- edcg:class(Class, Methods, Init, Final)), [] ) :- !,
    edcg_class(Class, Methods, value(Init), value(Final)).
term_expansion( (:- edcg:class(Class, Methods, Init)), [] ) :- !,
    edcg_class(Class, Methods, value(Init), no_value).
term_expansion( (:- edcg:class(Class, Methods)), [] ) :- !,
    edcg_class(Class, Methods, no_value, no_value).

term_expansion( (:- edcg:thread(Thread, Class)), [] ) :- !,
    edcg_thread(Thread, Class).

term_expansion( (:- edcg:using(L)), [] ) :- !,
    edcg_using(L).

term_expansion( (:- edcg:weave( Threads, Predicates )), [] ) :- !,
    edcg_weave(Threads, Predicates).

term_expansion( (H-->>B), Clause ) :- !,
    edcg_clause(H, B, Clause).

term_expansion( (H:--B) , Clause ) :- !,
    edcg_clause(H, B, Clause).

term_expansion( (:- edcg:class_alias(Alias, Class)), [] ) :- !,
    edcg_class_alias(Alias, Class).

%% ============================================================================
%% CURRENTLY LOADING MODULE INFO
%% ============================================================================

loading_module( Module ) :-
    (prolog_load_context(module,M); M=user), !, Module=M.
loading_file( FileName ) :-
    (prolog_load_context(file,F); F=user), !, FileName=F.
loading_lineno( LineNo ) :-
    (prolog_load_context(stream,Stream), line_count(Stream,N)
    ; N=0), !, LineNo=N.

maybe_prefix_with_loading_module(A,B) :-
    A=(_:_) -> A=B ; (loading_module(M), B=(M:A)).

%% ============================================================================
%% ERRORS
%% ============================================================================

edcg_error_( Format, Args, Which ) :-
    loading_module(Module),
    loading_file(Filename),
    loading_lineno(LineNo),
    edcg_error_fmt( Format, Args, Which, Module, Filename, LineNo).

edcg_error_fmt( Format, Args, Which, Module, Filename, LineNo ) :-
    format(user_error, "~n~w:~n", [Which]),
    format(user_error, "  module: ~w~n", [Module]),
    format(user_error, "filename: ~w~n", [Filename]),
    format(user_error, "  lineno: ~w~n", [LineNo]),
    format(user_error, Format, Args),
    format(user_error, "~n", []).

edcg_error( Format, Args ) :-
    edcg_error_( Format, Args, 'ERROR' ),
    throw(edcg_error).

edcg_warning( Format, Args ) :-
    edcg_error_( Format, Args, 'WARNING' ).

%% ============================================================================
%% METHOD TYPE DECLARATION
%%
%% invoked as:
%%     :- edcg:method(Method(Args...), Old, New, Joiner).
%%
%% stored as:
%%     edcg:edcg_info(Module:Method, method(Args, Old, New, Joiner))
%% ============================================================================

edcg_method(Mod:Method, Old, New, Joiner) :- !,
    Method=..[Name|Args],
    edcg_method_(Mod, Name, Args, Old, New, Joiner).
edcg_method(Method, Old, New, Joiner) :-
    maybe_prefix_with_loading_module(Method, ModMethod),
    edcg_method(ModMethod, Old, New, Joiner).

edcg_method_(Mod, Name, Args, Old, New, Joiner) :-
    assert_is_not_method(Mod:Name),
    assert(edcg:edcg_info(Mod:Name, method(Args, Old, New, Joiner))).

assert_is_not_method(ModMethod) :-
    edcg_info(ModMethod, method(_, _, _, _))
    -> edcg_error("method already defined: ~w", [ModMethod])
    ; true.

assert_is_method(ModMeth) :-
    edcg_info(ModMeth, method(_, _, _, _))
    -> true
    ; edcg_error("unknown method: ~w", [ModMeth]).

%% ============================================================================
%% CLASS ALIAS DECLARATION
%%
%% invoked as:
%%     :- edcg:class_alias(Alias, Class).
%% ============================================================================

edcg_class_alias(Alias, Class) :-
    maybe_prefix_with_loading_module(Alias, ModAlias),
    maybe_prefix_with_loading_module(Class, ModClass),
    assert_is_class(ModClass),
    assert(edcg:edcg_info(ModAlias, class_alias(ModClass))).

is_class_alias(ModAlias) :-
    edcg:edcg_info(ModAlias, class_alias(_)).

edcg_class_alias_deref(ModAlias, ModClass) :-
    edcg:edcg_info(ModAlias, class_alias(ModClass)).

%% ============================================================================
%% CLASS DECLARATION
%%
%% invoked as:
%%     :- edcg:class(Class, Methods, Init, Final)
%%     :- edcg:class(Class, Methods, Init)
%%     :- edcg:class(Class, Methods)
%%
%% stored as:
%%     edcg:edcg_info(Module:Class, class(ExpandedMethods, Init, Final))
%%
%% Methods is a list of elements that each bind a method type to a name.
%% Elements can be:
%%     Name=Module:Method
%%     Name=Method		(use current module)
%%     Module:Method		(same as Method=Module:Method)
%%     Method			(same as Method=Method)
%% ============================================================================

edcg_class(Class, Methods, Init, Final) :-
    maybe_prefix_with_loading_module(Class, ModClass),
    assert_is_not_class(ModClass),
    expand_methods(Methods, EMethods),
    assert(edcg:edcg_info(ModClass, class(EMethods, Init, Final))).

assert_is_not_class(ModClass) :-
    edcg_info(ModClass, class(_, _, _))
    -> edcg_error("class already defined: ~w", [ModClass])
    ; true.

assert_is_class(ModClass) :-
    edcg_info(ModClass, class(_, _, _))
    -> true
    ; edcg_error("unknown class: ~w", [ModClass]).

expand_methods([H1|T1],[H2|T2]) :- !,
    expand_method(H1, H2),
    expand_methods(T1, T2).
expand_methods([], []).

expand_method(N2=M1:N1, X) :- !,
    assert_is_name(N2),
    %% verify that M1:N1 is really a known method type
    assert_is_method(M1:N1),
    X = (N2=M1:N1).
expand_method(N2=N1, X) :- !,
    loading_module(M2),
    expand_method(N2=M2:N1, X).
expand_method(M1:N1, X) :- !,
    expand_method(N1=M1:N1, X).
expand_method(N2, X) :- !,
    expand_method(N2=N2, X).

assert_is_name(X) :-
    atom(X)
    -> true
    ; edcg_error("expected an atom as a name: ~w", [X]).

%% ============================================================================
%% THREAD (threaded accumulator) DECLARATION
%%
%% invoked as:
%%     :- edcg:thread(Thread, Class).
%%
%% stored as:
%%     edcg:edcg_info(Module:Thread, thread(Class))
%% ============================================================================

edcg_thread(Thread, Class) :-
    maybe_prefix_with_loading_module(Thread, ModThread),
    maybe_prefix_with_loading_module(Class , ModAlias),
    assert_is_not_thread(ModThread),
    (edcg_class_alias_deref(ModAlias, ModClass)
     -> true ; ModAlias=ModClass ),
    assert_is_class(ModClass),
    assert(edcg:edcg_info(ModThread, thread(ModClass))).

is_thread_(ModThread) :-
    ( edcg_info(ModThread, thread(_))
    ; edcg_info(ModThread,  alias(_)) ), !.

assert_is_not_thread(ModThread) :-
    is_thread_(ModThread)
    -> edcg_error("thread already defined: ~w", [ModThread])
    ; true.

assert_is_thread(ModThread) :-
    is_thread_(ModThread)
    -> true
    ; edcg_error("unknown thread: ~w", [ModThread]).

%% ============================================================================
%% USING DECLARATION
%%
%% invoked as:
%%     :- edcg:using(Threads).
%%
%% stored as a bunch of:
%%     edcg:edcg_info(Module:Thread, alias(Module2:Thread2))
%%
%% Threads is an element or a list of elements for importing threads into the
%% current module.  A thread may be renamed when imported.  Each element is one
%% of:
%%     Module:Thread
%%     Name=Module:Thread
%% ============================================================================

edcg_using([H|T]) :- !,
    edcg_using_(H),
    edcg_using(T).
edcg_using([]) :- !.
edcg_using(X) :-
    edcg_using_(X).

edcg_using_(Name=Module:Thread) :- !,
    assert_is_name(Name),
    loading_module(Mod),
    edcg_using__(Mod:Name, Module:Thread).
edcg_using_(Module:Thread) :- !,
    edcg_using_(Thread=Module:Thread).
edcg_using_(Thread) :-
    edcg_error("unexpected edcg:using spec: ~w", [Thread]).

edcg_using__(M1:T1, M2:T2) :- !,
    assert_is_thread(M2:T2),
    assert_is_not_thread(M1:T1),
    assert(edcg:edcg_info(M1:T1, alias(M2:T2))).

%% ============================================================================
%% WEAVE DECLARATION
%%
%% invoked as:
%%     :- edcg:weave(Threads, Predicates).
%%
%% stored as a bunch of:
%%     edcg:edcg_info(Module:Pred/Arity, weave(ExpandedThreads))
%%
%% Threads is an element or list of elements referring to threads.  Predicates
%% is an element or list of elements of the form Pred/Arity.  The declaration
%% states that these predicates have exacty the hiddent arguments required by
%% these threads.
%%
%% Since a thread may alias another (through edcg:using(...)), ExpandedThreads
%% is the dealiased list of threads with every one of the form Mod:Thr.
%% ============================================================================

edcg_weave(Threads, Predicates) :-
    expand_threads(Threads, EThreads),
    edcg_weave_preds(EThreads, Predicates).

expand_threads([Thread|Threads], [EThread|EThreads]) :- !,
    expand_thread(Thread, EThread),
    expand_threads(Threads, EThreads).
expand_threads([], []) :- !.
expand_threads(Thread, [EThread]) :-
    expand_thread(Thread, EThread).

expand_thread(Mod:Thread, EThread) :- !,
    expand_thread_(Mod:Thread, EThread).
expand_thread(Thread, EThread) :- !,
    loading_module(Mod),
    expand_thread(Mod:Thread, EThread).

expand_thread_(Thread, EThread) :-
    edcg_info(Thread, alias(Thread2)), !,
    expand_thread_(Thread2, EThread).
expand_thread_(Thread, EThread) :-
    edcg_info(Thread, thread(_)), !, EThread=Thread.
expand_thread_(Thread, _) :-
    edcg_error("unknown thread: ~w", [Thread]).

edcg_weave_preds(Threads, [Pred|Preds]) :- !,
    edcg_weave_pred(Threads, Pred),
    edcg_weave_preds(Threads, Preds).
edcg_weave_preds(_, []) :- !.
edcg_weave_preds(Threads, Pred) :-
    edcg_weave_pred(Threads, Pred).

edcg_weave_pred(Threads, Pred) :- !,
    expand_pred_arity(Pred, EPred),
    (assert_is_not_woven(EPred)
    -> assert(edcg:edcg_info(EPred, weave(Threads)))
    ; edcg_error("predicate already woven: ~w", [EPred])).

assert_is_woven(M:P/A) :-
    edcg_info(M:P/A, weave(_))
    -> true
    ; edcg_error("no weave defined for predicate: ~w", [M:P/A]).

assert_is_not_woven(M:P/A) :-
    edcg_info(M:P/A, weave(_))
    -> edcg_error("weave already defined for predicate: ~w", [M:P/A])
    ; true.

expand_pred_arity(M:P/A, R) :- !, R=M:P/A.
expand_pred_arity(P/A, R) :- !, loading_module(M), R=M:P/A.
expand_pred_arity(Pred, _) :-
    edcg_error("expected spec of the form Pred/Arity or Mod:Pred/Arity: ~w", [Pred]).

expand_goal_module(M1:G, R) :- !,
    (predicate_property(M1:G, imported_from(M2)) -> R=M2:G; R=M1:G).
expand_goal_module(G, R) :-
    loading_module(M), expand_goal_module(M:G, R).

expand_goal_to_pred_arity(Goal, Result) :-
    expand_goal_module(Goal, M:T),
    functor(T, F, N),
    Result=(M:F/N).

expand_goal_to_pred_arity(Goal, M:T, Result) :-
    expand_goal_module(Goal, M:T),
    functor(T, F, N),
    Result=(M:F/N).

%% ============================================================================
%% CLAUSE EXPANSION
%% ============================================================================

edcg_clause(H, B, (TH:-TB)) :-
    goal_to_pred_arity__args__accs(H, MH:FH/FN, HArgs, HAccs),!,
    new_head(MH:FH, HArgs, HAccs, HCtx, TH),
    expand_goal_(B, TB, HCtx, BCtx),
    finish_acc(BCtx).

edcg_clause(H, B, (H:-TB)) :-
    expand_goal_(B, TB, [], BCtx),
    finish_acc(BCtx).

goal_to_pred_arity__args__accs(G, P, Args, Accs) :-
    expand_goal_module(G, M1:G1),
    functor(G1, F, N),
    G1 =.. [_|Args],
    P=M1:F/N,
    (edcg_info(P, weave(L)) -> Accs=L ; Accs=[]).

new_head(M:F, Args, Accs, Ctx, M:H) :-
    append(Args, L, XArgs),
    new_head_(L, Accs, Ctx),
    H =.. [F|XArgs].

new_head_([], [], []).
new_head_([Ini,Fin|T], [Acc|Accs], [Acc=(Ini,Fin)|Ctx]) :-
    new_head_(T, Accs, Ctx).

finish_acc([]).
finish_acc([_=(X,X)|L]) :- finish_acc(L).

expand_goal_(G, G, Ctx, Ctx) :- var(G), !.
expand_goal_((A1,B1),(A2,B2), Ctx1, Ctx2) :- !,
    expand_goal_(A1, A2, Ctx1, Ctx_),
    expand_goal_(B1, B2, Ctx_, Ctx2).
expand_goal_((A1->B1;C1), (A2->(B2,BE2);(C2,CE2)), Ctx1, Ctx2) :- !,
    expand_goal_(A1, A2, Ctx1, CtxA),
    expand_goal_(B1, B2, CtxA, CtxB),
    expand_goal_(C1, C2, Ctx1, CtxC),
    context_equalities(CtxB, Ctx2, BE2),
    context_equalities(CtxC, Ctx2, CE2).
expand_goal_((A1;B1), ((A2,AE2);(B2,BE2)), Ctx1, Ctx2) :- !,
    expand_goal_(A1, A2, Ctx1, CtxA),
    expand_goal_(B1, B2, Ctx1, CtxB),
    context_equalities(CtxA, Ctx2, AE2),
    context_equalities(CtxB, Ctx2, BE2).
expand_goal_((A1->B1), (A2->B2), Ctx1, Ctx2) :- !,
    expand_goal_(A1, A2, Ctx1, CtxA),
    expand_goal_(B1, B2, CtxA, Ctx2).
expand_goal_({G}, G, Ctx, Ctx) :- !.
expand_goal_((G1 with A), G3, Ctx1, Ctx2) :- !,
    context_extend(A, Ctx1, CtxG1, N),
    expand_goal_(G1, G2, CtxG1, CtxG2),
    context_reduce(N, CtxG2, Ctx2, E),
    G3=(G2,E).
expand_goal_((!), G, Ctx, Ctx) :- !, G=(!).
expand_goal_([], true, Ctx, Ctx) :- !.
expand_goal_([H|L], G, Ctx1, Ctx2) :- !,
    expand_goal_(dcg::[H|L], G, Ctx1, Ctx2).
expand_goal_((Th::[]), G, Ctx1, Ctx2) :- !,
    expand_goal_((Th::default([])), G, Ctx1, Ctx2).
expand_goal_((Th::[H|T]), G, Ctx1, Ctx2) :- !,
    expand_goal_((Th::default([H|T])), G, Ctx1, Ctx2).
expand_goal_((Th::Method), G, Ctx1, Ctx2) :- !,
    expand_thread(Th, M1:T1),
    edcg_info(M1:T1, thread(M2:C2)),
    edcg_info(M2:C2, class(Methods,Init,Final)),
    Method=..[M|Args],
    lookup_accessor(M, Methods, Meth),
    edcg_info(Meth, method(Args, Old, New, Joiner)),
    update_context(M1:T1, Old, New, Ctx1, Ctx2, E),
    G=(E,Joiner).
expand_goal_(G1, G2, Ctx1, Ctx2) :-
    expand_goal_to_pred_arity(G1, M:G, M:F/N),
    edcg_info(M:F/N, weave(Accs)), !,
    new_body(M:G, Accs, Ctx1, Ctx2, G2).
expand_goal_(G, G, Ctx, Ctx).

new_body(M:G, Accs, Ctx1, Ctx2, M:G2) :-
    G=..[F|Args],
    append(Args,L,XArgs),
    new_body_(Accs,L,Ctx1,Ctx2),
    G2=..[F|XArgs].

new_body_([],[],Ctx,Ctx) :- !.
new_body_([Acc|Accs],[Ini,Fin|L],Ctx1,Ctx2) :-
    update_context(Acc, Ini, Fin, Ctx1, Ctx_, E),
    E,
    new_body_(Accs,L,Ctx_,Ctx2).

update_context(Thread1, Old, New, [Thread2=(I2,O2)|Ctx1], Ctx2, E) :- !,
    (Thread1=Thread2
    -> E=(Old=I2), Ctx2=[Thread2=(New,O2)|Ctx1]
    ; Ctx2=[Thread2=(I2,O2)|Ctx_], update_context(Thread1, Old, New, Ctx1, Ctx_, E)).
update_context(Thread1, _, _, _, _, _) :-
    edcg_error("no such thread in context: ~w", [Thread1]).

lookup_accessor(Name1,[Name2=Meth2|Methods],Meth) :- !,
    (Name1=Name2 -> Meth=Meth2 ; lookup_accessor(Name1, Methods, Meth)).
lookup_accessor(Name, _, _) :-
    edcg_error("unknown accessor: ~w", [Name]).

context_equalities([],[], true).
context_equalities([A=(I,O)|L], [A=(I2,O2)|L2], (I=I2,O=O2,E2)) :-
    context_equalities(L, L2, E2).

context_extend((E1,E2), Ctx1, Ctx2, N) :- !,
    context_extend(E1, Ctx1, Ctx_, N1),
    context_extend(E2, Ctx_, Ctx2, N2),
    N is N1+N2.
context_extend(M:E, Ctx1, Ctx2, 1) :- !,
    E=..[T|Args],
    expand_thread(M:T, M2:T2),
    edcg_info(M2:T2, thread(M3:C3)),
    edcg_info(M3:C3, class(_,Init,Final)),
    (Args=[]
    -> (context_extend_get_init(M2:T2,Init,I),
	Ctx2=[M2:T2=(I,Final)|Ctx1])
    ; (Args=[Fin]
      -> (context_extend_get_init(M2:T2,Init,I),
	  Ctx2=[M2:T2=(I,Fin)|Ctx1])
      ; (Args=[Ini,Fin]
	-> Ctx2=[M2:T2=(Ini,Fin)|Ctx1]))).
context_extend(E, Ctx1, Ctx2, N) :-
    E=..[T|Args],
    expand_thread(T, M2:T2),
    E2=..[T2|Args],
    context_extend(M2:E2, Ctx1, Ctx2, N).

context_extend_get_init(Thread,value(X),Y) :-
    !, (X=Y -> true; edcg_error("this should never happen (1)")).
context_extend_get_init(Thread,no_value,_) :-
    !, edcg_error("thread requires an init value: ~w", [Thread]).
context_extend_get_init(Thread,_,_) :-
    edcg_error("this should never happen (2)").

context_reduce(N, [_=(X,Y)|Ctx1], Ctx2, (X=Y,E)) :-
    N>0, !, N2 is N-1, context_reduce(N2, Ctx1, Ctx2, E).
context_reduce(0, Ctx, Ctx, true).

%% ============================================================================
%% PLUG EDCG TERM EXPANSION INTO PROLOG MACHINERY
%% ============================================================================

%term_expansion(C, _) :-
%    (C=(H:-_) -> true; H=C), XXXX.

:- multifile user:term_expansion/2.
user:term_expansion(X,Y) :- edcg:term_expansion(X,Y).
    

%% ============================================================================
%% PREDEFINED CLASSES
%% ============================================================================

:- edcg:method( noop, Old, New, Old=New ).
:- edcg:method( set(X), Old, New, New=X ).
:- edcg:method( get(X), Old, New, (X=Old, New=Old) ).
:- edcg:method( incr, Old, New, New is Old+1 ).
:- edcg:method( decr, Old, New, New is Old-1 ).
:- edcg:method( add(X), Old, New, New is Old+X ).
:- edcg:method( sub(X), Old, New, New is Old-X ).
:- edcg:method( mul(X), Old, New, New is Old*X ).
:- edcg:method( div(X), Old, New, New is Old//X ).
:- edcg:method( push(X), Old, New, New=[X|Old] ).
:- edcg:method( pop(X), Old, New, Old=[X|New] ).
:- edcg:method( top(X), Old, New, (Old=[X|_], Old=New) ).
:- edcg:method( enq(X), Old, New, (Old=(H1-[X|T2]), New=(H1-T2)) ).
:- edcg:method( enq_list(List), Old, New, (lists:append(List,T2,T1), Old=(H1-T1), New=(H1-T2)) ).
:- edcg:method( empty, Old, New, (Old==[], New=Old) ).
:- edcg:method( emptyq, Old, New, (Old=(H-T), H==T, New=Old) ).
:- edcg:method( deq(X), Old, New, (Old=(H-T), H\==T, H=[X|H2], New=(H2-T)) ).
:- edcg:method( topq(X), Old, New, (Old=(H-T), H\==T, H=[X|_], New=Old) ).
:- edcg:method( append(X), Old, New, Old=[X|New] ).
:- edcg:method( extend(L), Old, New, lists:append(L, New, Old) ).
:- edcg:method( close(X), Old, New, (X=Old, New=Old) ).
:- edcg:method( sclose(X), Old, New, (X=Old, Old=New) ).
:- edcg:method( qclose(X), Old, New, (Old=(X-[]), New=Old) ).
:- edcg:method( lclose, Old, New, (Old=[], New=[]) ).
%% assoc tables
:- edcg:method( tput(K,V), Old, New,  xmg_table:table_put(Old,K,V,New) ).
:- edcg:method( tdel(K), Old, New,  xmg_table:table_delete(Old,K,New) ).
:- edcg:method( tget(K,V), Old, New, (xmg_table:table_get(Old,K,V), New=Old) ).

:- edcg:method( drop, Old, New, (Old=[]) ).


:- edcg:class( value,   [set, get, put=set, noop, close=noop, value=get] ).
:- edcg:class( counter, [set, get, incr, decr, add, sub, mul, put=set, noop, close=noop, value=get], 0 ).
:- edcg:class( stack,   [push, pop, top, put=push, get=pop, pops=extend, empty=empty, noop, drop, close=sclose, value=get, set], [] ).
:- edcg:class( queue,   [enq, enq_list, deq, top=topq, pop=deq, put=enq, get=deq, empty=emptyq, noop, close=qclose, value=get], H-H, Q-[] ).
:- edcg:class( list,    [append, extend, put=append, noop, close=lclose, value=get, default=extend], _, [] ).
:- edcg:class( table,   [tget, tput, tdel, get, set] ).

