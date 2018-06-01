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

:- module(xmg_brick_unicity_solver, []).

:- xmg:gecode.
:- use_module('xmg/brick/tree/compiler/dominance').

:- op(500, xfx, ':=:').

:-edcg:using(xmg_brick_mg_solver:solver).
:-edcg:weave([solver],[post/1]).

post(Unicities):--
    	solver::tget(space,Space),
        solver::tget(nodes,NodeList),
        solver::tget(intvars,IntVars),
	post_unicities(Space,NodeList,IntVars,Unicities),
	!.


post_unicities(Space,Nodelist,IntVars,[]):- !.
post_unicities(Space,NodeList,IntVars,[U1|UT]):-
	xmg:send(debug,' one unicity '),
	xmg:send(debug,U1),
	post_unicities_first(Space,NodeList,IntVars,U1,1),
	%%xmg_compiler:send(info,' one done '),
	post_unicities(Space,NodeList,IntVars,UT),!.

post_unicities_first(Space,[],IntVars,[],_):- !.
post_unicities_first(Space,[Node|T],IntVars,['true'|TU],I1):-
	I2 is I1+1,
	post_unicities_others(Space,T,TU,IntVars,Node,I1,I2),!.
post_unicities_first(Space,[Node|T],IntVars,['false'|TU],I1):-
	I2 is I1 +1,
	post_unicities_first(Space,T,IntVars,TU,I2),!.



post_unicities_others(Space,[],[],IntVars,_,_,_):- !.
post_unicities_others(Space,[Node|T],[true|TU],IntVars,NodeU,I1,I2):-
	assert_node(Node),
	assert_node(NodeU),

	%% EqX       :=: eq(Node),      
	%% EqY       :=: eq(NodeU),      
	%% Space += rel(EqX,'SRT_EQ',EqY),

	%% version 1: if two nodes share a property that has to be unique, they have to be the same, or to be in different subtrees
	%% This should be the version used by XMG-1

	%% Parent   :=: parent(Node),   
	%% ParentU   :=: parent(NodeU),   

	%% Rel1 := boolvar(Space),
	%% Rel2 := boolvar(Space),


	%% Space += rel(Rel1,'IRT_NQ',Rel2),


	%% Space += rel(Parent,'SRT_DISJ',ParentU,Rel1),

	%% xmg_brick_tree_solver:get_rel(I1,I2,IntVars,IntVar),
	%% Space += dom(IntVar,1,Rel2),

	%% version 2: if two nodes share a property that has to be unique, they have to be the same

	xmg_brick_tree_solver:get_rel(I1,I2,IntVars,IntVar),
	Space += dom(IntVar,1),

	%% end of version 2
    
	I3 is I2+1,
	%%xmg_compiler:send(info,' posted unicity'),

	%% post eq(Node)=eq(NodeU)
	post_unicities_others(Space,T,TU,IntVars,NodeU,I1,I3),!.
post_unicities_others(Space,[Node|T],[false|TU],IntVars,NodeU,I1,I2):-
	I3 is I2+1,
	post_unicities_others(Space,T,TU,IntVars,NodeU,I1,I3),!.

