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
:-dynamic(xmg:type/2).
:-dynamic(xmg:property/2).
:-dynamic(xmg:field/2).
:-dynamic(fieldprec/2).
:-dynamic(xmg:feat/2).

:-multifile(xmg:type_stmt/10).
:-multifile(xmg:type_expr/10).

%% the type of statements into a dimension, with parameters given by the user
:-multifile(xmg:stmt_type/3).
%% the type of statements into a dimension, with default parameters
:-multifile(xmg:stmt_type_constr/2).

:- xmg:edcg.
%% types: local table for variable types
:-edcg:thread(types,edcg:table).
%% type_decls: global table for type definitions and constant types
:-edcg:thread(type_decls,edcg:table).
%% global_context: global table for class types
:-edcg:thread(global_context,edcg:table).
%% local table of exported variables
:-edcg:thread(exports,edcg:table).
%% global table of dimension types
:-edcg:thread(dim_types,edcg:table).

%% table of free variables in classes
:-edcg:thread(free,edcg:table).


:-edcg:weave([types,global_context,dim_types,type_decls],[xmg:type_stmt/2,xmg:type_expr/2,put_in_table/1,put_global_in_table/1,unify_imports/1,unify_import/1,xmg:get_var_type/2,import_exports/2, import_export/2]).
:-edcg:weave([global_context,dim_types,type_decls],[type_classes/1]).
:-edcg:weave([types,exports],[make_exports_global/1,make_params_global/1]).
:-edcg:weave([type_decls],[type_decls/1, type_decl/1, type_only_principles/1, type_decl_if_principle/1, get_types/1, get_type/1, get_feats_types/2, get_feat_type/2, assert_type/1, type_feats/1, type_feat/1, assert_feat/1,add_base_types/1, assert_consts/2, assert_const/2]).

:-edcg:weave([free],[new_free/2]).

xmg:check_types(T1,T2,Coord):-
    xmg:send(debug,'Checking types'),
    T1=T2,!.
xmg:check_types(T1,T2,Coord):- 
	not(T1=T2),
	xmg:send(info,'\n\nIncompatible types: '),
	xmg:send(info,T1),
	xmg:send(info,', '),
	xmg:send(info,T2),
	xmg:send(info,', '),
	xmg:send(info,Coord),
	halt,
	!.



xmg:type_expr(none,_):-- !.
xmg:type_expr(some(E),T):-- 
	     xmg:type_expr(E,T),!.

xmg:type_stmt(none,_):-- !.
xmg:type_stmt(some(E),T):-- 
	xmg:type_stmt(E,T),!.

xmg:get_var_type(none,_):-- !.
xmg:get_var_type(some(token(_,id(ID))),Var):-- 
	types::tget(ID,Var),!.
xmg:get_var_type(token(_,id(ID)),Var):-- 
	types::tget(ID,Var),!.
xmg:get_var_type(Get,_):--
	xmg:send(info,'\ncould not get type for var '),
	xmg:send(info,Get),
	halt,
	!.

type_metagrammar(MG):-
	xmg:send(debug,'Typing classes'),
	xmg:send(debug,MG).
	

do_type_classes(Classes,Type_Decls):--
	xmg_table:table_new(TableIn),
	xmg_table:table_new(TableDimIn),
	type_classes(Classes) with (global_context(TableIn,TableOut),dim_types(TableDimIn,TableDimOut),type_decls(Type_Decls,_)).


type_classes([]):--
	!.
