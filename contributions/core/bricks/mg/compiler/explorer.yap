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

:-module(xmg_brick_mg_explorer).

:-edcg:thread(calls,edcg:queue).
:-edcg:thread(classes,edcg:queue).

:-multifile(xmg:find_calls/3).

:-edcg:weave([classes],[xmg:find_calls_in_classes/1]).
:-edcg:weave([calls],[xmg:find_calls/1]).


find_calls_in_classes(MG,Classes):--
	%%xmg:send(info,MG),

	xmg:find_calls_in_classes(MG) with classes([]-Classes,[]-[]),!.

xmg:find_calls_in_classes(mg:mg(Decls,Classes,Values)):--
	%%xmg:send(info,Classes),
	xmg:find_calls_in_classes(Classes),!.

xmg:find_calls_in_classes([]):-- !.
xmg:find_calls_in_classes([H|T]):-- 
	xmg:find_calls_in_classes(H),
	xmg:find_calls_in_classes(T),!.

xmg:find_calls_in_classes(mg:class(token(_,id(Name)),Params,Imports,Exports,Decls,Stmts)):--
	%%xmg:send(info,Name),
	xmg:find_calls(Stmts) with calls([]-Calls,[]-[]),
	classes::enq((Name,Calls)),!.

xmg:find_calls_in_classes(Class):--
	xmg:send(info,'\n\nDo not know what to do with '),
	xmg:send(info,Class),
	
	!.
