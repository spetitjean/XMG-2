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

%% use excludes with (p1=v1, p2=v2) dims (d)
%% there cannot be both a node with p1=v1 and a node with p2=v2

:- module(xmg_brick_excludes_preparer, []).
:- use_module(xmg_brick_requires_preparer).

get_instances(I):-
    xmg:excludes(I).


prepare_instance(Dim,R1,H1,Dim):-
    xmg_brick_requires_preparer:write_require(Nodes,R1,H1),
    xmg_brick_requires_preparer:write_require_reduce(H1, false, false, B1, B2),
    %% fail here if the "excludes" is not satisfied
    (B1=false ; B2=false), !.

prepare_instance(Dim,R1,H1,Dim):-
    xmg:send(info,'\nFail caused by excludes: '),
    xmg:send(info,R1),
    fail.
