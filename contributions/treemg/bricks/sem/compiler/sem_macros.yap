%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2016  Simon Petitjean

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

:- module(xmg_brick_sem_macros).
:- xmg:edcg.

:- edcg:using([xmg_brick_mg_accs:name]).

:- edcg:weave([name],[new_name/2, write_macro_externs/2, write_macro_iface/2, write_macro_sem/2, write_sem/2, write_pred/2, write_args/2, write_arg/2, write_id/2]).

new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).


xmg:print_appendix:-
    xmg:more_mode,
    init_macros,!.

xmg:print_appendix:-
    not(xmg:more_mode),!.

init_macros:-
	xmg:sem_semantics(Sems),!,
	xmg:send(info,'init macros\n'),
	open('.more',write,S,[alias(macros)]),
	xmg:send(info,Sems),
	do_macros(Sems),
	close(macros),!.

init_macros:-
	not(xmg:sem_semantics(_)),!.

do_macros([]):- !.
do_macros([H|T]):-
	do_macro(H),!,
	do_macros(T),!.	

do_macro(Class):-
	xmg:send(info,' macro for '),
	xmg:send(info,Class),

	%% xmg_acc:acc(Sem,[]),
	%% xmg_acc:acc(Trace,[]),
	%% xmg_acc:acc(Mutex,[]),
	%% xmg_avm:avm(IFace,[]),

	%% I think the idea is to call the class here, and get the sem accumulation and the interface
	%% SemClass=..[CClass,_,_,_,Sem,IFace,Trace,Mutex,0],
	%% SemCall=..[':',xmg_generator,SemClass],

	%% SemCall,
	%% xmg_acc:acc(Sem,AccSem),
	%% xmg_avm:avm(IFace,AIFace),

	try_value(Class,Value),

	xmg:send(info,'Executed'),
	xmg_brick_mg_compiler:get_dim(sem,Value,AccSem),
	xmg_brick_mg_compiler:get_dim(iface,Value,AIFace),

	xmg:send(info,'\nWriting Macros'),
	xmg_brick_avm_avm:avm(AIFace,List),

	write_macro(Class,AccSem,List),!.

try_value(Class,Value):-
	xmg:start_value_class(Class,Value),!.
try_value(Class,_):-
	xmg:send(info,'\n\nError in semantics: '),
	xmg:send(info,Class),
	xmg:send(info,' is not a class.\n').


write_macro(Class,Sem,IFace):--
	write_macro_externs(IFace,Ext) with name(0,Name1),
	xmg:send(info,Ext),
	xmg:send(info,'\nWriting macro sem\n'),
	write_macro_sem(Sem,Sem1) with name(Name1,Name2),
	xmg:send(info,Sem1),
	xmg:send(info,'\nWriting macro iface'),
	xmg:send(info,IFace),
	write_macro_iface(IFace,IFace1) with name(Name2,_),
	xmg:send(info,IFace1),
	xmg:send(info,'\n\n'),!,
	print_macro(Class,Ext,Sem1,IFace1),
	!.

write_macro_externs(IFace,EIFace1):--
	xmg:send(info,'\nGetting externs in '),
	xmg:send(info,IFace),
	get_externs(IFace,EIFace),
	write_macro_iface(EIFace,EIFace1),!.

get_externs([],[]):- !.
get_externs([H-H1|T],[H-H1|T1]):-
	xmg:sem_extern(H),
	get_externs(T,T1),!.
get_externs([H-H1|T],T1):-
	not(xmg:sem_extern(H)),
	get_externs(T,T1),!.


write_macro_sem(Sem,Sem2):--
	write_sem(Sem,Sem1),
	atom_concat(['[',Sem1,']'],Sem2),
	!.

%% write_macro_iface(IFace):--
%% 	xmg_compiler:send(IFace,must),!.

write_macro_iface([],[]):-- !.

write_macro_iface([A-value(V,P)|T],[AV|T1]):--
	atom(V),
	atom_chars(V,['?'|_]),
	write_macro_iface(T,T1),
	%%AV=..['=',A,V],
	make_couple(A,V,AV),
	!.

write_macro_iface([A-value(V,P)|T],[AV|T1]):--
	(
	(
	    atom(V),!, Val=V,
	    write_macro_iface(T,T1)
	) 
    ;
	(
	    V=string(String),
	    not(var(String)),!,
	    atom_codes(Val,String),
	    write_macro_iface(T,T1)
	)
    ;
	(
	    V=int(Val), not(var(Val)), !,
	    write_macro_iface(T,T1)
	)  
    ;
	(
	    V=bool(Val), not(var(Val)), !,
	    write_macro_iface(T,T1)
	)
    ),
	%%AV=['=',A,Val],
	make_couple(A,Val,AV),
	!.

write_macro_iface([A-value(AVM,P)|T],T1):--
	xmg_brick_avm_avm:avm(AVM,LAVM),
	write_macro_iface(T,T1),!.


write_macro_iface([A-value(V,P)|T],[AV|T1]):--
	var(V),
	new_name('?V',V),
	%%AV=..['=',A,V],
	make_couple(A,V,AV),
	write_macro_iface(T,T1),!.

%% this should not happen
write_macro_iface([A-B|T],[AV|T1]):--
	write_macro_iface([A-value(B,P)|T],[AV|T1]),!.

write_sem([],''):-- !.

write_sem([H|T],T2):--
	write_pred(H,H1),
	write_sem(T,T1),
	atom_concat([H1,' ',T1],T2),
	!.

write_pred(LP,NewLP):--
	LP=..[':',L,P],
	P=..['@',Pred,Args],
	write_id(Pred,XPred),
	write_id(L,XL),
	write_args(Args,Args1),
	%%NewP=..[XPred|Args1],
	%%NewLP=..[':',XL,NewP],
	atom_concat([XPred,'(',Args1,')'],NewP),
	atom_concat([XL,':',NewP],NewLP),
	!.

write_pred(P,NewP):--
	P=..['@',Pred,Args],
	write_id(Pred,XPred),
	write_args(Args,Args1),
	%%NewP=..[XPred|Args1],
	atom_concat([XPred,'(',Args1,')'],NewP),!.

write_args([],''):--!.

write_args([Arg],Arg1):--
	write_arg(Arg,Arg1),!.

write_args([H|T],T2):--
	write_arg(H,H1),
	write_args(T,T1),
	atom_concat([H1,',',T1],T2),!.

write_arg(A,A):--
	var(A),
	new_name('?V',A), !.

write_arg(A,A):-- !.

write_id(value(ID,_),ID):--
	var(ID),
	new_name('?V',ID),!.
write_id(value(ID,_),ID):--
	xmg:send(info,ID),!.
	
write_id(ID,ID):--
	var(ID),
	new_name('?V',ID),!.
write_id(ID,ID):--
	xmg:send(info,ID),!.

make_couple(A,V,AV):-
	%%AV=..['=',A,V],!.
	atom_concat([A,'=',V],AV),
	!.
	
print_macro(Class,Ext,Sem,IFace):-
	write(macros,Class),
	write(macros,Ext),
	write(macros,'\n'),
	write(macros,'         semantics:'),
	write(macros,Sem),
	write(macros,'\n'),
	write(macros,'         interface:'),
	write(macros,IFace),	
	write(macros,'\n'),
	write(macros,'\n'),
	!.
