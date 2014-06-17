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


:-module(xmg_brick_frame_unfolder).

:-xmg:edcg.
:-xmg:unfolder_accs.

:-edcg:weave([constraints,name,vars,consts],[unfold_frame/2, unfold_pairs/2, unfold_pair/2]).

xmg:unfold_dimstmt(Frame,Stmt):--
	xmg:new_target_var(TFrame),
	unfold_frame(Stmt,UStmt),
	constraints::enq((UStmt,frame:topframe,Frame)),
	!.

unfold_frame(frame:frame(Var,Type,Feats),TFrame):--
	xmg:unfold_expr(Type,UType),
	
	(
	    Var=none 
	->
	xmg:new_target_var(TFrame)
    ;
	xmg:unfold_expr(Var,TFrame)
    ),

	constraints::enq((TFrame,frame:frame,UType)),

	unfold_pairs(Feats,TFrame),

	!.

unfold_pairs([],_):-- !.
unfold_pairs([H|T],TFrame):--
	unfold_pair(H,TFrame),
	xmg:send(info,' Pair unfolded'),
	unfold_pairs(T,TFrame),!.

unfold_pair(frame:pair(Left,Right),TFrame):--
	xmg:unfold_expr(Left,ULeft),
	xmg:unfold_expr(Right,URight),
	xmg:new_target_var(TVar),
	constraints::enq(eq(TVar,URight)),
	constraints::enq((TFrame,frame:pair,ULeft-TVar)),
	!.
unfold_pair(frame:pair(Left,Right),TFrame):--
	xmg:unfold_expr(Left,ULeft),
	unfold_frame(Right,URight),
	constraints::enq((TFrame,frame:pair,ULeft-URight)),
	!.



%% an older try, 

xmg:unfold_dimstmt(Frame,frame:tree(Root,Children)):--
	%%xmg_brick_mg_compiler:send(info,Root),
	!.


xmg:unfold_dimstmt(Frame,frame:node(N,P,F)):-- 
	xmg:unfold_expr(N,TN),
	
	constraints::enq((TN,frame:node,Frame)),
	%%constraints::enq(indim(Syn,TN)),
	xmg:new_target_var(T1),
	xmg:new_target_var(T2),
	%%xmg_brick_mg_compiler:send(info,P),
	%%xmg_brick_mg_compiler:send(info,F),
	xmg:unfold_expr(P,T1),
	constraints::enq((TN,frame:props(T1))),	
	xmg:unfold_expr(F,T2),
	constraints::enq((TN,frame:feats(T2))),
	!.
xmg:unfold_dimstmt(Frame,frame:edge(Props,N1,N2)):-- 
	xmg:new_target_var(V1),
	xmg:unfold_expr(Props,V1),
	xmg:unfold_expr(N1,T1),
	xmg:unfold_expr(N2,T2),
	constraints::enq((frame:edge(V1,T1,T2),Frame)),
	!.

%% xmg:unfold_dimstmt(Frame,Stmt):--
%% 	xmg:send(info,'\nunable to unfold\n'),
%% 	xmg:send(info,Stmt),
%% 	false,!.
	







