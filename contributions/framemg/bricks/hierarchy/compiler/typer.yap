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
:-dynamic(xmg:fConstraint/3).
:-dynamic(xmg:ftypes/1).
:-dynamic(xmg:hierarchy/1).
:-dynamic(xmg:fReachableType/2).
:-dynamic(xmg:fReachableTypes/1).
:-dynamic(xmg:fattrconstraint/2).
:-dynamic(xmg:fAttrConstraint/2).
:-dynamic(xmg:fAttrConstraint/4).
:-dynamic(xmg:fPathConstraint/4).
:-dynamic(xmg:fPathConstraintFromAtts/5).
    
:- xmg:edcg.
:- edcg:using(xmg_brick_mg_typer:type_decls).
%% Have to use threads here

:- use_module(library(gecode)).
:- use_module(library(assoc)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printing the hierarchy (as an appendix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmg:print_appendix:-
    xmg:more_mode,
    init_print_hierarchy,!.

xmg:print_appendix:-
    not(xmg:more_mode),!.

init_print_hierarchy:-
    xmg:send(info,'\n\nInit print hierarchy\n'),
    %%xmg:fReachableTypes(FVectors),
    findall(FReachable,xmg:fReachableType(FReachable,_),FVectors),

    xmg:send(debug,'\nGot reacheable types\n'),
    
    fVectorsToTypesAndAttrs(FVectors,FTypes,FAttrs),
    
    open('.more',write,S,[alias(hierarchy)]),
    write(hierarchy,'<type_info>\n'),
    write(hierarchy,'  <hierarchy>\n'),
    clean_all_attrs(FAttrs,CFAttrs),
    print_hierarchy(FTypes,CFAttrs),
    findall(fconstraint(TC,T1s,T2s),xmg:fConstraint(TC,T1s,T2s),Constraints),
    write(hierarchy,'  <type_constraints>\n'),
    print_type_constraints(Constraints),
    write(hierarchy,'</type_info>\n'),
    close(hierarchy),!.
init_print_hierarchy:-
    xmg:send(info,'\nType hierarchy could not be printed').

clean_all_attrs([],[]).
clean_all_attrs([H|T],[H1|T1]):-
    %%xmg:send(info,'\nConstraints:'),
    %%xmg:send(info,H),
    empty_assoc(Assoc),
    clean_attrs(H,[],Assoc,H1),
    clean_all_attrs(T,T1).

clean_attrs([],_,_,[]):-!.
clean_attrs([H-V|T],Seen,SeenVars,[H-V|T1]):-
    %%xmg:send(info,'\nClean attrs[0]: '),
    %%xmg:send(info,SeenVars),
    
    lists:member(H,Seen),
    get_assoc(H,SeenVars,V1),!,
    V=V1,
    clean_attrs(T,Seen,SeenVars,T1),!.
clean_attrs([H-V|T],Seen,SeenVars,[H-V|T1]):-
    %%xmg:send(info,'\nClean attrs[1]: '),
    %%xmg:send(info,SeenVars),
    put_assoc(H,SeenVars,V,NewSeenVars),
    clean_attrs(T,[H|Seen],NewSeenVars,T1),!.

    

print_hierarchy([],[]):-
        write(hierarchy,'  </hierarchy>\n'),!.
print_hierarchy([H|T],[H1|T1]):-
        write(hierarchy,'    <entry>\n'),
        write(hierarchy,'      <ctype>\n'),
	print_type('ctype',H),
	print_constraints(H1),
	write(hierarchy,'    </entry>\n'),
	print_hierarchy(T,T1).

print_type(Label,[]):-
    write(hierarchy,'      </'),
    write(hierarchy,Label),
    write(hierarchy,'>\n'),!.

print_type(Label,[H|T]):-
    write(hierarchy,'        <type val="'),
    write(hierarchy,H),
    write(hierarchy,'"/>\n'),
    print_type(Label,T),!.
	

print_constraints(C):-
	write(hierarchy,'      <constraints>\n'),
	print_constraints(C,0),
	write(hierarchy,'      </constraints>\n'),!.

print_constraints([],_).
print_constraints([A-(Type,V)|T],N):-
    	write(hierarchy,'        <constraint>\n'),
	print_attribute(A),
	set_constraint_value(V,N,M),
	set_constraint_value(Type,M,O),
	write(hierarchy,'          <type val="'),
	write(hierarchy,Type),
	write(hierarchy,'"/>\n'),
	write(hierarchy,'          <val val="'),
	write(hierarchy,V),
	write(hierarchy,'"/>\n'),	
	write(hierarchy,'        </constraint>\n'),
	print_constraints(T,O),
	!.

print_attribute(path(A1,A2)):-
    write(hierarchy,'          <path>\n'),
    write(hierarchy,'            <attr val="'),
    write(hierarchy,A1),
    write(hierarchy,'"/>\n'),
    write(hierarchy,'            <attr val="'),
    write(hierarchy,A2),
    write(hierarchy,'"/>\n'),
    write(hierarchy,'          </path>\n'),!.
print_attribute(A):-
	write(hierarchy,'          <attr val="'),
	write(hierarchy,A),
	write(hierarchy,'"/>\n'),!.
	
set_constraint_value(A,N,M):-
    var(A),
	%%A=N,
	atomic_concat(['@',N],A),
	M is N+1,!.
set_constraint_value(A,N,M):-
    not(var(A)),
	M is N,!.

print_type_constraints([]):-
    write(hierarchy,'  </type_constraints>\n'),!.

print_type_constraints([fconstraint(CType,Type1,Type2)|T]):-
    write(hierarchy,'    <type_constraint type="'),
    write(hierarchy,CType),
    write(hierarchy,'">\n'),
    write(hierarchy,'      <ctype1>\n'),    
    print_type('ctype1',Type1),
    write(hierarchy,'      <ctype2>\n'),
    print_type('ctype2',Type2),
    write(hierarchy,'    </type_constraint>\n'),
    print_type_constraints(T),!.

    
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hierarchies Declarations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

remove_ftypes([],[]).
remove_ftypes([ftype(H)|T],[H|T1]):-
    %%fTypeToVector(H,_,V),
    remove_ftypes(T,T1),!.

get_fconstraints([]):-
    	xmg:send(debug,'\n\nTypes:'),
        xmg:ftypes(Types),
	xmg:send(debug,Types),
	findall(fconstraint(TC,T1s,T2s),xmg:fConstraint(TC,T1s,T2s),Constraints),
	xmg:send(debug,'\n\nType constraints:'),
	xmg:send(debug,Constraints),
	%%xmg_brick_hierarchy_typer:constraints_to_vectors(Constraints,Types,CVectors),
	
	%%xmg:send(debug,'\n\nConstraint vectors:'),
	%%xmg:send(debug,CVectors),

	solve_types(Types, Constraints, FSets),
	%%xmg:send(info,FSets),!,
	%%build_types(types(Types,FSets,CVectors)),
	
	%% %%filter_sets(Sets,CVectors,FSets),
	assert_sets(FSets),
	%% xmg:send(debug,'\n\nFiltered types:'),
	xmg:send(debug,FSets),
	
	%%asserta(xmg:fReachableTypes(FSets)),
	%%xmg:fReachableTypes(TEST),
	%%xmg:send(info,TEST),false,

	findall(attrconstraint(TAC,TAs,TAT,TATT),xmg:fAttrConstraint(TAC,TAs,TAT,TATT),AttConstraints),

	xmg:send(debug,'\n\nAttr constraints:'),
	xmg:send(debug,AttConstraints),

	findall(pathconstraint(TACP,TAsP,TATP1,TATP2),xmg:fPathConstraint(TACP,TAsP,TATP1,TATP2),PathConstraints),

	xmg:send(debug,'\n\nPath constraints:'),
	xmg:send(debug,PathConstraints),

	lists:append(AttConstraints,PathConstraints,AttPathConstraints),

	xmg_brick_hierarchy_typer:attrConstraints_to_vectors(AttPathConstraints,Types,VAttConstraints),
	xmg:send(debug,'\n\nAttr constraints vectors:'),
	xmg:send(debug,VAttConstraints),
	xmg_brick_hierarchy_typer:generate_vectors_attrs(FSets,VAttConstraints),


	%%xmg_brick_hierarchy_typer:build_matrix(Types,FSets,Matrix),
	!.
get_fconstraints([H|T]):-
	get_fconstraint(H),
	get_fconstraints(T),!.

get_fconstraint(fconstraint(CT,Left,Right)):-
	xmg_brick_hierarchy_typer:type_fconstraint(CT,Left,Right),!.

get_fconstraint(C):-
	xmg:send(info,'\nUnknown fconstraint:\n'),
	xmg:send(info,C),
	false.


get_hierarchies([]):-!.
get_hierarchies([H|T]):-
	get_hierarchy(H),
	get_hierarchies(T),!.
get_hierarchy(hierarchy(Type,Pairs)):-
	xmg_brick_hierarchy_typer:type_hierarchy(Type,Pairs),!.




get_ftypes([]):--!.
get_ftypes([H|T]):--
	get_ftype(H),
	get_ftypes(T),!.
get_ftype(ftype(Type)):--
	xmg_brick_hierarchy_typer:type_ftype(Type),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Getting the hierarchy from the constraints, using constraint programming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve_types(Types, Constraints, List):-
    findall(T,solve(Types,Constraints,T),List),!.

solve(Types, Constraints, Sol):-
    Space:=space,
    create_vector(Space, Types, Vector),
    apply_constraints(Space, Vector, Constraints),
    branch(Space, Vector),
    SolSpace := search(Space),
    get_sol(SolSpace, Vector, Sol).

create_vector(_, [], []).
create_vector(Space, [H|T], [H-H1|T1]):-
    H1 := boolvar(Space),
    create_vector(Space, T, T1),!.

apply_constraints(_, _, []).
apply_constraints(Space, Vector, [H|T]):-
    apply_constraint(Space, Vector, H),
    apply_constraints(Space, Vector, T).


%% Two types of constraints:
%% fconstraint(implies,T1,T2), T1 and T2 lists
%% fconstrains(is_equivalent,T1,T2), T1 and T2 lists
%% fconstraint(implies,List,[false]) is incompatibility between members of List 
apply_constraint(Space, Vector, fconstraint(implies,Ts1,[false])):-
    %% The sum of all booleans must be smaller than the number of all booleans
    gets(Ts1, Vector, Vs1),
    lists:length(Vs1,Length),
    Space += linear(Vs1,'IRT_LE',Length),
    
    !.
apply_constraint(Space, Vector, fconstraint(implies,Ts1,Ts2)):-
    %% Eq is a boolean variable which is true if the sum of all booleans in Ts1 is equal to the arity of Ts1
    %% If Ts1 is true then Ts2 is true (We only support it with one type)
    gets(Ts1, Vector, Vs1),
    lists:length(Vs1,Length),
    gets(Ts2, Vector, Vs2),
    Vs2=[V2],
    R := boolvar(Space),
    Space += linear(Vs1,'IRT_EQ',Length,R),
    Space += rel(V2,'IRT_GQ',R),
    
    
    !.
apply_constraint(Space, Vector, fconstraint(is_equivalent,Ts1,Ts2)):-
    %% Eq1 is a boolean variable which is true if the sum of all booleans in Ts1 is equal to the arity of Ts1
    %% Eq2 is a boolean variable which is true if the sum of all booleans in Ts2 is equal to the arity of Ts2
    %% We must have Eq1=Eq2
    gets(Ts1, Vector, Vs1),
    lists:length(Vs1,Length),
    gets(Ts2, Vector, Vs2),
    Vs2=[V2],
    R := boolvar(Space),
    Space += linear(Vs1,'IRT_EQ',Length,R),
    Space += rel(V2,'IRT_EQ',R),
    
    !.

apply_constraint(Space, Vector, Constraint):-
    xmg:send(info,'\nError: Unsupported constraint - '),
    xmg:send(info,Constraint).


gets([],_,[]).
gets([H|T],Vector,[H1|T1]):-
    get(H,Vector,H1),
    gets(T,Vector,T1).
    

get(A, [A-H|_], H).
get(A, [B-_|T], O):-
    not(A=B),
    get(A, T, O).
get(A, [], _):-
    write('\nError: could not get type '),
    write(A).

branch(Space, []).
branch(Space, [_-V|T]):-
    Space += branch(V,'INT_VAL_MIN'),
    branch(Space, T).

get_sol(Space, [], []).
get_sol(Space, [_-H|T], [H1|T1]):-
    H1:=val(Space,H),
    get_sol(Space, T, T1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Getting the hierarchy from the constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% convert a type list to a vector (with _) and a constant vector (with 0)

fTypeToVector(Type,Type,Type):-
    var(Type),!.
fTypeToVector(Type,SVector,FVector):-
        atom(Type),
	xmg:ftypes(Types),
	typeExists(Type,Types),
	fTypeToSomeVector(Type,Types,Vector),
	xmg:send(debug,Vector),
	find_smaller_supertype(Vector,SVector,FVector),
	!.
%% Type is already a vector
fTypeToVector(Type,SVector,FVector):-
        not(atom(Type)),
	find_smaller_supertype(Type,SVector,FVector),
	!.
fTypeToVector(Type,SVector,FVector):-
        not(xmg:ftypes(Types)),
    	throw(xmg(type_error(no_frame_type))).

find_smaller_supertype(Vector,FVector,SVector):-
    check_hierarchy,
	find_smaller_supertype_from(Vector,SVector,0),
	replace_zeros(SVector,FVector),
			!.

check_hierarchy:-
    xmg:hierarchy(built),!.
check_hierarchy:-
    get_fconstraints([]),!.

find_smaller_supertype_from(Vector,Vector,N):-
    xmg:fReachableType(Vector,N),!.
%% if no constraint is defined, any type is reacheable
find_smaller_supertype_from(Type,Type,0):-
    not(xmg:fReachableType(Anything,Anyotherthing)),
    !.
find_smaller_supertype_from(Vector,SVector,N):-
	M is N +1,
	length(Vector,L),
	M =< L,
	find_smaller_supertype_from(Vector,SVector,M),!.
find_smaller_supertype_from(Vector,_,_):-
	xmg:send(debug,'\nDid not find supertype for vector '),
	xmg:send(debug,Vector),false.


typeExists(Type,Types):-
    var(Type),!.
typeExists(true,Types):-!.
typeExists(Type,Types):-
    lists:member(Type,Types),!.
%% Type is already a vector
%% typeExists([_|_],_):-!.
typeExists(Type,Types):-
	xmg:send(info,'\n\nError: '),
	xmg:send(info,Type),
	xmg:send(info,' is not a type. Types are:\n'),
	xmg:send(info,Types),
	xmg:send(info,'\n'),
	!.
	%%halt.

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

fVectorsToTypesAndAttrs([],[],[]).
fVectorsToTypesAndAttrs([H|T],[H1|T1],[H2|T2]):-
	fVectorToType(H,H1),
	xmg:fattrconstraint(H,H2),
	fVectorsToTypesAndAttrs(T,T1,T2),!.

fVectorToType(Vector,Type):-
    %%find_smaller_supertype_from(Vector,SVector,0),
	xmg:send(debug,'Converting vector '),
	xmg:send(debug,Vector),
	%%xmg:send(debug,SVector),
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

assert_types(OTypes):-
	%% get the list of elementary types
	findall(Type,xmg:ftype(Type),Types),
	ordsets:list_to_ord_set(Types,OTypes),
	asserta(xmg:ftypes(OTypes)),
	xmg:send(debug,'\nTypes are '),
	xmg:send(debug,OTypes),!.

build_types(types(OTypes,Sets,Constraints)):-
	%% build all set combination of these elementary types
	findall(Set,build_set(OTypes,Set,Constraints),Sets),!.

build_set(OTypes,Set,Constraints):-
    build_set_1(OTypes,Set),
    not(filter_set(Set,Constraints)).

build_set_1([],[]).
build_set_1([_|T],[Bool|T1]):-
	build_bool(Bool),
	build_set_1(T,T1).

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
	halt.




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

%% %% filtering sets by giving the shape of forbidden sets

%% filter_sets([],_,[]).
%% filter_sets([Set|Sets],Constraints,Sets1):-
%% 	filter_set(Set,Constraints),!,
%% 	filter_sets(Sets,Constraints,Sets1),!.
%% filter_sets([Set|Sets],Constraints,[Set|Sets1]):-
%% 	count_ones(Set,Len),
%% 	assert_valid_type(Set,Len),
%% 	filter_sets(Sets,Constraints,Sets1),!.

assert_sets([]).
assert_sets([Set|Sets]):-
	count_ones(Set,Len),
	assert_valid_type(Set,Len),
	assert_sets(Sets),!.

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
%%    Len>0,
	xmg:send(debug,'\nValid type: '),
	xmg:send(debug,Set),
	xmg:send(debug,Len),
	asserta(xmg:fReachableType(Set,Len)),
	!.
%%assert_valid_type(_,0).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Handling attribute constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

attrConstraints_to_vectors([],_,[]).
attrConstraints_to_vectors([A|AT],Types,[A1|AT1]):-
	attrConstraint_to_vector(A,Types,A1),
	attrConstraints_to_vectors(AT,Types,AT1),!.

attrConstraint_to_vector(attrconstraint(implies,Ts1,Path,Value),Types,(Vector,TPath-CValue)):-
    attr_value(Value,CValue),
    transform_path(Path,TPath),
	init_vector(Types,Vector),
	set_to_left(Ts1,Types,Vector),
	!.

attrConstraint_to_vector(pathconstraint(implies,Ts1,Path1,Path2),Types,(Vector,TPath1,TPath2)):-
    %%attr_value(Value,CValue),
    transform_path(Path1,TPath1),
    transform_path(Path2,TPath2),    
	init_vector(Types,Vector),
	set_to_left(Ts1,Types,Vector),
	!.

transform_path([Att],Att):- !.
transform_path([H|T],path(H,T1)):-
    transform_path(T,T1),!.

attr_value(true,_):-!.
attr_value(Value,Value).

generate_vectors_attrs([],_):- !.
generate_vectors_attrs([V1|VT],AttConstraints):-
        %%xmg:send(info,'\nGenerating vectors attrs '),
	%%xmg:send(info,V1),
	%%xmg:send(info,AttConstraints),

	generate_vector_attrs(V1,AttConstraints,Feats),
	asserta(xmg:fattrconstraint(V1,Feats)),

	%%xmg:send(info,'\nAsserted '),
	%%xmg:send(info,xmg:fattrconstraint(V1,Feats)),

	generate_vectors_attrs(VT,AttConstraints),!.

generate_vector_attrs(Vector,[],[]):-!.
%% path constraints
generate_vector_attrs(Vector,[(AVector,A1,A2)|ACT],ACT2):-
	not(not(Vector=AVector)),
	generate_vector_attrs(Vector,ACT,ACT1),
	insert(A1-(_,V),ACT1,ACTT),
	insert(A2-(_,V),ACTT,ACT2),!.
generate_vector_attrs(Vector,[(AVector,_,_)|ACT],ACT1):-
	generate_vector_attrs(Vector,ACT,ACT1),!.	
%% attribute constraints
generate_vector_attrs(Vector,[(AVector,Feat)|ACT],ACT2):-
	not(not(Vector=AVector)),!,
	generate_vector_attrs(Vector,ACT,ACT1),
	%%xmg:send(debug,'\n Adding '),
	%%xmg:send(debug,Feat),
	Feat=Att-Type,
	%%xmg:send(info,'\nInserting: '),
	%%xmg:send(info,Feat),
	%%xmg:send(info,' in '),
	%%xmg:send(info,ACT1),
	insert(Att-(Type,_),ACT1,ACT2),
	%%xmg:send(info,'\n -> '),
	%%xmg:send(info,ACT2),
	%%xmg:send(debug,ACT2),
	!.
generate_vector_attrs(Vector,[(AVector,Feat)|ACT],ACT1):-
	generate_vector_attrs(Vector,ACT,ACT1),!.

insert(Feat,[],[Feat]).
insert(A-V,[A-V1|T],[A-V1|T]):-
    V=(VV,_),
    V1=(VV1,_),
        not(var(VV)),
	not(var(VV1)),
	V=V1,!.
insert(A-V,[A-V1|T],[A-V,A-V1|T]):-
	not(V=V1),!.
insert(A-V,[B|T],[B|T1]):-
	insert(A-V,T,T1),!.

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
	%%xmg:send(info,'\nBuilding vector for type '),
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

type_fconstraint(CT,attrType(Attr,Type),pathEq(Attr1,Attr2)):-
	asserta(xmg:fPathConstraintFromAtts(CT,Attr,Type,Attr1,Attr2)),!.




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
	xmg:send(debug,'\nAsserting type '),
	xmg:send(debug,Type),
	asserta(xmg:ftype(Type)).

assert_constraints(Type,TConst,[]):-!.
assert_constraints(Type,TConst,[H|T]):-
	assert_constraint(Type,TConst,H),
	assert_constraints(Type,TConst,T),!.

assert_constraint(Type,TConst,Id):-
	xmg:send(debug,'\nAssert '),
	xmg:send(debug,Type),
	xmg:send(debug,TConst),
	xmg:send(debug,Id),
	
	asserta(xmg:fconstraint(Type,TConst,Id)),!.








%% Old stuff


type_hierarchy(_,[]):- !.
type_hierarchy(Type,[ID1-ID2|T]):-
	asserta(hierarchy(Type,ID1,ID2)),
	xmg:send(debug,hierarchy(Type,ID1,ID2)),
	type_hierarchy(Type,T),!.

subtype(Type,T1,T2):-
	%%xmg_compiler:send(info,'  calling subtype  \n'),
	hierarchy(Type,T1,T2),!.
subtype(Type,T1,T2):-
	hierarchy(Type,T3,T2),
	subtype(Type,T1,T3),
	!.

