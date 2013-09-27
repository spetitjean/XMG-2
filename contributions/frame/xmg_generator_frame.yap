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


:-module(xmg_generator_frame).
:-use_module(xmg_engine_frame).

:-edcg:using(xmg_generator:decls).
:-edcg:using(xmg_generator:name).


:-edcg:weave([decls,name], [new_name/2,var_Stmt/2,var_or_const/2,generate_Stmt/4]).

new_name(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),!.

generate_Stmt(Stmt,List,Class,VStmt):--
	%%xmg_compiler:send(info,Stmt),
	var_Stmt(Stmt,VStmt).

var_Stmt(or(S1,S2),Or):--
	var_Stmt(S1,VS1),
	var_Stmt(S2,VS2),
	Or=..[';',VS1,VS2].
var_Stmt(and(S1,S2),And):--
	var_Stmt(S1,VS1),
	var_Stmt(S2,VS2),
	And=..[',',VS1,VS2].
var_Stmt(framenode(N,props(Props),feats(Feats),C),Generated):--
	var_or_const(N,VN),
	VNode=xmg_engine_frame:inode(VN,N),
	xmg_generator_avm:generate(h_avm,Feats,GFeats,FOut,C),
	xmg_generator_avm:generate(h_avm,Props,GProps,POut,C),
	AVMFeats=xmg_h_avm:h_avm(AVMF,GFeats),
	AVMProps=xmg_h_avm:h_avm(AVMP,GProps),
	VFeats=xmg_engine_frame:inodefeats(VN,AVMF),
	VProps=xmg_engine_frame:inodeprops(VN,AVMP),
	Generated4=..[',',VNode,AVMProps],
	Generated3=..[',',Generated4,AVMFeats],
	Generated2=..[',',Generated3,VProps],
	Generated1=..[',',Generated2,VFeats],
	Put=..[put,VN],
	AccNode=..['::',xmg_generator:frame,Put],
	add_out(Generated1,FOut,Generated0),
	%% + POut
	Generated=..[',',Generated0,AccNode].
var_Stmt(edge(N1,N2,Prop,C),Generated):--
	not(var(N1)),
	not(var(N2)),
	var_or_const(N1,VN1),
	var_or_const(N2,VN2),
	VDom=edge(VN1,VN2,Prop),
	Add=..[put,VDom],
	Generated=..['::',xmg_generator:frame,Add].

var_or_const(A,B):--
	xmg_generator:var_or_const(A,B),!.





add_out(G,[],G):- !.
add_out(G,[O],AG):-
	AG=..[',',G,O],!.

add_out(G,[HO|TO],AG):- 
	add_out(G,TO,AG1),
	AG=..[',',HO,AG1],!.


check_type(Att,const(Value,Type),C):-
	xmg_typer:feat(Att,Type).
check_type(Att,const(Value,Type),C):-
	xmg_typer:property(Att,Type).
check_type(Att,Value,C):-
	xmg_compiler:send(info,'Warning : '),xmg_compiler:send(info,Att),xmg_compiler:send(info,' and '),xmg_compiler:send(info,Value),xmg_compiler:send(info,' do not share the same type, at '),xmg_compiler:send(info,C),xmg_compiler:send_nl(info),xmg_compiler:send_nl(info).


	