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

:- dynamic(xmg:sem_semantics/1).
:- dynamic(xmg:sem_extern/1).

:- xmg:edcg.

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).


xmg:unfold_dimstmt(Sem,sem:pred(Label,Pred,Params)):--
	xmg:unfold_expr(Label,ULabel),	    
	xmg:unfold_expr(Pred,UPred),
	xmg:unfold_exprs(Params,UParams),
	(
	    var(ULabel) 
	->
	    ULabel=none
        ;
	    true
	),
	constraints::enq((sem:pred(ULabel,UPred,UParams),Sem)),!.

xmg:unfold_dimstmt(Sem,sem:scopeOver(S1,S2)):--
	xmg:unfold_expr(S1,U1),	    
        xmg:unfold_expr(S2,U2),
	constraints::enq((sem:scopeOver(U1,U2),Sem)),!.

xmg:unfold(sem:semantics(IDs),none):--
	  xmg:send(info,IDs),
	  unfold_ids(IDs,UIDs),
          asserta(xmg:sem_semantics(UIDs)),!.
	  

unfold_ids([],[]).
unfold_ids([ID|T],[UID|T1]):-
    unfold_id(ID,UID),
    unfold_ids(T,T1),!.

unfold_id(token(_,id(ID)),ID).

xmg:unfold(sem:extern(IDs),none):--
	  unfold_externs(IDs),
	  !.

unfold_externs([]).
unfold_externs([E|T]):-
    unfold_id(E,UE),
    asserta(xmg:sem_extern(UE)),
    unfold_externs(T).
