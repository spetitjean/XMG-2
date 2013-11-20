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

:- edcg:using([xmg_brick_mg_accs:constraints, xmg_brick_mg_accs:name, xmg_brick_mg_accs:vars, xmg_brick_mg_accs:consts]).
%%:- edcg:weave([constraints,name,vars,consts], []).

xmg:unfold_stmt(control:and(E1,E2)):--
	xmg:unfold_stmt(E1),
	%%xmg_brick_mg_compiler:send(info,C1),
	xmg:unfold_stmt(E2),
	!.
xmg:unfold_stmt(control:or(E1,E2)):--
	xmg:unfold_stmt(E1) with (constraints([]-C1,[]-[])),
	xmg:unfold_stmt(E2) with (constraints([]-C2,[]-[])),
	constraints::enq(control:or([control:and(C1),control:and(C2)])),
	!.
xmg:unfold_stmt(control:stmt(E1,E2)):--
	%%xmg_brick_mg_compiler:send(info,E1),
 	xmg:unfold_stmt(E1),
 	xmg:unfold_stmt(E2), %% this is the interface
 	!.
xmg:unfold_stmt(control:dimStmt(Dim,E2)):--
	%%xmg_brick_mg_compiler:send(info,E2),
	xmg:unfold_dimstmt(Dim,E2), %% in brick_unfolder_syn pour Dim=syn
	!.
xmg:unfold_stmt(control:call(Class,Params)):--
	xmg:new_target_var(CT),
	xmg:unfold_exprs(Params, Params2),
	constraints::enq((CT,control:call(Class,Params2))),
	!.
xmg:unfold_stmt(none):-- !.

%%!!!DENYS: move to better place (core)
:- edcg:weave([constraints,name],[xmg:unfold_exprs/2]).
xmg:unfold_exprs([],[]) :-- !.
xmg:unfold_exprs([E|Es],[R|Rs]) :--
    xmg:unfold_expr(E,R),
    xmg:unfold_exprs(Es,Rs).

%% unfold('Stmts',[Stmt1,token(_,';'),Stmt2],conj(UStmt1,UStmt2)):- !,
%% 	unfold(Stmt1,UStmt1),
%% 	unfold(Stmt2,UStmt2).
%% unfold('Stmts',[Stmt1,token(_,'|'),Stmt2],disj(UStmt1,UStmt2)):- !,
%% 	unfold(Stmt1,UStmt1),
%% 	unfold(Stmt2,UStmt2).
%% unfold('Stmts',[Stmt],UStmt):- !,
%% 	unfold(Stmt,UStmt).
%% 
%% unfold('Stmt',[Stmt,IFace],stmt(UStmt,UIFace)):- !,
%% 	unfold(Stmt,UStmt),
%% 	unfold(IFace,UIFace).
%% 
%% unfold('MaybeIFace',[''],none):- !.
%% unfold('MaybeIFace',[token(_,'*='),IFace],UIFace):- 
%% 	unfold(IFace,UIFace),!.
%% 
%% unfold('IFace',[IFace],UIFace):-
%% 	unfold(IFace,UIFace),!.
%% 
%% unfold('AStmt',[token(_,'{'),Stmt,token(_,'}')],UStmt):- 
%% 	unfold(Stmt,UStmt),!.
%% unfold('AStmt',[token(_,'('),Stmt,token(_,')')],opt(UStmt)):- 
%% 	unfold(Stmt,UStmt),!.
%% unfold('AStmt',[Stmt],UStmt):-
%% 	unfold(Stmt,UStmt),!.
%% unfold('AStmt',[Left,token(_,'='),Right],eq(ULeft,URight,C)):-
%% 	unfold(Left,ULeft),
%% 	unfold(Right,URight).
%% 
%% unfold('EqPart',[token(C,id(ID))],id(ID,C)):-!.
%% unfold('EqPart',[Dot],UDot):-
%% 	unfold(Dot,UDot),!.
%% 
%% 
%% unfold('DimStmt',[Head,token(_,'{'),Stmt,token(_,'}')],HUStmt):-
%% 	infer_stmt_head(Head,Dim),
%% 	unfold(Stmt,UStmt),
%% 	HUStmt=..[dimStmt,Dim,UStmt],!.
%% 
%% 
%% unfold('Call',[token(_,id(Class)),token(_,'['),token(_,']')],class(Class,[])):- !.
%% unfold('Call',[token(_,id(Class)),token(_,'['),Params,token(_,']')],class(Class,UParams)):- 
%% 	unfold(Params,UParams),!.
%% 
%% unfold('Dot',[Var1,token(_,'.'),Var2],dot(UVar1,UVar2)):- 
%% 	unfold(Var1,UVar1),
%% 	unfold(Var2,UVar2),!.
%% 
%% unfold('ids_coma',[token(_,id(A))],[A]):- !.
%% unfold('ids_coma',[token(_,id(A)),token(_,','),Ids],[A|UIds]):-
%% 	unfold(Ids,UIds),!.
%% 
%% unfold('Var',[token(C,id(A))],id(A,C)):-!.
%% unfold('Var',[token(_,'?'),token(C,id(A))],id(A,C)):-!.
%% 
%% 
%% 
%% %% GENERIC RULES
%% 
%% unfold(Term,UTerm):-
%% 	Term=..[Head|Params],
%% 	head_module(Head,Module),
%% 	head_name(Head,Name),
%% 	(
%% 	    (
%% 		Module='control',
%% 		unfold(Name,Params,UTerm)
%% 	    )
%% 	;
%% 	(
%% 	    not(Module='control'),
%% 	    xmg_brick_mg_modules:get_module(Module,unfolder,UModule),
%% 	    UModule:unfold(Term,UTerm)
%% 	)
%%     ),!.
%% 
%% unfold(Rule,_):- 
%% 	throw(xmg(unfolder_error(no_unfolding_rule(control,Rule)))),	
%% 	!.
%% 
%% head_module(Head,Module):-
%% 	atomic_list_concat(A,'-',Head),
%% 	A=[Module|_],!.
%% 
%% head_name(Head,Name):-
%% 	atomic_list_concat(A,'-',Head),
%% 	A=[_,Name],!.
%% 
%% infer_stmt_head(token(_,S),I):-
%% 	atom_concat('<',TI,S),
%% 	atom_concat(I,'>',TI),!.
