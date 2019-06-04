%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2014  Simon Petitjean

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


:-module(xmg_brick_iface_generator).

:- xmg:edcg.


:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:name).
:-edcg:using(xmg_brick_mg_generator:code).





xmg:generate_instr(unify(IFace,v(AVM))):--
	decls::tget(AVM,VAVM),
        code::enq(xmg:send(debug,'unifying interface')),
        code::enq(xmg:send(debug,VAVM)),
	
	Set=..['::',xmg_acc:IFace,get(VAVM)],
	code::enq(Set),
	code::enq(xmg:send(debug,'unified interface')),
	code::enq(xmg:send(debug,'\nUnified')),

	!.



