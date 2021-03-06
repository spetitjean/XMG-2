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


:-module(xmg_brick_polAvm_generator).

:- xmg:edcg.


:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:name).
:-edcg:using(xmg_brick_mg_generator:code).

xmg:generate_instr((v(Target),polAvm:polarity(Pol))) :--
	decls::tget(Target,Var),
	code::enq(xmg_brick_polAvm_polarity:polarity(Var,Pol)),
	!.
xmg:generate_instr((v(Target),polAvm:feat(c(F),v(Target2),v(Pol)))):--
	decls::tget(Target,Var),
	decls::tget(Pol,PolVar),
	decls::tget(Target2,Var2),
	code::enq(xmg_brick_avm_avm:avm(Var,[F-value(Var2,PolVar)])),	
	!.
xmg:generate_instr((v(Target),polAvm:feat(c(F),c(Target2),v(Pol)))):--
	decls::tget(Target,Var),
	decls::tget(Pol,PolVar),
	Var2=Target2,
	code::enq(xmg_brick_avm_avm:avm(Var,[F-value(Var2,PolVar)])),	
	!.


xmg:generate_instr((v(Var),avm:dot(v(Class),c(CVar)))):--
	xmg:send(info,' generating dot '),
	decls::tget(Var,GV),
	decls::tget(Class,GC),
	
	Dot=..[avm_dot,CVar-GV,GC],
	code::enq(xmg:Dot),!.


xmg:avm_dot(Member-Value,List) :-
	lists:member(Member-Value,List).
	%%xmg:send(info,'\nFound key '),
	%%xmg:send(info,Member),
	%%xmg:send(info,' in '),
	%%xmg:send(info,List).
xmg:avm_dot(Member-_,List):-
	not(lists:member(Member-Value,List)),
	xmg:send(info,'\nDid not find key '),
	xmg:send(info,Member),
	xmg:send(info,' in '),
	xmg:send(info,List).
	
