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

:-module(xmg_brick_syn_typer).

:-edcg:using([xmg_brick_mg_typer:types]).

xmg:type_stmt(syn:and(S1,S2),SynType):--

	xmg:type_stmt(S1,SynType),!,


	xmg:type_stmt(S2,SynType),!.	

xmg:type_stmt(syn:or(S1,S2),SynType):--
	xmg:type_stmt(S1,SynType),!,
	xmg:type_stmt(S2,SynType),!.	

xmg:type_stmt(syn:node(ID,Props,Feats),syn:tree(FType,PType)):--

	xmg:type_expr(Feats,FType),
	xmg:check_types(FType,FeatType,Coord),

	xmg:type_expr(Props,PType),
	xmg:check_types(PType,PropType,Coord),

	xmg:get_var_type(ID,Type),
	xmg:check_types(Type,syn:node(tree(FType,PType)),Coord),
	!.

xmg:type_stmt(syn:dom(Dom,N1,N2),syn:tree(FType,PType)):--
	xmg:get_var_type(N1,V1),
	xmg:check_types(V1,syn:node(tree(FType,PType)),Coord),
	xmg:get_var_type(N2,V2),
	xmg:check_types(V2,syn:node(tree(FType,PType)),Coord),
	!.

xmg:type_stmt(syn:prec(Prec,N1,N2),syn:tree(FType,PType)):--
	xmg:get_var_type(N1,V1),
	xmg:check_types(V1,syn:node(tree(FType,PType)),Coord),
	xmg:get_var_type(N2,V2),
	xmg:check_types(V2,syn:node(tree(FType,PType)),Coord),
	!.

xmg:type_stmt(syn:eq(S1,S2),void):--
	xmg:get_var_type(S1,V1),
	xmg:get_var_type(S2,V2),
	xmg:check_types(V1,V2,Coord),
	!.

