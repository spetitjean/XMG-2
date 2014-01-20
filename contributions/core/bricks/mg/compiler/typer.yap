%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2012  Simon Petitjean

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

:-module(xmg_brick_mg_typer).
:-dynamic(type/2).
:-dynamic(property/2).
:-dynamic(field/2).
:-dynamic(fieldprec/2).
:-dynamic(feat/2).

:-multifile(xmg:type_stmt/3).
:-multifile(xmg:type_expr/4).

:-edcg:thread(types,edcg:table).
:-edcg:weave([types],[xmg:type_stmt/1,xmg:type_expr/2,put_in_table/1,xmg:get_var_type/2]).

xmg:check_types(T1,T1,Coord):- !.
xmg:check_types(T1,T2,Coord):- 
	not(T1=T2),
	xmg:send(info,' incompatible types:'),
	xmg:send(info,T1),
	xmg:send(info,', '),
	xmg:send(info,T2),
	xmg:send(info,', '),
	xmg:send(info,Coord),
	!.

xmg:type_expr(none,_):-- !.
xmg:type_expr(some(E),T):-- 
	xmg:type_expr(E,T),!.

xmg:get_var_type(none,_):-- !.
xmg:get_var_type(some(token(_,id(ID))),Var):-- 
	types::tget(ID,var(_,Var)),!.
xmg:get_var_type(Get,_):--
	xmg:send(info,'could not get type for var '),
	xmg:send(info,Get),
	false,
	!.


type_classes([]):--
	!.
type_classes([mg:class(token(Coord,id(N)),P,I,E,D,S)|T]):--
	!,
	xmg_brick_mg_exporter:declared(N,List),
	xmg_table:table_new(TableIn),
	put_in_table(List) with types(TableIn,TableOut),
	%%xmg:send(info,'\nTypes table:'),
	%%xmg:send(info,TableOut),
	xmg:type_stmt(S) with types(TableOut,TypedTable),
	xmg:send(info,'\nTyped table:'),
	xmg:send(info,TypedTable),
	xmg:send(info,'\n\n'),
	type_classes(T),!.
type_classes([_|T]):--
	type_classes(T),!.


put_in_table([]):-- !.
put_in_table([id(A,_)-B|T]):--
	types::tput(A,var(B,Type)),
	put_in_table(T),!.
put_in_table([const(A,_)-const(N,_)|T]):--
	%% skolemize ?
	types::tput(A,sconst(N,_)),
	put_in_table(T),!.

%% type_metagrammar('MetaGrammar'(decls(Principles,Types,Properties,Feats,Fields,FieldPrecs),_,_)):-
	
%% 	%%xmg_brick_mg_compiler:send(info,'types : '),
%% 	%%xmg_brick_mg_compiler:send(info,Types),
%% 	get_types(Types),!,
%% 	type_properties(Properties),!,
%% 	type_feats(Feats),!,
%% 	assert_field_precs(FieldPrecs),
%% 	prepare_fields(Fields,PFields),
%% 	order_fields(PFields,OFields),
%% 	retractall(fieldprec(_,_)),
%% 	type_fields(OFields,1),
%% 	xmg_brick_mg_compiler:send(info,' typed').

type_mg_decls(Decls):-
	xmg:send(info,Decls),
	G=[gather(field,fieldprec,fields)],
	gather_decls(Decls,G,GDecls),!,
	xmg:send(info,' decls gathered '),
	type_decls(GDecls),!.

gather_decls(Decls,[],Decls):- !.
gather_decls(Decls,[HG|TG],GDecls):-
	gather_one(Decls,HG,GODecls),!,
	gather_decls(GODecls,TG,GDecls),!.

gather_one(Decls,gather(One,Two,New),[New-NDecl|Decls2]):-
	xmg_brick_mg_compiler:send(info,' gathering '),
	xmg_brick_mg_compiler:send(info,New),
	lists:member(One-DOne,Decls),
	lists:delete(Decls,One-DOne,Decls1),
	lists:member(Two-DTwo,Decls1),
	lists:delete(Decls1,Two-DTwo,Decls2),
	NDecl=..[New,One-DOne,Two-DTwo],
	!.
