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

:- module(xmg_brick_tree_solver).

:- use_module(library(gecode)).
%%:- xmg:import('xmg/brick/tree/compiler/dominance').
:- xmg:edcg.

:- edcg:using(xmg_brick_mg_solver:solver).

:- op(500, xfx, ':=:').

%% Duplicate until Yap's import system is fixed
Eq       :=: eq(Node)       :- !, assert_node(Node), arg( 1,Node,Eq).
Up       :=: up(Node)       :- !, assert_node(Node), arg( 2,Node,Up).
Down     :=: down(Node)     :- !, assert_node(Node), arg( 3,Node,Down).
Left     :=: left(Node)     :- !, assert_node(Node), arg( 4,Node,Left).
Right    :=: right(Node)    :- !, assert_node(Node), arg( 5,Node,Right).
EqDown   :=: eqdown(Node)   :- !, assert_node(Node), arg( 6,Node,EqDown).
EqUp     :=: equp(Node)     :- !, assert_node(Node), arg( 7,Node,EqUp).
Side     :=: side(Node)     :- !, assert_node(Node), arg( 8,Node,Side).
Children :=: children(Node) :- !, assert_node(Node), arg( 9,Node,Children).
Parent   :=: parent(Node)   :- !, assert_node(Node), arg(10,Node,Parent).
UpCard   :=: upcard(Node)   :- !, assert_node(Node), arg(11,Node,UpCard).
IsRoot   :=: isroot(Node)   :- !, assert_node(Node), arg(12,Node,IsRoot).
RB       :=: rb(Node)       :- !, assert_node(Node), arg(13,Node,RB).
Values   :=: map(Fun,Nodes) :- !, map_fun(Values,Nodes,Fun).
X        :=: Y              :- throw(unrecognized(X :=: Y)).

is_node(Node) :- functor(Node,node,13).
assert_node(Node) :-
	is_node(Node) -> true ;
	throw(expected(node,Node)).

solve(prepared(_,_,Nodes,_,_,NotUnifs,Relations,_,plugins(Plugins),_,NodeList1),solution(IsRoot,Eq, Children, Left, NodeList1)):--
!,
        Space:=space,!,
	xmg:send(info,'\nHere in solver'),
	xmg:send(info,Relations),
	
	xmg_brick_tree_dominance:new_nodes(NodeList,Space,Nodes),!,
	xmg:send(info,'\nDone new nodes'),
	xmg_brick_tree_dominance:global_constraints(Space,NodeList,IntVars,IntPVars),!,
	xmg:send(info,'\nFurther in solver'),
	%% Here are the threads used by the plugins:
	%% space
	%% nodes - the list of nodes used by the solver
	%% onodes - the list of original nodes (node(Props,Feats,Name))
	%% intvars 
	xmg_table:table_new(Extras),
	xmg_table:table_put(Extras,space,Space,TS),
	xmg_table:table_put(TS,nodes,NodeList,TSN),
	xmg_table:table_put(TSN,intvars,IntVars,TSNI),
	xmg_table:table_put(TSNI,onodes,NodeList1,TSNO),
	

	xmg:send(info,'\nPosting plugins'),	
	%%xmg:post_plugins(Plugins) with solver(TSNO,_),

	xmg:send(info,'\nPosted plugins'),	
	
	xmg_brick_mg_compiler:send(info,'\nDoing nposts '),

	do_nposts(Space,IntVars,NotUnifs),!,

	xmg_brick_mg_compiler:send(info,'\nDoing posts '),
	%%xmg:send(info,Relations),
	do_posts(Space,IntVars,IntPVars,NodeList,Relations),!,
	xmg_brick_mg_compiler:send(info,'\nIgnored posts '),

	
	xmg_brick_mg_compiler:send(info,'\nBranching '),


	xmg_brick_tree_dominance:global_branch(Space,IntVars),!,
	xmg_brick_mg_compiler:send(info,'\nGlobal branched '),
	xmg_brick_tree_dominance:global_pbranch(Space,IntPVars),!,
	xmg_brick_mg_compiler:send(info,'\nPBranched '),
	xmg_brick_tree_dominance:do_branch(Space,NodeList),!,	

	xmg_brick_mg_compiler:send(info,'\nBranched'),

	SolSpace := search(Space),

	xmg_brick_mg_compiler:send(info,'\nSearched '),
	%%flush_output,

	xmg_brick_tree_dominance:eq_vals(SolSpace,NodeList,Eq,Left,Children,IsRoot),
	xmg:send(info,'\nEq vals done'),
	xmg:send(info,NodeList1).




do_posts(_,_,_,_,[]):- !.

do_posts(Space,IntVars,IntPVars,NodeList,[H|T]):-
    xmg:send(info,'\nPosting one'),
    xmg:send(info,H),
    do_post(Space,IntVars,IntPVars,NodeList,H),
    xmg:send(info,'\nPosted one'),
	do_posts(Space,IntVars,IntPVars,NodeList,T),!.



