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

principles('MetaGrammar'(Decls,_,_)):- 
	get_principles(Decls,Principles),!,
	unicities(Principles,Unicities),
	%%xmg_compiler:send(info,Unicities),
	asserta(xmg_compiler:unicity(Unicities)),!.

get_principles([],[]):- !.
get_principles([decls(principle,Principles)|_],Principles):-!.
get_principles([_|T],Principles):-
	get_principles(T,Principles),!.

unicities([],[]):- !.
unicities([principle(unicity,eq(ID1,ID2),_)|T],[feat(V1,V2)|T1]):-
	get_val(ID1,V1),
	get_val(ID2,V2),
	unicities(T,T1),!.
unicities([H|T],T1):- 
	unicities(T,T1),!.


get_val(id(ID,_),ID):- !.
get_val(int(Int,_),Int):- !.
get_val(default,default):- !.