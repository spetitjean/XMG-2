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

:-module(xmg_brick_control_generator).

:-edcg:using(xmg_brick_mg_generator:name).
:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:code).

:-edcg:weave([decls,name], [put_in_table/1, generate_Stmts/4, generate_Stmt/4, generate_iface/4, generate_EqPart/4, generate_dimStmt/4]).


xmg:generate_instr(control:or([I1,I2])):--
	xmg:generate_instr(I1) with code([]-C1,[]-[]),
	xmg:generate_instr(I2) with code([]-C2,[]-[]),
	code::enq(or(C1,C2)),
	!.
xmg:generate_instr(control:and(I)):--
	xmg:generate_instrs(I),
	!.

xmg:generate_instr(indim(Dim,Acc)):--
	code::enq(xmg_acc:Dim::enq(Acc)),!.

xmg:generate_instr((Var,control:call(Class,Params))):--
	Call=..[Class,Params,_,_],
	Instr=..['=',Var,Call],
	code::enq(Instr),!.











generate(Stmt,List,Class,Generated):--
	%xmg_table:table_new(TableIn),
	%put_in_table(List) with (decls(TableIn,TableOut),name(_,_)),
	
	%%xmg_compiler:send(debug,Stmt),
	generate_Stmts(Stmt,List,Class,Generated),% with (decls(TableOut,_),name(0,_)),
	%%xmg_compiler:send(debug,Generated),
	!.

generate_Stmts([],L,C,[]):-- !.
generate_Stmts([H|T],L,C,[H1|T1]):--
	generate_Stmt(H,L,C,H1),
	generate_Stmts(T,L,C,T1),!.

generate_dimStmt(dimStmt(morph,Stmt),List,Class,Generated):--
	%%use_module('xmg_generator_morph'),
	xmg_brick_morph_generator:generate_Stmt(Stmt,List,Class,Generated).
generate_dimStmt(dimStmt(syn,Stmt),List,Class,Generated):--
	%%use_module('xmg_generator_syn'),
	%% to do: automatically load the right generate_Stmt (from what is before Stmt)
	xmg_brick_mg_compiler:send(info,Stmt),
	xmg_brick_syn_generator:generate_Stmt(Stmt,List,Class,Generated,'syn').
generate_dimStmt(dimStmt(syn1,Stmt),List,Class,Generated):--
	xmg_brick_mg_compiler:send(info,Stmt),
	xmg_brick_syn_generator:generate_Stmt(Stmt,List,Class,Generated,'syn1').
generate_dimStmt(dimStmt(syn2,Stmt),List,Class,Generated):--
	xmg_brick_mg_compiler:send(info,Stmt),
	xmg_brick_syn_generator:generate_Stmt(Stmt,List,Class,Generated,'syn2').
generate_dimStmt(dimStmt(pg,Stmt),List,Class,Generated):--
	%%use_module('xmg_generator_pg'),
	xmg_brick_pg_generator:generate_Stmt(Stmt,List,Class,Generated).
generate_dimStmt(dimStmt(sem,Stmt),List,Class,Generated):--
	%%use_module('xmg_generator_sem'),
	xmg_brick_sem_generator:generate_Stmt(Stmt,List,Class,Generated).
generate_dimStmt(dimStmt(frame,Stmt),List,Class,Generated):--
	%%xmg_compiler:send(debug,Stmt),
	xmg_brick_frame_generator:generate_Stmt(Stmt,List,Class,Generated).

%% generate_dimStmt(Stmt,_,_,_):--
%% 	xmg_brick_mg_compiler:send(info,' unable to generate code for: \n'),
%% 	xmg_brick_mg_compiler:send(info,Stmt),
%% 	xmg_brick_mg_compiler:send(info,'\n\n'),
%% 	false,!.

generate_Stmt(none,_,_,true):-- !.
generate_Stmt(opt(Stmt),List,Class,Gen):-- 
	generate_Stmts(disj(Stmt,empty),List,Class,Gen),
	!.
generate_Stmt(and(Stmt1,Stmt2),List,Class,Conj):--
	generate_Stmts(Stmt1,List,Class,DS1),
	generate_Stmts(Stmt2,List,Class,DS2),
	Conj=..[',',DS1,DS2].
generate_Stmt(or(Stmt1,Stmt2),List,Class,Disj):--
	generate_Stmts(Stmt1,List,Class,DS1),
	generate_Stmts(Stmt2,List,Class,DS2),
	Disj=..[';',DS1,DS2].
