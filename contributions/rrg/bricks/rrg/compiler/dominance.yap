%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2015  Simon Petitjean

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

:- use_module(library(gecode)).

:- op(500, xfx, ':=:').

new_nodes(Nodes,Space,N) :-
	length(Nodes,N),
	retractall(nbNodes(_)),
	asserta(nbNodes(N)),
	init_nodes(Nodes,Space,N,1).

init_nodes([],_,_,_).
init_nodes([Node|Nodes],Space,N,I) :-
	init_node(Node,Space,N,I),
	J is I+1,
	init_nodes(Nodes,Space,N,J).

init_node(Node,Space,N,I) :-
	Node=node(Eq,Up,Down,Left,Right,EqDown,EqUp,Side,Children,Parent,UpCard,IsRoot,RB,LRoot),
	Empty := intset([]),
	Full := intset(1,N),
	FullVar := setvar(Space,Full,Full),
	EmptyVar := setvar(Space,Empty,Empty),
	[Eq,Up,Down,Left,Right,EqDown,EqUp,Side,Children,Parent,RB,LRoot] := setvars(Space,12,Empty,Full),
	M is N-1,
	UpCard := intvar(Space,0,M),
	IsRoot := boolvar(Space),
	Space += cardinality(Parent,0,M), 
	Space += cardinality(Up,UpCard),
	Space += rel(UpCard,'IRT_EQ',0,IsRoot),
	%%Space += rel(Side,'SRT_EQ',EmptyVar,IsRoot),
	Space += rel(FullVar,'SRT_EQ',EqDown,IsRoot),
	Space += rel(Eq,'SOT_DUNION',Down,'SRT_EQ',EqDown),
	Space += rel(Eq,'SOT_DUNION',Up,'SRT_EQ',EqUp),
	Space += rel(Left,'SOT_DUNION',Right,'SRT_EQ',Side),
	Space += rel('SOT_DUNION',[EqUp,Down,Left,Right],FullVar),
	Space += rel('SOT_DUNION',[Up,EqDown,Left,Right],FullVar),
    	Space += dom(Eq,'SRT_SUP',I),
	Space += rel(Parent, 'SRT_SUB', Up),
	Space += rel(Children, 'SRT_SUB', Down),
	Space += rel(RB, 'SRT_SUB', Eq),
	Space += rel(LRoot, 'SRT_SUB', Eq),
	Space += rel(LRoot, 'SRT_EQ', EmptyVar, IsRoot),
	Space += cardinality(RB,1,1),
	!.

is_node(Node) :- functor(Node,node,14).
assert_node(Node) :-
	is_node(Node) -> true ;
	throw(expected(node,Node)).

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
LRoot    :=: lroot(Node)    :- !, assert_node(Node), arg(14,Node,LRoot).
Values   :=: map(Fun,Nodes) :- !, map_fun(Values,Nodes,Fun).
X        :=: Y              :- throw(unrecognized(X :=: Y)).

map_fun([],[],_).
map_fun([Val|Vals],[Node|Nodes],Fun) :-
	Term =.. [Fun,Node],
	Val :=: Term,
	map_fun(Vals,Nodes,Fun).



