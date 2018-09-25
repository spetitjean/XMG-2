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

%% use requires with (p1=v1, p2=v2) dims (d)
%% if there is a node with p1=v1, then there must a node with p2=v2

:- module(xmg_brick_requires_preparer, []).

:-xmg:edcg.
%%:- use_module('xmg/brick/tree/utils', [node_with_prop_or_featq/2]).
:- use_module(library(apply), [include/3]).

:-edcg:using(xmg_brick_mg_preparer:preparer).
:-edcg:weave([preparer],[prepare/2]).


get_instances(I):-
    xmg:requires(I).


prepare((feat(F1,V1,_),feat(F2,V2,_)), (L1,L2)) :--
    preparer::tget(nodes,Nodes),
    include(node_with_prop_or_featq(F1-V1), Nodes, L1),
    (L1=[] -> true
     ; include(node_with_prop_or_featq(F2-V2), Nodes, [_|_])),
    !.

prepare((_,_), (_,_)) :--
    xmg:send(info,'\n  Solution discarded by principle requires\n'),
    fail.
    
