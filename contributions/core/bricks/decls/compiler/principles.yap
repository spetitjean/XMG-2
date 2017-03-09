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


:-module(xmg_brick_decls_principles).

:- xmg:edcg.


principles(mg(Decls,_,_)):- 
	get_principles(Decls,Principles),!,
	list_principles(Principles,[],ListPrinciples),
	xmg:send(debug,'\nPrinciples:\n'),
	xmg:send(debug,ListPrinciples),
	unicities(Principles,Unicities),
	requires(Principles,Requires),
	precedes(Principles,Precedes),
	xmg:send(debug,'\nUnicities:\n'),
	xmg:send(debug,Unicities),
	asserta(xmg:unicity(Unicities)),
	xmg:send(debug,'\nRequires:\n'),
	xmg:send(debug,Requires),
	asserta(xmg:requires(Requires)),
	xmg:send(debug,'\nPrecedes:\n'),
	xmg:send(debug,Precedes),
	asserta(xmg:precedes(Precedes)),
	asserta(xmg:principles(ListPrinciples)),!.

get_principles([],[]):- !.
get_principles([principle-Principles|_],Principles):-!.
get_principles([H|T],Principles):-
	get_principles(T,Principles),!.

unicities([],[]):- !.
unicities([principle(unicity,[eq(ID1,ID2)],Dim)|T],[feat(ID1,ID2,Dim)|T1]):-
	unicities(T,T1),!.
unicities([principle(unicity,[type(ID1)],Dim)|T],[feat(ID1,'+',Dim)|T1]):-
	unicities(T,T1),!.
unicities([H|T],T1):- 
	xmg:send(debug,H),
	xmg:send(debug,'\n\n'),
	unicities(T,T1),!.

requires([],[]):- !.
requires([principle(requires,[eq(ID1,ID2),eq(ID3,ID4)],Dim)|T],[(feat(ID1,ID2,_),feat(ID3,ID4,_))|T1]):-
	requires(T,T1),!.
requires([H|T],T1):- 
	xmg:send(debug,H),
	xmg:send(debug,'\n\n'),
	requires(T,T1),!.

precedes([],[]):- !.
precedes([principle(precedes,[eq(ID1,ID2),eq(ID3,ID4)],Dim)|T],[(feat(ID1,ID2,_),feat(ID3,ID4,_))|T1]):-
	precedes(T,T1),!.
precedes([H|T],T1):- 
	xmg:send(debug,H),
	xmg:send(debug,'\n\n'),
	precedes(T,T1),!.

list_principles([],_,[]).
list_principles([principle(P,_,Dim)|T],Seen,[Pr|T1]):-
	Pr=principle(P,Dim),
	not(lists:member(Pr,Seen)),!,
	list_principles(T,[Pr|Seen],T1).
list_principles([H|T],Seen,T1):-
	list_principles(T,Seen,T1),!.

get_val(id(ID,_),ID):- !.
get_val(int(Int,_),Int):- !.
get_val(default,default):- !.
