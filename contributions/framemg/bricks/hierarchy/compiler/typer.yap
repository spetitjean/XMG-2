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

:-module(xmg_brick_hierarchy_typer).
:-dynamic(hierarchy/3).
:-dynamic(xmg:fconstraint/3).

build_matrix(Matrix):-
	xmg:send(info,'\nBuilding vectors for types '),
	findall(Type,xmg:ftype(Type),Types),
	ordsets:list_to_ord_set(Types,OTypes),
	xmg:send(info,OTypes),
	
	%% should do this with tables
	build_indices_mappings(OTypes,TypeMap,ITypeMap,1),
	build_vectors(OTypes,Vectors,OTypes),
	xmg:send(info,Vectors),

	xmg:send(info,'\nBuilding matrix\n'),
	compute_matrix(Vectors,Matrix),
	xmg:send(info,Matrix),
	asserta(xmg:ftypeMatrix(Matrix)),
	asserta(xmg:ftypeMap(TypeMap)),
	asserta(xmg:ftypeIMap(ITypeMap)).

build_indices_mappings([],[],[],_).
build_indices_mappings([Type|Types],[Type-N|TypesMap],[N-Type|ITypesMap],N):-
	M is N + 1,
	build_indices_mappings(Types,TypesMap,ITypesMap,M).

build_vectors([],[],_).
build_vectors([Type|Types],[Vector|Vectors],Ts):-
	xmg:send(info,'\nBuilding vector for type '),
	xmg:send(info,Type),
	build_vector(Type,Vector,Ts),
	build_vectors(Types,Vectors,Ts).

build_vector(Type,[],[]).
build_vector(Type,[Val|Vals],[Type1|Types]):-
	subsumes(Type,Type1,Val),
	build_vector(Type,Vals,Types).

subsumes(Type,Type,1):-
	!.
subsumes(Type,Type1,1):-
	xmg:fconstraint(Type1,super,Type),
	!.
subsumes(Type,Type1,0).

compute_matrix(Vectors,Matrix):-
	xmg_brick_hierarchy_boolMatrix:fixpoint(Vectors,Matrix).

type_fconstraint(Type,Must,Cant,Super,Comp):-
	%% this should be independant
	assert_type(Type),

	assert_constraints(Type,must,Must),
	assert_constraints(Type,cant,Cant),
	assert_constraints(Type,super,Super),
	assert_constraints(Type,comp,Comp),
	!.

assert_type(Type):-
	asserta(xmg:ftype(Type)).

assert_constraints(Type,TConst,[]):-!.
assert_constraints(Type,TConst,[H|T]):-
	assert_constraint(Type,TConst,H),
	assert_constraints(Type,TConst,T),!.

assert_constraint(Type,TConst,Id):-
	xmg:send(info,'\nAssert '),
	xmg:send(info,Type),
	xmg:send(info,TConst),
	xmg:send(info,Id),
	
	asserta(xmg:fconstraint(Type,TConst,Id)),!.











type_hierarchy(_,[]):- !.
type_hierarchy(Type,[ID1-ID2|T]):-
	asserta(hierarchy(Type,ID1,ID2)),
	xmg:send(info,hierarchy(Type,ID1,ID2)),
	type_hierarchy(Type,T),!.

subtype(Type,T1,T2):-
	%%xmg_compiler:send(info,'  calling subtype  \n'),
	hierarchy(Type,T1,T2),!.
subtype(Type,T1,T2):-
	hierarchy(Type,T3,T2),
	subtype(Type,T1,T3),
	!.