:-module(xmg_unfolder_pg).

:-use_module(xmg_unfolder_avm).

unfold('pg-DimStmt',[token(_,'<pg>'),token(_,'{'),DimStmt,token(_,'}')],'pgStmt'(UStmt)):-
	unfold(DimStmt,UStmt),
	!.

unfold('pg-PGStmt',[M],UM):- 
	unfold(M,UM),!.
unfold('pg-PGStmts',[M],UM):- 
	unfold(M,UM),!.
unfold('pg-PGStmts',[token(_,'{'),M,token(_,'}')],UM):- 
	unfold(M,UM),!.
unfold('pg-PGStmts',[M1,token(_,';'),M2],and(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.
unfold('pg-PGStmts',[M1,token(_,'|'),M2],or(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.

unfold('pg-Eq',[ID,token(_,'='),AVM],eq(UID,UAVM,C)):-
	unfold(ID,UID),
	get_coord(ID,C),
	unfold(AVM,UAVM),
	!.
unfold('pg-Prop',[Stmt],prop(UStmt)):-
	unfold(Stmt,UStmt),
	!.

unfold('pg-Uni',[token(_,id(ID1)),token(_,':'),token(_,id(ID2)),token(_,'!')],uni(ID1,ID2)):- !.
unfold('pg-Obl',[token(_,id(ID1)),token(_,':'),token(_,'-!-'),token(_,id(ID2))],obl(ID1,ID2)):- !.
unfold('pg-Lin',[token(_,id(ID1)),token(_,':'),token(_,id(ID2)),token(_,'<'),token(_,id(ID3))],lin(ID1,ID2,ID3)):- !.
unfold('pg-Req',[token(_,id(ID1)),token(_,':'),token(_,id(ID2)),token(_,'=>'),token(_,id(ID3))],req(ID1,ID2)):- !.
unfold('pg-Excl',[token(_,id(ID1)),token(_,':'),token(_,id(ID2)),token(_,'<=!>'),token(_,id(ID3))],excl(ID1,ID2)):- !.
unfold('pg-Const',[token(_,id(ID1)),token(_,':'),token(_,id(ID2))],const(ID1,ID2)):- !.


unfold('pg-AVM',[AVM],UAVM):-
	xmg_unfolder_avm:unfold(AVM,UAVM).


unfold(token(C,id(ID)),id(ID,C)).
 
get_coord(token(C,_),C).

%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	unfold(Head,Params,UTerm),!.
