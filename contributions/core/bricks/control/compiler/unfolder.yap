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


:-module(xmg_brick_control_unfolder).

:- edcg:using([xmg_brick_mg_unfolder:constraints]).
:- edcg:weave([constraints],
	[
          %%unfold_stmt/2
         ]).

unfold_stmt(control:and(E1,E2),none):--
	!.
unfold_stmt(control:or(E1,E2),none):--
	!.
unfold_stmt(control:stmt(E1,E2),stmt(UE1,UE2)):--
	unfold_stmt(E1,UE1),
	unfold_stmt(E2,UE2),
	!.

unfold_stmt(control:dimStmt(syn,E2),UE2):--
	xmg_brick_syn_unfolder:unfold_stmt(E2,UE2),
	!.

	

unfold('Stmts',[Stmt1,token(_,';'),Stmt2],conj(UStmt1,UStmt2)):- !,
	unfold(Stmt1,UStmt1),
	unfold(Stmt2,UStmt2).
unfold('Stmts',[Stmt1,token(_,'|'),Stmt2],disj(UStmt1,UStmt2)):- !,
	unfold(Stmt1,UStmt1),
	unfold(Stmt2,UStmt2).
unfold('Stmts',[Stmt],UStmt):- !,
	unfold(Stmt,UStmt).

unfold('Stmt',[Stmt,IFace],stmt(UStmt,UIFace)):- !,
	unfold(Stmt,UStmt),
	unfold(IFace,UIFace).

unfold('MaybeIFace',[''],none):- !.
unfold('MaybeIFace',[token(_,'*='),IFace],UIFace):- 
	unfold(IFace,UIFace),!.

unfold('IFace',[IFace],UIFace):-
	unfold(IFace,UIFace),!.

unfold('AStmt',[token(_,'{'),Stmt,token(_,'}')],UStmt):- 
	unfold(Stmt,UStmt),!.
unfold('AStmt',[token(_,'('),Stmt,token(_,')')],opt(UStmt)):- 
	unfold(Stmt,UStmt),!.
unfold('AStmt',[Stmt],UStmt):-
	unfold(Stmt,UStmt),!.
unfold('AStmt',[Left,token(_,'='),Right],eq(ULeft,URight,C)):-
	unfold(Left,ULeft),
	unfold(Right,URight).

unfold('EqPart',[token(C,id(ID))],id(ID,C)):-!.
unfold('EqPart',[Dot],UDot):-
	unfold(Dot,UDot),!.


unfold('DimStmt',[Head,token(_,'{'),Stmt,token(_,'}')],HUStmt):-
	infer_stmt_head(Head,Dim),
	unfold(Stmt,UStmt),
	HUStmt=..[dimStmt,Dim,UStmt],!.


unfold('Call',[token(_,id(Class)),token(_,'['),token(_,']')],class(Class,[])):- !.
unfold('Call',[token(_,id(Class)),token(_,'['),Params,token(_,']')],class(Class,UParams)):- 
	unfold(Params,UParams),!.

unfold('Dot',[Var1,token(_,'.'),Var2],dot(UVar1,UVar2)):- 
	unfold(Var1,UVar1),
	unfold(Var2,UVar2),!.

unfold('ids_coma',[token(_,id(A))],[A]):- !.
unfold('ids_coma',[token(_,id(A)),token(_,','),Ids],[A|UIds]):-
	unfold(Ids,UIds),!.

unfold('Var',[token(C,id(A))],id(A,C)):-!.
unfold('Var',[token(_,'?'),token(C,id(A))],id(A,C)):-!.



%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	head_name(Head,Name),
	(
	    (
		Module='control',
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(Module='control'),
	    xmg_brick_mg_modules:get_module(Module,unfolder,UModule),
	    UModule:unfold(Term,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(control,Rule)))),	
	!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

head_name(Head,Name):-
	atomic_list_concat(A,'-',Head),
	A=[_,Name],!.

infer_stmt_head(token(_,S),I):-
	atom_concat('<',TI,S),
	atom_concat(I,'>',TI),!.