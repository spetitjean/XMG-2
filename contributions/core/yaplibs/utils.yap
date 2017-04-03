:- module(xmg_utils, [nthq/3, memberq/2, implements/2, zip/3, zip/4, zip/5]).
:- use_module(library(lists), [nth/3, length/2]).
:- use_module(library(apply), [maplist/3, maplist/4, maplist/5]).

%==============================================================================
% nthq(Index, List, Elem)
% like nth/3 except that when Index is a variable, it uses == rather than =
% to locate the Elem in the List.  In other words: in doesn't do unification,
% it checks for identity.  This is inportant when different Elems could unify
% but are not identical.
%==============================================================================

nthq(Index, List, Elem) :-
    var(Index)
    -> nthq_find(  Index, List, Elem, 1)
    ;  nthq_lookup(Index, List, Elem).

nthq_find(Index, [H|T], Elem, I) :-
    H==Elem
    -> Index=I
    ; J is I+1, nthq_find(Index, T, Elem, J).

nthq_lookup(Index, [H|T], Elem) :-
    Index=1
    -> H=Elem
    ; J is Index-1, nthq_lookup(J, T, Elem).

%==============================================================================
% memberq(Elem, List)
% like member/2 but uses == instead of =
%==============================================================================

memberq(Elem, [H|T]) :-
    Elem==H -> true ; memberq(Elem, T).

%==============================================================================
% implements(Module, Predicate/N)
% checks whether Module provides a clause for Predicate/N.
%==============================================================================

implements(Module, Predicate/N) :-
    length(Args, N),
    PredArgs =.. [Predicate | Args],
    Clause =.. [Module:PredArgs, ':-', _]
    clause(Clause).


%==============================================================================
% zip(L1, L2, Out)
% zip(L1, L2, L3, Out)
% zip(L1, L2, L3, L4, Out)
%   Out is the list of tuples of elements of same index of the Lis.
%==============================================================================

zip(L1, L2, Out) :- maplist(mk_tuple2, L1, L2, Out).
zip(L1, L2, L3, Out) :- maplist(mk_tuple3, L1, L2, L3, Out).
zip(L1, L2, L3, L4, Out) :- maplist(mk_tuple4, L1, L2, L3, L4, Out).

mk_tuple2(X1, X2, (X1,X2)).
mk_tuple3(X1, X2, X3, (X1,X2,X3)).
mk_tuple4(X1, X2, X3, X4, (X1,X2,X3,X4)).
