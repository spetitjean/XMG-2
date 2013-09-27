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

:- module(xmg_solver_morph).

eval_morph([],[]).
eval_morph([MAcc],Value):-!,
	xmg_xsat:eval(MAcc,Value).
eval_morph([H|T],Value):-
	eval_conj([H|T],Conj),
	eval_morph([Conj],Value).

eval_conj([H],H):-!.
eval_conj([H|T],and(H,T1)):-
	eval_conj(T,T1),!.