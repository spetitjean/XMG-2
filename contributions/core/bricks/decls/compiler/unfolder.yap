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


:-module(xmg_brick_decls_unfolder).

:- xmg:edcg.


sort_decls([],[]):- !.
sort_decls([H|T],[Head-Found|Sorted]):-
	H=..[Head|_],
	find(Head,[H|T],Found,Rest),
	sort_decls(Rest,Sorted),!.

find(Head,[],[],[]):- !.
find(Head,[H|T],[H|T1],Rest):-
	H=..[Head|_],!,
	find(Head,T,T1,Rest),!.
find(Head,[H|T],T1,[H|Rest]):-
	find(Head,T,T1,Rest),!.


xmg:unfold(decls:type(token(_,id(UType)),label),type(UType,label)):-!.
xmg:unfold(decls:type(token(_,id(UType)),TypeDef),type(UType,UTypeDef)):-	
	unfold_typedef(TypeDef,UTypeDef),!.
xmg:unfold(decls:property(token(_,id(UProp)),token(_,id(UPropType)),Rename),property(UProp,UPropType,none)):-!.
xmg:unfold(decls:principle(Pr,Args,Dims),principle(UPr,UArgs,UDims)):-
	unfold_id_or_constr(Pr,UPr),
	%%xmg:send(info,Args),
	unfold_args(Args,UArgs),
	unfold_dims(Dims,UDims),!,
	!.

unfold_typedef(decls:enum(Enum),enum(UEnum)):-
	unfold_enum(Enum,UEnum),!.
unfold_typedef(decls:struct(Feats),struct(UFeats)):-
	unfold_pairs(Feats,UFeats),!.
unfold_typedef(decls:range(token(_,int(I1)),token(_,int(I2))),range(I1,I2)):-!.
unfold_typedef(Def,_):-
	xmg:send(info,'\n\nUnknown type def: '),
	xmg:send(info,Def),
	false.

unfold_enum([],[]):- !.
unfold_enum([token(_,id(V))|T],[V|T1]):-
	unfold_enum(T,T1),!.
unfold_enum([token(_,bool(B))|T],[B|T1]):-
	unfold_enum(T,T1),!.

unfold_args([],[]):- !.
unfold_args([H|T],[H1|T1]):-
	unfold_arg(H,H1),
	unfold_args(T,T1),!.
unfold_args([H|T],_):-
	xmg:send(info,'\nUnknown principle arg: '),
	xmg:send(info,H),
	false,!.

unfold_arg(token(_,id(V)),V):-!.
unfold_arg(decls:principle_type(token(_,id(P1))),type(P1)):-!.
unfold_arg(decls:eq(token(C,id(Prop)),token(C1,int(Int))),eq(Prop,Int)):-!.
unfold_arg(decls:eq(token(C,id(Prop)),token(C1,id(Prop2))),eq(Prop,Prop2)):-!.
unfold_arg(token(_,dimtype(Brick,Type)),modtype(Brick,Type)):-!.


unfold_dims([],[]):- !.
unfold_dims([token(_,id(V))|T],[V|T1]):-
	unfold_dims(T,T1),!.

unfold_pairs([],[]):- !.
unfold_pairs([Pair|T],[UPair|T1]):-
	unfold_pair(Pair,UPair),
	unfold_pairs(T,T1),!.

unfold_pair(decls:structpair(token(_,id(P1)),token(_,id(P2))),P1-P2):- !.
unfold_pair(decls:structpair(token(_,id(P1)),DimType),P1-P2):- 
	unfold_arg(DimType,P2),
	!.
unfold_pair(decls:structpair(token(_,id(P1)),decls:struct(Pairs)),P1-struct(P2)):-
	unfold_pairs(Pairs,P2),!.

unfold_maybe_pairs(none,[]):- !.
unfold_maybe_pairs(some(List),UList):-
	unfold_pairs(List,UList),!.

unfold_more(none,no):- !.
unfold_more(_,yes):- !.

unfold_id_or_constr(token(_,id(ID)),ID):- !.
unfold_id_or_constr(decls:constructor(token(_,id(Dim)),token(_,Constr)),constructor(Dim,Constr)):- !.






