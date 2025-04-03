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


:-module(xmg_brick_hierarchy_unfolder).


xmg:unfold(hierarchy:ftype(T1),ftype(UT1)):-
	unfold_id(T1,UT1),
	!.

xmg:unfold(hierarchy:ftypes(T1),ftypes(UT1)):-
	unfold_ftypes(T1,UT1),
	!.

unfold_ftypes([],[]).
unfold_ftypes([H|T],[ftype(H1)|T1]):-
	unfold_id(H,H1),
	unfold_ftypes(T,T1),!.

%% xmg:unfold(hierarchy:hierarchy(token(_,id(Id)),Pairs),hierarchy(Id,UPairs)):-
%% 	unfold_pairs(Pairs,UPairs),!.

xmg:unfold(hierarchy:fconstraint(Op,Ts1,Ts2),fconstraint(UOp,UTs1,UTs2)):-
	unfold_op(Op,UOp),
	unfold_idOrAttrs(Ts1,UTs1),
	unfold_idOrAttrs(Ts2,UTs2),
	!.

xmg:unfold(hierarchy:frelation(Rel,Params),frelation(URel,UParams)):-
    unfold_id(Rel,URel),
    unfold_list(Params,UParams),
    !.

xmg:unfold(hierarchy:fconstraints(Cs),fconstraints(UCs)):-
	xmg:unfold(Cs,UCs),
	!.

xmg:unfold(hierarchy:frelations(Cs),frelations(UCs)):-
    xmg:unfold(Cs,UCs),
    !.

unfold_op(token(_,'->'),implies).
unfold_op(token(_,'<->'),is_equivalent).

unfold_list([],[]).
 
unfold_list([H|T],[H1|T1]):-
 
	unfold_id(H,H1),
 
	unfold_list(T,T1),!.

%% xmg:unfold(hierarchy:fconstraint(Type,Must,Cant,Supertypes,Compatible),fconstraint(UType,UMust,UCant,USupertypes,UCompatible)):-
%% 	unfold_id(Type,UType),
%% 	unfold_list(Must,UMust),
%% 	unfold_list(Cant,UCant),
%% 	unfold_list(Supertypes,USupertypes),
%% 	unfold_list(Compatible,UCompatible),
%% 	!.

unfold_id(token(_,id(ID)),ID).

unfold_idOrAttrs([],[]).
unfold_idOrAttrs([H|T],[H1|T1]):-
	unfold_idOrAttr(H,H1),
	unfold_idOrAttrs(T,T1),!.


unfold_idOrAttr(token(_,id(ID)),type(ID)).
unfold_idOrAttr(token(_,bool(+)),type(_)).
unfold_idOrAttr(token(_,bool(-)),type(false)).
unfold_idOrAttr(attrType(ID1,ID2),attrType(UID1,UID2)):-
	unfold_DotList(ID1,UID1),
	unfold_id(ID2,UID2),!.
unfold_idOrAttr(attrType(ID1,token(_,bool(+))),attrType(UID1,_)):-
	unfold_DotList(ID1,UID1),!.
unfold_idOrAttr(attrType(ID1,token(_,bool(-))),attrType(UID1,false)):-
	unfold_DotList(ID1,UID1),!.

unfold_idOrAttr(pathEq(ID1,ID2),pathEq(UID1,UID2)):-
	unfold_DotList(ID1,UID1),
	unfold_DotList(ID2,UID2),!.


unfold_DotList([],[]).
unfold_DotList([token(_, id(ID))|T],[ID|T1]):-
	unfold_DotList(T,T1),!.


unfold_pairs([],[]):- !.
unfold_pairs([H|T],[UH|UT]):-
	unfold_pair(H,UH),
	unfold_pairs(T,UT),!.

unfold_pair(hierarchy:pair(token(_,id(ID1)),token(_,id(ID2))),ID1-ID2):-
	!.




