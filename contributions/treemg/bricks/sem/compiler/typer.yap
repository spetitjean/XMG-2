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

:-module(xmg_brick_sem_typer).

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_typer:types]).


xmg:stmt_type(sem,Dim,sem):-!.


xmg:type_stmt(sem:pred(L,P,Args),S):--
	     xmg:type_expr(L,TL),
             xmg:type_expr(P,TP),
	     xmg:type_expr(sem:args(Args),TArgs),
	     !.

xmg:type_stmt(sem:scopeOver(_,_),S):--
	     !.

xmg:type_expr(sem:args([]),[]):--!.
xmg:type_expr(sem:args([H|T]),[H1|T1]):--
	 xmg:type_expr(H,H1),
         xmg:type_expr(sem:args(T),T1),!.


xmg:type_stmt(sem:A,_):--
	 xmg:send(info,'\n\nType error in sem statement:\n'),
         xmg:send(info,A),
	 halt,
	!.


