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


:-module(xmg_brick_avm_generator).

:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:name).
:-edcg:using(xmg_brick_mg_generator:code).

:-edcg:weave([decls,name], [new_name/2,var_or_const/2,generate/5]).

xmg:generate_instr((v(Target),avm:avm(Coord))) :--
	decls::tget(Target,Var),
	code::enq(xmg_brick_avm_avm:avm(Var,[])),
	!.
xmg:generate_instr((v(Target),avm:feat(c(F),v(Target2)))):--
	decls::tget(Target,Var),
	decls::tget(Target2,Var2);
	code::enq(xmg_brick_avm_avm:avm(Var,[F-Var2])),	
	!.
xmg:generate_instr((v(Target),avm:feat(c(F),c(Target2)))):--
	decls::tget(Target,Var),
	Var2=Target2,
	code::enq(xmg_brick_avm_avm:avm(Var,[F-Var2])),	
	!.


xmg:generate_instr((v(Var),avm:dot(v(Class),c(CVar)))):--
	xmg:send(info,' generating dot '),
	decls::tget(Var,GV),
	decls::tget(Class,GC),
	
	Member=..[member,CVar-GV,GC],
	code::enq(lists:Member),
	code::enq(xmg:send(info,'member found')),!.

xmg:generate_instr((v(Var),avm:dot(v(Class),c(CVar)))):--
	xmg:send(info,' generating dot '),
	decls::tget(Var,GV),
	decls::tget(Class,GC),
	
	Member=..[member,CVar-GV,GC],
	code::enq(lists:Member),
	code::enq(xmg:send(info,'member found')),!.


