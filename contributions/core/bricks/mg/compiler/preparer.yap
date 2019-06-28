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

:- module(xmg_brick_mg_preparer).
:- xmg:import('xmg/plugins').


:- xmg:edcg.
:-edcg:thread(preparer,edcg:table).
:-edcg:weave([preparer],[xmg:prepare_plugins/3, xmg:prepare_plugin/3, prepare_instances/5]).

:- multifile(xmg:prepare_plugin/3).
:- multifile(xmg:prepare_plugins/3).

xmg:get_plugins(Solver,TreePlugins,OutPlugins):-
	findall(P,xmg:principle(P,Args,Dims),Plugins),
	filter_plugins(Solver,Plugins,[],TreePlugins,OutPlugins),!.

filter_plugins(Solver,[],_,[],[]).
filter_plugins(Solver,[H|T],Mem,[NH|T1],[_|T2]):-
	xmg:is_plugin(Solver,NH,H),
	not(lists:member(NH,Mem)),!,
	filter_plugins(Solver,T,[NH|Mem],T1,T2).
filter_plugins(Solver,[H|T],Mem,T1,T2):-
	filter_plugins(Solver,T,Mem,T1,T2),!.

xmg:prepare_plugins(Syn,[],prepared([],Syn)):-- !.
xmg:prepare_plugins(Syn,[Plugin|T],prepared([Plugin-Out|TOut],NNSyn)):--
        %%xmg:send(info,'\nStarting prepare_plugins'),
        xmg:prepare_plugin(Syn,Plugin,prepared(Out,NSyn)),
        %%xmg:send(info,'\nOne done'),
	xmg:prepare_plugins(NSyn,T,prepared(TOut,NNSyn)),!.


%% calls a preparer plugin named Plugin, which is located in the module xmg_brick_Plugin_preparer
xmg:prepare_plugin(Dim,Plugin,prepared(Out,ODim)):--
        atomic_list_concat(['xmg/brick/', Plugin, '/compiler/preparer'], File1),
        atomic_list_concat(['xmg/brick/', Plugin, '/compiler/solver'  ], File2),
	%%use_module(File1, []),
	%%use_module(File2, []),
	atom_concat(['xmg_brick_',Plugin,'_preparer'],Module),
	%%xmg:send(info,'\nGot module: '),
	%%xmg:send(info,Module),
	Get=..[get_instances,I],
	DoGet=..[':',Module,Get],
	DoGet,!,
	%%xmg:send(info,'\nGot module'),
	prepare_instances(Dim,I,Module,Out,NDim),
	%% xmg:send(info,'\nDONE: '),
	%% xmg:send(info,prepared(Out,NDim)),
	preparer::tget(nodes,ODim),
	%%xmg:send(info,ODim),
	!.
xmg:prepare_plugin(Syn,Plugin,Out):--
	xmg:send(info,'\nUnknown plugin:'),
	xmg:send(info,Plugin),
	false,
	!.

prepare_instances(Dim,[],_,[],Dim):--!.
prepare_instances(Dim,[I|T],Module,[P|TP],NDim):--
        %%xmg:send(info,'\nPreparing instance'),
	preparer::get(In),
        %% cannot use the threads properly here, so give them explicitely
        Prepare=..[prepare,I,P,In,Out],
	DoPrepare=..[':',Module,Prepare],!,
	%%	    xmg:send(info,'\nDoing prepare: '),
	%%	    	xmg:send(info,DoPrepare),
			DoPrepare,
	%%		xmg:send(info,'\nDone'),
	preparer::set(Out),
	
	prepare_instances(IDim,T,Module,TP,NDim),!.
    
