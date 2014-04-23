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

:-module(xmg_brick_value_typer).

:-edcg:using([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:type_decls]).


xmg:type_expr(value:var(token(_,id(ID))),Type):--
	types::tget(ID,Type),
	!.
xmg:type_expr(token(_,id(ID)),Type):--
	types::tget(ID,Type),
	!.

xmg:type_expr(token(_,bool(_)),bool):--
	!.
xmg:type_expr(token(_,int(_)),int):--
	!.
xmg:type_expr(token(_,string(_)),string):--
	!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% typing a constant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmg:type_expr(token(_,id(ID)),Type):--
	type_decls::tget(Type,GType),
	type_const(ID,GType),
	!.

%% not only for constants
type_const(_,A):- 
	var(A),!.
type_const(Const,enum(Enum)):- 
	!,
	type_enum_const(Const,Enum),!.

%% not for constants at all
type_const(Const,struct(Obl,Opt,More)):- 
	type_stuct_const(Const,Obl,Opt,More),!.



type_enum_const(Const,List):-
	lists:member(Const,List),!.