node_rel(Space,X,Y,Rel):-
	assert_node(X),
	assert_node(Y),

	Rel := intvar(Space,1,5),

	Rel1 := boolvar(Space),
	Rel2 := boolvar(Space),
	Rel3 := boolvar(Space),
	Rel4 := boolvar(Space),
	Rel5 := boolvar(Space),	



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
	LRootX    :=: lroot(X),

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
	LRootY    :=: lroot(Y),

	nbNodes(NBNodes),
	Card1:= intvar(Space,1,NBNodes),
	CXCard:= intvar(Space,0,NBNodes),
	Space += cardinality(ChildrenX,CXCard),
	CYCard:= intvar(Space,0,NBNodes),
	Space += cardinality(ChildrenY,CYCard),	
	PXCard:= intvar(Space,0,NBNodes),
	Space += cardinality(ParentX,PXCard),	
	PYCard:= intvar(Space,0,NBNodes),
	Space += cardinality(ParentY,PYCard),



	%% 1 : =
	Space += rel(Rel,'IRT_EQ',1,Rel1),

	Rel1P := boolvars(Space,14),
	Rel1P=[R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14],

	Space += rel(Rel1P, 'IRT_GQ', Rel1),

	Space += rel(EqX,'SRT_EQ',EqY,R1),
	Space += rel(UpX,'SRT_EQ',UpY,R2),
	Space += rel(DownX,'SRT_EQ',DownY,R3),
	Space += rel(LeftX,'SRT_EQ',LeftY,R4),
	Space += rel(RightX,'SRT_EQ',RightY,R5),
	Space += rel(EqDownX,'SRT_EQ',EqDownY,R6),
	Space += rel(EqUpX,'SRT_EQ',EqUpY,R7),
	Space += rel(SideX,'SRT_EQ',SideY,R8),
	Space += rel(ChildrenX,'SRT_EQ',ChildrenY,R9),
	Space += rel(ParentX,'SRT_EQ',ParentY,R10),
	Space += rel(UpCardX,'IRT_EQ',UpCardY,R11),
	Space += rel(IsRootX,'IRT_EQ',IsRootY,R12),
	Space += rel(RbX,'SRT_EQ',RbY,R13),
	Space += rel(LRootX,'SRT_EQ',LRootY,R14),

	%% N1 : !=
	Rel1N := boolvar(Space),
	Space += rel(Rel,'IRT_NQ',1,Rel1N),

	Rel1NP := boolvars(Space,5),
	Rel1NP=[RN1,RN2,RN3,RN4,RN5],
	Space += rel(Rel1NP, 'IRT_GQ', Rel1N),

	Space +=rel(EqX,'SRT_DISJ',EqY,RN1),
	Space +=rel(ChildrenX,'SRT_DISJ',ChildrenY,RN2),
	Space +=linear([IsRootX,IsRootY],'IRT_LQ',1,RN3),
	Space += rel(RbX,'SRT_DISJ',RbY,RN4),
	Space += rel(LRootX,'SRT_DISJ',LRootY,RN5),

	%% 2 : <-+
	Space += rel(Rel,'IRT_EQ',2,Rel2),

	Rel2P := boolvars(Space,10),
	Rel2P=[RU1,RU2,RU3,RU4,RU5,RU6,RU7,RU8,RU9,RU10],

	Space += rel(Rel2P, 'IRT_GQ', Rel2),

	Space += rel(LeftY,'SRT_SUB',LeftX,RU1),
	Space += rel(RightY,'SRT_SUB',RightX,RU2),
	Space += rel(EqUpY,'SRT_SUB',UpX,RU3),
	Space += rel(EqDownX,'SRT_SUB',DownY,RU4),
	Space += rel(ParentX,'SRT_SUB',EqDownY,RU5),
	Space += rel(ChildrenX,'SRT_DISJ',ChildrenY,RU6),
	Space += rel(DownX,'SRT_DISJ',ChildrenY,RU7),
	Space += rel(CYCard,'IRT_GQ',Card1,RU8),
	Space += rel(PXCard,'IRT_GQ',Card1,RU9),
	Space += rel(IsRootX,'IRT_EQ',0,RU10),



	%% N2
	Rel2N := boolvar(Space),
	Space += rel(Rel,'IRT_NQ',2,Rel2N),

	Rel2NP := boolvars(Space,2),
	Rel2NP=[RNN1,RNN2],
	
	Space += rel(Rel2NP,'IRT_GQ',Rel2N),
	
	Space += rel(EqY,'SRT_DISJ',UpX,RNN1),
	Space += rel(DownY,'SRT_DISJ',EqX,RNN2),

	%% 3 : ->+
	Space += rel(Rel,'IRT_EQ',3,Rel3),

	Rel3P := boolvars(Space,10),
	Rel3P=[RO1,RO2,RO3,RO4,RO5,RO6,RO7,RO8,RO9,RO10],

	Space += rel(Rel3P, 'IRT_GQ', Rel3),

	Space += rel(LeftX,'SRT_SUB',LeftY,RO1),
	Space += rel(RightX,'SRT_SUB',RightY,RO2),
	Space += rel(EqUpX,'SRT_SUB',UpY,RO3),
	Space += rel(EqDownY,'SRT_SUB',DownX,RO4),
	Space += rel(ParentY,'SRT_SUB',EqDownX,RO5),
	Space += rel(ChildrenX,'SRT_DISJ',ChildrenY,RO6),
	Space += rel(ChildrenX,'SRT_DISJ',DownY,RO7),

	Space += rel(CXCard,'IRT_GQ',Card1,RO8),
	Space += rel(PYCard,'IRT_GQ',Card1,RO9),
	Space += rel(IsRootY,'IRT_EQ',0,RO10),

	
	%% N3
	Rel3N := boolvar(Space),
	Space += rel(Rel,'IRT_NQ',3,Rel3N),

	Rel3NP := boolvars(Space,2),
	Rel3NP=[RNNN1,RNNN2],
	
	Space += rel(Rel3NP,'IRT_GQ',Rel3N),
	
	Space += rel(EqX,'SRT_DISJ',UpY,RNNN1),
	Space += rel(DownX,'SRT_DISJ',EqY,RNNN2),


	%% 4 : <<+
	Space += rel(Rel,'IRT_EQ',4,Rel4),

	Rel4P := boolvars(Space,5),
	Rel4P=[RL1,RL2,RL3,RL4,RL5],

	Space += rel(Rel4P, 'IRT_GQ', Rel4),

	Space += rel(EqDownX,'SRT_SUB',LeftY,RL1),
	Space += rel(EqDownY,'SRT_SUB',RightX,RL2),
	Space += rel(RightY,'SRT_SUB',RightX,RL3),
	Space += rel(LeftX,'SRT_SUB',LeftY,RL4),
	Space += rel(ChildrenX,'SRT_DISJ',ChildrenY,RL5),

	%% N4
	Rel4N := boolvar(Space),
	Space += rel(Rel,'IRT_NQ',4,Rel4N),

	Rel4NP := boolvars(Space,2),
	Rel4NP=[RNNNN1,RNNNN2],
	
	Space += rel(Rel4NP,'IRT_GQ',Rel4N),
	
	Space += rel(EqX,'SRT_DISJ',LeftY,RNNNN1),
	Space += rel(EqY,'SRT_DISJ',RightX,RNNNN2),



	%% 5 : >>+
	Space += rel(Rel,'IRT_EQ',5,Rel5),

	Rel5P := boolvars(Space,5),
	Rel5P=[RR1,RR2,RR3,RR4,RR5],

	Space += rel(Rel5P, 'IRT_GQ', Rel5),

	Space += rel(EqDownY,'SRT_SUB',LeftX,RR1),
	Space += rel(EqDownX,'SRT_SUB',RightY,RR2),
	Space += rel(RightX,'SRT_SUB',RightY,RR3),
	Space += rel(LeftY,'SRT_SUB',LeftX,RR4),
	Space += rel(ChildrenX,'SRT_DISJ',ChildrenY,RR5),

	%% N5
	Rel5N := boolvar(Space),
	Space += rel(Rel,'IRT_NQ',5, Rel5N),

	Rel5NP := boolvars(Space,2),
	Rel5NP=[RNNNNN1,RNNNNN2],
	
	Space += rel(Rel5NP,'IRT_GQ',Rel5N),
	
	Space += rel(EqY,'SRT_DISJ',LeftX,RNNNNN1),
	Space += rel(EqX,'SRT_DISJ',RightY,RNNNNN2),
	!.

