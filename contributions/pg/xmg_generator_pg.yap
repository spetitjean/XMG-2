:-module(xmg_generator_pg).

generate_Stmt(Stmt,List,Class,VStmt):-
	%%write(Stmt),
	var_Stmt(Stmt,List,Class,VStmt).
	%%nl,write(Generated),nl.

var_Stmt(or(S1,S2),List,Class,Or):-
	var_Stmt(S1,List,Class,VS1),
	var_Stmt(S2,List,Class,VS2),
	Or=..[';',VS1,VS2].
var_Stmt(and(S1,S2),List,Class,And):-
	var_Stmt(S1,List,Class,VS1),
	var_Stmt(S2,List,Class,VS2),
	And=..[',',VS1,VS2].


var_Stmt(eq(ID,avm(AVM),C),List,Class,Generated):-
	get_id(ID,GID),
	Generated=xmg_avm:avm(GID,AVM).
var_Stmt(Prop,List,Class,AccProp):-
	Put=..[put,Prop],
	AccProp=..['::',xmg_generator:pg,Put],
	!.



get_id(ID,GID).
