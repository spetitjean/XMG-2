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
	    unify_types(Type1,Type2,Type3,CType3),
	    %%check_type(Type1),
	    get_attrconstraints(CType3,Must),
	    rb_visit(T1,Pairs),
	    lists:append(Must,Pairs,PairsMust),
	    list_to_rbtree(PairsMust,RPairsMust),
	    add_feat_constraints(RPairsMust,Final),
	    add_feat_constraints(Final,Final1),
	    rb_visit(Final1,LFinal1),	    
	    %%xmg:send(info,'\n\nUnifying entries: '),
	    
	    %%xmg:send(info,T2),
	    
	    %%xmg:send(info,LFinal1),
	    
	    unify_entries(T2,LFinal1,T3),
	    
	    get_atts(Other,avmfeats(TypeC,TC,UC)),
	    rb_visit(TC,LTC),
	    %%xmg:send(info,'\nhas the type changed? '),
	    %%xmg:send(info,LTC),
	    (not(TC=T2)->(
			  rb_visit(T3,T3List),     
		 unify_entries(TC,T3List,T33));T3=T33),
		 	    
	    add_feat_constraints(T33,FinalT3),
	    unify_types(TypeC,Type3,FinalType,_),
	    

	    put_atts(Other, avmfeats(FinalType,FinalT3,U)),
	    %%put_atts(Other, avmfeats(Type1,T3,U)),    

	    Goals=[]
	; \+ attvar(Other), Goals=[], put_atts(Other, avmfeats(Type1,T1,U))).

verify_attributes(_, _, []).

unify_entries(T,[],T).
unify_entries(T1,[K-V0|L],T3) :-
	(rb_lookup(K,V1,T1) ->  V0=V1,T1=T2 ; rb_insert(T1,K,V0,T2)),
	unify_entries(T2,L,T3).


h_avm(X, Type, L) :- var(L), !,
	xmg:send(debug,'\nGetting atts for havm '),
	xmg:send(debug,X),
	xmg:send(debug,' with given type '),
	xmg:send(debug,Type),
	get_atts(X, avmfeats(Type,T,_)),
	rb_visit(T,L),
	xmg:send(debug,'\nType is now '),
        xmg:send(debug,Type).

h_avm(X, Type, L) :-
        xmg:send(debug,'\nCreating havm '),
	xmg:send(debug,X),
	xmg:send(debug,' with given type '),
	xmg:send(debug,Type),
	xmg:send(debug,'\nConverting '),
	xmg:send(debug,Type),
	
	xmg_brick_hierarchy_typer:fTypeToVector(Type,Vector,CVector),

	xmg:send(debug,' to '),
	xmg:send(debug,Vector),		

	(var(CVector)->
	     true;
	 get_attrconstraints(CVector,Must)
	),
	
	list_to_rbtree(L,T),
	%%xmg:send(info,T),

	(var(Must)->
	     MT=T;
	 add_must(Must,T,MT)
	),
	
	!,

	%% two passes, in case something happens deeper in the structure
	add_feat_constraints(MT,Final),
	add_feat_constraints(Final,Final1),

	
	put_atts(Y, avmfeats(Vector,Final1,_)),

	X = Y.


%% MT should be a RB TREE and return a RB TREE
add_feat_constraints(MT,Final):-
    xmg:send(debug,'\nStarting add_feat_constraints: '),
    xmg:send(debug,MT),
    check_feat_constraints(MT,MT,ToApply,N),
    xmg:send(debug,'\nToApply:'),
    xmg:send(debug,ToApply),

    xmg_brick_hierarchy_typer:generate_vector_attrs(_,ToApply,Feats),
    xmg:send(debug,Feats),
	create_attr_types(Feats,CToApply),

	xmg:send(debug,'\nCToApply: '),
	xmg:send(debug,CToApply),
	xmg_brick_avm_avm:avm(E,CToApply),

	merge_feats(CToApply,CToApply,MToApply),
	
	xmg:send(debug,'\nMT: '),
	xmg:send(debug,MT),
	xmg:send(debug,'\nMToApply: '),
	xmg:send(debug,MToApply),
	
	add_must(MToApply,MT,Final),
	%% Final should be a rb_tree now
	
	xmg:send(debug,'\nFinal: '),
	xmg:send(debug,Final),	
	!.



%% To check contraints on attributes (only leading to path equalities for now)
check_feat_constraints(Feats,Feats,ToApply,N):-
    findall(featconstraint(CT,Attr,Type,Attr1,Attr2),xmg:fPathConstraintFromAtts(CT,Attr,Type,Attr1,Attr2),FeatConstraints),
    xmg:send(debug,'\nChecking these constraints on feats:\n'),
    xmg:send(debug,FeatConstraints),
    OldFeats = Feats,
    check_feat_constraints(FeatConstraints,Feats,Feats,ToApply,0,N),
    %%(N>0 -> (check_feat_constraints(FeatConstraints,Feats,Feats,ToApply,0,_)) ; true ),
    %%(OldFeats==Feats -> true ; check_feat_constraints(Feats,Feats,ToApply) ),
    %%check_feat_constraints(FeatConstraints,Feats,Feats,ToApply,0,_),
    !.

