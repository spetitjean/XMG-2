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

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_typer:types]).

%% statement type with default parameters
xmg:stmt_type(syn,Dim,Dim:tree(FType,PType)):-
	xmg_brick_avm_avm:avm(FType,[]),
	xmg_brick_avm_avm:avm(PType,[]).
%% statement type with given parameters
xmg:stmt_type_constr(syn,tree).


xmg:type_stmt(syn:node(ID,Props,Feats),Syn:tree(FType,PType)):--
	xmg:type_expr(Feats,FType),

	xmg:send(debug,'\nFeats type is now '),
	xmg_brick_avm_avm:avm(FType,LFType),
	xmg:send(debug,LFType),
	xmg:type_expr(Props,PType),
	xmg:send(debug,'\nProps type is now '),
	xmg_brick_avm_avm:avm(PType,LPType),
	xmg:send(debug,LPType),
	xmg:get_var_type(ID,Type),
	Type=Syn:node(Syn:tree(FType,PType)),
	!.

xmg:type_stmt(syn:dom(Dom,N1,N2),Syn:tree(FType,PType)):--
	xmg:get_var_type(N1,T1),
	T1=Syn:node(Syn:tree(FType,PType)),
	xmg:get_var_type(N2,T2),
	T2=Syn:node(Syn:tree(FType,PType)),

	!.

xmg:type_stmt(syn:prec(Prec,N1,N2),Syn:tree(FType,PType)):--
	xmg:get_var_type(N1,T1),
	T1=Syn:node(Syn:tree(FType,PType)),
	xmg:get_var_type(N2,T2),
	T2=Syn:node(Syn:tree(FType,PType)),
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


xmg:type_stmt(syn:X,Type):--
	xmg:send(info,'\n\nDid not type syn statement:\n'),
        xmg:send(info,X),
        xmg:send(info,'\nwith type:\n'),
	xmg:send(info,Type),!,
	fail.

