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

:- xmg:edcg.

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).

:- edcg:weave([constraints,name,vars,consts],[unfold_tree/4, unfold_children/4, unfold_child/4, unfold_node/3, unfold_brothers/4, unfold_node_or_tree/3]).
:- multifile(unfold_children/12).
:- multifile(unfold_node/11).


%%:-add_to_path('../AVM').
%%:-use_module('xmg_unfolder_avm').

%% unfold('DimStmt',[token(_,'<syn>'),token(_,'{'),DimStmt,token(_,'}')],'synStmt'(UStmt)):-
%% 	unfold(DimStmt,UStmt),
%% 	!.


xmg:unfold_dimstmt(Syn,syn:tree(Root,Children)):--
	%%xmg:send(info,'\n\nTREE: '),
	%%xmg_brick_mg_compiler:send(info,Root),
	unfold_tree(Syn,Root,Children,_),
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
	unfold_node(Syn,syn:node(N,P,F),_),
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

xmg:unfold_dimstmt(Syn,syn:notdom(token(_,Op),N1,N2)):-- 
	%%xmg:new_target_var(T1),
	%%xmg:new_target_var(T2),
	xmg:unfold_expr(N1,T1),
	xmg:unfold_expr(N2,T2),
	constraints::enq((syn:notdom(T1,Op,T2,C),Syn)),
	!.
xmg:unfold_dimstmt(Syn,syn:notprec(token(_,Op),N1,N2)):-- 
	xmg:unfold_expr(N1,T1),
	xmg:unfold_expr(N2,T2),
	constraints::enq((syn:notprec(T1,Op,T2,C),Syn)),
	!.





unfold_tree(Syn,Root,Children,URoot):--
	unfold_node(Syn,Root,URoot),
        %%xmg:send(info,Children),
	%%xmg:send(info,'\n\n'),
	unfold_children(Syn,URoot,Children,_),!.

unfold_children(Syn,URoot,syn:children(Child,Brothers),UChild):--
	unfold_child(Syn,URoot,Child,UChild),
	%%xmg:send(info,'\n\nHERE\n\n'),
	unfold_brothers(Syn,URoot,UChild,Brothers),!.
%% unfold_children(Syn,URoot,Children,UChild):--
%% 	xmg:send(info,'\n\nCould not unfold Children:\n'),
%% 	xmg:send(info,Children),
%% 	xmg:send(info,'\n\n'),
%% 	false,
%% 	!.

unfold_child(Syn,URoot,syn:child(Op,Child),UChild):--
	unfold_treeDomOp(Op,UOp),
	unfold_node_or_tree(Syn,Child,UChild),
	constraints::enq((syn:dom(URoot,UOp,UChild,C),Syn)),
	!.
unfold_child(Syn,URoot,Child,UChild):--
	xmg:send(info,'\n\nCould not unfold Child:\n'),
	xmg:send(info,Child),
	xmg:send(info,'\n\n'),
	false,
	!.

	
unfold_brothers(Syn,URoot,UChild,none):-- !.
unfold_brothers(Syn,URoot,UChild,brothers(Op,Children)):--
	unfold_treePrecOp(Op,UOp),
	%%xmg:send(info,'\n\n'),
	%%xmg:send(info,Children),
	unfold_children(Syn,URoot,Children,UChild1),
	constraints::enq((syn:prec(UChild,UOp,UChild1,C),Syn)),
	!.

unfold_node_or_tree(Syn,NodeOrTree,UNodeOrTree):--
	unfold_node(Syn,NodeOrTree,UNodeOrTree),!.
unfold_node_or_tree(Syn,syn:tree(Root,Children),URoot):--
	unfold_tree(Syn,Root,Children,URoot),!.


unfold_node(Syn,syn:node(N,P,F),TN):-- 
	xmg:unfold_expr(N,TN),

	(
	    var(TN)
	->
	    xmg:new_target_var(TN)
	    ;
	    true
        ),
	
	constraints::enq((TN,syn:node,Syn)),
	%%constraints::enq(indim(Syn,TN)),

	xmg:unfold_expr(P,T1),
	xmg:unfold_expr(F,T2),

	(var(T1)->xmg:new_target_var(T1);true),
	(var(T2)->xmg:new_target_var(T2);true),
	

	constraints::enq((TN,syn:props(T1))),	
	constraints::enq((TN,syn:feats(T2))),
	
	!.

unfold_treeDomOp(none,'->').
unfold_treeDomOp(token(_,'...'),'->*').
unfold_treeDomOp(token(_,'...+'),'->+').
unfold_treePrecOp(none,'>>').
unfold_treePrecOp(token(_,',,,'),'>>*').
unfold_treePrecOp(token(_,',,,+'),'>>+').



