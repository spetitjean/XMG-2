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


:-module(xmg_brick_sem_unfolder).

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).


xmg:unfold_dimstmt(Sem,sem:pred(Label,Pred,Params)):--
	constraints::enq((sem:pred(Label,Pred,Params),Sem)),
	!.


unfold('sem-SemStmt',[M],UM):- 
	unfold(M,UM),!.
unfold('sem-SemStmts',[M],UM):- 
	unfold(M,UM),!.
unfold('sem-SemStmts',[token(_,'{'),M,token(_,'}')],UM):- 
	unfold(M,UM),!.
unfold('sem-SemStmts',[M1,token(_,';'),M2],and(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.
unfold('sem-SemStmts',[M1,token(_,'|'),M2],or(UM1,UM2)):- 
	unfold(M1,UM1),
	unfold(M2,UM2),!.

unfold('sem-Pred',[Label,token(_,':'),Pred,token(_,'('),Ids_Coma,token(_,')')],pred(ULabel,UPred,UIds)):-
	unfold(Label,ULabel),
	unfold(Pred,UPred),
	unfold(Ids_Coma,UIds),
	!.

unfold('sem-Pred',[Pred,token(_,'('),Ids_Coma,token(_,')')],pred(none,UPred,UIds)):-
	unfold(Pred,UPred),
	unfold(Ids_Coma,UIds),
	!.

unfold('sem-Vars_coma',[Var,token(_,','),Vars],[UVar|UVars]):-
	unfold(Var,UVar),
	unfold(Vars,UVars).
unfold('sem-Vars_coma',[Var],[UVar]):-
	unfold(Var,UVar).

unfold('sem-Var',[token(C,id(ID))],id(ID,C)).
unfold('sem-Var',[token(_,'?'),token(C,id(ID))],id(ID,C)).
unfold('sem-Var',[token(_,'!'),token(C,id(ID))],id(ID,C)).

unfold(token(C,id(ID)),id(ID,C)).
 
unfold(token(C,string(S)),string(US,C)):- 
	atom_codes(US,S),!.
unfold(token(C,id(ID)),id(ID,C)):- !.



%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	(
	    (
		Module='sem',
		unfold(Head,Params,UTerm)
	    )
	;
	(
	    not(Module='sem'),
	    xmg_modules:get_module(Module,unfolder,UModule),
	    UModule:unfold(Head,Params,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(sem,Rule)))),	
	!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.
