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

:-module(xmg_brick_caller_explorer).

:- xmg:edcg.


:-edcg:using(xmg_brick_mg_explorer:calls).

xmg:find_calls(control:and(S1,S2)):--
	xmg:find_calls(S1),
	xmg:find_calls(S2),!.
xmg:find_calls(control:or(S1,S2)):--
	xmg:find_calls(S1),
	xmg:find_calls(S2),!.

xmg:find_calls(control:stmt(S1,S2)):--
	%%xmg:send(info,S1),
	xmg:find_calls(S1),!.

xmg:find_calls(control:eq(E1,E2)):--
	xmg:find_calls(E1),
	xmg:find_calls(E2),
	!.

xmg:find_calls(control:dot(E1,E2)):--
	xmg:find_calls(E1),
	!.

xmg:find_calls(control:call(token(_,id(Class)),Params)):--!,
	calls::enq(Class),
	!.

xmg:find_calls(_):-- !.