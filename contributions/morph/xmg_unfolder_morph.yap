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

unfold('morph-DimStmt',[token(_,'<morph>'),token(_,'{'),DimStmt,token(_,'}')],'morphStmt'(UStmt)):-
	unfold(DimStmt,UStmt),
	!.

unfold('Stmt-Stmt',[Stmt],UStmt):- 
	unfold(Stmt,UStmt).

unfold('morph-MorphStmt',[M],UM):- 
	unfold(M,UM),!.
unfold('morph-MorphStmts',[M],UM):- 
	unfold(M,UM),!.
unfold('morph-MorphStmts',[token(_,'{'),M,token(_,'}')],UM):- 
	unfold(M,UM),!.
unfold('morph-MorphStmts',[M1,token(_,';'),M2],and(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.
unfold('morph-MorphStmts',[M1,token(_,'|'),M2],or(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.


unfold('morph-InField',[token(CF,id(Field)),token(_,'<-'),'morph-Expr'(E)],infield(id(Field,CF),UE)):-
	unfold(E,UE),!.
unfold('morph-Eq',['morph-Expr'(E1),token(_,'='),'morph-Expr'(E2)],eq(UE1,UE2)):-
	unfold(E1,UE1),
	unfold(E2,UE2),!.
unfold('morph-ADisj',[ADisj],UADisj):-
	unfold(ADisj,UADisj),!.
 
unfold(token(C,string(S)),string(US,C)):- 
	atom_codes(US,S),!.
unfold(token(C,id(ID)),id(ID,C)):- !.
unfold(token(C,int(Int)),int(Int,C)):- !.
unfold(token(C,bool(Bool)),bool(Bool,C)):- !.

%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	(
	    (
		Module='morph',
		unfold(Head,Params,UTerm)
	    )
	;
	(
	    not(Module='morph'),
	    xmg_modules:get_module(Module,unfolder,UModule),
	    xmg_compiler:send(info,UModule),
	    UModule:unfold(Term,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(morph,Rule)))),	
	!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.
