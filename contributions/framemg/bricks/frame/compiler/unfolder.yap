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

xmg:unfold_dimstmt(Frame,frame:dom(V1,V2,Op)):--
	xmg:unfold_expr(V1,T1),
	xmg:unfold_expr(V2,T2),
	constraints::enq((frame:dom(T1,Op,T2),Frame)),
	!.

xmg:unfold_dimstmt(Frame,frame:frame(V,T,F)):--
	xmg:new_target_var(TFrame),
	unfold_frame(frame:frame(V,T,F),UStmt),
	constraints::enq((UStmt,frame:topframe,Frame)),
	!.

unfold_frame(frame:frame(Var,Type,Feats),TFrame):--
	xmg:unfold_expr(Type,UType),
	(
	    Var=none 
	->
	    xmg:new_target_var(TFrame)
	 ;
	 (
	     xmg:unfold_expr(Var,TFrame)
	)),
	constraints::enq((TFrame,frame:frame,UType)),

	unfold_pairs(Feats,TFrame),

	!.

unfold_pairs([],_):-- !.
unfold_pairs([H|T],TFrame):--
	unfold_pair(H,TFrame),
	xmg:send(debug,' Pair unfolded'),
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