type_classes([mg:class(token(Coord,id(N)),P,I,E,D,S)|T]):--
	!,
	xmg:send(debug,N),
	global_context::get(GContext),
	xmg_brick_mg_exporter:declared(N,List),
	xmg_table:table_new(TableIn),
	put_in_table(List) with types(TableIn,TableOut),
	rbtrees:rb_visit(GContext,GContextList),

	put_global_in_table(GContextList) with types(TableOut,TableGOut),
	unify_imports(I) with types(TableGOut,UTableOut),

	xmg:send(debug,'\n\nInitial table for '),
	xmg:send(debug,N),
	xmg:send(debug,': '),
	xmg:send(debug,UTableOut),
	xmg:type_stmt(S,void) with types(UTableOut,TypedTable),
	xmg:send(debug,'\n\nTyped table: '),
	xmg:send(debug,TypedTable),
	xmg:send(debug,'\n\n'),

	%% build a constant avm for export vector
	xmg_brick_mg_exporter:exports(N,ListExports),
	xmg_table:table_new(IExports),
	make_exports_global(ListExports) with (types(TypedTable,_), exports(IExports,Exports)),
	rbtrees:rb_visit(Exports,ExportList),
	xmg_brick_avm_avm:cavm(CAVM,ExportList),

	%% build a constant avm for params
	xmg_table:table_new(IParams),

	xmg:send(debug,'\nBuilding parameters using types: '),
	xmg:send(debug,TypedTable),

	make_params_global(P) with (types(TypedTable,_), exports(IParams,Params)),
	rbtrees:rb_visit(Params,ParamList),

	%% ParamList has to be ordered now
	order_params(P,ParamList,OParamList),
	
	global_context::tput(class(N),(OParamList,CAVM)),

	xmg:send(debug,'\n\nClass '),
	xmg:send(debug,N),
	xmg:send(debug,' now has type '),
	xmg:send(debug,(ParamList,CAVM)),
	xmg:send(debug,'\n'),
	
	type_classes(T),!.
type_classes([_|T]):--
	    type_classes(T),!.

order_params(none,_,[]).
order_params(some(P),ParamList,OParamList):-
             order_params(P,ParamList,OParamList).
order_params([],_,[]).
order_params([H|T],ParamList,[H1|T1]):-
		get_param(H,ParamList,H1),
		order_params(T,ParamList,T1),!.

get_param(value:var_or_const(token(_,id(P))),List,P-GP):-
    lists:member(P-GP,List),
    !.
get_param(value:var(token(_,id(P))),List,P-GP):-
    lists:member(P-GP,List),
    !.
get_param(value:const(token(_,id(P))),List,P-GP):-
    lists:member(P-GP,List),
    !.



put_in_table([]):-- !.
put_in_table([id(A,_)-B|T]):--
	types::tput(A,B),
	put_in_table(T),!.
put_in_table([const(A,_)-const(N,_)|T]):--
	%% skolemize ?
	types::tput(A,N),
	put_in_table(T),!.

put_global_in_table([]):-- !.
put_global_in_table([A-B|T]):--
	types::tput(A,B),!,
	put_global_in_table(T),!.

make_exports_global([]):-- !.
make_exports_global([id(A,_)-_|T]):--
	types::tget(A,Type),
	exports::tput(A,Type),
	make_exports_global(T),!.

make_params_global(none):-- !.
make_params_global(some(Params)):-- 
	make_params_global(Params),!.
make_params_global([]):-- !.
make_params_global([token(_,id(A))|T]):--
	types::tget(A,Type),
	exports::tput(A,Type),
	make_params_global(T),!.
make_params_global([value:var(token(_,id(A)))|T]):--
	types::tget(A,Type),
	exports::tput(A,Type),
	make_params_global(T),!.
make_params_global([value:var_or_const(token(_,id(A)))|T]):--
	types::tget(A,Type),
	exports::tput(A,Type),
	make_params_global(T),!.
make_params_global([A|T]):--
	xmg:send(info,'\nNo type for:'),
	xmg:send(info,A),
	halt,!.

unify_imports(none):-- !.
unify_imports(some(mg:import(I))):-- 
	unify_imports(I),!.
unify_imports([]):-- !.
unify_imports([I|T]):--
	unify_import(I),
	unify_imports(T).

unify_import(mg:iclass(token(_,id(A)),_,none)):--
	%%global_context::tget(A,Exports),
	types::tget(class(A),(Params,CAVM)),
	xmg:do_forall((Params,CAVM),(NParams,FACAVM)),
	xmg_brick_mg_exporter:exports(N,List),
	%%xmg:send(info,List),
	import_exports(List,FACAVM).
