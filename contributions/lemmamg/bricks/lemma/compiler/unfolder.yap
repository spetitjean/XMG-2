%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2016  Simon Petitjean

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

:-module(xmg_brick_lemma_unfolder).

:-xmg:edcg.
:-xmg:unfolder_accs.


xmg:unfold_dimstmt(Dim,lemma:feat(Att,Val)):--
	xmg:unfold_expr(Att,UAtt),
	xmg:unfold_expr(Val,UVal),
	constraints::enq((lemma:feat(UAtt,UVal),Dim)),!.
xmg:unfold_dimstmt(Dim,lemma:equation(E1,E2,E3)):--
	xmg:unfold_expr(E1,UE1),
        xmg:unfold_expr(E2,UE2),
        xmg:unfold_expr(E3,UE3),
	constraints::enq((lemma:equation(UE1,UE2,UE3),Dim)),!.
xmg:unfold_dimstmt(Dim,lemma:coanchor(ID1,Expr,ID2)):--
		  xmg:unfold_expr(ID1,UID1),
		  xmg:unfold_expr(ID2,UID2),
		  xmg:unfold_expr(Expr,UExpr),
		  constraints::enq((lemma:coanchor(UID1,UExpr,UID2),Dim)),
		  !.
xmg:unfold_expr(lemma:dot(ID1,ID2),lemma:dot(UID1,UID2)):--
		  xmg:unfold_expr(ID1,UID1),
		  xmg:unfold_expr(ID2,UID2),
		  !.



