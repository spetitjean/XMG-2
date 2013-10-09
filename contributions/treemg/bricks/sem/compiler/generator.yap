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


:-module(xmg_brick_sem_generator).

:-edcg:using(xmg_generator:decls).
:-edcg:using(xmg_generator:name).

:-edcg:weave([decls,name], [var_Stmt/2,var_or_const/2,generate_Stmt/4,generate_params/2]).

generate_Stmt(Stmt,List,Class,VStmt):--
	%%xmg_compiler:send(info,Stmt),
	var_Stmt(Stmt,VStmt).
	%%xmg_compiler:send(info,VStmt)

var_Stmt(or(S1,S2),Or):--
	var_Stmt(S1,VS1),
	var_Stmt(S2,VS2),
	Or=..[';',VS1,VS2].
var_Stmt(and(S1,S2),And):--
	var_Stmt(S1,VS1),
	var_Stmt(S2,VS2),
	And=..[',',VS1,VS2].
var_Stmt(pred(none,Pred,Params),Generated):--
	%%Pred=id(CPred,_),
	var_or_const(Pred,CPred),
	generate_params(Params,GParams),
	APred=..['@',CPred,GParams],
	Generated=..['::',xmg_generator:sem,put(APred)],
	!.
var_Stmt(pred(L,Pred,Params),Generated):--
	var_or_const(L,VL),
	%%Pred=id(CPred,_),
	var_or_const(Pred,CPred),
	generate_params(Params,GParams),
	APred=..['@',CPred,GParams],
	ALPred=..[':',VL,APred],
	Generated=..['::',xmg_generator:sem,put(ALPred)],

	!.

generate_params([],[]):-- !.
generate_params([P|T],[GP|T1]):--
	var_or_const(P,GP),
	generate_params(T,T1),!.

var_or_const(id(A,C),Var):--
	%%xmg_compiler:send(info,List),
	%%lists:member(id(A,_)-Var,List),!.
	decls::tget(A,Var),!.
var_or_const(id(A,C),const(A,T)):--
	xmg_typer:type(T,TD),
	lists:member(id(A,_),TD),!.
var_or_const(id(A,C),const(A,_)):--
	xmg_compiler:send(info,'Warning in sem : '),xmg_compiler:send(info,A),xmg_compiler:send(info,' was not declared '),xmg_compiler:send(info,C),xmg_compiler:send_nl(info).
var_or_const(string(A,C),const(A,string)):-- !.
var_or_const(const(A,C),const(NA,_)):-- 
	!.


