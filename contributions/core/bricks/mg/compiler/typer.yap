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

%% type_metagrammar('MetaGrammar'(decls(Principles,Types,Properties,Feats,Fields,FieldPrecs),_,_)):-
	
%% 	%%xmg_compiler:send(info,'types : '),
%% 	%%xmg_compiler:send(info,Types),
%% 	get_types(Types),!,
%% 	type_properties(Properties),!,
%% 	type_feats(Feats),!,
%% 	assert_field_precs(FieldPrecs),
%% 	prepare_fields(Fields,PFields),
%% 	order_fields(PFields,OFields),
%% 	retractall(fieldprec(_,_)),
%% 	type_fields(OFields,1),
%% 	xmg_compiler:send(info,' typed').

type_metagrammar('MetaGrammar'(Decls,_,_)):-
	G=[gather(field,fieldprec,fields)],
	gather_decls(Decls,G,GDecls),
	type_decls(GDecls),!.

gather_decls(Decls,[],Decls):- !.
gather_decls(Decls,[HG|TG],GDecls):-
	gather_one(Decls,HG,GODecls),!,
	gather_decls(GODecls,TG,GDecls),!.

gather_one(Decls,gather(One,Two,New),[New-NDecl|Decls2]):-
	xmg_compiler:send(info,' gathering '),
	xmg_compiler:send(info,New),
	lists:member(One-DOne,Decls),
	lists:delete(Decls,One-DOne,Decls1),
	lists:member(Two-DTwo,Decls1),
	lists:delete(Decls1,Two-DTwo,Decls2),
	NDecl=..[New,One-DOne,Two-DTwo],
	!.
gather_one(Decls,_,Decls):-!.


type_decls([]):- !.
type_decls([H|T]):-
	type_decl(H),!,
	type_decls(T),!.

%% Warning: types have to be done before properties and feats
%% Warning: fieldprecs must be processed before fields
type_decl(type-Decls):-
	get_types(Decls),!.
type_decl(hierarchy-Decls):-
	get_hierarchies(Decls),!.
type_decl(property-Decls):-
	type_properties(Decls),!.
type_decl(feat-Decls):-
	type_feats(Decls),!.
type_decl(principle-Principle):-
	!.
type_decl(fields-fields(field-Fields,fieldprec-FieldPrecs)):-
	assert_field_precs(FieldPrecs),
	xmg_compiler:send(info,' fields orders asserted\n '),
	prepare_fields(Fields,PFields),
	xmg_compiler:send(info,' fields prepared\n '),
	order_fields(PFields,OFields),
	xmg_compiler:send(info,' fields ordered\n '),
	xmg_compiler:send(info,OFields),
	type_fields(OFields,1),
	!.
type_decl(Type-Decls):-
	xmg_compiler:send(info,'  unknown decl type: '),
	xmg_compiler:send(info,Type),
	false,!.

get_types([]).
get_types([H|T]):-
	get_type(H),
	get_types(T).

get_type(type(Type,enum(List))):-
	asserta(type(Type,List)).
get_type(type(Type,range(Inf,Sup))):-
	get_range(Inf,Sup,Range),
	asserta(type(Type,Range)).
get_type(type(Type,label)):-
	asserta(type(Type,label)),!.
get_type(A):-
	xmg_compiler:send(info,A),xmg_compiler:send_nl(info).

get_hierarchies([]):-!.
get_hierarchies([H|T]):-
	get_hierarchy(H),
	get_hierarchies(T),!.
get_hierarchy(hierarchy(Type,Pairs)):-
	xmg_typer_hierarchy:type_hierarchy(Type,Pairs),!.

type_feats([]).
type_feats([H|T]):-
	type_feat(H),
	type_feats(T).

type_feat(feat(G,T)):-
	asserta(feat(G,T)).

type_properties([]).
type_properties([H|T]):-
	type_property(H),
	type_properties(T).

type_property(property(G,T,_)):-
	asserta(property(G,T)).

assert_field_precs([]):- !.
assert_field_precs([fieldprec(id(F1,_),id(F2,_))|T]):- 
	asserta(fieldprec(F1,F2)),
	assert_field_precs(T),!.

prepare_fields([],[]):- !.
prepare_fields([field(id(ID,_))|T],[ID|PT]):-
	prepare_fields(T,PT),!.
prepare_fields([U|T],[ID|PT]):-
	xmg_compiler:send(info,'UNEXPECTED '),
	xmg_compiler:send(info,U),false,!.

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
	xmg_compiler:send(info,' Could not order fields, nothing seems to follow '),
	xmg_compiler:send(info,First),
	false,!.



find_first([],_):- !,
	xmg_compiler:send(info,' Could not find a first field, there might be a cycle'),false,!.
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

