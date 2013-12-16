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

:- module(xmg_brick_tree_solver, []).

:- use_module(library(gecode)).
:- use_module('xmg/brick/tree/compiler/dominance').

:- op(500, xfx, ':=:').


solve(prepared(Family,Noteqs,Nodes,Doms,Precs,NotUnifs,Relations,NodeNames,Plugins,Table,NodeList1),solution(UTree,Children,Table)):-
	!,		
	Space:=space,!,
	
	new_nodes(NodeList,Space,Nodes),!,
	global_constraints(Space,NodeList,IntVars,IntPVars),!,


	%%xmg_brick_unicity_solver:post_unicities(Space,NodeList,IntVars,Unicities),

	xmg:send(info,' posting plugins '),
	post_plugins([colors,rank,tag,unicity],Space,NodeList,IntVars,Plugins),

	%% (
	%%     xmg_brick_mg_compiler:principle(color) ->
	%%     (
	%% 	%use_module('syn/xmg_colors'),
	%% 	xmg_brick_mg_compiler:send(info,' using colors '),
	%% 	xmg_brick_colors_solver:colors(Space,NodeList,Colors)
	%%     );
	%%     true
	%% ),!,
	%% (
	%%      xmg_brick_mg_compiler:principle(rank) ->
	%%      (
	%%  	%use_module('syn/xmg_rank'),
	%% 	xmg_brick_mg_compiler:send(info,' using rank '),
	%% 	%%xmg_brick_mg_compiler:send(info,Ranks),
	%%  	xmg_brick_rank_solver:ranks(Space,NodeList,IntVars,Ranks,RankRels)
	%%      );
	%%      true
	%%  ),!,

	xmg_brick_mg_compiler:send(info,' doing nposts '),

	do_nposts(Space,IntVars,NotUnifs),!,

	%use_module(xmg_tag),
	%% xmg_brick_mg_compiler:send(info,' using tag '),
	%% xmg_brick_mg_compiler:send(info,TagOps),
	%%xmg_brick_tag_solver:post_tags(Space,NodeList,TagOps),

	xmg_brick_mg_compiler:send(info,' doing posts '),


	do_posts(Space,IntVars,IntPVars,NodeList,Relations),!,

	%%color_branch(Space,NodeList),

	%% (
	%%     xmg_parser:principle(rank) ->
	%%     (
	%% 	xmg_rank:branch_ranks(Space,RankRels)
	%%     );
	%%     true
	%% ),!,

	global_branch(Space,IntVars),!,
	global_pbranch(Space,IntPVars),!,
	do_branch(Space,NodeList),!,	

	SolSpace := search(Space),

	xmg_brick_mg_compiler:send(info,' searched '),
	flush_output,

	eq_vals(SolSpace,NodeList,Eq,Left,Children,IsRoot),

	make_tree(IsRoot,Eq,Children,Left,Tree),
	xmg_brick_mg_compiler:send(info,' tree made '),
	flush_output,

	unify_in_tree(Tree,UTree,NodeList1),
	xmg_brick_mg_compiler:send(info,' tree unified ').


post_plugins([],_,_,_,_):- !.
post_plugins([Plugin|T],Space,NodeList,IntVars,plugins(Plugins)):-	
	lists:member(Plugin-PlugList,Plugins),
	post_plugin(Plugin,Space,NodeList,IntVars,PlugList),
	post_plugins(T,Space,NodeList,IntVars,plugins(Plugins)),!.


post_plugin(Plugin,Space,NodeList,IntVars,PlugList):-
	xmg:send(info,' posting '),
	xmg:send(info,Plugin),
	xmg:send(info,'\n'),
	xmg:send(info,PlugList),

	atom_concat(['xmg_brick_',Plugin,'_solver'],Module),
	Post=..[post,Space,NodeList,IntVars,PlugList],
	Do=..[':',Module,Post],
	%%xmg:send(info,Do),
	Do,
	xmg:send(info,' posted\n'),
		
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
	%%Space += branch([Eq,Children],'SET_VAR_NONE','SET_VAL_MIN_INC'),
	Space += branch([Eq,Up,Down,Left,Right,EqUp,EqDown,Side,Children,Parent],'SET_VAR_NONE','SET_VAL_MIN_INC'),

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

