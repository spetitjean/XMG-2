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
:-dynamic(xmg:fReachableType/2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Getting the hierarchy from the constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% convert a type list to a vector

fTypeToVector(Type,SVector):-
	xmg:ftypes(Types),
	fTypeToVector(Type,Types,Vector),
	%%xmg:send(info,Vector),
	find_smaller_supertype(Vector,SVector),
	!.

find_smaller_supertype(Vector,FVector):-
	find_smaller_supertype(Vector,SVector,0),
	%%xmg:send(info,SVector),
	replace_zeros(SVector,FVector),
	!.

find_smaller_supertype(Vector,Vector,N):-
	xmg:fReachableType(Vector,N),!.
find_smaller_supertype(Vector,SVector,N):-
	M is N +1,
	find_smaller_supertype(Vector,SVector,M),!.
find_smaller_supertype(Vector,_,_):-
	xmg:send(info,'\nDid not find supertype for vector '),
	xmg:send(info,Vector),false.

replace_zeros([],[]).
replace_zeros([0|T],[_|T1]):-
	replace_zeros(T,T1),!.
replace_zeros([1|T],[1|T1]):-
	replace_zeros(T,T1),!.

fTypeToVector(_,[],[]).
fTypeToVector(Type,[_|Types],[_|Vector]):-
	var(Type),
	fTypeToVector(Type,Types,Vector).
fTypeToVector(Type,[Type|Types],[1|Vector]):-
	fTypeToVector(Type,Types,Vector),!.
fTypeToVector(Type,[_|Types],[_|Vector]):-
	fTypeToVector(Type,Types,Vector),!.

fVectorToType(Vector,Type):-
	xmg:send(info,'Converting vector '),
	xmg:send(info,Vector),
	xmg:ftypes(Types),
	%%xmg:send(info,Types),
	fVectorToType(Vector,Types,Type),!.

fVectorToType([],[],[]).
fVectorToType([V|Vector],[_|Types],Types1):-
	var(V),
	fVectorToType(Vector,Types,Types1),!.
fVectorToType([0|Vector],[_|Types],Types1):-
	fVectorToType(Vector,Types,Types1),!.
fVectorToType([1|Vector],[Type|Types],[Type|Types1]):-
	fVectorToType(Vector,Types,Types1),!.



%% building all possible type sets

build_types(types(OTypes,Sets)):-
	%% get the list of elementary types
	findall(Type,xmg:ftype(Type),Types),
	ordsets:list_to_ord_set(Types,OTypes),
	asserta(xmg:ftypes(OTypes)),
	xmg:send(info,'\nTypes are '),
	xmg:send(info,OTypes),
	%% build all set combination of these elementary types
	findall(Set,build_set(OTypes,Set),Sets),!.

build_set([],[]).
build_set([_|T],[Bool|T1]):-
	build_bool(Bool),
	build_set(T,T1).

build_bool(0).
build_bool(1).

%% generate exclusion vectors from the constraints
constraints_to_vectors([],Types,[]).
constraints_to_vectors([H|T],Types,[H1|T1]):-
	constraint_to_vector(H,Types,H1),
	constraints_to_vectors(T,Types,T1).

constraint_to_vector(incomp(T1,T2),Types,Vector):-
	init_vector(Types,Vector),
	set_to(1,T1,Types,Vector),
	set_to(1,T2,Types,Vector),!.
constraint_to_vector(implies(T1,T2),Types,Vector):-
	init_vector(Types,Vector),
	set_to(1,T1,Types,Vector),
	set_to(0,T2,Types,Vector),!.
constraint_to_vector(implies(T1,T2,T3),Types,Vector):-
	init_vector(Types,Vector),
	set_to(1,T1,Types,Vector),
	set_to(1,T2,Types,Vector),
	set_to(0,T3,Types,Vector),
	!.
constraint_to_vector(C,_,_):-
	xmg:send(info,'\nCould not translate constraint '),
	xmg:send(info,C),
	
	false.

init_vector([],[]).
init_vector([_|T],[_|T1]):-
	init_vector(T,T1),!.

set_to(Val,Type,[Type|T],[Val|T1]):-!.
set_to(Val,Type,[_|T],[_|T1]):-
	set_to(Val,Type,T,T1),!.
set_to(Val,Type,Types,Vector):-
	xmg:send(info,'\nCould not set to value '),
	xmg:send(info,Val),
	xmg:send(info,Type),
	xmg:send(info,Types),
	xmg:send(info,Vector),
	false.


%% filtering sets by giving the shape of forbidden sets

filter_sets([],_,[]).
filter_sets([Set|Sets],Constraints,Sets1):-
	filter_set(Set,Constraints),!,
	filter_sets(Sets,Constraints,Sets1),!.
filter_sets([Set|Sets],Constraints,[Set|Sets1]):-
	count_ones(Set,Len),
	assert_valid_type(Set,Len),
	filter_sets(Sets,Constraints,Sets1),!.

count_ones([],0).
count_ones([1|T],M):-
	count_ones(T,N),
	M is N + 1,!.
count_ones([0|T],N):-
	count_ones(T,N),!.


%% should succeed if Set matches one of the shapes in Constraints
filter_set(Set,[Constraint|_]):-
	not(not(Set=Constraint)).
filter_set(Set,[Constraint|T]):-
	filter_set(Set,T).

assert_valid_type(Set,Len):-
	xmg:send(info,'\nValid type: '),
	xmg:send(info,Set),
	xmg:send(info,Len),
	asserta(xmg:fReachableType(Set,Len)),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Getting the unification rules from the hierarchy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


build_matrix(Types,FSet,Matrix):-
	xmg:send(info,'\nElementary types:'),
	xmg:send(info,Types),
	xmg:send(info,'\nType sets:'),
	xmg:send(info,FSet),


	build_sets_mappings(Types,FSet,Sets,Map,IMap,1),

	xmg:send(info,'\nBuilding vectors for types '),
	%% findall(Type,xmg:ftype(Type),Types),
	%% ordsets:list_to_ord_set(Types,OTypes),
	xmg:send(info,Sets),
	
	%% should do this with tables
	%%build_indices_mappings(OTypes,TypeMap,ITypeMap,1),
	build_vectors(Sets,Vectors,Sets),
	xmg:send(info,Vectors),

	xmg:send(info,'\nBuilding matrix\n'),
	compute_matrix(Vectors,Matrix),
	xmg:send(info,Matrix),
	asserta(xmg:ftypeMatrix(Matrix)),
	asserta(xmg:ftypeMap(Map)),
	asserta(xmg:ftypeIMap(IMap)).

build_sets_mappings(_,[],[],[],[],_).
build_sets_mappings(Types,[H|T],[Set|Sets],[Set-N|Maps],[N-Set|Imaps],N):-
	vector_to_set(Types,H,Set),
	M is N+1,
	build_sets_mappings(Types,T,Sets,Maps,IMaps,M),!.

vector_to_set([],[],[]).
vector_to_set([Type|Types],[1|Vector],[Type|Set]):-
	vector_to_set(Types,Vector,Set),
	!.
vector_to_set([Type|Types],[0|Vector],Set):-
	vector_to_set(Types,Vector,Set),
	!.

%% build_indices_mappings([],[],[],_).
%% build_indices_mappings([Type|Types],[Type-N|TypesMap],[N-Type|ITypesMap],N):-
%% 	M is N + 1,
%% 	build_indices_mappings(Types,TypesMap,ITypesMap,M).

build_vectors([],[],_).
build_vectors([Type|Types],[Vector|Vectors],Ts):-
	xmg:send(info,'\nBuilding vector for type '),
	%%xmg:send(info,Type),
	build_vector(Type,Vector,Ts),
	%%xmg:send(info,Vector),
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








%% Old stuff


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