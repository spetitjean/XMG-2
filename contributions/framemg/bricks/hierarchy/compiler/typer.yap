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
:-dynamic(xmg:ftypes/1).
:-dynamic(xmg:fReachableType/2).
:-dynamic(xmg:fAttrConstraint/2).
:-dynamic(xmg:fAttrConstraint/4).
:-dynamic(xmg:fPathConstraint/4).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Getting the hierarchy from the constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% convert a type list to a vector (with _) and a constant vector (with 0)

fTypeToVector(Type,SVector,FVector):-
	xmg:ftypes(Types),
	typeExists(Type,Types),
	fTypeToSomeVector(Type,Types,Vector),
	xmg:send(info,Vector),
	find_smaller_supertype(Vector,SVector,FVector),
	!.
fTypeToVector(Type,SVector,FVector):-
	not(xmg:ftypes(Types)),
	xmg:send(info,'\n\nError: no frame type was defined'),
	false.

find_smaller_supertype(Vector,FVector,SVector):-
	find_smaller_supertype_from(Vector,SVector,0),
	xmg:send(info,SVector),
	replace_zeros(SVector,FVector),
	!.

find_smaller_supertype_from(Vector,Vector,N):-
	xmg:fReachableType(Vector,N),!.
find_smaller_supertype_from(Vector,SVector,N):-
	M is N +1,
	find_smaller_supertype_from(Vector,SVector,M),!.
find_smaller_supertype_from(Vector,_,_):-
	xmg:send(info,'\nDid not find supertype for vector '),
	xmg:send(info,Vector),false.

typeExists(Type,Types):-
	var(Type),!.
typeExists(Type,Types):-
	lists:member(Type,Types),!.
typeExists(Type,Types):-
	xmg:send(info,'\n\nError: '),
	xmg:send(info,Type),
	xmg:send(info,' is not a type.'),false.

replace_zeros([],[]).
replace_zeros([0|T],[_|T1]):-
	replace_zeros(T,T1),!.
replace_zeros([1|T],[1|T1]):-
	replace_zeros(T,T1),!.

fTypeToSomeVector(_,[],[]).
fTypeToSomeVector(Type,[_|Types],[_|Vector]):-
	var(Type),
	fTypeToSomeVector(Type,Types,Vector).
fTypeToSomeVector(Type,[Type|Types],[1|Vector]):-
	fTypeToSomeVector(Type,Types,Vector),!.
fTypeToSomeVector(Type,[_|Types],[_|Vector]):-
	fTypeToSomeVector(Type,Types,Vector),!.

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
constraints_to_vectors([H|T],Types,Vectors):-
	constraint_to_vectors(H,Types,H1),
	constraints_to_vectors(T,Types,T1),
	lists:append(H1,T1,Vectors).


%% each symbol on the left means: put a 1 in for this symbol
%% each symbol on the right means: create a new vector with 0 in this symbol's column (and the 1s from the left).
%% true on the right or false on the left means: Vector is [_,_..._]
%% false on the right or true on the left means: put nothing


constraint_to_vectors(fconstraint(implies,Ts1,Ts2),Types,Vectors):-
	init_vector(Types,Vector),
	set_to_left(Ts1,Types,Vector),
	set_to_right(Ts2,Types,Vector,Vectors),!.

constraint_to_vectors(fconstraint(is_equivalent,Ts1,Ts2),Types,Vectors):-
	constraint_to_vectors(fconstraint(implies,Ts1,Ts2),Types,Vectors1),
	constraint_to_vectors(fconstraint(implies,Ts2,Ts1),Types,Vectors2),	
	lists:append(Vectors1,Vectors2,Vectors),
	!.

constraint_to_vectors(C,_,_):-
	xmg:send(info,'\nCould not translate constraint '),
	xmg:send(info,C),
	
	false.

init_vector([],[]).
init_vector([_|T],[_|T1]):-
	init_vector(T,T1),!.

set_to_left([],Types,Vector).
set_to_left([Type1|Types1],Types,Vector):-
	is_type(Type1),
	set_to_left(Type1,Types,Vector),
	set_to_left(Types1,Types,Vector),!.


%% for right side with multiple symbols, need to return a list of vectors (ToDo)
set_to_right([],Types,Vector,[]).
set_to_right([Type1|Types1],Types,Vector,[RVector|Vectors]):-
	is_type(Type1),
	set_to_right(Type1,Types,Vector,RVector),
	set_to_right(Types1,Types,Vector,Vectors),
	!.

is_type(true):-!.
is_type(false):-!.
is_type(T):-
	xmg:ftype(T),!.