node_parent_rel(Space,X,Y,ParentorNot,IParentorNot):-
	ParentorNot := intvar(Space,1,2),
	IParentorNot := intvar(Space,1,2),

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


	%%Space += linear([ParentorNot,IParentorNot],'IRT_LQ',1),

	%% ParentX 
	Parent := boolvar(Space),
	Space += rel(ParentorNot,'IRT_EQ',1,Parent),
	RRParent := boolvars(Space,6),
	RRParent=[RParent1,RParent2,RParent3,RParent4,RParent5,RParent6],
	Space += rel(RRParent, 'IRT_GQ', Parent),

	Space += rel(EqX,'SRT_EQ',ParentY,RParent1),
	Space += rel(EqUpX,'SRT_EQ',UpY,RParent2),
	Space += rel(EqDownY,'SRT_SUB',DownX,RParent3),
	Space += rel(EqY,'SRT_SUB',ChildrenX,RParent4),
	Space += rel(LeftX,'SRT_SUB',LeftY,RParent5),
	Space += rel(RightX,'SRT_SUB',RightY,RParent6),


	%% Not parentX 
	RNParent := boolvar(Space),
	Space += rel(ParentorNot,'IRT_EQ',2,RNParent),

	RRNParent := boolvars(Space,2),
	RRNParent=[RNParent1,RNParent2],
	Space += rel(RRNParent, 'IRT_GQ', RNParent),

	Space += rel(EqX,'SRT_DISJ',ParentY,RNParent1),
	Space += rel(EqY,'SRT_DISJ',ChildrenY,RNParent2),


	%% ParentY 
	IParent := boolvar(Space),
	Space += rel(IParentorNot,'IRT_EQ',1,IParent),
	IRRParent := boolvars(Space,6),
	IRRParent=[IRParent1,IRParent2,IRParent3,IRParent4,IRParent5,IRParent6],
	Space += rel(IRRParent, 'IRT_GQ', IParent),

	Space += rel(EqY,'SRT_EQ',ParentX,IRParent1),
	Space += rel(EqUpY,'SRT_EQ',UpX,IRParent2),
	Space += rel(EqDownX,'SRT_SUB',DownY,IRParent3),
	Space += rel(EqX,'SRT_SUB',ChildrenY,IRParent4),
	Space += rel(LeftY,'SRT_SUB',LeftX,IRParent5),
	Space += rel(RightY,'SRT_SUB',RightX,IRParent6),


	%% Not parentY 
	IRNParent := boolvar(Space),
	Space += rel(IParentorNot,'IRT_EQ',2,IRNParent),


	IRRNParent := boolvars(Space,2),
	IRRNParent=[IRNParent1,IRNParent2],
	Space += rel(IRRNParent, 'IRT_GQ', IRNParent),

	Space += rel(EqY,'SRT_DISJ',ParentX,IRNParent1),
	Space += rel(EqX,'SRT_DISJ',ChildrenX,IRNParent2),
	
	!.

