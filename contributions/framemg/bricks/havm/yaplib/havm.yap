%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2013  Simon Petitjean

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

:- module(xmg_brick_havm_havm, [h_avm/3, const_h_avm/2]).

:- use_module(library(atts)).
:- use_module(library(rbtrees)).
:- use_module(library(ordsets)).

:- attribute avmfeats/3.

verify_attributes(Var, Other, Goals) :-
	get_atts(Var, avmfeats(Type1,T1,U)), !,
	var(Other),
	( get_atts(Other, avmfeats(Type2,T2,U)) ->	    
	    unify_types(Type1,Type2,Type3),
	    rb_visit(T1,Pairs),
	    unify_entries(T2,Pairs,T3),
	    put_atts(Other, avmfeats(Type3,T3,U)),
	    %%put_atts(Other, avmfeats(Type1,T3,U)),
	    Goals=[]
	; \+ attvar(Other), Goals=[], put_atts(Other, avmfeats(Type1,T1,U))).

verify_attributes(_, _, []).

unify_entries(T,[],T).
unify_entries(T1,[K-V0|L],T3) :-
	(rb_lookup(K,V1,T1) ->  V0=V1, T1=T2; rb_insert(T1,K,V0,T2)),
	unify_entries(T2,L,T3).


h_avm(X, Type, L) :- var(L), !,
	get_atts(X, avmfeats(Type,T,_)),
	rb_visit(T,L).

h_avm(X, Type, L) :-
	get_constraints(Type,must,Must),
	%%xmg:send(info,Must),
	list_to_rbtree(L,T),
	%%xmg:send(info,T),
	add_must(Must,T,MT),
	%%xmg:send(info,MT),

	put_atts(Y, avmfeats(Type,MT,_)),
	X = Y.

const_h_avm(A,C) :-
	get_atts(A, avmfeats(_, _, C)).
	
attribute_goal(Var, h_avm(Var,Type,L)) :-
	get_atts(Var, avmfeats(Type,T,_)),
	rb_visit(T,L).


get_constraints(Type,_,[]):-
	var(Type),!.
get_constraints(Type,CType,List):-
	findall(A,xmg:fconstraint(Type,CType,A),List),!.

add_must([],L,L).
add_must([H|T],L,NewL):-
	rb_insert(L,H,_,TL),
	add_must(T,TL,NewL),!.
	

unify_types(T,T,T):- !.
unify_types(T1,T2,T):-
	comp_types_types(T1,T2),!,
	%% T1 and T2 should already be ordered set
	ordsets:ord_union(T1,T2,T3),!,
	reduce_set(T3,T),
	%%xmg:send(info,'\nreduced'),
	!.

comp_types_types([],_).
comp_types_types([H|T],Types):-
	comp_type_types(H,Types),
	comp_types_types(T,Types).

comp_type_types(Type,[]).
comp_type_types(Type,[H|T]):-
	comp_type_type(Type,H),
	comp_type_types(Type,T).

comp_type_type(Type,Type).
comp_type_type(Type1,Type2):-
	supertype(Type1,Type2,_),!.
comp_type_type(Type1,Type2):-
	xmg:send(info,'\nError: types '),
	xmg:send(info,Type1),
	xmg:send(info,' and '),
	xmg:send(info,Type2),
	xmg:send(info,' are not compatible.\n '),
	false,
	!.
%% compatible types are also the ones asserted with declarations, or the subtypes or supertypes


reduce_set([],[]).
reduce_set([H|T],[H|RSet]):-
	%%xmg:send(info,'reducing '),
	%%xmg:send(info,H),
	%%xmg:send(info,T),
	remove_supertypes(H,T,RT),!,
	%%xmg:send(info,RT),
	reduce_set(RT,RSet).
%% the set can be reduced when some types are subtypes of others


remove_supertypes(Type,[],[]).
remove_supertypes(Type,[H|T],T1):-
	supertype(Type,H,Type),!,
	remove_supertypes(Type,T,T1).
remove_supertypes(Type,[H|T],[H|T1]):-
	not(supertype(Type,H,Type)),!,
	remove_supertypes(Type,T,T1).

supertype(T1,T2,T2):-
	xmg:fconstraint(T1,super,T2).
supertype(T1,T2,T1):-
	xmg:fconstraint(T2,super,T1).











hierarchy(V0,V1,V0):-
	V0=V1,!.

hierarchy(V0,V1,V1):-
	V0=const(VV0,T),
	V1=const(VV1,T),

	%%xmg_typer:hierarchy(T,VV0,VV1),!.
	xmg_brick_hierarchy_typer:subtype(T,VV0,VV1),!.

hierarchy(V0,V1,V0):-
	V0=const(VV0,T),
	V1=const(VV1,T),

	%%xmg_typer:hierarchy(T,VV1,VV0),!.
	xmg_brick_hierarchy_typer:subtype(T,VV1,VV0),!.

hierarchy(V0,V1,V0):-
	xmg:send(info,'Hierarchy type unification: do not know what to do with '),
	xmg:send(info,V0),
	xmg:send(info,V1),
	false.
	
indent(0).
indent(N):-
	xmg:send(info,' '),
	M is N - 1,
	indent(M),!.

print_h_avm(AVM,Indent):-
	h_avm(AVM,Type,Feats),
	xmg:send(info,'\n'),
	indent(Indent),
	xmg:send(info,'[\n'),
	indent(Indent),
	xmg:send(info,Type),
	xmg:send(info,',\n'),
	print_feats(Feats,Indent),
	indent(Indent),
	xmg:send(info,']\n'),
	!.	

print_feats([],I).
print_feats([A-V|T],I):-
	indent(I),
	xmg:send(info,A),
	xmg:send(info,':'),
	print_value(V,I),
	%%xmg:send(info,'\n'),
	print_feats(T,I).

print_value(AVM,I):-
	J is I +2,
	print_h_avm(AVM,J).
print_value(V,I):-
	xmg:send(info,V),
	xmg:send(info,'\n'),
	!.