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

:-module(xmg_brick_avm_typer).

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:dim_types,xmg_brick_mg_typer:type_decls]).

:-edcg:weave([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:dim_types,xmg_brick_mg_typer:type_decls],[value_type/2,type_def/2,extend_type/3]).


xmg:type_expr(avm:avm(Coord,Feats),Type):--
	(
	    var(Type)->
	      xmg_brick_avm_avm:avm(Type,[])
	      ;
 	      true
	),
	xmg:type_expr(Feats,Type),
	!.

xmg:type_expr([],_):--!.
xmg:type_expr([H|T],Type):--
	xmg:type_expr(H,Type),
	xmg:type_expr(T,Type),!.

xmg:type_expr(avm:feat(Attr,Value),Type):--
	xmg:send(debug,'\n\nTyping feat: '),
	xmg:send(debug,Attr),
	xmg:send(debug,'\n'),
	xmg:send(debug,Value),
	xmg:send(debug,'\nwith type '),
	xmg:send(debug,Type),
	feat_type(Attr,UAttr,Type,TypeAttr),
	type_def(TypeAttr,TypeDef),
	value_type(Value,TypeDef),
	extend_type(Type,UAttr,TypeDef),
	!.
xmg:type_expr(avm:feat(Attr,Value),Type):--
	throw(xmg(type_error(incompatible_types(Attr,Value)))).

%% when typing a structured type
extend_type(Type,UAttr,TypeAttr):--
	xmg_brick_avm_avm:dot(Type,UAttr,AVM),
	type_decls::tget(AVM,AVMType),
	xmg:send(debug,' got avm type '),
	TypeAttr=AVMType,
	!.
%% when typing a single feat
extend_type(Type,UAttr,TypeAttr):--
	xmg_brick_avm_avm:dot(Type,UAttr,TypeAttr),!.
extend_type(Type,UAttr,TypeAttr):--
	xmg:send(info,'\n\nAVM Type Error! Could not extend type:\n'),
	xmg_brick_avm_avm:avm(Type,LType),
	xmg:send(info,LType),
	xmg:send(info,'\n'),
	xmg:send(info,UAttr),
	xmg:send(info,'\n'),	
	xmg:send(info,TypeAttr),
	halt.
extend_type(Type,UAttr,TypeAttr):--
	xmg:send(info,'\n\nAVM Type Error! Could not extend type:\n'),
	xmg:send(info,Type),
	xmg:send(info,'\n'),
	xmg:send(info,UAttr),
	xmg:send(info,'\n'),	
	xmg:send(info,TypeAttr),
	halt.

	
xmg:type_stmt(avm:avm(Coord,Feats),Type):--
	xmg:type_expr(avm:avm(Coord,Feats),Type),!.

xmg:type_expr(avm:dot(value:var(token(_,id(AVM))),token(_,id(Feat))),Type):--
	types::tget(AVM,CAVM),
	xmg:send(debug,'\n\nTyping dot expression:'),
	xmg:send(debug,CAVM),
	xmg:send(debug,'DOT'),
	xmg:send(debug,Feat),

	xmg_brick_avm_avm:dot(CAVM,Feat,Type),
	!.

xmg:type_expr(avm:dot(avm:dot(AVM1,V),token(_,id(Feat))),Type):--
	     xmg:type_expr(avm:dot(AVM1,V),T1),
xmg:send(debug,'\n\nTyping recursive dot expression:'),
	xmg:send(debug,'DOT'),
	xmg:send(debug,Feat),
	xmg_brick_avm_avm:dot(T1,Feat,Type),
	!.

%% For dots in classes (should be consistent)
xmg:type_expr(avm:dot(token(_,id(AVM)),token(_,id(Feat))),Type):--
	types::tget(AVM,CAVM),
	xmg:send(debug,'\n\nTyping dot expression:'),
	xmg:send(debug,CAVM),
	xmg:send(debug,'DOT'),
	xmg:send(debug,Feat),

	xmg_brick_avm_avm:dot(CAVM,Feat,Type),
	!.



%% when typing a structured avm
feat_type(token(_,id(Feat)),Feat,AVM,Type):-
	xmg_brick_avm_avm:avm(AVM,AVMFeats),
	xmg:send(debug,AVMFeats),
	lists:member(Feat-_,AVMFeats),
	xmg_brick_avm_avm:dot(AVM,Feat,Type),

	!.
%% when typing a single feat
feat_type(token(_,id(Feat)),Feat,_,Type):-
	xmg:feat(Feat,Type),
	!.
feat_type(token(_,id(Feat)),Feat,_,Type):-
	xmg:property(Feat,Type),
	!.
feat_type(token(C,ID),Feat,_,Type):-
	throw(xmg(type_error(feature_not_declared(ID,C)))).

type_def(TypeAttr,TypeDef):--
	type_decls::tget(TypeAttr,TypeDef),
	!.
type_def(TypeAttr,TypeAttr):--
	var(TypeAttr),
	!.
type_def(TypeAttr,_):--
	xmg:send(info,'\n\nError! Type '),
	xmg:send(info,TypeAttr),
	xmg:send(info,' is undefined.'),
	halt,
	!.

value_type(Value,Type):--
	xmg:type_expr(Value,Type),
	!.
