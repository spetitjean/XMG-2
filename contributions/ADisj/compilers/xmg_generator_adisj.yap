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


:-module(xmg_generator_adisj).

:-edcg:using(xmg_generator:decls).
:-edcg:using(xmg_generator:name).

:-edcg:weave([decls,name], [new_name/2,var_or_const/3,generate/6]).

new_name(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),!.

generate(adisj,[],[]):- !.
generate(adisj,[id(ID,_)|AD],[ID|AD1]):-
	generate(adisj,AD,AD1),!.
generate(adisj,[bool(ID,_)|AD],[ID|AD1]):-
	generate(adisj,AD,AD1),!.
generate(adisj,[int(ID,_)|AD],[ID|AD1]):-
	generate(adisj,AD,AD1),!.
generate(adisj,[H|AD],[H|AD1]):-
	xmg_compiler:send(info,H),
	generate(adisj,AD,AD1),!.


var_or_const(Var,Class,var(NVar)):--
	var(Var),!,
	new_name(Name,'xmgnode'),
	Var=id(Name,no_coord),
	decls::tput(Name,NVar),!.

var_or_const(id(A,C),Class,var(Var)):--
	%%xmg_compiler:send(info,List),
	decls::tget(A,Var),!.
var_or_const(id(A,C),_,var(A)):--
	xmg_typer:feat(A,_),!.
var_or_const(id(A,C),_,var(A)):--
	xmg_typer:property(A,_),!.
var_or_const(id(A,C),_,var(A)):--
	xmg_typer:field(A,_),!.
var_or_const(id(A,C),_,const(A,T)):--
	xmg_typer:type(T,TD),
	lists:member(id(A,_),TD),!.
var_or_const(int(A,C),_,const(A,int)):--!.
var_or_const(bool(A,C),_,const(A,bool)):--!.
var_or_const(id(A,C),Class,A):--
	xmg_compiler:send(info,'Warning : '),xmg_compiler:send(info,A),xmg_compiler:send(info,' was not declared '),xmg_compiler:send(info,C),xmg_compiler:send_nl(info).
var_or_const(string(A,C),Class,const(A,string)):-- !.

check_type(var(Att),const(Value,Type),C):-
	xmg_typer:feat(Att,Type).
check_type(var(Att),const(Value,Type),C):-
	xmg_typer:property(Att,Type).
check_type(Att,Value,C):-
	xmg_compiler:send(info,'Warning : '),xmg_compiler:send(info,Att),xmg_compiler:send(info,' and '),xmg_compiler:send(info,Value),xmg_compiler:send(info,' do not share the same type, at '),xmg_compiler:send(info,C),xmg_compiler:send_nl(info),xmg_compiler:send_nl(info).