%% put children corresponding to same nodes in lists

children_eqs([],[],_):-	!.
children_eqs([C|T],[Leqs|L],Eqs):-
	search_in_eqs(C,Eqs,Leqs),
	%%print(user_output,Leqs),
	remove_children(Leqs,T,T1),
	children_eqs(T1,L,Eqs),!.

search_in_eqs(C,[H|T],H):-
	lists:member(C,H),!.
search_in_eqs(C,[_|T],Eq):-
	search_in_eqs(C,T,Eq),!.

remove_children([],L,L):- !.
remove_children([H|T],L,LR):-
	remove_child(H,L,L1),
	remove_children(T,L1,LR),!.

remove_child(C,L,LR):-
	lists:delete(L,C,LR), !.



%% sort children 

sort_children(Children,ChildrenLefts,LS):-
	sizes(ChildrenLefts,ChildrenLeftsSize),
	fusion(Children,ChildrenLeftsSize,L),
	keysort(L,LS),!.

sizes([],[]):- !.
sizes([H|T],[H1|T1]):-
	length(H,H1),
	sizes(T,T1),!.

fusion([],[],[]):-!.
fusion([H|T],[H1|T1],[H1-H|T2]):-
	fusion(T,T1,T2),!.


%% Converting sets to a tree

make_tree(IsRoot,Eq,Children,Left,tree(Root,Trees)):-  %% Trees : list of children trees
	search_root(IsRoot,Eq,Root),!,
	search_children(Root,Children,NChildren),!,
	children_eqs(NChildren,NChildrenEqs,Eq),!,
	search_lefts(NChildrenEqs,Left,ChildrenLefts),!,
	sort_children(NChildrenEqs,ChildrenLefts,NChildrenSorted),!,
	make_subtrees(NChildrenSorted,Eq,Children,Left,Trees),!.

make_subtrees([],_,_,_,[]):-!.
make_subtrees([_-H|T],Eq,Children,Left,[Tree|Trees]):-!,
	make_subtree(H,Eq,Children,Left,Tree),!,
	make_subtrees(T,Eq,Children,Left,Trees),!.


make_subtree(Node,Eq,Children,Left,Tree):- !,
	search_children(Node,Children,NChildren),!,
	((
	    NChildren=[],
	    Tree=Node,!
	    )
	;
	(
	    children_eqs(NChildren,NChildrenEqs,Eq),!,
	    search_lefts(NChildrenEqs,Left,ChildrenLefts),!,
	    sort_children(NChildrenEqs,ChildrenLefts,NChildrenSorted),!,
	    make_subtrees(NChildrenSorted,Eq,Children,Left,Trees),!,
	    Tree=tree(Node,Trees)
	)),
	
	!.



search_root([1|_],[Eq|_],Eq):-!.
search_root([_|T],[_|Eqs],Root):-
	search_root(T,Eqs,Root),!.

search_lefts([],_,[]):-!.
search_lefts([H|T],Lefts,[H1|T1]):-
	search_left(H,Lefts,H1),!,
	search_lefts(T,Lefts,T1),!.

search_left([N|_],Lefts,L):-
	lists:nth(N,Lefts,L),!.

search_children([N|_],Children,L):-
	lists:nth(N,Children,L),!.

unify_in_trees([],[],NodeList):- !.
unify_in_trees([H],[H1], NodeList):-
	unify_in_tree(H,H1,NodeList),!.
unify_in_trees([H|T],[H1|T1], NodeList):-
	unify_in_tree(H,H1,NodeList),!,
	unify_in_trees(T,T1,NodeList),!.

unify_in_tree(tree(T,Trees), tree(T1,Trees1), NodeList):-
	unify_node(T,T1,NodeList),!,
	unify_in_trees(Trees,Trees1,NodeList),!.
