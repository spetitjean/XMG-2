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


:-module(xmg_brick_syn_unfolder).

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).

:- edcg:weave([constraints,name,vars,consts],[unfold_tree/3, unfold_children/3]).


%%:-add_to_path('../AVM').
%%:-use_module('xmg_unfolder_avm').

%% unfold('DimStmt',[token(_,'<syn>'),token(_,'{'),DimStmt,token(_,'}')],'synStmt'(UStmt)):-
%% 	unfold(DimStmt,UStmt),
%% 	!.


xmg:unfold_dimstmt(Syn,syn:tree(Root,Children)):--
	%%xmg_brick_mg_compiler:send(info,Root),
	unfold_tree(Syn,Root,Children),
	!.
xmg:unfold_dimstmt(Syn,syn:and(S1,S2)):-- 
	%%xmg_brick_mg_compiler:send(info,S1),
	xmg:unfold_dimstmt(Syn,S1) ,
	xmg:unfold_dimstmt(Syn,S2) ,
	!.
xmg:unfold_dimstmt(Syn,syn:or(S1,S2)):-- 
	xmg:unfold_dimstmt(Syn,S1) with (constraints([]-C1,[]-[])),
	xmg:unfold_dimstmt(Syn,S2) with (constraints([]-C2,[]-[])),
	constraints::enq(or([and(C1),and(C2)])),
	!.

xmg:unfold_dimstmt(Syn,syn:S1):-- 
	xmg:unfold_dimstmt(Syn,S1),!.

xmg:unfold_dimstmt(Syn,syn:node(N,P,F)):-- 
	xmg:unfold_expr(N,TN),
	
	constraints::enq((TN,syn:node,Syn)),
	%%constraints::enq(indim(Syn,TN)),
	xmg:new_target_var(T1),
	xmg:new_target_var(T2),
	%%xmg_brick_mg_compiler:send(info,P),
	%%xmg_brick_mg_compiler:send(info,F),
	xmg:unfold_expr(P,T1),
	constraints::enq((TN,syn:props(T1))),	
	xmg:unfold_expr(F,T2),
	constraints::enq((TN,syn:feats(T2))),
	!.
xmg:unfold_dimstmt(Syn,syn:dom(token(_,Op),N1,N2)):-- 
	%%xmg:new_target_var(T1),
	%%xmg:new_target_var(T2),
	xmg:unfold_expr(N1,T1),
	xmg:unfold_expr(N2,T2),
	constraints::enq((syn:dom(T1,Op,T2,C),Syn)),
	!.
xmg:unfold_dimstmt(Syn,syn:prec(token(_,Op),N1,N2)):-- 
	xmg:unfold_expr(N1,T1),
	xmg:unfold_expr(N2,T2),
	constraints::enq((syn:prec(T1,Op,T2,C),Syn)),
	!.

xmg:unfold_expr(none,_):-- !.
xmg:unfold_expr(some(E),Target):--
	xmg:unfold_expr(E,Target),!.



unfold_tree(Syn,Root,Children):--
	%%xmg:unfold_expr(Root,URoot),
	xmg:send(info,Children),
	unfold_children(Syn,Root,Children),!.

unfold_children(Syn,Root,syn:child(Op,Child,Brothers)):--

	constraints::enq((syn:dom(T1,Op,T2,C),Syn)),
	unfold_brothers(Syn,Root,Brothers),!.