do_post(Space,IntVars,IntPVars,_,vstep(one,A,B)):-
	B>A,!,
	  xmg:send(info,'\nPost 1'),
	  get_rel(A,B,IntVars,IntVar),
	get_prel(A,B,IntPVars,IntPVar),
	Space += dom(IntVar,3),
	Space += dom(IntPVar,1),
	!.

do_post(Space,IntVars,IntPVars,_,vstep(one,A,B)):-
	A>B,!,
	  xmg:send(info,'\nPost 2'),
	  get_rel(B,A,IntVars,IntVar),
	  xmg:send(info,'\nPost 2.3'),
	get_prel(A,B,IntPVars,IntPVar),
	xmg:send(info,'\nPost 2.5'),
	Space += dom(IntVar,2),
	Space += dom(IntPVar,1),
	!.

do_post(Space,IntVars,_,_,vstep(more,A,B)):-
	B>A,!,
	  xmg:send(info,'\nPost 3'),
	get_rel(A,B,IntVars,IntVar),
	
	Space += dom(IntVar,3),
  	!.

do_post(Space,IntVars,_,_,vstep(more,A,B)):-
    A>B,!,
      	  xmg:send(info,'\nPost 4'),

	get_rel(B,A,IntVars,IntVar),
	
	Space += dom(IntVar,2),
  	!.

do_post(Space,IntVars,_,_,vstep(any,A,B)):-
	B>A,!,
	  xmg:send(info,'\nPost 5'),
	get_rel(A,B,IntVars,IntVar),
	
	IntSet := intset([1,3]),
	Space += dom(IntVar,IntSet),
	!.

do_post(Space,IntVars,_,_,vstep(any,A,B)):-
    A>B,!,
      	  xmg:send(info,'\nPost 6'),

	get_rel(B,A,IntVars,IntVar),
	
	IntSet := intset([1,2]),
	Space += dom(IntVar,IntSet),
  
	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(oneleft,A,B)):-
    B>A,!,
      	  xmg:send(info,'\nPost 7'),
	get_rel(A,B,IntVars,IntVar),
	get_prel(A,B,IntPVars,IntPVar),
	Space += dom(IntVar,3),
	Space += dom(IntPVar,1),
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),
	LeftB:=:left(NB),
	LeftA:=:left(NA),
	Space += rel(LeftA,'SRT_EQ',LeftB),
	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(oneleft,A,B)):-
    A>B,!,
      	  xmg:send(info,'\nPost 8'),
	get_rel(B,A,IntVars,IntVar),
	get_prel(A,B,IntPVars,IntPVar),
	Space += dom(IntVar,2),
	Space += dom(IntPVar,1),
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),
	LeftB:=:left(NB),
	LeftA:=:left(NA),
	Space += rel(LeftA,'SRT_EQ',LeftB),
	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(oneright,A,B)):-
    B>A,!,
      	  xmg:send(info,'\nPost 9'),

	get_rel(A,B,IntVars,IntVar),
	get_prel(A,B,IntPVars,IntPVar),
	Space += dom(IntVar,3),
	Space += dom(IntPVar,1),
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),
	RightB:=:right(NB),
	RightA:=:right(NA),
	Space += rel(RightA,'SRT_EQ',RightB),
	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(oneright,A,B)):-
    A>B,!,
      	  xmg:send(info,'\nPost 10'),

	get_rel(B,A,IntVars,IntVar),
	get_prel(A,B,IntPVars,IntPVar),
	Space += dom(IntVar,2),
	Space += dom(IntPVar,1),
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),
	RightB:=:right(NB),
	RightA:=:right(NA),
	Space += rel(RightA,'SRT_EQ',RightB),
	!.

%% HSTEPS


do_post(Space,IntVars,_,NodeList,hstep(one,A,B)):-
	B>A,!,
      	  xmg:send(info,'\nPost 11'),
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),
	Left:=:left(NB),
	Right:=:right(NA),
	Empty := intset([]),
	Space += rel(Left,'SOT_INTER',Right,'SRT_EQ',Empty),
	get_rel(A,B,IntVars,IntVar),
	
	Space += dom(IntVar,4),
	!.

do_post(Space,IntVars,_,NodeList,hstep(one,A,B)):-
    A>B,!,
      xmg:send(info,'\nPost 12'),
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),
	xmg:send(info,'\nPost 12.1'),
	Left:=:left(NB),
	Right:=:right(NA),
	xmg:send(info,'\nPost 12.5'),
	Empty := intset([]),
	Space += rel(Left,'SOT_INTER',Right,'SRT_EQ',Empty),
	get_rel(B,A,IntVars,IntVar),
	xmg:send(info,'\nPost 12.9'),
	Space += dom(IntVar,5),  
	!.

