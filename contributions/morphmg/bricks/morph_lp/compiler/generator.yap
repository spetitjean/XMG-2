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

:-module(xmg_generator_morph).

:-edcg:using(xmg_generator:decls).
:-edcg:using(xmg_generator:name).

:-edcg:weave([decls,name], [new_name/2,generate_Stmt/4,var_Stmt/3,var_or_const/2]).

new_name(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),!.

generate_Stmt(Stmt,List,Class,VarStmt):--
	var_Stmt(Stmt,VarStmt,Out),!.

var_Stmt(or(S1,S2),Or,[]):--
	var_Stmt(S1,VS1,_),
	var_Stmt(S2,VS2,_),
	Or=..[';',VS1,VS2].
var_Stmt(and(S1,S2),And,[]):--
	var_Stmt(S1,VS1,_),
	var_Stmt(S2,VS2,_),
	And=..[',',VS1,VS2].

var_Stmt(morpheme(Stem), Gen, []):--
	var_or_const(Stem,VStem),
	put_in_morph(morpheme(VStem),Gen),!.

var_Stmt(eq(S1,adisj(S2)),Eq,[ADP]):--
	var_or_const(S1,feat(CV1)),
	xmg_generator_avm:generate(adisj,S2,TAD),		
	ADP=xmg_adisj:adisj(ADisj,TAD),
	Eq=..['=',CV1,ADisj]	.

var_Stmt(eq(S1,S2),Eq,[]):--
	var_or_const(S1,G1),
	var_or_const(S2,G2),
	Eq=..['=',G1,G2].
var_Stmt(eq(S1,S2),Eq,[]):--
	var_or_const(S1,G1),
	var_or_const(S2,G2),
	Eq=..['==',G1,G2].




var_Stmt(eq(S1,S2),Eq,[]):--
	var_or_const(S1,CV1),
	var_or_const(S2,G2),
	check_type(S1,T,CV2),
	Eq=..['=',CV1,CV2].
var_Stmt(eq(S1,S2),Eq,[]):--
	var_or_const(S1,CV1),
	var_or_const(S2,CV2),
	Eq=..['==',CV1,CV2].

var_Stmt(precmorph(S1,S2,Prec),Gen,[]):--
	var_or_const(S1,VS1),
	var_or_const(S2,VS2),
	put_in_morph(prec(VS1,VS2,Prec),Gen),!.


var_Stmt(inmorph(S1,S2),Eq,[]):--
	var_or_const(S1,CV1),
	var_or_const(S2,CV2),!,
	Eq=..['=',CV1,CV2].

var_Stmt(Unknown,_,_):-- !,
	xmg_compiler:send(info,'unknown instruction to generate '),
	xmg_compiler:send(info,Unknown),
	false.


put_in_morph(Put,Gen):-
	PPut=..[put,Put],
	Gen=..['::',xmg_generator:morph,PPut],!.



%%var_Stmt(A,A).

var_or_const(A,B):--
	xmg_generator:var_or_const(A,B),!.


%% should be in another file
check_type(string,string,Value):- !.
check_type(string,_,Value):-
	xmg_compiler:send(info,'Warning : '),xmg_compiler:send(info,Value),xmg_compiler:send(info,' is not of type string '),!.
check_type(Feat,Type,Value):-
	Feat=id(A,C),
	xmg_typer:feat(A,Type),!.
check_type(Feat,int,Value):-
	Feat=id(A,C),
	xmg_typer:type(A,Range),
	lists:member(Value,Range),!.
check_type(Feat,bool,Value):-
	Feat=id(A,C),
	xmg_typer:type(A,bool),
	lists:member(Value,['+','-']),!.
check_type(Feat,Type,Value):-
	Feat=id(A,C),
	xmg_compiler:send(info,'Warning : '),xmg_compiler:send(info,A),xmg_compiler:send(info,' and '),xmg_compiler:send(info,Value),xmg_compiler:send(info,' do not share the same type, at '),xmg_compiler:send(info,C),xmg_compiler:send_nl(info),xmg_compiler:send_nl(info).

add_out(G,[],G):- !.
add_out(G,[O],AG):-
	AG=..[',',G,O],!.

add_out(G,[HO|TO],AG):- 
	add_out(G,TO,AG1),
	AG=..[',',HO,AG1],!.