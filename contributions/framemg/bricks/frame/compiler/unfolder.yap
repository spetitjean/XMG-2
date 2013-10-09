%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2013  Simon Petitjean

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


:-module(xmg_unfolder_frame).

%% SPECIFIC RULES

unfold('FrameStmt',[M],UM):- 
	unfold(M,UM),!.
unfold('FrameStmts',[M],UM):-
	unfold(M,UM),!.
unfold('FrameStmts',[token(_,'{'),M,token(_,'}')],UM):- 
	unfold(M,UM),!.
unfold('FrameStmts',[M1,token(_,';'),M2],and(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.
unfold('FrameStmts',[M1,token(_,'|'),M2],or(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.

unfold('Node',[token(CN,node),MaybeId,MaybeProps,MaybeFeats],framenode(UId,props(UP),feats(UF),CN)):-
	unfold(MaybeId,UId),
	unfold(MaybeProps,UP),
	unfold(MaybeFeats,UF),
	!.

unfold('Tree',[Node,token(_,'{'),Children,token(_,'}')],and(UNode,UT)):-
	unfold(Node,UNode),!,
	unfold_children(UNode,Children,UT),
	!.

unfold_children(Node,'frame-Children'(Child),UC):-
	unfold_propchild(Node,Child,UC),!.
unfold_children(Node,'frame-Children'(Child,Children),and(UC,UT)):-
	unfold_propchild(Node,Child,UC),
	unfold_brothers(Node,UC,Children,UT),!.

unfold_propchild(Node,'frame-PropChild'(Props,Child),UC):-
	unfold(Props,UProps),
	unfold_child(Node,UProps,Child,UC),!.
	

unfold_child(Node,Props,'frame-Child'(NodeOrTree),and(UC,URC)):-
	unfold(NodeOrTree,UC),
	root_id(Node,NID),
	root_id(UC,UCID),
	unfold_rel_child(NID,UCID,Props,URC),
	!.

unfold_rel_child(Node,Child,Props,edge(Node,Child,Props,C)):-
	!.

unfold_brothers(Father,Bro,Bros,UB):-
	unfold_children(Father,Bros,UB),
	!.

root_id(framenode(UId,_,_,_),UId):- !.
root_id(and(Tree,_),TreeId):-
	root_id(Tree,TreeId),!.

unfold('MaybeId',[''],NID).
unfold('MaybeId',[ID],UID):-
	unfold(ID,UID),
	!.

unfold('MaybeProps',[''],[]).
unfold('MaybeProps',[token(_,'('),Feats,token(_,')')],UFeats):-
	unfold(Feats,UFeats).

unfold('Props',[Feat],[UF]):-
	xmg_unfolder_avm:unfold(Feat,UF).
unfold('Props',[Feat,token(_,','),Feats],[UF|UFs]):-
	xmg_unfolder_avm:unfold(Feat,UF),
	unfold(Feats,UFs).

unfold('Feat',List,UF):-
	xmg_unfolder_avm:unfold('Feat',List,UF),!.

unfold('MaybeFeats',[''],[]).
unfold('MaybeFeats',['AVM'(AVM)],UFeats):-
	xmg_unfolder_avm:unfold(AVM,avm(UFeats)).

unfold('Eq',[Left,token(_,'='),Right],eq(UL,UR)):-
	unfold(Left,UL),
	unfold(Right,UR),!.

unfold('Edge',[token(C,'edge'),Props,N1,N2],edge(UN1,UN2,UProps,C)):-
	unfold(N1,UN1),
	unfold(N2,UN2),
	unfold(Props,UProps),!.


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
		Module='frame',
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(Module='frame'),
	    xmg_modules:get_module(Module,unfolder,UModule),
	    UModule:unfold(Head,Params,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(frame,Rule)))),	
	!.


unfold(Head,Params,UList):-
	unfold_type(Head,list),
	unfold_list(Params,UList),!.
unfold(Head,Params,UList):-
	unfold_type(Head,maybe),
	unfold_maybe(Params,UList),!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

head_name(Head,Name):-
	atomic_list_concat(A,'-',Head),
	A=[_,Name],!.

%% PATTERNS

unfold_list([''],[]):-!.
unfold_list([Elem],[UElem]):-
	unfold(Elem,UElem),!.
unfold_list([Elem,List],[UElem|UList]):-
	unfold(Elem,UElem),!,
	unfold(List,UList),!.

unfold_maybe([''],[]):-!.
unfold_maybe([Elem],UElem):-
	unfold(Elem,UElem),!.

%% USING PATTERNS 

unfold_type('Decls-Principles',list):- !.
unfold_type('Decls-Types',list):- !.
unfold_type('Decls-Properties',list):- !.
unfold_type('Decls-Feats',list):- !.
unfold_type('Decls-Fields',list):- !.

unfold_type('Decls-ids',list):- !.

unfold_type('Decls-DeclsOrNot',maybe):- !.
unfold_type('Decls-ImportsOrNot',maybe):- !.
unfold_type('Decls-ExportsOrNot',maybe):- !.
unfold_type('Decls-ParamsOrNot',maybe):- !.