unify_in_tree(A,A1,NodeList):-
	unify_node(A,A1,NodeList),!.

unify_node([NNode],node(P,F,N),NodeList):-
	get_node(NNode,NodeList,node(P,F,N)),
	!.
unify_node([N1],node(P2,F2,NN2),NodeList):-
	%% get_node(N1,NodeList,node(P1,F1,NN1)),!,
	%% xmg_nodename:nodename(NN1,Name1),
	%% xmg_nodename:nodename(NN2,Name2),
	%% xmg_avm:avm(P1,PP1),
	%% xmg_avm:avm(P2,PP2),
	%% xmg_avm:avm(F1,FF1),
	%% xmg_avm:avm(F2,FF2),


	
	%% xmg_brick_mg_compiler:send(info,' could not unify '),
	%% xmg_brick_mg_compiler:send(info,Name1),
	%% xmg_brick_mg_compiler:send(info,Name2),
	%% xmg_avm:print_avm(P1),
	%% xmg_avm:print_avm(P2),
	%% xmg_avm:print_avm(F1),
	%% xmg_avm:print_avm(F2),
	%% NN1=NN2,
	%% xmg_brick_mg_compiler:send(info,' not names '),
	%% P1=P2,
	%% xmg_brick_mg_compiler:send(info,' not props '),
	%% F1=F2,
	%% xmg_brick_mg_compiler:send(info,' feats' ),
	%% !,
	false,
	!.
unify_node([NNode|T],node(P,F,N),NodeList):-
	get_node(NNode,NodeList,node(P,F,N)),!,
	unify_node(T,node(P,F,N),NodeList),
	!.
unify_node([N1|T],node(P2,F2,NN2),NodeList):-
	%% get_node(N1,NodeList,node(P1,F1,NN1)),!,
	%% xmg_nodename:nodename(NN1,Name1),
	%% xmg_nodename:nodename(NN2,Name2),
	
	%% xmg_brick_mg_compiler:send(info,' could not unify '),
	%% xmg_brick_mg_compiler:send(info,Name1),
	%% xmg_brick_mg_compiler:send(info,Name2),
	false,
	!.

%% unify_node([NNode|T],node(P,F,N),NodeList):-
%% 	get_node(NNode,NodeList,node(_,F1,_)),!,

%% 	xmg_brick_mg_compiler:send(info,' unification failed '),
%% 	xmg_avm:avm(F,AF),
%% 	xmg_avm:avm(F1,AF1),
%% 	xmg_avm:print_avm(AF),
%% 	xmg_avm:print_avm(AF1),

%% 	F=F1,
%% 	xmg_brick_mg_compiler:send(info,' unified ! '),

	
%% 	unify_node(T,node(P,F,N),NodeList),
%% 	!.

get_node(N,[N-Node|_],Node):- !.
get_node(N,[M-_|T],Node):-
	N>M,
	get_node(N,T,Node),!.





get_rel(A,B,Rels,Rel):- 
	B>A,!,
	A1 is A - 1,
	xmg_brick_tree_solver:nbNodes(NNodes),
	I is (A1*NNodes)-(A1*A//2)+B-A,
	lists:nth(I,Rels,Rel),
	!.

get_rel(A,B,Rels,Rel):-
	A>B,!,
	get_rel(B,A,Rels,Rel),!.

get_prel(A,B,Rels,Rel):- 
	B>A,!,
	A1 is A - 1,
	xmg_brick_tree_solver:nbNodes(NNodes),
	I is 2*((A1*NNodes)-(A1*A//2)+B-A)-1,
	lists:nth(I,Rels,Rel),
	!.

get_prel(A,B,Rels,Rel):-
	A>B,!,
	B1 is B - 1,
	xmg_brick_tree_solver:nbNodes(NNodes),
	I is 2*((B1*NNodes)-(B1*B//2)+A-B),
	lists:nth(I,Rels,Rel),
	!.
	
	