check_feat_constraints([],Feats,Feats,[],N,N).
check_feat_constraints([H|T],Feats,Feats,[EH|ToApply],N,O):-
    check_feat_constraint(H,Feats,Feats),!,
    extract_constraint(H,EH),
    %%xmg:send(debug,EH),
    M is N+1,
    check_feat_constraints(T,Feats,Feats,ToApply,M,O),
    !.
check_feat_constraints([H|T],Feats,Feats,ToApply,N,M):-
    not(check_feat_constraint(H,Feats,Feats1)),!,
    check_feat_constraints(T,Feats,Feats,ToApply,N,M),
    !.

extract_constraint(featconstraint(CT,Attr,Type,P1,P2),(_,TP1,TP2)):-
    transform_path(P1,TP1),
    transform_path(P2,TP2),!.


check_feat_constraint(featconstraint(CT,[Attr],Type,Attr1,Attr2),Feats,Feats):-
  
    rb_lookup(Attr,Val,Feats),
    xmg:send(debug,'\nFound attribute\n'),
    xmg:send(debug,Attr),
    h_avm(NVal,Type,[]),
    xmg:send(debug,'\nCreated new h_avm\n'),
    not(not(NVal=Val)),
    xmg:send(debug,'\nGot the feature\n'),
    !.
check_feat_constraint(featconstraint(CT,[Attr,Else|Path],Type,Attr1,Attr2),Feats,Feats):-
  
    rb_lookup(Attr,Val,Feats),
    xmg:send(debug,'\nFound attribute\n'),
    xmg:send(debug,Attr),
    xmg:send(debug,'\nNow looking for\n'),
    xmg:send(debug,Else),
    xmg:send(debug,' in \n'),
    attvar(Val),
    h_avm(Val,_,ValFeats),
    xmg:send(debug,' the havm '),
    list_to_rbtree(ValFeats,RBValFeats),
    xmg:send(debug,RBValFeats),
    check_feat_constraint(featconstraint(CT,[Else|Path],Type,Attr1,Attr2),RBValFeats,RBValFeats),
    %%rb_visit(RBValFeats,Visit),
    %%h_avm(Val,_,Visit),
    !.
%%check_feat_constraint(featconstraint(CT,Attr,Type,Attr1,Attr2),Fentityeats,Feats).
    
transform_path([Att],Att):- !.
transform_path([H|T],path(H,T1)):-
    transform_path(T,T1),!.

const_h_avm(A,C) :-
	get_atts(A, avmfeats(_, _, C)).
	
attribute_goal(Var, h_avm(Var,Type,L)) :-
	get_atts(Var, avmfeats(Type,T,_)),
	rb_visit(T,L).

get_attrconstraints(Type,MCT):-
        var(Type),!.
get_attrconstraints(Type,MCT):-
	xmg:fattrconstraint(Type,C),
	xmg:send(debug,'\nGot attr contraints:'),
	xmg:send(debug,C),
	xmg:send(debug,'\n for :'),
	xmg:send(debug,Type),
	create_attr_types(C,CT),

	merge_feats(CT,CT,MCT),
        !.

get_attrconstraints(Type,MCT):-
	not(xmg:fattrconstraint(Type,C)),!.

create_attr_types([],[]).
create_attr_types([path(A,A1)-(Type,V)|T],[A-V1|T1]):-
    !,
    create_attr_types([A1-(Type,V)],New),
    h_avm(V1,_,New),
    create_attr_types(T,T1),
    !.
create_attr_types([A-(Type,V)|T],[A-V|T1]):-
	var(Type),!,
	create_attr_types(T,T1),!.
create_attr_types([A-(Type,V)|T],[A-V|T1]):-
	%%not(var(V)),!,
	h_avm(V,Type,[]),
	create_attr_types(T,T1),!.

merge_feats([],Feats,[]).
merge_feats([A-V|T],Feats,[A-V|T1]):-
	lists:member(A-V1,T),
	V=V1,!,
	merge_feats(T,Feats,T1),!.
merge_feats([F|T],Feats,[F|T1]):-
	merge_feats(T,Feats,T1),!.


add_must([],L,L).
add_must([H-V|T],L,NewL):-
    rb_lookup(H,V1,L),!,
    V=V1,
    add_must(T,L,NewL),!.
    
add_must([H-V|T],L,NewL):-
    rb_insert(L,H,V,TL),

	add_must(T,TL,NewL),!.
	
check_type(Vector):-
	not(not(xmg:fReachableType(Vector,_))),!.
check_type(Vector):-
	xmg:send(info,'\nInvalid type vector:'),
	xmg:send(info,Vector),false.

unify_types(T1,T2,T3,CT3):-
    xmg:send(debug,'Unify types: '),
    xmg:send(debug,T1),
    xmg:send(debug,' and '),
    xmg:send(debug,T2),
    xmg:send(debug,'\n'),

    var(T1),
    var(T2),
    T1=T2,
    T3=T1,!.