unify_import(mg:iclass(token(_,id(A)),_,AS)):--
	%% TODO: something about the AS
	%%global_context::tget(A,Exports),
	types::tget(class(A),(Params,CAVM)),
	xmg:do_forall((Params,CAVM),(NParams,FACAVM)),
	xmg_brick_mg_exporter:exports(N,List),
	import_exports(List,FACAVM).

xmg:do_forall((Params,cavm(Vars)),(NParams,NVars)):--
	xmg:send(debug,'\n forall on '),
	xmg:send(debug,(Params,cavm(Vars))),
	rbtrees:rb_visit(Vars,VarsList),
	xmg_table:table_new(Free),
	new_free(VarsList,NVarsList) with free(Free,Free1),
	xmg:send(debug,NVarsList),

	new_free(Params,NParams) with free(Free1,_),
	xmg_brick_avm_avm:cavm(NVars,NVarsList),
	xmg:send(debug,'\n forall done : '),
	xmg:send(debug,(NParams,NVars)).

new_free([],[]):-- !.
%% with vectors
new_free([V-H|T],[V-F|T1]):--
	free::tget(H,F),!,
	xmg:send(debug,'\nBINDING NEW VAR'),
	new_free(T,T1),!.
new_free([V-H|T],[V-F|T1]):--
	var(H),
	not(attvar(H)),
	xmg:send(debug,'\nCREATING NEW VAR'),
	free::tput(H,F),
	new_free(T,T1),!.
new_free([V-H|T],[V-H|T1]):--
	new_free(T,T1),
	!.
%% with lists
new_free([H|T],[V-F|T1]):--
	free::tget(H,F),!,
	xmg:send(debug,'\nBINDING NEW VAR'),
	new_free(T,T1),!.
new_free([H|T],[V-F|T1]):--
	var(H),
	not(attvar(H)),
	xmg:send(debug,'\nCREATING NEW VAR'),
	free::tput(H,F),
	new_free(T,T1),!.
new_free([H|T],[V-H|T1]):--
	new_free(T,T1),
	!.	


import_exports([],CAVM):-- !.
import_exports([H|T],CAVM):--
	import_export(H,CAVM),
	import_exports(T,CAVM).

import_export(id(A,_)-_,CAVM):--
	xmg:send(debug,'\nexporting '),
	xmg:send(debug,A),
	xmg:send(debug,',  '),
	xmg:send(debug,CAVM),

	xmg_brick_avm_avm:dot(CAVM,A,Type),
	types::tget(A,Type),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Type Declarations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmg:type(bool,bool).
xmg:type(int,int).
xmg:type(string,string).

type_mg_decls(Decls,Type_BDecls):--
	xmg:send(debug,Decls),
	G=[gather(field,fieldprec,fields)],
	gather_decls(Decls,G,GDecls),!,
	xmg:send(debug,' decls gathered '),
	xmg_table:table_new(TableNew),
	type_decls(GDecls) with type_decls(TableNew,Type_Decls),
	add_base_types([int,string,bool]) with type_decls(Type_Decls,Type_BDecls),
	xmg:send(debug,'\n\nType Decls:\n'),
	xmg:send(debug,Type_BDecls),
	!.

gather_decls(Decls,[],Decls):- !.
gather_decls(Decls,[HG|TG],GDecls):-
	gather_one(Decls,HG,GODecls),!,
	gather_decls(GODecls,TG,GDecls),!.

gather_one(Decls,gather(One,Two,New),[New-NDecl|Decls2]):-
	xmg_brick_mg_compiler:send(debug,' gathering '),
	xmg_brick_mg_compiler:send(debug,New),
	lists:member(One-DOne,Decls),
	lists:delete(Decls,One-DOne,Decls1),
	lists:member(Two-DTwo,Decls1),
	lists:delete(Decls1,Two-DTwo,Decls2),
	NDecl=..[New,One-DOne,Two-DTwo],
	!.
