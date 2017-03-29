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

get_instances(I):-
    xmg:unicity(I).

prepare_instances(Syn,prepared(Unicities,Syn)):- 
	xmg:unicity(LUnicities), 
	prepare_list(Syn,LUnicities,Unicities),
	!.

prepare_list(Nodes,[],[],Nodes):- !.

prepare_list(Nodes,[U1|UT],[H1|T1],Nodes):-
	prepare_instance(Nodes,U1,H1,INodes),
	prepare_list(INodes,UT,T1,Nodes),!.

prepare_instance([],_,[],[]):-!.
prepare_instance([H|T],I,[H1|T1],[H|T2]):-
    prepare(H,I,H1,H),
    prepare_instance(T,I,T1,T2),!.
prepare_instance([_|T],I,T1,T2):-
    prepare_instance(T,I,T1,T2),!.


prepare(Node,feat(A,V,_),'true',Node):-
	Node=node(Prop,Feat,_),
	xmg_brick_avm_avm:avm(Prop,PL),
	lists:member(A-V,PL),!.	
prepare(Node,feat(A,V,_),'true',Node):-
	Node=node(Prop,Feat,_),
	xmg_brick_avm_avm:avm(Feat,PL),
	lists:member(A-V,PL),!.
prepare(Node,feat(A,V,_),'false',Node):-
        Node=node(Prop,Feat,_).


