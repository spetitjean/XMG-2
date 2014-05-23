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

:-module(xmg_brick_control_typer).

:- xmg:edcg.

:-edcg:using([xmg_brick_mg_typer:types,xmg_brick_mg_typer:type_decls,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:dim_types]).
:-edcg:weave([dim_types,types,type_decls,global_context],[get_dim_type/2,type_params/2]).


xmg:type_stmt(control:and(S1,S2),Type):--
	xmg:type_stmt(S1,Type),!,
	xmg:type_stmt(S2,Type),!.	

xmg:type_stmt(control:or(S1,S2),Type):--
	xmg:type_stmt(S1,Type),!,
	xmg:type_stmt(S2,Type),!.

%% this should be in dim brick:
xmg:type_stmt(dim:dim(Dim,S),void):--
	%% xmg:send(info,'\n\ndim statement:\n'),
	%% xmg:send(info,S),
	%% xmg:send(info,Dim),
	xmg:dimbrick(Dim,Brick),
	get_dim_type(Brick,Type),
	xmg:send(info,Type),
	%% xmg:send(info,'\nexpected type:\n'),
	%% xmg:send(info,Type),

	xmg:type_stmt(S,Type),
	xmg:send(info,'\ndim typed\n'),

	!.

get_dim_type(Dim,Type):--
	dim_types::tget(dim:Dim,Type),!.
get_dim_type(Dim,Type):--
	xmg:principle(dimtype,DimType,Dims),
	lists:member(Dim,Dims),!,
	xmg:send(info,DimType),
	xmg:stmt_type(Dim,DimType,Type),
	xmg:send(info,'\n\nDim type: '),
	xmg:send(info,Type),
	dim_types::tput(dim:Dim,Type),!.
get_dim_type(Dim,Type):--
	xmg:stmt_type(Dim,Type),
	dim_types::tput(dim:Dim,Type),!.


xmg:type_stmt(control:eq(S1,S2),void):--
	xmg:type_expr(S1,Type),
	xmg:type_expr(S2,Type2),
	check_types(S1,S2,Type,Type2),
	!.

check_types(_,_,Type,Type2):-
	Type=Type2,!.
check_types(S1,S2,Type,Type2):-
	throw(xmg(type_error(incompatible_exprs(expr(S1,Type),expr(S2,Type2))))).

xmg:type_stmt(control:call(S1,S2),void):--
	xmg:type_expr(control:call(S1,S2),_),
	!.	

xmg:type_expr(control:call(token(_,id(S1)),Params),Type):--
	%% params should be checked here
	xmg:send(info,Params),
	types::tget(S1,(ParamsTypes,Type)),
	type_params(Params,ParamsTypes),
	!.


xmg:type_stmt(control:X,Type):--
	throw(xmg(type_error(incompatible_types(control:X,Type)))).


type_params([],_):-- !.
type_params([Expr|T],[Param-Type|T1]):--
	xmg:send(info,Expr),
	xmg:send(info,Type),
	xmg:type_expr(Expr,Type),
	type_params(T,T1),!.