gather_one(Decls,_,Decls):-!.


type_decls([]):-- !.
type_decls(L):--
	  xmg:notype_mode,
          type_only_principles(L),
	  !.
type_decls([H|T]):--
	%%xmg:send(info,H),
	type_decl(H),!,
	type_decls(T),!.

type_only_principles([]):--!.
type_only_principles([H|T]):--
	%%xmg:send(info,H),
	type_decl_if_principle(H),!,
        type_only_principles(T),!.

type_decl_if_principle(principle-P):--
		      type_decl(principle-P),!.
type_decl_if_principle(_-P):--
		      !.


%% Warning: types have to be done before properties and feats
%% Warning: fieldprecs must be processed before fields
type_decl(type-Decls):--
	get_types(Decls),!.
type_decl(hierarchy-Decls):--
	xmg_brick_hierarchy_typer:get_hierarchies(Decls),!.
type_decl(ftype-Decls):--
	 xmg_brick_hierarchy_typer:remove_ftypes(Decls,NDecls),
	   assert_consts(NDecls,hierarchy:ftype),
	 xmg_brick_hierarchy_typer:get_ftypes(Decls),!.
type_decl(fconstraint-Decls):--
	xmg_brick_hierarchy_typer:get_fconstraints(Decls),!.
type_decl(ftypes-[ftypes(Decls)]):--
	 xmg_brick_hierarchy_typer:remove_ftypes(Decls,NDecls),
	 assert_consts(NDecls,hierarchy:ftype),
	 xmg_brick_hierarchy_typer:get_ftypes(Decls),
	 xmg_brick_hierarchy_typer:assert_types(Types),
	 !.
type_decl(fconstraints-[fconstraints(Decls)]):--
	 xmg_brick_hierarchy_typer:get_fconstraints(Decls),
         asserta(xmg:hierarchy(built)),!.
type_decl(property-Decls):--
	type_properties(Decls),!.
type_decl(feat-Decls):--
	type_feats(Decls),!.
type_decl(principle-Principle):--
	type_principles(Principle),
	!.
type_decl(fields-fields(field-Fields,fieldprec-FieldPrecs)):--
	assert_field_precs(FieldPrecs),
	xmg_brick_mg_compiler:send(debug,' fields orders asserted\n '),
	prepare_fields(Fields,PFields),
	xmg_brick_mg_compiler:send(debug,' fields prepared\n '),
	order_fields(PFields,OFields),
	xmg_brick_mg_compiler:send(debug,' fields ordered\n '),
	xmg_brick_mg_compiler:send(debug,OFields),
	type_fields(OFields,1),
	!.
type_decl(none-_):--!.
type_decl(Type-Decls):--
	xmg_brick_mg_compiler:send(info,'  unknown decl type: '),
	xmg_brick_mg_compiler:send(info,Type),
	halt,!.

get_types([]):-- !.
get_types([H|T]):--
	get_type(H),!,
	get_types(T).

get_type(type(Type,enum(List))):--
	assert_type(type(Type,Type)),
	assert_consts(List,Type).
get_type(type(Type,range(Inf,Sup))):--
	get_range(Inf,Sup,Range),
	assert_type(type(Type,int)).
get_type(type(Type,label)):--
	assert_type(type(Type,_)),!.
get_type(type(Type,struct(Feats))):--
	get_feats_types(Feats,FeatsTypes),
	xmg_brick_avm_avm:avm(AVM,FeatsTypes),
	assert_type(type(Type,AVM)),!.
get_type(type(Type,const_struct(Feats))):--
	get_feats_types(Feats,FeatsTypes),
	xmg_brick_avm_avm:cavm(AVM,FeatsTypes),
	assert_type(type(Type,AVM)),!.
get_type(type(Type,TypeDef)):--
	xmg:send(info,'\nunknown type def: '),
	xmg:send(info,Type),
	xmg:send(info,', '),
	xmg:send(info,TypeDef),
	halt,!.


