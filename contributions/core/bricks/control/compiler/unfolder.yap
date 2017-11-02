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

:- xmg:edcg.


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
xmg:unfold_stmt(control:opt(E1)):--
	xmg:unfold_stmt(E1) with (constraints([]-C1,[]-[])),
	constraints::enq(control:or([control:and(C1),control:opt_true])),
	!.

xmg:unfold_dimstmt(Dim,control:and(S1,S2)):-- 
	%% xmg_brick_mg_compiler:send(info,'\n\nunfolding:\n'),
	%% xmg_brick_mg_compiler:send(info,S1),
	xmg:unfold_dimstmt(Dim,S1) ,
	%% xmg:send(info,'\nDone'),
	xmg:unfold_dimstmt(Dim,S2) ,
	!.
xmg:unfold_dimstmt(Dim,control:or(S1,S2)):-- 
	xmg:unfold_dimstmt(Dim,S1) with (constraints([]-C1,[]-[])),
	xmg:unfold_dimstmt(Dim,S2) with (constraints([]-C2,[]-[])),
	constraints::enq(control:or([control:and(C1),control:and(C2)])),
	!.
xmg:unfold_dimstmt(Dim,control:opt(S1)):-- 
	xmg:unfold_dimstmt(Dim,S1) with (constraints([]-C1,[]-[])),
	constraints::enq(control:or([control:and(C1),control:opt_true])),
	!.


xmg:unfold_stmt(control:dimStmt(Dim,E2)):--
	%%xmg_brick_mg_compiler:send(info,E2),
	xmg:unfold_dimstmt(Dim,E2), %% in brick_unfolder_syn pour Dim=syn
	!.
xmg:unfold_stmt(control:eq(E1,E2)):--
	xmg:unfold_expr(E1,V1),
	xmg:unfold_expr(E2,V2),
	(
	    var(V2)->
	        xmg:new_target_var(V2)
	    ;
	        true
	),
	constraints::enq(eq(V1,V2)),
	!.
xmg:unfold_stmt(control:call(token(_,id(Class)),Params)):--
	xmg:new_target_var(Target),
	xmg:unfold_exprs(Params, P),
	constraints::enq((Target,control:call(Class,P))),
	!.

xmg:unfold_dimstmt(_,control:eq(E1,E2)):--
	xmg:unfold_expr(E1,V1),
	xmg:unfold_expr(E2,V2),
	(
	    var(V2)->
	        xmg:new_target_var(V2)
	    ;
	        true
	),
	constraints::enq(eq(V1,V2)),
	!.
xmg:unfold_dimstmt(_,control:call(token(_,id(Class)),Params)):--
	xmg:new_target_var(Target),
	xmg:unfold_exprs(Params, P),
	constraints::enq((Target,control:call(Class,P))),
	!.

xmg:unfold_stmt(none):-- !.

xmg:unfold_expr(control:call(token(_,id(Class)),Params),Target):--
	xmg:new_target_var(Target),
	%%xmg:unfold_expr(Class,CT),
	xmg:unfold_exprs(Params, P),
	constraints::enq((Target,control:call(Class,P))),
	!.

%% xmg:unfold_expr(control:dot(Var1,Var2),Target):--
%% 	xmg:new_target_var(Target),	
%% 	xmg:unfold_expr(Var1,T1),
%% 	xmg:unfold_expr(Var2,T2),
%% 	constraints::enq((Target,control:dot(T1,T2))),
%% 	!.

%%xmg:unfold_expr(var(token(C,id(ID))),id(ID,C)):-- !.
