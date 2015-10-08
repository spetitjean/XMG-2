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

:- module(xmg_brick_morphtf_convert).

:- xmg:edcg.

:- edcg:using(xmg_brick_mg_convert:name).

xmg:xml_convert_term(morphtf:morphtf(AVM),elem(morphtf,children([elem(feats,children(Feats)),elem(fields,children(Fields))]))):--
	xmg_brick_avm_avm:avm(AVM,LAVM),
	%%xmg:send(info,LAVM),
	order_list(LAVM,L1,L2),
	xmg:send(info,L2),

	order_fields(L2,L3),
	xmg:send(info,L3),
	xmg_brick_avm_convert:xmlFeats(L1,Feats),
	xmg_brick_avm_convert:xmlFeats(L3,Fields),
	!.

toXML(List, elem(morph, children([elem(feats, children(Feats)),elem(fields,children(Fields))])),Number) :--
	order_list(List,L1,L2),
	xmlFeats(L1,Feats) with name(0,N1),
	%%xmg_compiler:send(info,Feats),
	order_fields(L2,L3),
	
	xmlFeats(L3,Fields) with name(N1,_),
	!.

xmlFeats(List,Feats):--
	xmg_convert_avm:xmlFeats(List,Feats),!.


order_list([],[],[]):-
	!.

order_list([A-B|T],T1,[N-field(A,B)|T2]):-
	xmg:field(A,N),!,
	order_list(T,T1,T2).
order_list([A-B|T],[A-B|T1],T2):-
	xmg:feat(A,Type),!,
	order_list(T,T1,T2).
order_list([H|T],_,_):-
	xmg:send(info,'UNEXPECTED IN MORPH: '),
	xmg:send(info,H),
	false,!.


order_fields(F,COF):-
	lists:keysort(F,OF),
	clean_fields(OF,COF).

clean_fields([],[]):- !.
clean_fields([_-field(F,V)|T],[F-V|T1]):-
	clean_fields(T,T1),!.



