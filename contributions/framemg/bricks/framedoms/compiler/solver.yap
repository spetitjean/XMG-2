%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2016  Simon Petitjean

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

:- module(xmg_brick_framedoms_solver).

solve(prepared(Frames,Doms),solution(Frames)):-
    solve_doms(Doms,Frames).

solve_doms([],Frames).
solve_doms([H|T],Frames):-
    solve_dom(H,Frames),
    solve_doms(T,Frames).

%% solve one dominance constraints: operate the necessary unifications
solve_dom(dom(F1,token(_,'>*'),F2),Frames):-
    solve_dom_star(F1,F2,Frames).

solve_dom_star(F1,F2,Frames):-
    find_label(F1,Frames,FL1),
    xmg:send(debug,'found label \n'),
    xmg:send(debug,F1),
    xmg:send(debug,FL1),
    xmg:send(debug,'\nNow unifying '),
    attvar(F2),!,
    xmg_brick_havm_havm:h_avm(F2,_,Feats),
    xmg:send(debug,Feats),
    unify_star(F2,FL1,F21),
    F2=F21,
    xmg:send(debug,'unified \n').
%% When F2 is not a typed feature structure (either constant or variable)
solve_dom_star(F1,F2,Frames):-
    find_label(F1,Frames,FL1),
    xmg:send(debug,'found label \n'),
    xmg:send(debug,F1),
    xmg:send(debug,FL1),
    xmg:send(debug,'\nNow unifying '),
    xmg:send(debug,Feats),
    unify_star(F2,FL1,F21),
    F2=F21,
    xmg:send(debug,'unified \n').

find_label(F1,[H|T],FL1):-
    find_label_1(F1,H,FL1).
find_label(F1,[H|T],FL1):-
    find_label(F1,T,FL1).

%% TODO
find_label_1(F1,Frame,Frame):-
    F1==Frame.
find_label_1(F1,Frame,Frame1):-
    attvar(Frame),
    xmg_brick_havm_havm:h_avm(Frame,_,List),
    find_label_in_children(F1,List,Frame1).

find_label_in_children(F1,[_-H|T],H):-
    F1==H.
find_label_in_children(F1,[_-H|T],FL):-
    attvar(H),
    xmg_brick_havm_havm:h_avm(H,_,List),
    find_label_in_children(F1,List,FL).
find_label_in_children(F1,[_|T],FL):-
    find_label_in_children(F1,T,FL).

    

unify_star(F2,Frame,Frame):-
    not(not(F2=Frame)),
    xmg:send(debug,'Performed unification on initial node \n').
unify_star(F2,Frame,F21):-
    attvar(Frame),
    xmg_brick_havm_havm:h_avm(Frame,_,List),
    xmg:send(debug,'Unify in children: \n'),
    xmg:send(debug,List),
    unify_in_children(F2,List,F21).

unify_in_children(F2,[A-H|T],H):-
    not(not(F2=H)),
    xmg:send(debug,'Performed unification for child attribute \n'),
    xmg:send(debug,A).
unify_in_children(F2,[_-H|T],F21):-
    attvar(H),
    xmg_brick_havm_havm:h_avm(H,_,List),
    xmg:send(debug,List),
    unify_in_children(F2,List,F21).
unify_in_children(F2,[_-H|T],F21):-
    unify_in_children(F2,T,F21).
    
