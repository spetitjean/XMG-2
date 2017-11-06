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

:-module(xmg_brick_framedoms_compiler).

xmg:eval(frame,[framedoms],Frame,framedoms:frame(Extracted),Class):-
	xmg:send(debug,' preparing '),
	xmg_brick_framedoms_preparer:prepare(frame(Frame,[Class]),Prepared),
	xmg:send(debug,' prepared '),
	xmg_brick_framedoms_solver:solve(Prepared,solution(Solved)),
	xmg_brick_framedoms_extractor:extract(Solved,Extracted),
	xmg:send(debug,' extracted '),
	xmg:send(debug,Extracted).
	%%xmg_brick_mg_compiler:current(Previous)
	%%xmg:do_xml_convert(tree:tree(Tree,Class,Previous),XML)



