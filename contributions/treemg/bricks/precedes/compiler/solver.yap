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
:- xmg:edcg.

:-edcg:using(xmg_brick_mg_solver:solver).
:-edcg:weave([solver],[post/1]).


post(Precedes) :--
    solver::tget(onodes,ONodeList),
    solver::tget(nodes,NodeList),
    solver::tget(intvars,IntVars),
    solver::tget(space,Space),
    rposts(Space, ONodeList, NodeList, IntVars, Precedes).

rposts(_,_,_,_,[]) :- !.
rposts(Space, ONodeList, NodeList, IntVars, [Precede|Precedes]) :-
    rpost( Space,  ONodeList,NodeList, IntVars, Precede ),
    rposts(Space,  ONodeList,NodeList, IntVars, Precedes).

rpost(Space, ONodeList, NodeList, IntVars, (L1,L2)) :-
    %% rpost_split computes L1 and L2
    %% L1 is the list of nodes that have F1=V1
    %% L2 is the list of nodes that have F2=V2
    %%rpost_split(NodeList, Precede, L1, L2),
    rpost_do(L1, L2, ONodeList, NodeList, Space, IntVars).

rpost_split([], [], [], []).
rpost_split([N|NL], [(B1,B2)|Precede], O1, O2) :-
    (B1=true -> O1=[N|L1] ; O1=L1),
    (B2=true -> O2=[N|L2] ; O2=L2),
    rpost_split(NL, Precede, L1, L2).

%% rpost_do(L1,L2,_,_)
%% for each (N1,N2) of a node N1 from L1 a node N2 from L2
%% post the constraint that N1 precedes N2
rpost_do([], _, _, _, _, _) :- !.
rpost_do([N1|L1], L2, ONodeList, NodeList, Space, IntVars) :-
    rpost_do2(N1, L2,  ONodeList,NodeList, Space, IntVars),
    rpost_do( L1, L2,  ONodeList,NodeList, Space, IntVars).

rpost_do2(_, [], _, _,  _, _) :- !.
rpost_do2(N1, [N2|L2],  ONodeList,NodeList, Space, IntVars) :-
    rpost_do3(N1, N2, ONodeList, NodeList, Space, IntVars),
    rpost_do2(N1, L2, ONodeList, NodeList, Space, IntVars).

rpost_do3(N1, N2, ONodeList, NodeList, Space, IntVars) :-
    %%assert_node(N1),
    %%xmg:send(info,ONodeList),
    %%xmg:send(info,NodeList),
    %% xmg:send(info,N1),
    %% N1=node(_,F,_),
    %% xmg_brick_avm_avm:avm(F,FS),
    %% xmg:send(info,FS),

    %% N1 and N2 come from the preparer, they have to be found in
    %% ONodeList and might still have colors
    get_node(N1,ONodeList,Num1),
    get_node(N2,ONodeList,Num2),
    %%xmg:send(info,Num1),
    %%xmg_brick_tree_solver:get_number(NodeList, N1,Num1),
    %%assert_node(N2),
    %%xmg_brick_tree_solver:get_number(NodeList, N2,Num2),
    %%xmg:send(info,hstep(more,Num1,Num2)),
    xmg_brick_tree_solver:do_post(Space,IntVars,_,NodeList,hstep(more,Num1,Num2)),
    %%xmg_brick_tree_solver:get_rel(Num1,Num2,IntVars,RelVar),
    %%Space += dom(RelVar, 4),
    !.


get_node(node(_,_,N),[Num-node(_,_,N1)|_],Num):-
    N==N1,!.
get_node(node(_,F,N),[_-node(_,_,N1)|T],M):-
    not(N==N1),
    get_node(node(_,F,N),T,M),!.
