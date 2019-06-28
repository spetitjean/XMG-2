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

:- module(xmg_brick_colors_preparer).
:- use_module(library(apply), [maplist/3]).
:- xmg:edcg.

:-edcg:using(xmg_brick_mg_preparer:preparer).
:-edcg:weave([preparer],[prepare/2]).

get_instances([color]).


prepare(I,Out):--
    preparer::tget(nodes, Nodes),
    maplist(prepare_one, Nodes, Out),
    maplist(no_color, Nodes, NNodes),
    preparer::tput(nodes,NNodes),!.


prepare_one(node(P,F,N), Color) :- 
	xmg_brick_avm_avm:avm(P, Props),
	%%xmg:send(info,Props),
	xmg_brick_syn_nodename:nodename(N, NodeName),
	search_color(NodeName,Props,Color).


search_color(Name, [], Color) :-
    Color=none,
    xmg:send(info,'\nNo color for node '),
    xmg:send(info,Name),
    xmg:send(info,'. This should not happen.\n\n'),
    !.
search_color(_, [color-C|_], color(C)) :-
    !.
search_color(Name, [_|T], C) :-
    search_color(Name, T, C).


no_color(node(AVM,F,N),node(NCAVM,F,N)):-
	xmg_brick_avm_avm:avm(AVM,LAVM),
	lists:member(color-C,LAVM),!,
	      lists:subtract(LAVM,[color-C],NCLAVM),
	      %%xmg:send(info,NCLAVM),
	xmg_brick_avm_avm:avm(NCAVM,NCLAVM),
	%%xmg:send(info,'\nremoved color!'),
	!.

no_color(AVM,AVM):-
	!.