get_feats_types([],[]):-- !.
get_feats_types([H|T],[H1|T1]):--
	get_feat_type(H,H1),
	get_feats_types(T,T1),!.

get_feat_type(F-struct(Feats),F-AVM):--
	get_feats_types(Feats,FeatsTypes),
	xmg_brick_avm_avm:avm(AVM,FeatsTypes),	
	!.
get_feat_type(F-const_struct(Feats),F-AVM):--
	get_feats_types(Feats,FeatsTypes),
	xmg_brick_avm_avm:cavm(AVM,FeatsTypes),	
	!.
get_feat_type(F-T,F-T):--
	%%assert_feat(feat(F,T)),
	!.

assert_type(type(Id,Type)):--
	type_decls::tget(Id,Type),!.
assert_type(type(Id,Type)):--
	   type_decls::tget(Id,T),not(T=Type),!,
	throw(xmg(type_error(multiple_type(Id)))).
assert_type(type(Id,Type)):--
	   type_decls::tput(Id,Type),!.

assert_consts([],_):-- !.
assert_consts([Const|T],Type):--
	assert_const(Const,Type),!,
	assert_consts(T,Type),!.

assert_const(Const,Type):--
	type_decls::tget(const(Const),Type),!.
assert_const(Const,Type):--
	type_decls::tget(const(Const),T),not(T=Type),!,
	throw(xmg(type_error(multiple_const(Const)))).

assert_const(Const,Type):--
	    type_decls::tput(const(Const),Type),
            xmg:send(debug,'\nAsserted constant: '),
            xmg:send(debug,Const).

get_range(Sup,Sup,[]):-!.
get_range(Inf,Sup,[int(Inf)|T]):-
	Inf1 is Inf + 1,
	get_range(Inf1,Sup,T),!.

add_base_types([]):-- !.
add_base_types([H|T]):--
	type_decls::tput(H,_),
	add_base_types(T),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Feats Declarations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert_feat(feat(Id,Type)):--
	xmg:feat(Id,Type),!.
assert_feat(feat(Id,Type)):--
	   xmg:feat(Id,T),not(T=Type),!,
           throw(xmg(type_error(multiple_feature(Id)))).

assert_feat(feat(Id,Type)):--
	not(xmg:feat(Id,_)),
	%%xmg:send(info,'\n\nassert feat \n '),
	%%xmg:send(info,Id),
	asserta(xmg:feat(Id,Type)),!.

type_feats([]):--!.
type_feats([H|T]):--
	type_feat(H),
	type_feats(T).

type_feat(feat(G,T)):--
	assert_feat(feat(G,T)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Properties Declarations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type_properties([]).
type_properties([H|T]):-
	type_property(H),
	type_properties(T).

type_property(property(G,T,_)):-
	asserta(xmg:property(G,T)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Principles Declarations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type_principles([]).
type_principles([H|T]):-
	type_principle(H),
	type_principles(T).

type_principle(principle(Principle,Args,Dims)):-	
	asserta(xmg:principle(Principle,Args,Dims)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fields Declarations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert_field_precs([]):- !.
assert_field_precs([fieldprec(id(F1,_),id(F2,_))|T]):- 
	asserta(fieldprec(F1,F2)),
	assert_field_precs(T),!.

prepare_fields([],[]):- !.
prepare_fields([field(id(ID,_))|T],[ID|PT]):-
	prepare_fields(T,PT),!.
prepare_fields([U|T],[ID|PT]):-
	xmg_brick_mg_compiler:send(info,'UNEXPECTED '),
	xmg_brick_mg_compiler:send(info,U),halt,!.

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
	xmg_brick_mg_compiler:send(info,'\nCould not order fields, nothing seems to follow '),
	xmg_brick_mg_compiler:send(info,First),
	halt,!.



find_first([],_):- !,
	xmg_brick_mg_compiler:send(info,'\nCould not find a first field, there might be a cycle'),halt,!.
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
	xmg:send(debug,'\nassert field '),
	xmg:send(debug,F),
	
	asserta(xmg:field(F,N)).










