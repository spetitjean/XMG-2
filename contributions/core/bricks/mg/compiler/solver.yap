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

:- module(xmg_brick_mg_solver, []).

:-xmg:edcg.
:-edcg:thread(solver,edcg:table).
:-edcg:weave([solver],[xmg:post_plugins/4, xmg:post_plugin/4]).



xmg:post_plugins([],_,_,_):-- !.
xmg:post_plugins([Plugin|Plugins],Space,NodeList,IntVars):--	
	xmg:post_plugin(Plugin,Space,NodeList,IntVars),
	xmg:post_plugins(Plugins,Space,NodeList,IntVars),!.


xmg:post_plugin(Plugin-PlugList,Space,NodeList,IntVars):--
	xmg:send(debug,' posting '),
        xmg:send(debug,Plugin),
	xmg:send(debug,'\n'),
	%%xmg:send(debug,PlugList),

	atom_concat(['xmg_brick_',Plugin,'_solver'],Module),

	solver::get(In),
        %% cannot use the threads properly here, so give them explicitely	
	Post=..[post,Space,NodeList,IntVars,PlugList,In,Out],
	Do=..[':',Module,Post],
	Do,
	xmg:send(debug,'\nposted'),

	solver::set(Out),
	!.
