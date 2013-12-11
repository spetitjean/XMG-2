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

xmg:type_stmt(syn:and(S1,S2)):--

	xmg:type_stmt(S1),!,


	xmg:type_stmt(S2),!.	

xmg:type_stmt(syn:or(S1,S2)):--
	xmg:type_stmt(S1),!,
	xmg:type_stmt(S2),!.	

xmg:type_stmt(syn:node(ID,Props,Feats)):--
	xmg:get_var_type(ID,Type),
	xmg:send(info,Type),
	Type=syn:node,
	!.

xmg:type_stmt(syn:dom(Dom,N1,N2)):--
	!.

xmg:type_stmt(syn:prec(Prec,N1,N2)):--
	!.

xmg:type_stmt(syn:eq(S1,S2)):--
	!.

