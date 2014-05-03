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

:-module(xmg_brick_polAvm_typer).

:-edcg:using([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:dim_types,xmg_brick_mg_typer:type_decls]).


xmg:type_expr(polAvm:feat(Attr,Value,Pol),Type):--
	xmg:type_expr(avm:feat(Attr,Value),Type),
	!.
