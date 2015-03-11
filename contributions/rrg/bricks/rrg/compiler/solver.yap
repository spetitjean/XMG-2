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

:- module(xmg_brick_rrg_solver, []).

:- use_module(library(gecode)).
:- use_module('xmg/brick/rrg/compiler/dominance').

:- op(500, xfx, ':=:').


solve(prepared(Family,Noteqs,Nodes,Doms,Precs,NotUnifs,NoParents, Relations,NodeNames,Plugins,Table,NodeList1),solution(IsRoot,Eq, Children, Left, NodeList1)):-
	!,		
	Space:=space,!,
	
	new_nodes(NodeList,Space,Nodes),!,
	global_constraints(Space,NodeList,IntVars,IntPVars),!,


	%%xmg_brick_unicity_solver:post_unicities(Space,NodeList,IntVars,Unicities),

	xmg:get_plugins(TreePlugins,_),
	xmg:send(debug,TreePlugins),
	
	%%post_plugins([colors,rank,tag,unicity],Space,NodeList,IntVars,Plugins),
	xmg:send(debug,TreePlugins),
	post_plugins(TreePlugins,Space,NodeList,IntVars,Plugins),

	xmg_brick_mg_compiler:send(debug,' doing nposts '),

	do_nposts(Space,IntVars,NotUnifs),!,

	xmg_brick_mg_compiler:send(info,' doing npposts '),
	xmg_brick_mg_compiler:send(info,Table),

	%%xmg_brick_mg_compiler:send(info,NodeList),

	do_npposts(Space,NodeNames,NodeList,NoParents),!,

	xmg_brick_mg_compiler:send(debug,' doing posts '),

	do_posts(Space,IntVars,IntPVars,NodeList,Relations),!,

	xmg_brick_mg_compiler:send(debug,' branching '),


	global_branch(Space,IntVars),!,
	global_pbranch(Space,IntPVars),!,
	do_branch(Space,NodeList),!,	

	xmg_brick_mg_compiler:send(debug,' branched '),
	%%color_branch(Space,NodeList),

	SolSpace := search(Space),

	xmg:send(info,' searched '),
	flush_output,

	eq_vals(SolSpace,NodeList,Eq,Left,Children,IsRoot),
	xmg:send(debug,' got values:'),
	xmg:send(debug,solution(IsRoot,Eq, Children, Left, NodeList1)).


do_npposts(_,[],[],_):- !.
do_npposts(Space,[H|T],[H1|T1],NoParents):-
	do_nppost(Space,H,H1,NoParents),
	do_npposts(Space,T,T1,NoParents),!.

do_nppost(Space,N,Node,NoParents):-
	lists:member(N,NoParents),
	%%xmg:send(info,'\nhere no parent: '),
	%%xmg:send(info,Node),
	IntVar:=intvar(Space,N,N),
	LRoot :=: lroot(Node),
	Space += rel(LRoot,'SRT_DISJ', IntVar),
	!.
do_nppost(Space,N,Node,NoParents):- 
	IntVar:=intvar(Space,N,N),
	LRoot :=: lroot(Node),
	Space += rel(LRoot,'SRT_SUP', IntVar),
	!.

post_plugins([],_,_,_,_):- !.
post_plugins([Plugin|T],Space,NodeList,IntVars,plugins(Plugins)):-	
	lists:member(Plugin-PlugList,Plugins),
	post_plugin(Plugin,Space,NodeList,IntVars,PlugList),
	post_plugins(T,Space,NodeList,IntVars,plugins(Plugins)),!.


post_plugin(Plugin,Space,NodeList,IntVars,PlugList):-
	xmg:send(debug,' posting '),
	xmg:send(debug,Plugin),
	xmg:send(debug,'\n'),
	%%xmg:send(debug,PlugList),

	atom_concat(['xmg_brick_',Plugin,'_solver'],Module),
	Post=..[post,Space,NodeList,IntVars,PlugList],
	Do=..[':',Module,Post],
	%%xmg:send(debug,Do),
	Do,
	xmg:send(debug,' posted\n'),
		
	!.

do_posts(_,IntVars,IntPVars,NodeList,[]):- !.

do_posts(Space,IntVars,IntPVars,NodeList,[H|T]):-
	do_post(Space,IntVars,IntPVars,NodeList,H),
	do_posts(Space,IntVars,IntPVars,NodeList,T),!.



do_post(Space,IntVars,IntPVars,NodeList,vstep(one,A,B)):-
	B>A,!,
	get_rel(A,B,IntVars,IntVar),
	get_prel(A,B,IntPVars,IntPVar),
	Space += dom(IntVar,3),
	Space += dom(IntPVar,1),
	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(one,A,B)):-
	A>B,!,
	get_rel(B,A,IntVars,IntVar),
	get_prel(A,B,IntPVars,IntPVar),
	Space += dom(IntVar,2),
	Space += dom(IntPVar,1),
	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(more,A,B)):-
	B>A,!,
	get_rel(A,B,IntVars,IntVar),
	
	Space += dom(IntVar,3),
  	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(more,A,B)):-
	A>B,!,
	get_rel(B,A,IntVars,IntVar),
	
	Space += dom(IntVar,2),
  	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(any,A,B)):-
	B>A,!,
	get_rel(A,B,IntVars,IntVar),
	
	IntSet := intset([1,3]),
	Space += dom(IntVar,IntSet),
	!.