do_post(Space,IntVars,_,NodeList,not(hstep(one,A,B))):-
        B>A,!,
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),

	get_rel(A,B,IntVars,IntVar),

	lists:length(NodeList,N),
	
	Full := intset(1,N),
	Empty := intset([]),
	EmptyVar := setvar(Space,Empty,Empty),

	Inter := setvar(Space,Empty,Full),

	Right:=:right(NA),
	Left:=:left(NB),
	
	Space += rel(Right,'SOT_INTER',Left,'SRT_EQ',Inter),

	IsLeft := boolvar(Space),
	EmptyInter := boolvar(Space),
	Space += dom(IntVar,4,IsLeft),

	Space += rel(Inter,'SRT_NQ',EmptyVar,EmptyInter),
	Space += rel(EmptyInter,'IRT_GQ',IsLeft),
	!.

do_post(Space,IntVars,_,NodeList,not(hstep(one,A,B))):-
        A>B,!,
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),

	get_rel(B,A,IntVars,IntVar),

	lists:length(NodeList,N),
	
	Full := intset(1,N),
	Empty := intset([]),
	EmptyVar := setvar(Space,Empty,Empty),

	Inter := setvar(Space,Empty,Full),

	Right:=:right(NA),
	Left:=:left(NB),
	
	Space += rel(Right,'SOT_INTER',Left,'SRT_EQ',Inter),

	IsLeft := boolvar(Space),
	EmptyInter := boolvar(Space),
	Space += dom(IntVar,5,IsLeft),

	Space += rel(Inter,'SRT_NQ',EmptyVar,EmptyInter),
	Space += rel(EmptyInter,'IRT_GQ',IsLeft),	
	!.


do_post(Space,IntVars,_,_,hstep(more,A,B)):-
	B>A,!,
	get_rel(A,B,IntVars,IntVar),
	
	Space += dom(IntVar,4),
	!.

do_post(Space,IntVars,_,_,hstep(more,A,B)):-
	A>B,!,
	get_rel(B,A,IntVars,IntVar),
	
	Space += dom(IntVar,5)  ,
	!.

do_post(Space,IntVars,_,_,hstep(any,A,B)):-
	B>A,!,
	get_rel(A,B,IntVars,IntVar),
	
	IntSet:= intset([1,4]),
	Space += dom(IntVar,IntSet),
	!.

do_post(Space,IntVars,_,_,hstep(any,A,B)):-
	A>B,!,
	get_rel(B,A,IntVars,IntVar),
	
	IntSet:= intset([1,5]),
	Space += dom(IntVar,IntSet),  
	!.

do_post(_,_,_,_,Const):-
    xmg:send(info,'\nConstraint not supported: '),
    xmg:send(info,Const),
    false,
	!.







do_nposts(_,_,[]):- !.

do_nposts(Space,Rels,[noteq(A,B)|T]):-
	get_rel(A,B,Rels,Rel),!,
	IntVarEq :=  intvar(Space,1,1),
	Space+=rel(Rel,'IRT_NQ',IntVarEq),
	do_nposts(Space,Rels,T),!.

do_nposts(Space,Rels,[H|T]):-
	xmg:send(info,'\nCould not post this:\n'),
	xmg:send(info,H),
	do_nposts(Space,Rels,T),!.






get_node([H|_],1,H):- !.
get_node([_|T],N,S):-
	M is N - 1,
	get_node(T,M,S),!.

get_number([H|_],H1,1):-
    H==H1,!.
get_number([H|T],H1,N):-
    not(H==H1),
    get_number(T,H1,M),
    N is M+1,!.





get_node(N,[N-Node|_],Node):- !.
get_node(N,[M-_|T],Node):-
	N>M,
	get_node(N,T,Node),!.





get_rel(A,B,Rels,Rel):- 
	B>A,!,
	  A1 is A - 1,
	  xmg:send(info,'\nGet Rel'),
	  xmg_brick_tree_dominance:nbNodes(NNodes),
	  xmg:send(info,'\nGot nbNodes'),
	I is (A1*NNodes)-(A1*A//2)+B-A,
	lists:nth(I,Rels,Rel),
	!.

get_rel(A,B,Rels,Rel):-
	A>B,!,
	get_rel(B,A,Rels,Rel),!.

%% prel is parent_rel

get_prel(A,B,Rels,Rel):- 
	B>A,!,
	A1 is A - 1,
	xmg_brick_tree_dominance:nbNodes(NNodes),
	I is 2*((A1*NNodes)-(A1*A//2)+B-A)-1,
	lists:nth(I,Rels,Rel),
	!.

get_prel(A,B,Rels,Rel):-
	A>B,!,
	B1 is B - 1,
	xmg_brick_tree_dominance:nbNodes(NNodes),
	I is 2*((B1*NNodes)-(B1*B//2)+A-B),
	lists:nth(I,Rels,Rel),
	!.
	
	