unify_types(T1,T2,T3,CT3):-
	T1=T2,
	
	xmg_brick_hierarchy_typer:find_smaller_supertype(T1,T3,CT3),!.
unify_types(T1,T2,T3,CT3):-
    %% This should not happen (having 0s in vectors), but strangely does.
    xmg:send(debug,'\n\n\nZeros in vector: \n'),
    xmg:send(debug,T1),
    xmg:send(debug,T2),
    xmg_brick_hierarchy_typer:replace_zeros(T1,TT1),
    xmg_brick_hierarchy_typer:replace_zeros(T2,TT2),
    xmg:send(debug,TT1),
    xmg:send(debug,TT2),
    TT1=TT2,
        xmg_brick_hierarchy_typer:find_smaller_supertype(TT1,T3,CT3),!.
    
unify_types(T1,T2,_,_):-
	xmg:send(info,'\nCould not unify frame types '),
	xmg:send(info, T1),
	xmg:send(info, T2),
	false.














%% unify_types(T1,T2,T3):-
%% 	(
%% 	    var(T1);var(T2)
%% 	),
%% 	T1=T2,
%% 	T3=T2,!.
%% unify_types(T1,T2,T3):-
%% 	%% xmg:send(info,'\nUnifying '),
%% 	%% xmg:send(info,T1),
%% 	%% xmg:send(info,' and '),
%% 	%% xmg:send(info,T2),

%% 	xmg:ftypeMap(TypeMap),
%% 	%%xmg:send(info,TypeMap),
%% 	lists:member(T1-I1,TypeMap),
%% 	lists:member(T2-I2,TypeMap),
%% 	xmg:ftypeMatrix(Matrix),
%% 	xmg_brick_hierarchy_boolMatrix:get_row(I1,Matrix,V1),
%% 	%%xmg:send(info,V1),
%% 	xmg_brick_hierarchy_boolMatrix:get_row(I2,Matrix,V2),
%% 	%%xmg:send(info,V2),

%% 	xmg_brick_hierarchy_boolMatrix:and_rows(V1,V2,V3),
%% 	%%xmg:send(info,V3),
%% 	%%xmg:send(info,'\n\n'),
%% 	%%xmg:send(info,Matrix),

	
%% 	xmg_brick_hierarchy_boolMatrix:get_type(Matrix,V3,I3),
%% 	xmg:ftypeIMap(TypeIMap),
%% 	lists:member(I3-T3,TypeIMap),!.

%% unify_types(T1,T2,_):-
%% 	xmg:send(info,'\n\nTypes '),
%% 	xmg:send(info,T1),
%% 	xmg:send(info,' and '),
%% 	xmg:send(info,T2),
%% 	xmg:send(info,' are not compatible. Vectors are:\n'),

%% 	xmg:ftypeMap(TypeMap),
%% 	xmg:send(info,TypeMap),
%% 	lists:member(T1-I1,TypeMap),
%% 	lists:member(T2-I2,TypeMap),
%% 	xmg:ftypeMatrix(Matrix),
%% 	xmg_brick_hierarchy_boolMatrix:get_row(I1,Matrix,V1),
%% 	xmg:send(info,V1),
%% 	xmg:send(info,' and '),
%% 	xmg_brick_hierarchy_boolMatrix:get_row(I2,Matrix,V2),
%% 	xmg:send(info,V2),

%% 	false.
	

%% unify_types(T,T,T):- !.
%% unify_types(T1,T2,T):-
%% 	comp_types_types(T1,T2),!,
%% 	%% T1 and T2 should already be ordered set
%% 	ordsets:ord_union(T1,T2,T3),!,
%% 	reduce_set(T3,T3,T),
%% 	%%xmg:send(info,'\nreduced'),
%% 	!.

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
	compatible_types(Type1,Type2),!.
comp_type_type(Type1,Type2):-
	xmg:send(info,'\nError: types '),
	xmg:send(info,Type1),
	xmg:send(info,' and '),
	xmg:send(info,Type2),
	xmg:send(info,' are not compatible.\n '),
	false,
	!.
%% compatible types are also the ones asserted with declarations, or the subtypes or supertypes



compatible_types(Type1,Type2):-
	xmg:fconstraint(Type1,comp,Type2),!.
compatible_types(Type1,Type2):-
	xmg:fconstraint(Type2,comp,Type1),!.


reduce_set([],Set,Set).
reduce_set([H|T],Set,RSet):-
	%% xmg:send(info,'reducing '),
	%% xmg:send(info,H),
	%% xmg:send(info,Set),
	remove_supertypes(H,Set,RT),!,
	%% xmg:send(info,RT),
	reduce_set(T,RT,RSet).
%% the set can be reduced when some types are subtypes of others


remove_supertypes(Type,[],[]).
remove_supertypes(Type,[H|T],T1):-
	supertype(Type,H,H),!,
	remove_supertypes(Type,T,T1).
remove_supertypes(Type,[H|T],[H|T1]):-
	not(supertype(Type,H,H)),!,
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
	xmg:send(info,AVM),
	xmg:send(info,':[\n'),
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
