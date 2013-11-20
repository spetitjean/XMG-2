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


:-module(xmg_brick_syn_generator).
:-use_module(xmg_brick_syn_engine).

:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:name).


:-edcg:weave([decls,name], [new_name/2,var_Stmt/3,var_or_const/2,generate_Stmt/5]).


xmg:generate_instr((TN,syn:node)):--
	code::enq(xmg_brick_syn_engine:inode(VN,TN)),
	Put=..[put,VN],
	Acc='syn',
	AccNode=..['::',xmg_brick_mg_generator:Acc,Put],
	code::enq(Put),
	!.
xmg:generate_instr((TN,syn:props(T1))):--
	!.
xmg:generate_instr((TN,syn:feats(T1))):--
	!.
xmg:generate_instr((syn:dom(N1,N2))):--
	!.









new_name(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),!.

generate_Stmt(Stmt,List,Class,VStmt,Acc):--
	var_Stmt(Stmt,VStmt,Acc).

var_Stmt(or(S1,S2),Or,Acc):--
	var_Stmt(S1,VS1,Acc),
	var_Stmt(S2,VS2,Acc),
	Or=..[';',VS1,VS2].
var_Stmt(and(S1,S2),And,Acc):--
	var_Stmt(S1,VS1,Acc),
	var_Stmt(S2,VS2,Acc),
	And=..[',',VS1,VS2].
var_Stmt(eq(Left,Right),Generated,Acc):--
	var_or_const(Left,GLeft),
	var_or_const(Right,GRight),
	Generated=..['=',GLeft,GRight],!.
var_Stmt(synnode(N,props(Props),feats(Feats),C),Generated,Acc):--
	var_or_const(N,VN),
	VNode=xmg_brick_syn_engine:inode(VN,N),

	xmg_brick_mg_compiler:send(info,Props),
	xmg_brick_mg_compiler:send_nl(info),

	xmg_brick_mg_compiler:send(info,Feats),
	
	xmg_brick_avm_generator:generate(avm,Feats,GFeats,FOut,C),
	xmg_brick_avm_generator:generate(avm,Props,GProps,POut,C),
	AVMFeats=xmg_brick_avm_avm:avm(AVMF,GFeats),
	AVMProps=xmg_brick_avm_avm:avm(AVMP,GProps),
	VFeats=xmg_brick_syn_engine:inodefeats(VN,AVMF),
	VProps=xmg_brick_syn_engine:inodeprops(VN,AVMP),
	Generated4=..[',',VNode,AVMProps],
	Generated3=..[',',Generated4,AVMFeats],
	Generated2=..[',',Generated3,VProps],
	Generated1=..[',',Generated2,VFeats],
	Put=..[put,VN],
	AccNode=..['::',xmg_brick_mg_generator:Acc,Put],
	add_out(Generated1,FOut,Generated0),
	%% + POut
	Generated=..[',',Generated0,AccNode].
var_Stmt(syndom(Dom,N1,N2,C),Generated,Acc):--
	var_or_const(N1,VN1),
	var_or_const(N2,VN2),
	VDom=dom(VN1,Dom,VN2,none),
	Add=..[put,VDom],
	Generated=..['::',xmg_brick_mg_generator:Acc,Add].
var_Stmt(synprec(Prec,N1,N2,C),Generated,Acc):--
	var_or_const(N1,VN1),
	var_or_const(N2,VN2),
	VPrec=prec(VN1,Prec,VN2),
	Add=..[put,VPrec],
	Generated=..['::',xmg_brick_mg_generator:Acc,Add].

var_or_const(A,B):--
	xmg_brick_mg_generator:var_or_const(A,B),!.



add_out(G,[],G):- !.
add_out(G,[O],AG):-
	AG=..[',',G,O],!.

add_out(G,[HO|TO],AG):- 
	add_out(G,TO,AG1),
	AG=..[',',HO,AG1],!.


	