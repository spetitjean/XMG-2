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

:- module(xmg_brick_mg_preparer, []).

:- xmg:edcg.

xmg:get_plugins(Solver,TreePlugins,OutPlugins):-
	findall(P,xmg:principle(P,Args,Dims),Plugins),
	filter_plugins(Solver,Plugins,[],TreePlugins,OutPlugins),!.

filter_plugins(Solver,[],_,[],[]).
filter_plugins(Solver,[H|T],Mem,[NH|T1],[_|T2]):-
	xmg:is_plugin(Solver,H,NH),
	not(lists:member(NH,Mem)),!,
	filter_plugins(Solver,T,[NH|Mem],T1,T2).
filter_plugins(Solver,[H|T],Mem,T1,T2):-
	filter_plugins(Solver,T,Mem,T1,T2),!.

xmg:prepare_plugins(Syn,[],prepared([],Syn)):- !.
xmg:prepare_plugins(Syn,[Plugin|T],prepared([Plugin-Out|TOut],NNSyn)):-
	xmg:prepare_plugin(Syn,Plugin,prepared(Out,NSyn)),
	xmg:prepare_plugins(NSyn,T,prepared(TOut,NNSyn)),!.


%% calls a preparer plugin named Plugin, which is located in the module xmg_brick_Plugin_preparer
xmg:prepare_plugin(Syn,Plugin,Out):-
	atom_concat(['xmg_brick_',Plugin,'_preparer'],Module),
	xmg:send(debug,Module),
	Prepare=..[prepare,Syn,Out],
	Do=..[':',Module,Prepare],!,
	Do,
	!.
xmg:prepare_plugin(Syn,Plugin,Out):-
	xmg:send(info,'\nUnknown plugin:'),
	xmg:send(info,Plugin),
	false,
	!.