generate_Stmt(class(Call,Params),List,Class,Gen):--
	%%current_predicate(Call/N),
	get_params(Params,List,GParams,Eqs),
	ClassCall=..[Call,params(GParams),IDVar],
	Calls=xmg_brick_mg_generator:ClassCall,
	%%add_eqs(Eqs,CEqs),
	%%Calls=..[',',xmg_generator:ClassCall,CEqs],
	%%write(Calls),

	%% add Call to Trace
	%%Put=..[put,Call],
	%%Trace=..['::',xmg_generator:trace,Put],
	Gen=Calls,

	!.

generate_Stmt(eq(Left,Right,C),List,Class,NewEq):--
	generate_EqPart(Left,List,Class,part(Out1,V1)),
	generate_EqPart(Right,List,Class,part(Out2,V2)),

	%% + add Out1 and Out2
	Eq=..['=',V1,V2],
	lists:append(Out1,Out2,Out),
	add_out(Eq,Out,NewEq),
	%%xmg_compiler:send(info,NewEq),
	!.

generate_Stmt((Left,Right),List,Class,some_eq):--
	!.

generate_Stmt(Stmt,List,Class,Generated):--
	generate_dimStmt(Stmt,List,Class,Generated).

generate_Stmt(stmt(Stmt,IFace),List,Class,FGenerated):--
	generate_Stmts(Stmt,List,Class,Generated),
	generate_iface(IFace,List,Class,IGenerated),
	add_out(Generated,IGenerated,FGenerated),!.

generate_Stmt(Stmt,_,_,_):--
	xmg_brick_mg_compiler:send(info,' unable to generate code for: \n'),
	xmg_brick_mg_compiler:send(info,Stmt),
	xmg_brick_mg_compiler:send(info,'\n\n'),
	false,!.

%% generate_EqPart(id(ID,C),List,Class,part([],IDVar)):-- 
%% 	decls::tget(ID,IDVar),

%% 	%%lists:member(id(ID,_)-IDVar,List),
%% 	%%xmg_generator:var_or_const(id(ID,C),var(IDVar)),
%% 	!.
generate_EqPart(id(ID,C),List,Class,part([],Const)):--
	xmg_brick_mg_generator:var_or_const(id(ID,C),Const),
	!.

generate_EqPart(dot(D1,D2),List,Class,part([xmg_brick_control_generator:Dot],Var)):--
	Dot=..['dot',List,D1,D2,Var],
	!.
generate_EqPart(class(Call,Params),List,Class,part([xmg_brick_mg_generator:ClassCall],Var)):--
	get_params(Params,List,GParams,Eqs),
	ClassCall=..[Call,params(GParams),Var],
	!.




generate_iface(none,List,Class,[]):-- !.
generate_iface(avm(IFace),List,Class,[AVMFeats,UIFace]):--
	xmg_brick_avm_generator:generate(avm,IFace,GFeats,FOut,C),

	AVMFeats=xmg_brick_avm_avm:avm(AVMF,GFeats),
	UIFace=..['::',xmg_brick_mg_generator:iface,top(AVMF)],
	
	%%Generated=iface::top(AVM),
	%% Or just: iface::top(AVM)
	!.

get_params([],_,[],[]):- !.
get_params([ID|T],List,[Var|T1],Eqs):-
	lists:member(id(ID,_)-Var,List),
	get_params(T,List,T1,Eqs),!.
get_params([ID|T],List,[A|T1],[eq(A,ID)|T2]):-
	get_params(T,List,T1,T2),!.

add_eqs([],true):- !.
add_eqs([eq(A,B)|T],Calls1):-
	Eq=..['=',A,B],
	add_eqs(T,EqT),
	Calls1=..[',',Eq,EqT],!.

dot(List,id(ID,C),id(Key,C1),Var):-
	lists:member(id(ID,_)-exports(IDList),List),
	lists:member(Key-Var,IDList),!.
dot(List,id(ID,C),Key,Var):-
	lists:member(id(ID,_)-exports(IDList),List),!,
	xmg_brick_mg_compiler:send(info,Var),
	throw(xmg(generator_error(cannot_find(Key,in(ID),try(IDList))))),!.
dot(List,ID,Key,Var):-
	throw(xmg(generator_error(cannot_find(ID)))),!.

put_in_table([]):-- !.
put_in_table([id(A,_)-B|T]):--
	decls::tput(A,B),
	put_in_table(T),!.

add_out(G,[],G):- !.
add_out(G,[O],AG):-
	AG=..[',',O,G],!.

add_out(G,[HO|TO],AG):- 
	add_out(G,TO,AG1),
	AG=..[',',HO,AG1],!.