is_type(T):-
	not(xmg:ftype(T)),
	xmg:send(info,'\n\nError: '),
	xmg:send(info,T),
	xmg:send(info,' is not a ftype.'),
	false.




set_to_left(true,[Type|T],[_|T1]):-!.
set_to_left(Type,[Type|T],[1|T1]):-!.

set_to_left(Type,[_|T],[_|T1]):-
	set_to_left(Type,T,T1),!.
set_to_left(Type,Types,Vector):-
	xmg:send(info,'\n\nCould not set on left to value '),
	xmg:send(info,Type),
	xmg:send(info,Types),
	xmg:send(info,Vector),
	false.

set_to_right(false,[Type|T],[V1|VT],[V1|VT]):-!.
set_to_right(Type,[Type|T],[V1|VT],[0|VT]):-!.
set_to_right(Type,[_|T],[V1|VT],[V1|VT1]):-
	set_to_right(Type,T,VT,VT1),!.
set_to_right(Type,Types,Vector,Vectors):-
	xmg:send(info,'\n\nCould not set on right to value '),
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
%% Handling attribute constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

attrConstraints_to_vectors([],_,[]).
attrConstraints_to_vectors([A|AT],Types,[A1|AT1]):-
	attrConstraint_to_vector(A,Types,A1),
	attrConstraints_to_vectors(AT,Types,AT1),!.

attrConstraint_to_vector(attrconstraint(implies,Ts1,Attr,Value),Types,(Vector,Attr-CValue)):-
	attr_value(Value,CValue),
	init_vector(Types,Vector),
	set_to_left(Ts1,Types,Vector),
	!.

attrConstraint_to_vector(pathconstraint(implies,Ts1,Attr1,Attr2),Types,(Vector,Attr1,Attr2)):-
	attr_value(Value,CValue),
	init_vector(Types,Vector),
	set_to_left(Ts1,Types,Vector),
	!.

attr_value(true,_):-!.
attr_value(Value,Value).

generate_vectors_attrs([],_):- !.
generate_vectors_attrs([V1|VT],AttConstraints):- 
	generate_vector_attrs(V1,AttConstraints,Feats),
	asserta(xmg:fattrconstraint(V1,Feats)),

	xmg:send(info,'\nAsserted '),
	xmg:send(info,xmg:fattrconstraint(V1,Feats)),

	generate_vectors_attrs(VT,AttConstraints),!.

generate_vector_attrs(Vector,[],[]):-!.
%% path constraints
generate_vector_attrs(Vector,[(AVector,A1,A2)|ACT],[A1-V,A2-V|ACT1]):-
	not(not(Vector=AVector)),
	generate_vector_attrs(Vector,ACT,ACT1),!.
generate_vector_attrs(Vector,[(AVector,_,_)|ACT],ACT1):-
	generate_vector_attrs(Vector,ACT,ACT1),!.	
%% attribute constraints
generate_vector_attrs(Vector,[(AVector,Feat)|ACT],[Feat|ACT1]):-
	not(not(Vector=AVector)),
	generate_vector_attrs(Vector,ACT,ACT1),!.
generate_vector_attrs(Vector,[(AVector,Feat)|ACT],ACT1):-
	generate_vector_attrs(Vector,ACT,ACT1),!.


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






type_ftype(Type):-
	assert_type(Type),!.



type_fconstraint(CT,types(Ts1),types(Ts2)):-
	asserta(xmg:fConstraint(CT,Ts1,Ts2)),!.

type_fconstraint(CT,types(Ts1),attrType(Attr,Type)):-
	asserta(xmg:fAttrConstraint(CT,Ts1,Attr,Type)),!.

type_fconstraint(CT,types(Ts1),pathEq(Attr1,Attr2)):-
	asserta(xmg:fPathConstraint(CT,Ts1,Attr1,Attr2)),!.



type_fconstraint(CT,C1,C2):-
	xmg:send(info,'\n\nUnsupported constraint:'),
	xmg:send(info,CT),
	xmg:send(info,' with '),
	xmg:send(info,C1),
	xmg:send(info,' and '),
	xmg:send(info,C2),
	false.

%% type_fconstraint(Type,Must,Cant,Super,Comp):-
%% 	%% this should be independant
%% 	assert_type(Type),

%% 	assert_constraints(Type,must,Must),
%% 	assert_constraints(Type,cant,Cant),
%% 	assert_constraints(Type,super,Super),
%% 	assert_constraints(Type,comp,Comp),
%% 	!.

assert_type(Type):-
	xmg:send(info,'\nAsserting type '),
	xmg:send(info,Type),
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