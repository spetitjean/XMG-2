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

:- module(xmg_brick_morphlp_solver).

eval(Morph,solved(OStems,Form)):-
	xmg:send(info,'\nSolving lp: '),
	xmg:send(info,Morph),
	get_all(Morph,Stems,Precs,InF,Eqs),
	xmg:send(info,Stems),
	xmg:send(info,Precs),
	order_stems(Stems,Precs,OStems),
	concat_stems(OStems,Form),
	xmg:send(info,OStems),
	!.

get_all([],[],[],[],[]):- !.
get_all([field(Stem)|T],[field(Stem)|T1],T2,T3,T4):-
	get_all(T,T1,T2,T3,T4),!.
get_all([fieldprec(S1,S2)|T],T1,[fieldprec(S1,S2)|T2],T3,T4):-
	get_all(T,T1,T2,T3,T4),!.
get_all([H|T],T1,T2,[H|T3],T4):-
	get_all(T,T1,T2,T3,T4),!.
get_all([fieldprec(S1,S2,P)|T],T1,[fieldprec(S1,S2,P)|T2],T3,T4):-
	get_all(T,T1,T2,T3,T4),!.


order_stems([],_,[]):-!.
order_stems(Stems,Precs,OFields):-
	find_first(Stems,Precs,First),
	order_stems(Stems,Precs,First,OFields),!.

order_stems([morpheme(Stem)],_,_,[Stem]):- !.
order_stems(Stems,Precs,First,[First|OStems]):-
	lists:delete(Stems,morpheme(First),NStems),
	lists:member(prec(First,Next,'>>'),Precs),!,
	order_stems(NStems,Precs,Next,OStems),!.
order_stems(Stems,Precs,First,[Stem|OStems]):- !,
	xmg_compiler:send(info,' Could not order stems, nothing seems to follow '),
	xmg_compiler:send(info,First),
	false,!.



find_first([],_,_):- !,
	xmg_compiler:send(info,' Could not find a first stem, there might be a cycle'),false,!.
find_first([morpheme(F1)|T],Precs,F2):-
	lists:member(prec(_,F1,'>>'),Precs),!,
	find_first(T,Precs,F2),!.
find_first([morpheme(F1)|T],_,F1):- !.


type_fields([],_).
type_fields([H|T],N):-
	type_field(H,N),
	M is N+1,
	type_fields(T,M).

	
type_field(F,N):-
	asserta(field(F,N)).

concat_stems([const(A,_)],A):- !.
concat_stems([const(A,_)|T],Concat):-
	concat_stems(T,Next),!,
	atom_concat(A,Next,Concat),!.