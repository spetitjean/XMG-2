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

%% le type associé à la dimension est a priori inconnu, ce sont des variables contraintes (au départ pas contraintes)
%% dans l'environnement, on a toutes les variables de type contraintes

%% ici, quelque part, il faut dire que le type des expressions de cette brique est syn:tree(FType,PType)
xmg:stmt_type(syn,syn:tree(FType,PType)).

xmg:type_stmt(syn:node(ID,Props,Feats),syn:tree(FType,PType)):--
	xmg:type_expr(Feats,FType),

	xmg:type_expr(Props,PType),

	xmg:get_var_type(ID,Type),
	Type=syn:node(syn:tree(FType,PType)),


	!.

xmg:type_stmt(syn:dom(Dom,N1,N2),syn:tree(FType,PType)):--
	xmg:get_var_type(N1,T1),
	T1=syn:node(syn:tree(FType,PType)),
	xmg:get_var_type(N2,T2),
	T2=syn:node(syn:tree(FType,PType)),

	!.

xmg:type_stmt(syn:prec(Prec,N1,N2),syn:tree(FType,PType)):--
	xmg:get_var_type(N1,T1),
	T1=syn:node(syn:tree(FType,PType)),
	xmg:get_var_type(N2,T2),
	T2=syn:node(syn:tree(FType,PType)),
	!.

xmg:type_stmt(syn:tree(Node,Children),Type):--
	xmg:type_stmt(Node,Type),
	xmg:type_stmt(Children,Type),
	!.

xmg:type_stmt(syn:children(Tree,none),Type):--
	xmg:type_stmt(Tree,Type),
	!.
xmg:type_stmt(syn:children(Tree,brothers(_,Brothers)),Type):--
	xmg:type_stmt(Tree,Type),
	xmg:type_stmt(Brothers,Type),
	!.

xmg:type_stmt(syn:child(Op,Tree),Type):--
	xmg:type_stmt(Tree,Type),
	!.


xmg:type_stmt(syn:X,_):--
	xmg:send(info,'\n\nDid not type syn statement:\n'),
	xmg:send(info,X),!,
	fail.

