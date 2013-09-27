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

:- module(xmg_convert_lex).

%%:- use_module('../AVM/xmg_convert_avm').

%%:- edcg:using([xmg_convert_avm:name]).
:- edcg:using(xmg_convert:name).

:- edcg:weave([name],[new_name/2, xmlFeats/2]).

new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).


toXML(List, elem(morph, children([elem(feats, children(Feats)),elem(fields,children(Fields))])),Number) :--
	order_list(List,L1,L2),
	xmg_convert_avm:xmlFeats(L1,Feats) with name(0,N1),
	concat_fields(L2,L3),
	xmg_convert_avm:xmlFeats(L3,Fields) with name(N1,_),
	!.

order_list([],[],[]).
order_list([H|T],[A-const(B,Type)|T1],T2):-
	H=..['=',var(A),B],
	not(var(A)),
	xmg_typer:feat(A,Type),
	order_list(T,T1,T2).
order_list([H|T],T1,[N-field(A-const(B,none))|T2]):-
	H=..['=',var(A),B],
	not(var(A)),
	xmg_typer:field(A,N),
	order_list(T,T1,T2).
order_list([H|T],T1,T2):-
	H=..['=',var(A),B],
	var(A),
	order_list(T,T1,T2).

concat_fields([_-field(F)],F):-!.
concat_fields([_-field(F1), _-field(F2)],F):-
	atom_concat(F1,F2,F).
concat_fields([_-field(F1)|T],F):-
	concat_fields(T,FT),
	atom_concat(F1,FT,F),!.


clean_fields([],[]):- !.
clean_fields([_-field(F)|T],[F|T1]):-
	clean_fields(T,T1),!.



