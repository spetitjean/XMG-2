%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2017  Simon Petitjean

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

:-module(xmg_brick_morpho_unfolder).

:-xmg:edcg.
:-xmg:unfolder_accs.

xmg:unfold_dimstmt(Dim,morpho:feat(Att,avm:avm(C,F))):--
    xmg:unfold_expr(Att,UAtt),
    xmg:unfold_expr(avm:avm(C,F),UVal),
    (var(UVal)->xmg:new_target_var(UVal);true),

    constraints::enq((morpho:feat(UAtt,UVal),Dim)),
    !.

xmg:unfold_dimstmt(Dim,morpho:feat(Att,Val)):--
    xmg:unfold_expr(Att,UAtt),
    xmg:unfold_expr(Val,UVal),
    constraints::enq((morpho:feat(UAtt,UVal),Dim)),
    !.

xmg:unfold_expr(morpho:dot(ID1,ID2),morpho:dot(UID1,UID2)):--
		  xmg:unfold_expr(ID1,UID1),
		  xmg:unfold_expr(ID2,UID2),
		  !.




