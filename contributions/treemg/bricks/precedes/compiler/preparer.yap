%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2017  Denys Duchier

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

%% use precedes with (p1=v1, p2=v2) dims (d)
%% if there is a node X with p1=v1 and a node Y with p2=v2, X must precede Y

:- module(xmg_brick_precedes_preparer, []).
:- use_module(library(apply), [include/3]).
:- use_module('xmg/brick/tree/utils', [node_with_prop_or_featq/2]).

:-edcg:using(xmg_brick_mg_preparer:preparer).
:-edcg:weave([preparer],[prepare/2]).


get_instances(I):-
    xmg:precedes(I).


prepare((feat(F1,V1,_),feat(F2,V2,_)), (L1,L2)) :--
    preparer::tget(nodes,Nodes),
    include(node_with_prop_or_featq(F1-V1), Nodes, L1),
    include(node_with_prop_or_featq(F2-V2), Nodes, L2).
