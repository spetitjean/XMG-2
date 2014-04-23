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

:-edcg:using([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:dim_types]).

:-edcg:weave([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:dim_types],[value_type/2]).

xmg:stmt_type(iface,AVM):-
	xmg_brick_avm_avm:avm(AVM,[]).

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
	xmg:send(info,'\n\nTyping feat: '),
	xmg:send(info,Attr),
	xmg:send(info,'\n'),
	xmg:send(info,Value),
	xmg:send(info,'\nwith type '),
	xmg:send(info,Type),
	feat_type(Attr,UAttr,TypeAttr),
	type_def(TypeAttr,TypeDef),
	(
	    TypeDef=label ->
	    (
		value_type(Value,NewType),
	        ITypeAttr=NewType
	    )
	;
	    (
		value_type(Value,TypeAttr),
	        ITypeAttr=TypeAttr
	    )
	),
	extend_type(Type,UAttr,ITypeAttr),
	!.
xmg:type_expr(avm:feat(Attr,Value),Type):--
	throw(xmg(type_error(incompatible_types(Attr,Value,C)))).


extend_type(Type,UAttr,TypeAttr):-
	xmg_brick_avm_avm:dot(Type,UAttr,TypeAttr),!.
extend_type(Type,UAttr,TypeAttr):-
	xmg:send(info,'\n\nAVM Type Error! Could not extend type:\n'),
	xmg_brick_avm_avm:avm(Type,LType),
	xmg:send(info,LType),
	xmg:send(info,'\n'),
	xmg:send(info,UAttr),
	xmg:send(info,'\n'),	
	xmg:send(info,TypeAttr),
	fail.

	
xmg:type_stmt(avm:avm(Coord,Feats),Type):--
	xmg:type_expr(avm:avm(Coord,Feats),Type),!.

xmg:type_expr(avm:dot(value:var(token(_,id(AVM))),token(_,id(Feat))),Type):--
	types::tget(AVM,CAVM),
	xmg_brick_avm_avm:dot(CAVM,Feat,Type),
	!.

feat_type(token(_,id(Feat)),Feat,Type):-
	xmg:feat(Feat,Type),
	!.
feat_type(token(C,ID),Feat,Type):-
	throw(xmg(type_error(feature_not_declared(ID,C)))).

type_def(TypeAttr,TypeDef):-
	xmg:type(TypeAttr,TypeDef),
	!.
type_def(TypeAttr,_):-
	xmg:send(info,'\n\nError! Type '),
	xmg:send(info,TypeAttr),
	xmg:send(info,' is undefined.'),
	fail,
	!.

value_type(Value,Type):--
	xmg:type_expr(Value,Type),
	!.
