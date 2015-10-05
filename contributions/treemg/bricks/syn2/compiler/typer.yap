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

:-module(xmg_brick_syn2_typer).

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_typer:types]).

%% statement type with default parameters
xmg:stmt_type(syn2,Dim,Dim:tree(FType,PType)):-
	xmg_brick_avm_avm:avm(FType,[]),
	xmg_brick_avm_avm:avm(PType,[]).
%% statement type with given parameters
xmg:stmt_type_constr(syn2,tree).


xmg:type_stmt(syn:node(ID,Props,Feats,L),Syn:tree(FType,PType)):--
	     xmg:type_stmt(syn:node(ID,Props,Feats),Syn:tree(FType,PType)),
	!.