gather_one(Decls,_,Decls):-!.


type_decls([]):- !.
type_decls([H|T]):-
	%%xmg:send(info,H),
	type_decl(H),!,
	type_decls(T),!.

%% Warning: types have to be done before properties and feats
%% Warning: fieldprecs must be processed before fields
type_decl(type-Decls):-
	get_types(Decls),!.
type_decl(hierarchy-Decls):-
	get_hierarchies(Decls),!.
type_decl(fconstraint-Decls):-
	get_fconstraints(Decls),!.
type_decl(property-Decls):-
	type_properties(Decls),!.
type_decl(feat-Decls):-
	type_feats(Decls),!.
type_decl(principle-Principle):-
	type_principles(Principle),
	!.
type_decl(fields-fields(field-Fields,fieldprec-FieldPrecs)):-
	assert_field_precs(FieldPrecs),
	xmg_brick_mg_compiler:send(info,' fields orders asserted\n '),
	prepare_fields(Fields,PFields),
	xmg_brick_mg_compiler:send(info,' fields prepared\n '),
	order_fields(PFields,OFields),
	xmg_brick_mg_compiler:send(info,' fields ordered\n '),
	xmg_brick_mg_compiler:send(info,OFields),
	type_fields(OFields,1),
	!.
type_decl(Type-Decls):-
	xmg_brick_mg_compiler:send(info,'  unknown decl type: '),
	xmg_brick_mg_compiler:send(info,Type),
	false,!.

get_types([]).
get_types([H|T]):-
	get_type(H),
	get_types(T).

get_type(type(Type,enum(List))):-
	assert_type(type(Type,List)).
get_type(type(Type,range(Inf,Sup))):-
	get_range(Inf,Sup,Range),
	assert_type(type(Type,Range)).
get_type(type(Type,label)):-
	assert_type(type(Type,label)),!.
get_type(type(Type,struct(Obl,Opt,More))):-
	get_feat_types(Obl),
	get_feat_types(Opt),
	assert_type(type(Type,struct(Obl,Opt,More))),!.
%% get_type(A):-
%% 	xmg_brick_mg_compiler:send(info,A),xmg_brick_mg_compiler:send_nl(info).

get_feat_types([]):- !.
get_feat_types([H|T]):-
	get_feat_type(H),
	get_feat_types(T),!.

get_feat_type(F-T):-
	assert_feat(feat(F,T)),!.

assert_type(type(Id,Type)):-
	type(Id,Type),!.
assert_type(type(Id,Type)):-
	type(Id,T),not(T=Type),!,
	xmg:send(info,'\n Multiple definition of type '),
	xmg:send(info,Id),
	false,!.
assert_type(type(Id,Type)):-
	not(type(Id,_)),
	xmg:send(info,'\n\nassert type\n '),
	xmg:send(info,Id),
	asserta(xmg:type(Id,Type)),!.

assert_feat(feat(Id,Type)):-
	type(Id,Type),!.
assert_feat(feat(Id,Type)):-
	feat(Id,T),not(T=Type),!,
	xmg:send(info,'\n Multiple definition of feature '),
	xmg:send(info,Id),
	false,!.
assert_feat(feat(Id,Type)):-
	not(feat(Id,_)),
	xmg:send(info,'\n\nassert feat \n '),
	xmg:send(info,Id),
	asserta(xmg:feat(Id,Type)),!.

get_hierarchies([]):-!.
get_hierarchies([H|T]):-
	get_hierarchy(H),
	get_hierarchies(T),!.
get_hierarchy(hierarchy(Type,Pairs)):-
	xmg_brick_hierarchy_typer:type_hierarchy(Type,Pairs),!.

