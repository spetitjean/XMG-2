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

:- module(xmg_brick_rrg_extractor, []).

extract(IsRoot,Eq, Children, Left, NodeList1, UTree):-
	xmg:send(debug,'making tree'),
	make_tree(IsRoot,Eq,Children,Left,Tree),
	xmg:send(debug,'\ntree made: '),
	xmg:send(debug,Tree),
	unify_in_tree(Tree,UTree,NodeList1),
	xmg:send(debug,'\ntree unified ').




%% Converting sets to a tree

make_tree(IsRoot,Eq,Children,Left,tree:tree(Root,Trees)):-  %% Trees : list of children trees
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
	    Tree=tree:tree(Node,Trees)
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





unify_in_trees([],[],NodeList):- !.
unify_in_trees([H],[H1], NodeList):-
	!,
	unify_in_tree(H,H1,NodeList),!.
unify_in_trees([H|T],[H1|T1], NodeList):-
	unify_in_tree(H,H1,NodeList),!,
	unify_in_trees(T,T1,NodeList),!.

unify_in_tree(tree:tree(T,Trees), tree:tree(T1,Trees1), NodeList):-
	!,

	T1=node(P,F,N),
	xmg_brick_avm_avm:avm(P,[]),
	xmg_brick_avm_avm:avm(F,[]),
	xmg_brick_syn_nodename:nodename(N,''),
	unify_node(T,T1,NodeList),!,
	unify_in_trees(Trees,Trees1,NodeList),!.
unify_in_tree(A,A1,NodeList):-

	unify_node(A,A1,NodeList),!.

unify_node([NNode],node(P,F,N),NodeList):-
	xmg_brick_rrg_solver:get_node(NNode,NodeList,node(P1,F1,N1)),

	%% xmg_brick_avm_avm:avm(P1,Props1),
	%% xmg_brick_avm_avm:avm(F1,Feats1),
	%% xmg_brick_syn_nodename:nodename(N1,Name1),
	
	%% xmg:send(debug,Props1),
	%% xmg:send(debug,Feats1),
	%% xmg:send(debug,Name1),

	%% xmg_brick_avm_avm:avm(P,Props),
	%% xmg_brick_avm_avm:avm(F,Feats),
	%% xmg_brick_syn_nodename:nodename(N,Name),
	
	%% xmg:send(debug,Props),
	%% xmg:send(debug,Feats),
	%% xmg:send(debug,Name),

	P1=P,
	F1=F,
	N1=N,
	!.
unify_node([N1],node(P2,F2,NN2),NodeList):-
	!,
	false.
unify_node([NNode|T],node(P,F,N),NodeList):-
	xmg_brick_rrg_solver:get_node(NNode,NodeList,node(P,F,N)),!,
	unify_node(T,node(P,F,N),NodeList),
	!.
unify_node([N1|T],node(P2,F2,NN2),NodeList):-
	!,
	false.


