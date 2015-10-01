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

:- xmg:edcg.


:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:name).
:-edcg:using(xmg_brick_mg_generator:code).

:-edcg:weave(decls,generate_params/2).

xmg:generate_instr((sem:pred(none,v(P),Args),Sem)):--
	decls::tget(P,VP),
	generate_params(Args,GArgs),
	APred=..['@',VP,GArgs],
	Generated=..['::',xmg_acc:Sem,put(APred)],
	code::enq(Generated),!.

xmg:generate_instr((sem:pred(none,c(P),Args),Sem)):--
	generate_params(Args,GArgs),
	APred=..['@',c(P),GArgs],
	Generated=..['::',xmg_acc:Sem,put(APred)],
	code::enq(Generated),!.

xmg:generate_instr((sem:pred(v(L),v(P),Args),Sem)):--
	decls::tget(L,VL),
	decls::tget(P,VP),
	generate_params(Args,GArgs),
	APred=..['@',VP,GArgs],
	BPred=..[':',VL,APred],
	Generated=..['::',xmg_acc:Sem,put(BPred)],
	code::enq(Generated),!.

xmg:generate_instr((sem:pred(v(L),c(P),Args),Sem)):--
	decls::tget(L,VL),
	generate_params(Args,GArgs),
	APred=..['@',c(P),GArgs],
	BPred=..[':',VL,APred],
	Generated=..['::',xmg_acc:Sem,put(BPred)],
	code::enq(Generated),!.


%% var_Stmt(pred(none,Pred,Params),Generated):--
%% 	%%Pred=id(CPred,_),
%% 	var_or_const(Pred,CPred),
%% 	generate_params(Params,GParams),
%% 	APred=..['@',CPred,GParams],
%% 	Generated=..['::',xmg_brick_mg_generator:sem,put(APred)],
%% 	!.
%% var_Stmt(pred(L,Pred,Params),Generated):--
%% 	var_or_const(L,VL),
%% 	%%Pred=id(CPred,_),
%% 	var_or_const(Pred,CPred),
%% 	generate_params(Params,GParams),
%% 	APred=..['@',CPred,GParams],
%% 	ALPred=..[':',VL,APred],
%% 	Generated=..['::',xmg_brick_mg_generator:sem,put(ALPred)],

%% 	!.

generate_params([],[]):-- !.
generate_params([v(V)|T],[GV|T1]):--
	decls::tget(V,GV),
	generate_params(T,T1),!.
generate_params([c(C)|T],[C|T1]):--
	generate_params(T,T1),!.

