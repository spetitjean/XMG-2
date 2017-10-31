%% -*- prolog -*-

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
	Node=node(Eq,Up,Down,Left,Right,EqDown,EqUp,Side,Children,Parent,UpCard,IsRoot,RB),
	Empty := intset([]),
	Full := intset(1,N),
	FullVar := setvar(Space,Full,Full),
	EmptyVar := setvar(Space,Empty,Empty),
	[Eq,Up,Down,Left,Right,EqDown,EqUp,Side,Children,Parent,RB] := setvars(Space,11,Empty,Full),
	M is N-1,
	UpCard := intvar(Space,0,M),
	IsRoot := boolvar(Space),
	Space += cardinality(Parent,0,M), 
	Space += cardinality(Up,UpCard),
	Space += reify(IsRoot,'RM_EQV',IsRootR),
	Space += rel(UpCard,'IRT_EQ',0,IsRootR),
	%%Space += rel(Side,'SRT_EQ',EmptyVar,IsRoot),
	Space += rel(FullVar,'SRT_EQ',EqDown,IsRootR),
	Space += rel(Eq,'SOT_DUNION',Down,'SRT_EQ',EqDown),
	Space += rel(Eq,'SOT_DUNION',Up,'SRT_EQ',EqUp),
	Space += rel(Left,'SOT_DUNION',Right,'SRT_EQ',Side),
	Space += rel('SOT_DUNION',[EqUp,Down,Left,Right],FullVar),
	Space += rel('SOT_DUNION',[Up,EqDown,Left,Right],FullVar),
    	Space += dom(Eq,'SRT_SUP',I),
	Space += rel(Parent, 'SRT_SUB', Up),
	Space += rel(Children, 'SRT_SUB', Down),
	Space += rel(RB, 'SRT_SUB', Eq),
	Space += cardinality(RB,1,1),!.

