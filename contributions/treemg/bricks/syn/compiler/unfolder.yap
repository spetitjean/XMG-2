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


:-module(xmg_brick_syn_unfolder).

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).

:- edcg:weave([constraints,name,vars,consts],[]).


%%:-add_to_path('../AVM').
%%:-use_module('xmg_unfolder_avm').

%% unfold('DimStmt',[token(_,'<syn>'),token(_,'{'),DimStmt,token(_,'}')],'synStmt'(UStmt)):-
%% 	unfold(DimStmt,UStmt),
%% 	!.


xmg:unfold_dimstmt(Syn,syn:tree(Root,Children)):--
	%%xmg_brick_mg_compiler:send(info,Root),
	!.
xmg:unfold_dimstmt(Syn,syn:and(S1,S2)):-- 
	%%xmg_brick_mg_compiler:send(info,S1),
	xmg:unfold_dimstmt(Syn,S1) ,
	xmg:unfold_dimstmt(Syn,S2) ,
	!.
xmg:unfold_dimstmt(Syn,syn:or(S1,S2)):-- 
	xmg:unfold_dimstmt(Syn,S1) with (constraints([]-C1,[]-[])),
	xmg:unfold_dimstmt(Syn,S2) with (constraints([]-C2,[]-[])),
	constraints::enq(or([and(C1),and(C2)])),
	!.

xmg:unfold_dimstmt(Syn,syn:S1):-- 
	xmg:unfold_dimstmt(Syn,S1),!.

xmg:unfold_dimstmt(Syn,syn:node(N,P,F)):-- 
	xmg:unfold_expr(N,TN),
	
	constraints::enq((TN,syn:node,Syn)),
	%%constraints::enq(indim(Syn,TN)),
	xmg:new_target_var(T1),
	xmg:new_target_var(T2),
	%%xmg_brick_mg_compiler:send(info,P),
	%%xmg_brick_mg_compiler:send(info,F),
	xmg:unfold_expr(P,T1),
	constraints::enq((TN,syn:props(T1))),	
	xmg:unfold_expr(F,T2),
	constraints::enq((TN,syn:feats(T2))),
	!.
xmg:unfold_dimstmt(Syn,syn:dom(token(_,Op),N1,N2)):-- 
	%%xmg:new_target_var(T1),
	%%xmg:new_target_var(T2),
	xmg:unfold_expr(N1,T1),
	xmg:unfold_expr(N2,T2),
	constraints::enq((syn:dom(T1,Op,T2,C),Syn)),
	!.
xmg:unfold_dimstmt(Syn,syn:prec(token(_,Op),N1,N2)):-- 
	xmg:unfold_expr(N1,T1),
	xmg:unfold_expr(N2,T2),
	constraints::enq((syn:prec(T1,Op,T2,C),Syn)),
	!.

xmg:unfold_expr(none,_):-- !.
xmg:unfold_expr(some(E),Target):--
	xmg:unfold_expr(E,Target),!.




unfold('SynStmt',[M],UM):- 
	unfold(M,UM),!.
unfold('SynStmts',[M],UM):-
	unfold(M,UM),!.
unfold('SynStmts',[token(_,'{'),M,token(_,'}')],UM):- 
	unfold(M,UM),!.
unfold('SynStmts',[M1,token(_,';'),M2],and(UM1,UM2)):- 
	unfold(M1,UM1),!,
	unfold(M2,UM2),!.
unfold('SynStmts',[M1,token(_,'|'),M2],or(UM1,UM2)):- 
	unfold(M1,UM1),!,
	unfold(M2,UM2),!.

unfold('Dom',[IdOrNode1,Op,IdOrNode2],syndom(UOp,U1,U2,C)):-
	unfold(IdOrNode1,U1),
	unfold(Op,UOp),
	unfold(IdOrNode2,U2),
	!.
unfold('Prec',[IdOrNode1,Op,IdOrNode2],synprec(UOp,U1,U2,C)):-
	unfold(IdOrNode1,U1),
	unfold(Op,UOp),
	unfold(IdOrNode2,U2),
	!.
unfold('Node',[token(CN,node),MaybeId,MaybeProps,MaybeFeats],synnode(UId,props(UP),feats(UF),CN)):-
	unfold(MaybeId,UId),
	unfold(MaybeProps,UP),
	unfold(MaybeFeats,UF),
	!.

unfold('Tree',[Node,token(_,'{'),Children,token(_,'}')],and(UNode,UT)):-
	unfold(Node,UNode),!,
	unfold_children(UNode,Children,UT),
	!.


unfold_children(Node,'syn-Children'(Child),UC):-
	unfold_child(Node,Child,UC),!.
