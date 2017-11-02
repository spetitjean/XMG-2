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

	assert_principles(Principles,ListPrinciples),

	asserta(xmg:principles(ListPrinciples)),
	!.

assert_principles(_,[]):-!.
assert_principles(Principles,[principle(H,_)|T]):-
    assert_principle(Principles,H),
    assert_principles(Principles,T),!.


assert_principle(_,rank).	      
assert_principle(_,color).	      
%% assert_principle(Principles,unicity):-	      				      
%%     	unicities(Principles,Unicities),
%% 	xmg:send(debug,'\nUnicities:\n'),
%% 	xmg:send(debug,Unicities),
%% 	asserta(xmg:unicity(Unicities)),!.
%% assert_principle(Principles,requires):-	      				      
%% 	requires(Principles,Requires),
%% 	xmg:send(debug,'\nRequires:\n'),
%% 	xmg:send(debug,Requires),
%% 	asserta(xmg:requires(Requires)),!.
%% assert_principle(Principles,precedes):-	      				      
%% 	precedes(Principles,Precedes),
%% 	xmg:send(debug,'\nPrecedes:\n'),
%% 	xmg:send(debug,Precedes),
%% 	asserta(xmg:precedes(Precedes)),!.

assert_principle(Input,Principle):-	      				      
	filter(Principle,Input,Output),
	xmg:send(debug,Principle),
	xmg:send(debug,Output),
	Assert=..[Principle,Output],
	ToAssert=..[':',xmg,Assert],
	xmg:send(debug,Assert),
	asserta(ToAssert),!.
assert_principle(_,Principle):-
    xmg:send(info,'\nWarning: do not know what to do with principle '),
    xmg:send(info,Principle),!.	      


get_principles([],[]):- !.
get_principles([principle-Principles|_],Principles):-!.
get_principles([_|T],Principles):-
	get_principles(T,Principles),!.

%% unicities([],[]):- !.
%% unicities([principle(unicity,[eq(ID1,ID2)],Dim)|T],[feat(ID1,ID2,Dim)|T1]):-
%% 	unicities(T,T1),!.
%% unicities([principle(unicity,[type(ID1)],Dim)|T],[feat(ID1,'+',Dim)|T1]):-
%% 	unicities(T,T1),!.
%% unicities([H|T],T1):- 
%% 	xmg:send(debug,H),
%% 	xmg:send(debug,'\n\n'),
%% 	unicities(T,T1),!.

%% requires([],[]):- !.
%% requires([principle(requires,[eq(ID1,ID2),eq(ID3,ID4)],Dim)|T],[(feat(ID1,ID2,_),feat(ID3,ID4,_))|T1]):-
%% 	requires(T,T1),!.
%% requires([H|T],T1):- 
%% 	xmg:send(debug,H),
%% 	xmg:send(debug,'\n\n'),
%% 	requires(T,T1),!.

%% precedes([],[]):- !.
%% precedes([principle(precedes,[eq(ID1,ID2),eq(ID3,ID4)],Dim)|T],[(feat(ID1,ID2,_),feat(ID3,ID4,_))|T1]):-
%% 	precedes(T,T1),!.
%% precedes([H|T],T1):- 
%% 	xmg:send(debug,H),
%% 	xmg:send(debug,'\n\n'),
%% 	precedes(T,T1),!.


filter(_,[],[]):- !.
%% two clauses used by e.g. unicity
filter(Principle,[principle(Principle,[eq(ID1,ID2)],Dim)|T],[feat(ID1,ID2,Dim)|T1]):-
	filter(Principle,T,T1),!.
filter(Principle,[principle(Principle,[type(ID1)],Dim)|T],[feat(ID1,'+',Dim)|T1]):-
	filter(Principle,T,T1),!.
%% two clauses used by e.g. requires and precedes
filter(Principle,[principle(Principle,[eq(ID1,ID2),eq(ID3,ID4)],_)|T],[(feat(ID1,ID2,_),feat(ID3,ID4,_))|T1]):-
	filter(Principle,T,T1),!.
filter(Principle,[H|T],T1):- 
	xmg:send(debug,H),
	xmg:send(debug,'\n\n'),
	filter(Principle,T,T1),!.


list_principles([],_,[]).
list_principles([principle(P,_,Dim)|T],Seen,[Pr|T1]):-
	Pr=principle(P,Dim),
	not(lists:member(Pr,Seen)),!,
	list_principles(T,[Pr|Seen],T1).
list_principles([_|T],Seen,T1):-
	list_principles(T,Seen,T1),!.

get_val(id(ID,_),ID):- !.
get_val(int(Int,_),Int):- !.
get_val(default,default):- !.
