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

:- use_module(library(assoc)).

eval(Morph,morphlp:solved(Atom,MEqs)):-
	xmg:send(debug,'\nSolving lp: '),
	xmg:send(debug,Morph),
	get_all(Morph,Stems,Precs,InF,Eqs),
	xmg:send(debug,Stems),
	xmg:send(debug,Precs),
	xmg:send(debug,InF),
	xmg:send(debug,Eqs),
	order_stems(Stems,Precs,OStems),
	xmg:send(debug,'\nFields ordered'),
	put_in_fields(InF,OStems,Strings),
	merge_eqs(Eqs,MEqs),
	xmg:send(debug,'\nStrings in fields: '),
	concat_stems(Strings,Form),
	atom_codes(Atom,Form),
	xmg:send(debug,Atom),
	!.

get_all([],[],[],[],[]):- !.
get_all([field(Stem)|T],[field(Stem)|T1],T2,T3,T4):-
	get_all(T,T1,T2,T3,T4),!.
get_all([fieldprec(S1,S2)|T],T1,[fieldprec(S1,S2)|T2],T3,T4):-
	get_all(T,T1,T2,T3,T4),!.
get_all([infield(H,H1)|T],T1,T2,[infield(H,H1)|T3],T4):-
	get_all(T,T1,T2,T3,T4),!.
get_all([eq(H,H1)|T],T1,T2,T3,[H-H1|T4]):-
	get_all(T,T1,T2,T3,T4),!.


order_stems([],_,[]):-!.
order_stems(Stems,Precs,OFields):-
	find_first(Stems,Precs,First),
	order_stems(Stems,Precs,First,OFields),!.

order_stems([field(Stem)],_,_,[field(Stem)]):- !.
order_stems(Stems,Precs,First,[field(First)|OStems]):-
    %%lists:delete(Stems,field(First),NStems),
    %% delete is deprecated
    lists:subtract(Stems,[field(First)],NStems),
    lists:member(fieldprec(First,Next),Precs),!,
	  order_stems(NStems,Precs,Next,OStems),!.
order_stems(Stems,Precs,First,[Stem|OStems]):- !,
	xmg:send(info,' Could not order fields, nothing seems to follow '),
	xmg:send(info,First),
	false,!.



find_first([],_,_):- !,
	xmg:send(info,' Could not find a first field, there might be a cycle'),false,!.
find_first([field(F1)|T],Precs,F2):-
	lists:member(fieldprec(_,F1),Precs),!,
	find_first(T,Precs,F2),!.
find_first([field(F1)|T],_,F1):- !.


type_fields([],_).
type_fields([H|T],N):-
	type_field(H,N),
	M is N+1,
	type_fields(T,M).

	
type_field(F,N):-
	asserta(field(F,N)).

put_in_fields([],Fields,Fields):-
	!.
put_in_fields([H|T],Fields,IFields):-
	put_in_field(H,Fields,Fields1),
	put_in_fields(T,Fields1,IFields),!.

put_in_field(infield(F,S),[field(F)|T],[S|T]):- !.
put_in_field(infield(F,S),[H|T],[H|T1]):- 
	put_in_field(infield(F,S),T,T1),
	!.
	

concat_stems([string(A)],A):- !.
concat_stems([string(A)|T],Concat):-
	concat_stems(T,Next),!,
	lists:append(A,Next,Concat),!.

merge_eqs([],[]):- !.
merge_eqs([H|T],[H|Eqs]):-
	merge_eq(H,T,Eqs1),
	merge_eqs(Eqs1,Eqs),!.

merge_eq(A-V,Eqs,MMEqs):-
	lists:member(A-V,Eqs),
	xmg:send(debug,'\nwas in eqs'),
	%%lists:delete(Eqs,A-V,MEqs),
	lists:subtract(Eqs,[A-V],MEqs),
	merge_eq(A-V,MEqs,MMEqs),!.
merge_eq(A-V,Eqs,Eqs):-
	not(lists:member(A-_,Eqs)),
	xmg:send(debug,'\nwas not in eqs'),!.

	