get_fconstraints([]):-
	xmg_brick_hierarchy_typer:build_types(types(Types,Sets)),

	%% Constraints will be built from the metagrammar, but until then...
	Constraints=[
           %% types are [action,action-reaction,activity,causation,reaction,supercausation]
    

	   %% supercausation is the root

           %% this one means action -> supercausation
           [1,_,_,_,_,0],
           %% this one means reaction -> supercausation
           [_,_,_,_,1,0],
           %% this one means activity -> supercausation
           [_,_,1,_,_,0],
           %% this one means causation -> supercausation
           [_,_,_,1,_,0],

	   %% amongst these children, only action and reaction are compatible

	   %% %% this one means activity and causation are incompatible
	   %% [_,_,1,1,_,_],
	   %% this one means reaction and causation are incompatible
	   [_,_,_,1,1,_],	   
	   %% this one means activity and reaction are incompatible
	   [_,_,1,_,1,_],
	   %% this one means action and causation are incompatible
	   [1,_,_,1,_,_],
	   %% this one means action and activity are incompatible
	   [1,_,1,_,_,_],
	   

           %% this one means action-reaction -> reaction	   
	   [_,1,_,_,0,_],
           %% this one means action-reaction -> action	   
	   [0,1,_,_,_,_],
           %% this one means action and reaction -> action-reaction	   
	   [1,0,_,_,1,_]          
        ],
	
	xmg_brick_hierarchy_typer:filter_sets(Sets,Constraints,FSets),
	xmg:send(info,'\nFiltered types:'),
	xmg:send(info,FSets),

	%%xmg_brick_hierarchy_typer:build_matrix(Types,FSets,Matrix),
	!.
get_fconstraints([H|T]):-
	get_fconstraint(H),
	get_fconstraints(T),!.
get_fconstraint(fconstraint(Type,Must,Cant,Sub,Comp)):-
	xmg_brick_hierarchy_typer:type_fconstraint(Type,Must,Cant,Sub,Comp),!.

type_feats([]).
type_feats([H|T]):-
	type_feat(H),
	type_feats(T).

type_feat(feat(G,T)):-
	assert_feat(feat(G,T)).

type_properties([]).
type_properties([H|T]):-
	type_property(H),
	type_properties(T).

type_property(property(G,T,_)):-
	asserta(property(G,T)).

type_principles([]).
type_principles([H|T]):-
	type_principle(H),
	type_principles(T).

type_principle(principle(Principle,Args,Dims)):-	
	asserta(xmg:principle(Principle,Args,Dims)).

assert_field_precs([]):- !.
assert_field_precs([fieldprec(id(F1,_),id(F2,_))|T]):- 
	asserta(fieldprec(F1,F2)),
	assert_field_precs(T),!.

prepare_fields([],[]):- !.
prepare_fields([field(id(ID,_))|T],[ID|PT]):-
	prepare_fields(T,PT),!.
prepare_fields([U|T],[ID|PT]):-
	xmg_brick_mg_compiler:send(info,'UNEXPECTED '),
	xmg_brick_mg_compiler:send(info,U),false,!.

order_fields([],[]):-!.
order_fields(Fields,OFields):-
	find_first(Fields,First),
	order_fields(Fields,First,OFields),!.

order_fields([Field],_,[Field]):- !.
order_fields(Fields,First,[First|OFields]):-
	lists:delete(Fields,First,NFields),
	fieldprec(First,Next),!,
	order_fields(NFields,Next,OFields),!.
order_fields(Fields,First,[First|OFields]):- !,
	xmg_brick_mg_compiler:send(info,' Could not order fields, nothing seems to follow '),
	xmg_brick_mg_compiler:send(info,First),
	false,!.



find_first([],_):- !,
	xmg_brick_mg_compiler:send(info,' Could not find a first field, there might be a cycle'),false,!.
find_first([F1|T],F2):-
	fieldprec(_,F1),!,
	find_first(T,F2),!.
find_first([F1|T],F1):- !.


type_fields([],_).
type_fields([H|T],N):-
	type_field(H,N),
	M is N+1,
	type_fields(T,M).

	
type_field(F,N):-
	asserta(field(F,N)).

get_range(Sup,Sup,[]):-!.
get_range(Inf,Sup,[int(Inf)|T]):-
	Inf1 is Inf + 1,
	get_range(Inf1,Sup,T),!.

