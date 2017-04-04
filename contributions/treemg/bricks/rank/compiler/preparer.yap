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

:- module(xmg_brick_rank_preparer, []).
:- use_module(library(apply), [maplist/3]).
:- use_module('xmg/brick/avm/avm', [avm/2]).
:- use_module('xmg/brick/tree/utils', [node_with_prop/2]).

:-edcg:using(xmg_brick_mg_preparer:preparer).
:-edcg:weave([preparer],[prepare/2]).

get_instances([rank]).

prepare(I, Out) :--
    preparer::tget(nodes,Nodes),
    maplist(prepare_one, Nodes, Out),
    !.

prepare_one(Node, Result) :-
    node_with_prop(rank-C, Node)
    -> Result=rank(C)
    ;  Result=rank(none).