global_constraints(Space,Nodes,IntVars1,IntVars2):-
	global_rels(Space,Nodes,IntVars1,IntVars2),
	%%one_root(Space,Nodes,[]),
	!.


global_rels(Space,[N|Nodes],IntVars1,IntVars2):-
	node_rels(Space,[N|Nodes],Nodes,IntVars1,IntVars2),
	!.

node_rels(Space,[],_,[],[]):-!.
node_rels(Space,[H],_,[],[]):-!.
node_rels(Space,[_,H|T],[],I,J):-
	node_rels(Space,[H|T],T,I,J).
node_rels(Space,[Node1|T1],[Node2|T2],[H|T],[HH,HHH|TP]):-
	node_rel(Space,Node1,Node2,H),
	node_parent_rel(Space,Node1,Node2,HH,HHH),
	Space +=linear([HH,HHH],'IRT_GR',2),
	node_rels(Space,[Node1|T1],T2,T,TP),
	!.


global_branch(Space,List):-
	Space += branch(List,'INT_VAR_NONE','INT_VAL_MIN').

global_pbranch(Space,List):-
	Space += branch(List,'INT_VAR_NONE','INT_VAL_MIN').


one_root(Space,[],IsRoot):-
	Space += linear(IsRoot, 'IRT_GR' , 0),
	!.
one_root(Space,[Node|T],BoolVars):-
	IsRoot :=: isroot(Node),
	one_root(Space,T,[IsRoot|BoolVars]).




