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

:- module(xmg_brick_unicity_preparer, []).

prepare(Syn,prepared(Unicities,Syn)):- 
	xmg_compiler:unicity(LUnicities), 
	write_unicities(Syn,LUnicities,Unicities),
	!.

write_unicities(_,[],[]):- !.

write_unicities(Nodes,[U1|UT],[H1|T1]):-
	write_unicity(Nodes,U1,H1),
	write_unicities(Nodes,UT,T1),!.

write_unicity([],_,[]):-!.
write_unicity([Node|T],feat(A,V),['true'|T1]):-
	Node=node(Prop,Feat,_),
	xmg_brick_avm_avm:avm(Prop,PL),
	lists:member(A-const(V,_),PL),!,	
	write_unicity(T,feat(A,V),T1),!.
write_unicity([Node|T],feat(A,V),['true'|T1]):-
	Node=node(Prop,Feat,_),
	xmg_brick_avm_avm:avm(Feat,PL),
	lists:member(A-const(V,_),PL),!,	
	write_unicity(T,feat(A,V),T1),!.
write_unicity([Node|T],feat(A,V),['false'|T1]):-
	Node=node(Prop,Feat,_),
	write_unicity(T,feat(A,V),T1),!.
write_unicity([_|T],feat(A,V),T1):-
	write_unicity(T,feat(A,V),T1),!.