unfold_children(Node,'syn-Children'(Child,Op,Children),and(UC,UT)):-
	unfold_child(Node,Child,UC),!,
	unfold_brothers(Node,UC,Op,Children,UT),!.

unfold_child(Node,'syn-Child'(Op,NodeOrTree),and(UC,URC)):-
	unfold(NodeOrTree,UC),!,
	root_id(Node,NID),!,
	root_id(UC,UCID),!,
	unfold_rel_child(NID,Op,UCID,URC),
	!.

unfold_rel_child(Node,Op,Child,syndom(UOp,Node,Child,C)):-
	unfold(Op,UOp),
	!.
	
unfold('TreeDomOp',[''],'->'):- !.
unfold('TreeDomOp',[token(_,'...+')],'->+'):- !.
unfold('TreeDomOp',[token(_,'...')],'->*'):- !.


unfold_brothers(Father,Bro,Op,Bros,and(UB,URB)):-
	unfold_children(Father,Bros,UB),!,
	root_id(Bro,BroID),!,
	root_id(UB,UBID),!,
	unfold_rel_brother(BroID,Op,UBID,URB),
	!.

unfold_rel_brother(Node,Op,Child,synprec(UOp,Node,Child,C)):-
	unfold(Op,UOp),
	!.
	
unfold('TreePrecOp',[''],'>>'):- !.
unfold('TreePrecOp',[token(_,',,,+')],'>>+'):- !.
unfold('TreePrecOp',[token(_,',,,')],'>>*'):- !.

root_id(synnode(UId,_,_,_),UId):- !.
root_id(and(Tree,_),TreeId):-
	root_id(Tree,TreeId),!.

unfold('MaybeId',[''],Var):-!.
	%%new_name(UID).
unfold('MaybeId',[ID],UID):-
	unfold(ID,UID),
	!.

unfold('MaybeProps',[''],[]).
unfold('MaybeProps',[token(_,'('),Feats,token(_,')')],UFeats):-
	unfold(Feats,UFeats).

unfold('Feat',List,UF):-
	xmg_brick_avm_unfolder:unfold('Feat',List,UF),!.

unfold('AVM',[AVM],UAVM):-
	unfold(AVM,UAVM),!.

unfold('MaybeFeats',[''],[]).
unfold('MaybeFeats',[AVM],UAVM):-
	unfold(AVM,avm(UAVM)).

unfold('IdOrNode',[I],UI):-
	unfold(I,UI).
unfold('DomOp',[token(_,O)],O).
unfold('PrecOp',[token(_,O)],O).

unfold('Props',[Feat],[UF]):-
	xmg_brick_avm_unfolder:unfold(Feat,UF).
unfold('Props',[Feat,token(_,','),Feats],[UF|UFs]):-
	xmg_brick_avm_unfolder:unfold(Feat,UF),
	unfold(Feats,UFs).

unfold('Eq',[Left,token(_,'='),Right],eq(UL,UR)):-
	unfold(Left,UL),
	unfold(Right,UR),!.

unfold('Var',[token(C,id(ID))],id(ID,C)).
unfold('Var',[token(_,'?'),token(C,id(ID))],id(ID,C)).

unfold('id',[token(C,id(ID))],id(ID,C)).
 
unfold('Expr',[token(C,string(S))],string(US,C)):- 
	atom_codes(US,S),!.
unfold('Expr',[token(C,id(ID))],id(ID,C)):- !.

%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	head_name(Head,Name),
	(
	    (
		Module=syn,
		%%xmg_modules_def:module_def(Module,'syn'),
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(Module=syn),
	    %%not(xmg_modules_def:module_def(Module,'syn')),
	    xmg_brick_mg_modules:get_module(Module,unfolder,UModule),
	    UModule:unfold(Term,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(syn,Rule)))),	
	!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

head_name(Head,Name):-
	atomic_list_concat(A,'-',Head),
	A=[_,Name],!.

unfold(Head,Params,UList):-
	unfold_type(Head,list),
	unfold_list(Params,UList),!.
unfold(Head,Params,UList):-
	unfold_type(Head,maybe),
	unfold_maybe(Params,UList),!.

%% PATTERNS

unfold_type(none,none).

unfold_list([''],[]):-!.
unfold_list([Elem],[UElem]):-
	unfold(Elem,UElem),!.
unfold_list([Elem,List],[UElem|UList]):-
	unfold(Elem,UElem),
	unfold(List,UList),!.

unfold_maybe([''],[]):-!.
unfold_maybe([Elem],UElem):-
	unfold(Elem,UElem),!.