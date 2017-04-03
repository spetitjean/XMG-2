:- module(xmg_utils, [nthq/3]).
:- use_module(lists, [nth/3, length/2]).

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
% implements(Module, Predicate/N)
% checks whether Module provides a clause for Predicate/N.
%==============================================================================

implements(Module, Predicate/N) :-
    length(Args, N),
    PredArgs =.. [Predicate | Args],
    Clause =.. [Module:PredArgs, ':-', _]
    clause(Clause).
