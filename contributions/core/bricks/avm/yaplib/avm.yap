%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2011  Simon Petitjean

%%  This program is free software: you can redistribute it and/or modify
%%  it under the terms of the GNU General Public License as published by
%%  the Free Software Foundation, either version 3 of the License, or
%%  (at your option) any later version.

%%  This program is distributed in the hope that it will be useful,
%%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%  GNU General Public License for more details.

%%  You should have received a copy of the GNU General Public License
%%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%% ========================================================================

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
	put_atts(X, avmfeats(TT,C))),!.
avm_dot(X,F,V):-
    xmg:send(debug,'\nDot error: no value for attribute '),
    xmg:send(debug,F),
    false.


cavm_dot(cavm(T),F,V) :-        %% should signal an error if not applicable
    rb_lookup(F,V,T).
cavm_dot(cavm(X),F,V):-
    xmg:send(debug,'\nDot error: no value for attribute '),
    xmg:send(debug,F),
    false.

%% ============================================================================
%% DEBUGGING
%% ============================================================================

xmg:send_others(I,AVM):-
    attvar(AVM),
    print_avm(I,AVM),!.

print_avm(I):-
    print_avm(debug,I),!.

print_avm(I,AVM):-
    avm(AVM,LAVM),!,
    xmg:send(I,'\n'),
    xmg:send(I,'['),
    print_inside(I,LAVM),
    xmg:send(I,']'),!.
print_avm(I,AVM):-
    xmg_brick_adisj_adisj:adisj(AVM,LAVM),
    xmg:send(I,LAVM),!.
print_avm(I,AVM):-
    xmg:send(I,AVM),!.

print_inside(I,[]):- !.
print_inside(I,[A-V|T]):-
    xmg:send(I,A),
    xmg:send(I,':'),
    print_avm(I,V),
    print_inside(I,T),!.
