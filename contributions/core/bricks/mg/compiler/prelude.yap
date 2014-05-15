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

:-module(xmg_brick_mg_prelude).

:-use_module('xmg/brick/mg/edcg.yap').

:-multifile(user:term_expansion/2).

term_expansion((:- xmg:edcg), R) :-
    !, R=(:- use_module(edcg, 'xmg/brick/mg/edcg.yap', all)).

term_expansion((:- xmg:gecode), R) :-
    !, R=(:- use_module(gecode, library(gecode), all)).

user:term_expansion(X,Y) :- xmg_brick_mg_prelude:term_expansion(X,Y).
