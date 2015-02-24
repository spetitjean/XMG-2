%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2015  Simon Petitjean

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

:-module(xmg_brick_morphlp_unfolder).

:-xmg:edcg.
:-xmg:unfolder_accs.


xmg:unfold_dimstmt(Dim,morphlp:field(Var)):--
	xmg:send(debug,'here'),
	xmg:unfold_expr(Var,UVar),
	constraints::enq((morphlp:field(UVar),Dim)),!.
xmg:unfold_dimstmt(Dim,morphlp:infield(Field,E)):--
	xmg:unfold_expr(Field,UField),
	xmg:unfold_expr(E,UE),
	constraints::enq((morphlp:infield(UField,UE),Dim)),!.
xmg:unfold_dimstmt(Dim,morphlp:fieldprec(Stem1,Stem2)):--
	xmg:unfold_expr(Stem1,UStem1),
	xmg:unfold_expr(Stem2,UStem2),
	constraints::enq((morphlp:fieldprec(UStem1,UStem2),Dim)),!.
xmg:unfold_dimstmt(Dim,morphlp:meq(E1,E2)):--
	xmg:unfold_expr(E1,UE1),
	xmg:unfold_expr(E2,UE2),
	constraints::enq((morphlp:eq(UE1,UE2),Dim)),!.


