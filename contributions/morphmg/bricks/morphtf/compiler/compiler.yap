%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2015  Simon Petitjean

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

:-module(xmg_brick_morphtf_compiler).


xmg:eval(morphtf,Dim,_,Morph,morphtf:morphtf(Value),_):-
	xmg:send(info,Morph),
	xmg_brick_morphtf_solver:eval_morph(Morph,Value),
	%%xmg:send_nl(info,2),
	xmg:send(debug,' Value : '),
	xmg:send(debug,Value).

