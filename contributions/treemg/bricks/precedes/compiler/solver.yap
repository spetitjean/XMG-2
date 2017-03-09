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

:- module(xmg_brick_precedes_solver, []).

:- use_module(library(gecode)).
:- use_module('xmg/brick/tree/compiler/dominance').


post(Space, NodeList, IntVars, Precedes) :-
    rposts(Space, NodeList, IntVars, Precedes).

rposts(_,_,_,[]) :- !.
rposts(Space, NodeList, IntVars, [Precede|Precedes]) :-
    rpost( Space, NodeList, IntVars, Precede ),
    rposts(Space, NodeList, IntVars, Precedes).

rpost(Space, NodeList, IntVars, Precede) :-
    %% rpost_split computes L1 and L2
    %% L1 is the list of nodes that have F1=V1
    %% L2 is the list of nodes that have F2=V2
    rpost_split(NodeList, Precede, L1, L2),
    rpost_do(L1, L2, NodeList, Space, IntVars).

rpost_split([], [], [], []).
rpost_split([N|NL], [(B1,B2)|Precede], O1, O2) :-
    (B1=true -> O1=[N|L1] ; O1=L1),
    (B2=true -> O2=[N|L2] ; O2=L2),
    rpost_split(NL, Precede, L1, L2).

%% rpost_do(L1,L2,_,_)
%% for each (N1,N2) of a node N1 from L1 a node N2 from L2
%% post the constraint that N1 precedes N2
rpost_do([], _, _, _, _) :- !.
rpost_do([N1|L1], L2, NodeList, Space, IntVars) :-
    rpost_do2(N1, L2, NodeList, Space, IntVars),
    rpost_do( L1, L2, NodeList, Space, IntVars).

rpost_do2(_, [], _,  _, _) :- !.
rpost_do2(N1, [N2|L2], NodeList, Space, IntVars) :-
    rpost_do3(N1, N2, NodeList, Space, IntVars),
    rpost_do2(N1, L2, NodeList, Space, IntVars).

rpost_do3(N1, N2, NodeList, Space, IntVars) :-
    assert_node(N1),
    xmg_brick_tree_solver:get_number(NodeList, N1,Num1),
    assert_node(N2),
    xmg_brick_tree_solver:get_number(NodeList, N2,Num2),
    xmg_brick_tree_solver:do_post(Space,IntVars,IntPVars,NodeList,hstep(more,Num1,Num2)),
    %%xmg_brick_tree_solver:get_rel(Num1,Num2,IntVars,RelVar),
    %%Space += dom(RelVar, 4),
    !.