do_post(Space,IntVars,IntPVars,NodeList,vstep(any,A,B)):-
	A>B,!,
	get_rel(B,A,IntVars,IntVar),
	
	IntSet := intset([1,2]),
	Space += dom(IntVar,IntSet),
  
	!.


do_post(Space,IntVars,IntPVars,NodeList,vstep(oneleft,A,B)):-
	B>A,!,
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


do_post(Space,IntVars,IntPVars,NodeList,hstep(one,A,B)):-
	B>A,!,
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),
	Left:=:left(NB),
	Right:=:right(NA),
	Empty := intset([]),
	Space += rel(Left,'SOT_INTER',Right,'SRT_EQ',Empty),
	get_rel(A,B,IntVars,IntVar),
	
	Space += dom(IntVar,4),
	!.

do_post(Space,IntVars,IntPVars,NodeList,hstep(one,A,B)):-
	A>B,!,
	get_node(NodeList,A,NA),
	get_node(NodeList,B,NB),
	Left:=:left(NB),
	Right:=:right(NA),
	Empty := intset([]),
	Space += rel(Left,'SOT_INTER',Right,'SRT_EQ',Empty),
	get_rel(B,A,IntVars,IntVar),
	
	Space += dom(IntVar,5),  
	!.

do_post(Space,IntVars,IntPVars,NodeList,hstep(more,A,B)):-
	B>A,!,
	get_rel(A,B,IntVars,IntVar),
	
	Space += dom(IntVar,4),
	!.

do_post(Space,IntVars,IntPVars,NodeList,hstep(more,A,B)):-
	A>B,!,
	get_rel(B,A,IntVars,IntVar),
	
	Space += dom(IntVar,5)  ,
	!.

do_post(Space,IntVars,IntPVars,NodeList,hstep(any,A,B)):-
	B>A,!,
	get_rel(A,B,IntVars,IntVar),
	
	IntSet:= intset([1,4]),
	Space += dom(IntVar,IntSet),
	!.

do_post(Space,IntVars,IntPVars,NodeList,hstep(any,A,B)):-
	A>B,!,
	get_rel(B,A,IntVars,IntVar),
	
	IntSet:= intset([1,5]),
	Space += dom(IntVar,IntSet),  
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



color_branch(_,[]):- !.
color_branch(Space,[Node|T]):-
	RB :=: rb(Node),
	Space += branch(RB,'SET_VAL_MIN_INC'),

	color_branch(Space,T).

do_branch(_,[]):- !.

do_branch(Space,[Node|T]):-
	Eq       :=: eq(Node),
	Up       :=: up(Node) ,     
	Down     :=: down(Node),    
	Left     :=: left(Node),    
	Right    :=: right(Node),   
	EqDown   :=: eqdown(Node),   
	EqUp     :=: equp(Node),    
	Side     :=: side(Node),    
	Children :=: children(Node), 
	Parent   :=: parent(Node),   
	UpCard   :=: upcard(Node),   
	IsRoot   :=: isroot(Node),
	LRoot    :=: lroot(Node),
	%%Space += branch([Eq,Children],'SET_VAR_NONE','SET_VAL_MIN_INC'),
	Space += branch([Eq,Up,Down,Left,Right,EqUp,EqDown,Side,Children,Parent,LRoot],'SET_VAR_NONE','SET_VAL_MIN_INC'),

	Space += branch(IsRoot,'INT_VALUES_MIN'),
	Space += branch(UpCard,'INT_VALUES_MIN'),

	do_branch(Space,T).

get_node([H|T],1,H):- !.
get_node([H|T],N,S):-
	M is N - 1,
	get_node(T,M,S),!.

eq_vals(_,[],[],[],[],[]):- !.

eq_vals(Space,
	[Node|T],
	[VEq|T1],
	%%[VRb|T2],
	[VLeft|T3],
	[VChildren|T4],
	[VIsRoot|T5]
	%%[VParent|T6]
    )  :-
	
	Eq:=:eq(Node),
	%%Rb:=:rb(Node),
	Left:=:left(Node),
	Children:=:children(Node),
	IsRoot:=:isroot(Node),
	%%Parent:=:parent(Node),

	[VEq,VLeft,VChildren]:=lub_values(Space,[Eq,Left,Children]),
	%% VEq:=lub_values(Space,Eq),
	%% %%VRb:=lub_values(Space,Rb),
	%% VLeft:=lub_values(Space,Left),
	%% VChildren:=lub_values(Space,Children),
	VIsRoot:=val(Space,IsRoot),
	%% %%VParent:=lub_values(Space,Parent),
	eq_vals(Space,T,T1,T3,T4,T5),
	!.



get_node(N,[N-Node|_],Node):- !.
get_node(N,[M-_|T],Node):-
	N>M,
	get_node(N,T,Node),!.





get_rel(A,B,Rels,Rel):- 
	B>A,!,
	A1 is A - 1,
	nbNodes(NNodes),
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
	nbNodes(NNodes),
	I is 2*((A1*NNodes)-(A1*A//2)+B-A)-1,
	lists:nth(I,Rels,Rel),
	!.

get_prel(A,B,Rels,Rel):-
	A>B,!,
	B1 is B - 1,
	nbNodes(NNodes),
	I is 2*((B1*NNodes)-(B1*B//2)+A-B),
	lists:nth(I,Rels,Rel),
	!.
	
	