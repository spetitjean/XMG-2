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

:- module(xmg_brick_rank_solver, []).

:- use_module(library(gecode)).
:- use_module('xmg/brick/tree/compiler/dominance').


:- op(500, xfx, ':=:').


post(Space,NodeList,IntVars,Ranks):-
	ranks(Space,NodeList,IntVars,Ranks,RankRels),!.

ranks(Space,NodeList,IntVars,Ranks,RankRels):-

	rposts(Space,NodeList,Ranks,1,RankList),!,
	lists:keysort(RankList,SRankList),!,
	(
	    SRankList=[]
	->
	RankRels=[]
    ;
	(
	    SRankList=[RH|RT],
	    do_rposts(Space,[RH|RT],RT,RankRels,IntVars)
	)
    ),!.

rposts(_,[],[],_,[]):- !.

rposts(Space,[Node|T],[rank(none)|TC],N,T1):-
	M is N+1,
	rposts(Space,T,TC,M,T1),!.

rposts(Space,[Node|T],[rank(Rank)|TC],N,[Rank-rank(Node,N)|T1]):-
	%%	post(Space,Node,rank(Rank),N),
	M is N+1,
	rposts(Space,T,TC,M,T1),!.

do_rposts(Space,[],_,[],IntVars):-
	!.
do_rposts(Space,[_],_,[],IntVars):-
	!.
do_rposts(Space,[H,H1|T],[],Rels,IntVars):-
	do_rposts(Space,[H1|T],T,Rels,IntVars),!.
do_rposts(Space,[R1-rank(X,N1)|T],[R2-rank(Y,N2)|T1],[Rel2|RT],IntVars):-
	assert_node(X),
	assert_node(Y),

	EqX       :=: eq(X),      
	UpX       :=: up(X) ,     
	DownX     :=: down(X),    
	LeftX     :=: left(X),    
	RightX    :=: right(X),   
	EqDownX   :=: eqdown(X),   
	EqUpX     :=: equp(X),    
	SideX     :=: side(X),    
	ChildrenX :=: children(X), 
	ParentX   :=: parent(X),   
	UpCardX   :=: upcard(X),   
	IsRootX   :=: isroot(X),
	RbX       :=: rb(X),

	EqY       :=: eq(Y),      
	UpY       :=: up(Y) ,     
	DownY     :=: down(Y),    
	LeftY     :=: left(Y),    
	RightY    :=: right(Y),   
	EqDownY   :=: eqdown(Y),   
	EqUpY     :=: equp(Y),    
	SideY     :=: side(Y),    
	ChildrenY :=: children(Y), 
	ParentY   :=: parent(Y),   
	UpCardY   :=: upcard(Y),   
	IsRootY   :=: isroot(Y),
	RbY       :=: rb(Y),

	Rel1 := boolvar(Space),
	Rel2 := boolvar(Space),


	Space += rel(Rel1,'IRT_NQ',Rel2),
	
	Space += rel(ParentX,'SRT_DISJ',ParentY,Rel1),
	
	%%	post(Space,H,'<<+',H1),

	%% X precedes Y and their up are equal


	Rel2P := boolvars(Space,2),
	Rel2P=[RL1,RL2],

	Space += rel(Rel2P, 'IRT_GQ', Rel2),

	Space += rel(ParentX,'SRT_EQ',ParentY,RL1),

	(
	    N2>N1
	->
	(
	    xmg_brick_tree_solver:get_rel(N1,N2,IntVars,IntVar),
	    Space += dom(IntVar,4,RL2)
	
	)
    ;
	(
	    xmg_brick_tree_solver:get_rel(N2,N1,IntVars,IntVar),
	    Space += dom(IntVar,5,RL2)
	)
    ),

	do_rposts(Space,[R1-rank(X,N1)|T],T1,RT,IntVars),!.

branch_ranks(Space,Rels):-
	Space += branch(Rels,'INT_VAR_NONE','INT_VAL_MIN'),!.