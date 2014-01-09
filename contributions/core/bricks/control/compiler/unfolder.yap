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


:-module(xmg_brick_control_unfolder).

:- edcg:using([xmg_brick_mg_accs:constraints, xmg_brick_mg_accs:name, xmg_brick_mg_accs:vars, xmg_brick_mg_accs:consts]).
%%:- edcg:weave([constraints,name,vars,consts], []).

xmg:unfold_stmt(control:and(E1,E2)):--
	xmg:unfold_stmt(E1),
	%%xmg_brick_mg_compiler:send(info,C1),
	xmg:unfold_stmt(E2),
	!.
xmg:unfold_stmt(control:or(E1,E2)):--
	xmg:unfold_stmt(E1) with (constraints([]-C1,[]-[])),
	xmg:unfold_stmt(E2) with (constraints([]-C2,[]-[])),
	constraints::enq(control:or([control:and(C1),control:and(C2)])),
	!.

xmg:unfold_dimstmt(Dim,control:and(S1,S2)):-- 
	%%xmg_brick_mg_compiler:send(info,S1),
	xmg:unfold_dimstmt(Dim,S1) ,
	xmg:unfold_dimstmt(Dim,S2) ,
	!.
xmg:unfold_dimstmt(Dim,control:or(S1,S2)):-- 
	xmg:unfold_dimstmt(Dim,S1) with (constraints([]-C1,[]-[])),
	xmg:unfold_dimstmt(Dim,S2) with (constraints([]-C2,[]-[])),
	constraints::enq(control:or([control:and(C1),control:and(C2)])),
	!.