is_node(Node) :- functor(Node,node,13).
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

	Space += reify(Rel1,'RM_EQV',Rel1R),
	Space += reify(Rel2,'RM_EQV',Rel2R),
	Space += reify(Rel3,'RM_EQV',Rel3R),
	Space += reify(Rel4,'RM_EQV',Rel4R),
	Space += reify(Rel5,'RM_EQV',Rel5R),

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
	Space += rel(Rel,'IRT_EQ',1,Rel1R),

	Rel1P := boolvars(Space,13),
	Rel1P=[R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13],

	Space += reify(R1,'RM_EQV',R1R),
	Space += reify(R2,'RM_EQV',R2R),
	Space += reify(R3,'RM_EQV',R3R),
	Space += reify(R4,'RM_EQV',R4R),
	Space += reify(R5,'RM_EQV',R5R),
	Space += reify(R6,'RM_EQV',R6R),
	Space += reify(R7,'RM_EQV',R7R),
	Space += reify(R8,'RM_EQV',R8R),
	Space += reify(R9,'RM_EQV',R9R),
	Space += reify(R10,'RM_EQV',R10R),
	Space += reify(R11,'RM_EQV',R11R),
	Space += reify(R12,'RM_EQV',R12R),
	Space += reify(R13,'RM_EQV',R13R),
	

	Space += rel(Rel1P, 'IRT_GQ', Rel1),

	Space += rel(EqX,'SRT_EQ',EqY,R1R),
	Space += rel(UpX,'SRT_EQ',UpY,R2R),
	Space += rel(DownX,'SRT_EQ',DownY,R3R),
	Space += rel(LeftX,'SRT_EQ',LeftY,R4R),
	Space += rel(RightX,'SRT_EQ',RightY,R5R),
	Space += rel(EqDownX,'SRT_EQ',EqDownY,R6R),
	Space += rel(EqUpX,'SRT_EQ',EqUpY,R7R),
	Space += rel(SideX,'SRT_EQ',SideY,R8R),
	Space += rel(ChildrenX,'SRT_EQ',ChildrenY,R9R),
	Space += rel(ParentX,'SRT_EQ',ParentY,R10R),
	Space += rel(UpCardX,'IRT_EQ',UpCardY,R11R),
	Space += rel(IsRootX,'IRT_EQ',IsRootY,R12R),
	Space += rel(RbX,'SRT_EQ',RbY,R13R),
	
	%% N1 : !=
	Rel1N := boolvar(Space),
	Space += reify(Rel1N,'RM_EQV',Rel1NR),

	Space += rel(Rel,'IRT_NQ',1,Rel1NR),

	Rel1NP := boolvars(Space,4),
	Rel1NP=[RN1,RN2,RN3,RN4],

	Space += reify(RN1,'RM_EQV',RN1R),
	Space += reify(RN2,'RM_EQV',RN2R),
	Space += reify(RN3,'RM_EQV',RN3R),
	Space += reify(RN4,'RM_EQV',RN4R),


	Space += rel(Rel1NP, 'IRT_GQ', Rel1N),

	Space +=rel(EqX,'SRT_DISJ',EqY,RN1R),
	Space +=rel(ChildrenX,'SRT_DISJ',ChildrenY,RN2R),
	Space +=linear([IsRootX,IsRootY],'IRT_LQ',1,RN3R),
	Space += rel(RbX,'SRT_DISJ',RbY,RN4R),

	%% 2 : <-+
	Space += rel(Rel,'IRT_EQ',2,Rel2R),

	Rel2P := boolvars(Space,10),
	Rel2P=[RU1,RU2,RU3,RU4,RU5,RU6,RU7,RU8,RU9,RU10],

	Space += reify(RU1,'RM_EQV',RU1R),
	Space += reify(RU2,'RM_EQV',RU2R),
	Space += reify(RU3,'RM_EQV',RU3R),
	Space += reify(RU4,'RM_EQV',RU4R),
	Space += reify(RU5,'RM_EQV',RU5R),
	Space += reify(RU6,'RM_EQV',RU6R),
	Space += reify(RU7,'RM_EQV',RU7R),
	Space += reify(RU8,'RM_EQV',RU8R),
	Space += reify(RU9,'RM_EQV',RU9R),
	Space += reify(RU10,'RM_EQV',RU10R),


	Space += rel(Rel2P, 'IRT_GQ', Rel2),

	Space += rel(LeftY,'SRT_SUB',LeftX,RU1R),
	Space += rel(RightY,'SRT_SUB',RightX,RU2R),
	Space += rel(EqUpY,'SRT_SUB',UpX,RU3R),
	Space += rel(EqDownX,'SRT_SUB',DownY,RU4R),
	Space += rel(ParentX,'SRT_SUB',EqDownY,RU5R),
	Space += rel(ChildrenX,'SRT_DISJ',ChildrenY,RU6R),
	Space += rel(DownX,'SRT_DISJ',ChildrenY,RU7R),
	Space += rel(CYCard,'IRT_GQ',Card1,RU8R),
	Space += rel(PXCard,'IRT_GQ',Card1,RU9R),
	Space += rel(IsRootX,'IRT_EQ',0,RU10R),


	%% N2
	Rel2N := boolvar(Space),
	Space += reify(Rel2N,'RM_EQV',Rel2NR),

	Space += rel(Rel,'IRT_NQ',2,Rel2NR),

	Rel2NP := boolvars(Space,2),
	Rel2NP=[RNN1,RNN2],

	Space += reify(RNN1,'RM_EQV',RNN1R),
	Space += reify(RNN2,'RM_EQV',RNN2R),

	
	Space += rel(Rel2NP,'IRT_GQ',Rel2N),
	
	Space += rel(EqY,'SRT_DISJ',UpX,RNN1R),
	Space += rel(DownY,'SRT_DISJ',EqX,RNN2R),

	%% 3 : ->+
	Space += rel(Rel,'IRT_EQ',3,Rel3R),

	Rel3P := boolvars(Space,10),
	Rel3P=[RO1,RO2,RO3,RO4,RO5,RO6,RO7,RO8,RO9,RO10],

	Space += reify(RO1,'RM_EQV',RO1R),
	Space += reify(RO2,'RM_EQV',RO2R),
	Space += reify(RO3,'RM_EQV',RO3R),
	Space += reify(RO4,'RM_EQV',RO4R),
	Space += reify(RO5,'RM_EQV',RO5R),
	Space += reify(RO6,'RM_EQV',RO6R),
	Space += reify(RO7,'RM_EQV',RO7R),
	Space += reify(RO8,'RM_EQV',RO8R),
	Space += reify(RO9,'RM_EQV',RO9R),
	Space += reify(RO10,'RM_EQV',RO10R),


	Space += rel(Rel3P, 'IRT_GQ', Rel3),

	Space += rel(LeftX,'SRT_SUB',LeftY,RO1R),
	Space += rel(RightX,'SRT_SUB',RightY,RO2R),
	Space += rel(EqUpX,'SRT_SUB',UpY,RO3R),
	Space += rel(EqDownY,'SRT_SUB',DownX,RO4R),
	Space += rel(ParentY,'SRT_SUB',EqDownX,RO5R),
	Space += rel(ChildrenX,'SRT_DISJ',ChildrenY,RO6R),
	Space += rel(ChildrenX,'SRT_DISJ',DownY,RO7R),

	Space += rel(CXCard,'IRT_GQ',Card1,RO8R),
	Space += rel(PYCard,'IRT_GQ',Card1,RO9R),
	Space += rel(IsRootY,'IRT_EQ',0,RO10R),
	
	%% N3
	Rel3N := boolvar(Space),
	Space += reify(Rel3N,'RM_EQV',Rel3NR),

	Space += rel(Rel,'IRT_NQ',3,Rel3NR),

	Rel3NP := boolvars(Space,2),
	Rel3NP=[RNNN1,RNNN2],
	
	Space += reify(RNNN1,'RM_EQV',RNNN1R),
	Space += reify(RNNN2,'RM_EQV',RNNN2R),

	Space += rel(Rel3NP,'IRT_GQ',Rel3N),
	
	Space += rel(EqX,'SRT_DISJ',UpY,RNNN1R),
	Space += rel(DownX,'SRT_DISJ',EqY,RNNN2R),

	%% 4 : <<+
	Space += rel(Rel,'IRT_EQ',4,Rel4R),

	Rel4P := boolvars(Space,5),
	Rel4P=[RL1,RL2,RL3,RL4,RL5],

	Space += reify(RL1,'RM_EQV',RL1R),
	Space += reify(RL2,'RM_EQV',RL2R),
	Space += reify(RL3,'RM_EQV',RL3R),
	Space += reify(RL4,'RM_EQV',RL4R),
	Space += reify(RL5,'RM_EQV',RL5R),


	Space += rel(Rel4P, 'IRT_GQ', Rel4),

	Space += rel(EqDownX,'SRT_SUB',LeftY,RL1R),
	Space += rel(EqDownY,'SRT_SUB',RightX,RL2R),
	Space += rel(RightY,'SRT_SUB',RightX,RL3R),
	Space += rel(LeftX,'SRT_SUB',LeftY,RL4R),
	Space += rel(ChildrenX,'SRT_DISJ',ChildrenY,RL5R),

	%% N4
	Rel4N := boolvar(Space),
	Space += reify(Rel4N,'RM_EQV',Rel4NR),

	Space += rel(Rel,'IRT_NQ',4,Rel4NR),

	Rel4NP := boolvars(Space,2),
	Rel4NP=[RNNNN1,RNNNN2],

	Space += reify(RNNNN1,'RM_EQV',RNNNN1R),
	Space += reify(RNNNN2,'RM_EQV',RNNNN2R),
	
	Space += rel(Rel4NP,'IRT_GQ',Rel4N),
	
	Space += rel(EqX,'SRT_DISJ',LeftY,RNNNN1R),
	Space += rel(EqY,'SRT_DISJ',RightX,RNNNN2R),



	%% 5 : >>+
	Space += rel(Rel,'IRT_EQ',5,Rel5R),

	Rel5P := boolvars(Space,5),
	Rel5P=[RR1,RR2,RR3,RR4,RR5],

	Space += reify(RR1,'RM_EQV',RR1R),
	Space += reify(RR2,'RM_EQV',RR2R),
	Space += reify(RR3,'RM_EQV',RR3R),
	Space += reify(RR4,'RM_EQV',RR4R),
	Space += reify(RR5,'RM_EQV',RR5R),


	Space += rel(Rel5P, 'IRT_GQ', Rel5),

	Space += rel(EqDownY,'SRT_SUB',LeftX,RR1R),
	Space += rel(EqDownX,'SRT_SUB',RightY,RR2R),
	Space += rel(RightX,'SRT_SUB',RightY,RR3R),
	Space += rel(LeftY,'SRT_SUB',LeftX,RR4R),
	Space += rel(ChildrenX,'SRT_DISJ',ChildrenY,RR5R),

	%% N5
	Rel5N := boolvar(Space),
	Space += reify(Rel5N,'RM_EQV',Rel5NR),

	Space += rel(Rel,'IRT_NQ',5, Rel5NR),

	Rel5NP := boolvars(Space,2),
	Rel5NP=[RNNNNN1,RNNNNN2],

	Space += reify(RNNNNN1,'RM_EQV',RNNNNN1R),
	Space += reify(RNNNNN2,'RM_EQV',RNNNNN2R),

	
	Space += rel(Rel5NP,'IRT_GQ',Rel5N),
	
	Space += rel(EqY,'SRT_DISJ',LeftX,RNNNNN1R),
	Space += rel(EqX,'SRT_DISJ',RightY,RNNNNN2R),
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
	Space += reify(Parent,'RM_EQV',ParentR),

	Space += rel(ParentorNot,'IRT_EQ',1,ParentR),
	RRParent := boolvars(Space,6),
	RRParent=[RParent1,RParent2,RParent3,RParent4,RParent5,RParent6],

	Space += reify(RParent1,'RM_EQV',RParent1R),
	Space += reify(RParent2,'RM_EQV',RParent2R),
	Space += reify(RParent3,'RM_EQV',RParent3R),
	Space += reify(RParent4,'RM_EQV',RParent4R),
	Space += reify(RParent5,'RM_EQV',RParent5R),
	Space += reify(RParent6,'RM_EQV',RParent6R),

	Space += rel(RRParent, 'IRT_GQ', Parent),

	Space += rel(EqX,'SRT_EQ',ParentY,RParent1R),
	Space += rel(EqUpX,'SRT_EQ',UpY,RParent2R),
	Space += rel(EqDownY,'SRT_SUB',DownX,RParent3R),
	Space += rel(EqY,'SRT_SUB',ChildrenX,RParent4R),
	Space += rel(LeftX,'SRT_SUB',LeftY,RParent5R),
	Space += rel(RightX,'SRT_SUB',RightY,RParent6R),

	%% Not parentX 
	RNParent := boolvar(Space),
	Space += reify(RNParent,'RM_EQV',RNParentR),

	Space += rel(ParentorNot,'IRT_EQ',2,RNParentR),

	RRNParent := boolvars(Space,2),
	RRNParent=[RNParent1,RNParent2],

	Space += reify(RNParent1,'RM_EQV',RNParent1R),
	Space += reify(RNParent2,'RM_EQV',RNParent2R),


	Space += rel(RRNParent, 'IRT_GQ', RNParent),

	Space += rel(EqX,'SRT_DISJ',ParentY,RNParent1R),
	Space += rel(EqY,'SRT_DISJ',ChildrenY,RNParent2R),


	%% ParentY 
	IParent := boolvar(Space),
	Space += reify(IParent,'RM_EQV',IParentR),

	Space += rel(IParentorNot,'IRT_EQ',1,IParentR),
	IRRParent := boolvars(Space,6),
	IRRParent=[IRParent1,IRParent2,IRParent3,IRParent4,IRParent5,IRParent6],

	Space += reify(IRParent1,'RM_EQV',IRParent1R),
	Space += reify(IRParent2,'RM_EQV',IRParent2R),
	Space += reify(IRParent3,'RM_EQV',IRParent3R),
	Space += reify(IRParent4,'RM_EQV',IRParent4R),
	Space += reify(IRParent5,'RM_EQV',IRParent5R),
	Space += reify(IRParent6,'RM_EQV',IRParent6R),
	
	Space += rel(IRRParent, 'IRT_GQ', IParent),

	Space += rel(EqY,'SRT_EQ',ParentX,IRParent1R),
	Space += rel(EqUpY,'SRT_EQ',UpX,IRParent2R),
	Space += rel(EqDownX,'SRT_SUB',DownY,IRParent3R),
	Space += rel(EqX,'SRT_SUB',ChildrenY,IRParent4R),
	Space += rel(LeftY,'SRT_SUB',LeftX,IRParent5R),
	Space += rel(RightY,'SRT_SUB',RightX,IRParent6R),


	%% Not parentY 
	IRNParent := boolvar(Space),
	Space += reify(IRNParent,'RM_EQV',IRNParentR),

	Space += rel(IParentorNot,'IRT_EQ',2,IRNParentR),


	IRRNParent := boolvars(Space,2),
	IRRNParent=[IRNParent1,IRNParent2],

	Space += reify(IRNParent1,'RM_EQV',IRNParent1R),
	Space += reify(IRNParent2,'RM_EQV',IRNParent2R),


	Space += rel(IRRNParent, 'IRT_GQ', IRNParent),

	Space += rel(EqY,'SRT_DISJ',ParentX,IRNParent1R),
	Space += rel(EqX,'SRT_DISJ',ChildrenX,IRNParent2R),
	
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




