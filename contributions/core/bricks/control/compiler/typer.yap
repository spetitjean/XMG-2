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

xmg:type_stmt(control:opt(S1),Type):--
	xmg:type_stmt(S1,Type),!.

%% this should be in dim brick:
xmg:type_stmt(dim:dim(Dim,S),void):--
	%%xmg:send(info,'\n\ndim statement:\n'),
	%%xmg:send(info,S),
	%%xmg:send(info,Dim),
	%%xmg:dimbrick(Dim,Brick),
	get_dim_type(Dim,Type),
	xmg:send(debug,'\nexpected type:\n'),
	xmg:send(debug,Type),

	xmg:type_stmt(S,Type),
	xmg:send(debug,'\ndim typed\n'),

	!.

get_dim_type(Dim,Type):--
	dim_types::tget(dim:Dim,Type),
	!.
get_dim_type(Dim,Type):--
	xmg:principle(dimtype,DimType,Dims),
	xmg:send(debug,'\ngot dimtype declaration\n'),
	xmg:send(debug,Dim),
	xmg:send(debug,Dims),
	lists:member(Dim,Dims),!,
	xmg:dimbrick(Dim,Brick),
	xmg:send(debug,DimType),
	xmg:stmt_type(Brick,Dim,DimType,Type),
	%%xmg:send(info,'\n\nDim type: '),
	%%xmg:send(info,Type),
	dim_types::tput(dim:Dim,Type),!.
get_dim_type(Dim,Type):--
	xmg:dimbrick(Dim,Brick),
	xmg:send(debug,'\ndefault typing: '),
	xmg:stmt_type(Brick,Dim,Type),
	xmg:send(debug,Type),
	dim_types::tput(dim:Dim,Type),!.


xmg:type_stmt(control:eq(S1,S2),void):--
	xmg:type_expr(S1,Type),

	xmg:type_expr(S2,Type2),

	xmg:check_types(S1,S2,Type,Type2).
xmg:type_stmt(control:eq(S1,S2),_):--
	xmg:type_expr(S1,Type),
	%%xmg:send(debug,S2),

	xmg:type_expr(S2,Type2),

	xmg:check_types(S1,S2,Type,Type2),
	!.

xmg:check_types(_,_,Type,Type2):-
	Type=Type2,!.
xmg:check_types(S1,S2,Type,Type2):-
	xmg:send(info,'\n\n\nType Checker error: '),

	xmg:send(info,S1),
	xmg:send(info,Type),
	xmg:send(info,'\nand\n'),

	xmg:send(info,S2),
	xmg:send(info,Type2),
	xmg:send(info,'\n\n\n'),


	throw(xmg(type_error(incompatible_exprs(expr(S1,Type),expr(S2,Type2))))).

xmg:type_stmt(control:call(S1,S2),void):--
	xmg:type_expr(control:call(S1,S2),_),
	!.	

xmg:type_expr(control:call(token(_,id(S1)),Params),Type):--
	%% params should be checked here
	xmg:send(debug,Params),
	types::tget(class(S1),ClassType),
	xmg:do_forall(ClassType,(ParamsTypes,Type)),
	type_params(Params,ParamsTypes),
	!.


xmg:type_stmt(control:X,Type):--
	xmg:send(info,X),
	throw(xmg(type_error(incompatible_types(control:X,Type)))).


type_params([],_):-- !.
type_params([Expr|T],[Param-Type|T1]):--
	xmg:send(debug,Expr),
	xmg:send(debug,Type),
	xmg:type_expr(Expr,Type),
	type_params(T,T1),!.
