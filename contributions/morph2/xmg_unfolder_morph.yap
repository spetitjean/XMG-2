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

:-module(xmg_unfolder_morph).

unfold('MorphStmt',[M],UM):- 
	unfold(M,UM),!.
unfold('MorphStmts',[M],UM):- 
	unfold(M,UM),!.
unfold('MorphStmts',[token(_,'{'),M,token(_,'}')],UM):- 
	unfold(M,UM),!.
unfold('MorphStmts',[M1,token(_,';'),M2],and(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.
unfold('MorphStmts',[M1,token(_,'|'),M2],or(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.

unfold('Stem',[token(_,'morpheme'),Var],morpheme(UVar)):-
	unfold(Var,UVar),!.
unfold('InStem',[Stem,token(_,'<-'),E],inmorph(UStem,UE)):-
	unfold(Stem,UStem),
	unfold(E,UE),!.
unfold('StemRel',[Stem1,Prec,Stem2],precmorph(UStem1,UStem2,UPrec)):-
	unfold(Stem1,UStem1),
	unfold(Stem2,UStem2),
	unfold(Prec,UPrec),!.
unfold('Eq',['Expr'(E1),token(_,'='),'Expr'(E2)],eq(UE1,UE2)):-
	unfold(E1,UE1),
	unfold(E2,UE2),!.
unfold('ADisj',[ADisj],UADisj):-
	unfold(ADisj,UADisj),!.

unfold('Expr',[Expr],UExpr):-
	unfold(Expr,UExpr),!.

unfold('Var',[token(_,'?'),ID],UID):-
	unfold(ID,UID),!.
 
unfold(token(C,string(S)),string(US,C)):- 
	atom_codes(US,S),!.
unfold(token(C,id(ID)),id(ID,C)):- !.
unfold(token(C,int(Int)),int(Int,C)):- !.
unfold(token(C,bool(Bool)),bool(Bool,C)):- !.
unfold(token(_,'>>'),'>>'):- !.

%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	head_name(Head,Name),
	(
	    (
		Module='morph',
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(Module='morph'),
	    xmg_modules:get_module(Module,unfolder,UModule),
	    %%xmg_compiler:send(info,UModule),
	    UModule:unfold(Term,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(morph2,Rule)))),	
	!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

head_name(Head,Name):-
	atomic_list_concat(A,'-',Head),
	A=[_,Name],!.