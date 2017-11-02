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

:-module(xmg_brick_value_unfolder).

:- xmg:edcg.


:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).
:- edcg:weave([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts],unfold_disj/3).

	

xmg:unfold_expr(token(_,int(Int)),c(Int)):--
	!.
xmg:unfold_expr(token(_,bool(Bool)),c(Bool)):--
	       !.
xmg:unfold_expr(token(_,string(String)),c(string(String))):--
	!.
xmg:unfold_expr(value:var(token(_,id(ID))),v(ID)):--
	       vars::tget(ID,_),!.
xmg:unfold_expr(value:var(token(C,id(ID))),v(ID)):--
	xmg:send(info,'\n\nVariable was not declared: '),
        xmg:send(info,ID),
	xmg:send(info,' at '),
	xmg:send(info,C),
	halt,!.

xmg:unfold_expr(value:const(token(_,id(ID))),c(ID)):--
	       consts::tget(ID,_),!.
xmg:unfold_expr(value:const(token(_,id(ID))),c(ID)):--
	       vars::tget(ID,sconst(_)),!.
xmg:unfold_expr(value:const(token(C,id(ID))),c(ID)):--
	xmg:send(info,'\n\nVariable or constant was not declared: '),
        xmg:send(info,ID),
	xmg:send(info,' at '),
	xmg:send(info,C),
	halt,!.


xmg:unfold_expr(token(_,id(ID)),v(ID)):--
	       vars::tget(ID,_),!.
xmg:unfold_expr(token(_,id(ID)),c(ID)):--
               !.


xmg:unfold_expr(value:disj(Values),Var):--
	xmg:new_target_var(Disj),
        unfold_disj(Values,UValues,Disj),
	constraints::enq(UValues),
	constraints::enq(eq(Disj,Var)),
        !.



unfold_disj([Value],eq(Var,UValue),Var):--	   
	   xmg:unfold_expr(Value,UValue),
!.

unfold_disj([Value|Values],control:or([eq(Var,UValue),UValues]),Var):--	   
	   xmg:unfold_expr(Value,UValue),
           unfold_disj(Values,UValues,Var),
           !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% unfolding an intersection of cavm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmg:unfold_expr(value:inter(E1,E2),Var):--
	   xmg:unfold_expr(E1,U1),
           xmg:unfold_expr(E2,U2),
	   constraints::enq((Var,value:inter(U1,U2))),
	   !.

