%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2014  Simon Petitjean

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

:-module(xmg_brick_dim_typer).

:- xmg:edcg.

:-edcg:using([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:dim_types,xmg_brick_mg_typer:type_decls]).
:-edcg:weave([xmg_brick_mg_typer:types,xmg_brick_mg_typer:type_decls],[xmg:stmt_type/4,get_types/2,get_type/2]).

xmg:stmt_type(Brick,Dim,Params,Type):--
	xmg:send(info,Params),
	get_types(Params,Types),	
	%%xmg:dimbrick(Dim,Brick),
	%% The types for Dim are contributed by Brick
	xmg:stmt_type_constr(Brick,Constr),!,
	DimType=..[Constr|Types],
	Type=..[':',Dim,DimType],!.

%% in case there is no type constructor (like in iface)
xmg:stmt_type(Brick,Dim,Params,Type):--
	xmg:send(info,Params),
	get_types(Params,[Type]),!.

get_types([],[]):-- !.
get_types([H|T],[H1|T1]):--
	get_type(H,H1),
	get_types(T,T1),!.

get_type(type(Type),GType):--
	type_decls::tget(Type,GType),!.
