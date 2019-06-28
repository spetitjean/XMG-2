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

:- module(xmg_brick_unicity_preparer).
:- use_module(library(apply), [include/3]).
:- use_module(library(apply), [maplist/3]).

:- xmg:edcg.
:- xmg:import('xmg/brick/tree/utils').

:-edcg:using([xmg_brick_mg_preparer:preparer]).
:-edcg:weave([preparer],[prepare/2]).

get_instances(I):-
    xmg:unicity(I).

prepare(feat(A,V,_), Out) :--
    xmg:send(info,'\nHere in prepare unicity'),
    preparer::tget(nodes,Nodes),
    xmg:send(info,'\nGot nodes'),
    maplist(prepare_one(A-V), Nodes, Out).

prepare_one(FV, Node, Result) :-
    xmg:send(info,'\nIn prepare_one'),
    (xmg_brick_tree_utils:node_with_prop_or_featq(FV, Node)
    -> Result=true ; Result=false).
