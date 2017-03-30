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

:- module(xmg_brick_rank_preparer, []).

get_instances([rank]).

prepare_instance([],_,[],[]):- !.

prepare_instance([H|T],I,[H1|T1],[H|T2]):-
	prepare(H,I,H1,H),
	prepare_instance(T,I,T1,T2),!.

prepare_instance([H|T],I,Ranks,[H|T2]):-
	prepare_instance(T,I,Ranks,T2),!.

prepare(node(P,F,N),I,rank(C),node(P,F,N)):-
	xmg_brick_avm_avm:avm(P, Props),
	search_rank(Props,C),
	!.

search_rank([],none):-
	!.

search_rank([rank-R|_],R):-!.

search_rank([_|T],C):-
	search_rank(T,C),!.



