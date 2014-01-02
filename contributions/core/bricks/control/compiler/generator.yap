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


xmg:generate_instr(control:or([I1,I2])):--
	xmg:generate_instr(I1) with code([]-C1,[]-[]),
	xmg:generate_instr(I2) with code([]-C2,[]-[]),
	code::enq(or(C1,C2)),
	!.
xmg:generate_instr(control:and(I)):--
	xmg:generate_instrs(I),
	!.

