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


xmg:unfold(decls:type(token(_,id(UType)),label),type(UType,label)):-	
	!.
xmg:unfold(decls:type(token(_,id(UType)),TypeDef),type(UType,UTypeDef)):-	
	unfold_typedef(TypeDef,UTypeDef),!.

xmg:unfold(decls:property(token(_,id(UProp)),token(_,id(UPropType)),Rename),property(UProp,UPropType,none)):-
	!.

xmg:unfold(decls:principle(Pr,Args,Dims),principle(UPr,UArgs,UDims)):-
	unfold_id_or_constr(Pr,UPr),
	xmg:send(info,Args),
	unfold_args(Args,UArgs),
	unfold_dims(Dims,UDims),!,
	!.

unfold_typedef(decls:enum(Enum),enum(UEnum)):-
	unfold_enum(Enum,UEnum),!.
unfold_typedef(decls:struct(Obl,Opt,More),struct(UObl,UOpt,UMore)):-
	unfold_pairs(Obl,UObl),
	unfold_maybe_pairs(Opt,UOpt),
	unfold_more(More,UMore),
	!.
unfold_typedef(decls:range(token(_,int(I1)),token(_,int(I2))),range(I1,I2)):-
	!.
unfold_typedef(Def,_):-
	xmg:send(info,'\n\nUnknown type def: '),
	xmg:send(info,Def),
	false,
	!.

unfold_enum([],[]):- !.
unfold_enum([token(_,id(V))|T],[V|T1]):-
	unfold_enum(T,T1),!.
unfold_enum([token(_,bool(B))|T],[B|T1]):-
	unfold_enum(T,T1),!.

unfold_args([],[]):- !.
unfold_args([token(_,id(V))|T],[V|T1]):-
	unfold_args(T,T1),!.
unfold_args([decls:principle_type(token(_,id(P1)))|T],[type(P1)|T1]):-
	unfold_args(T,T1),!.

unfold_args([decls:eq(token(C,id(Prop)),token(C1,int(Int)))|T],[eq(Prop,Int)|T1]):-
	unfold_args(T,T1),!.

unfold_args([H|T],_):-
	xmg:send(info,'\nUnknown principle arg: '),
	xmg:send(info,H),
	false,!.
unfold_dims([],[]):- !.
unfold_dims([token(_,id(V))|T],[V|T1]):-
	unfold_dims(T,T1),!.
unfold_pairs([],[]):- !.
unfold_pairs([Pair|T],[UPair|T1]):-
	unfold_pair(Pair,UPair),
	unfold_pairs(T,T1),!.
unfold_pair(decls:structpair(token(_,id(P1)),token(_,id(P2))),P1-P2):- !.

unfold_maybe_pairs(none,[]):- !.
unfold_maybe_pairs(some(List),UList):-
	unfold_pairs(List,UList),!.

unfold_more(none,no):- !.
unfold_more(_,yes):- !.

unfold_id_or_constr(token(_,id(ID)),ID):- !.
unfold_id_or_constr(decls:constructor(token(_,id(Dim)),token(_,Constr)),constructor(Dim,Constr)):- !.


%% SPECIFIC RULES

%% unfold([],[]):-!.
%% unfold([H|T],[UH|UT]):-
%% 	unfold(H,UH),
%% 	unfold(T,UT),!.

%% unfold(principle(token(_,id(Principle)),PrincipleFeat,Dims),principle(Principle,UFeat,UDims)):-
%% 	unfold(PrincipleFeat,UFeat),
%% 	asserta(xmg_compiler:principle(Principle)),
%% 	unfold(Dims,UDims),!.

%% unfold(none,none):-!.

%% unfold(eq(Id,none),eq(UId,default)):-
%% 	unfold(Id,UId),
%% 	!.
%% unfold(eq(Id,Id1),eq(UId,UId1)):-
%% 	unfold(Id,UId),
%% 	unfold(Id1,UId1),
%% 	!.

%% unfold(token(_,dim(DIM)),DIM):-!.

%% unfold(type(token(_,id(Id)),TypeDef),type(Id,UTypeDef)):- 
%% 	xmg_brick_mg_compiler:send(info,TypeDef),
%% 	unfold(TypeDef,UTypeDef),!.
%% unfold(type(token(_,id(Id)),label),type(Id,label)):- 
%% 	!.

%% unfold(enum(IDS),enum(UIDS)):-
%% 	unfold(IDS,UIDS),!.

%% unfold('Property',[token(_,property),token(_,id(Id)),token(_,':'),token(_,id(Val)),MaybeAbbrev],property(Id,Val,UAbbrev)):-
%% 	unfold_maybeAbbrev(MaybeAbbrev,UAbbrev),
%% 	!.

%% unfold_maybeAbbrev(A,A):- !.


%% unfold('TypeDef',[token(_,'{'),Ids,token(_,'}')],enum(UIds)):-
%% 	unfold(Ids,UIds).
%% unfold('TypeDef',[token(_,'['),token(_,int(Int1)),token(_,'.'),token(_,'.'),token(_,int(Int2)),token(_,']')],range(Int1,Int2)):- !.
%% unfold('TypeDef',[token(_,'['),Struct,token(_,']')],struct(UStruct)):-
%% 	unfold(Struct,UStruct),!.

%% unfold('Structs',[Struct],[UStruct]):-
%% 	unfold(Struct,UStruct),!.
%% unfold('Structs',[Struct,token(_,','),Structs],[UStruct|UStructs]):-
%% 	unfold(Struct,UStruct),
%% 	unfold(Structs,UStructs),!.

%% unfold('Struct',[A,token(_,':'),B],UA-UB):-
%% 	unfold(A,UA),
%% 	unfold(B,UB),!.



%% unfold(token(C,id(ID)),id(ID,C)):-!.
%% unfold(token(C,int(ID)),int(ID,C)):-!.
%% unfold(token(C,bool(ID)),bool(ID,C)):-!.

%% unfold('vals_coma',[Val],[UVal]):-
%% 	unfold(Val,UVal),!.
%% unfold('vals_coma',[Val,token(_,','),Vals],[UVal|UVals]):-
%% 	unfold(Val,UVal),
%% 	unfold(Vals,UVals),!.

%% unfold('id_pairs',[Pair],[UPair]):-
%% 	unfold(Pair,UPair),!.
%% unfold('id_pairs',[Pair,token(_,','),Pairs],[UPair|UPairs]):-
%% 	unfold(Pair,UPair),
%% 	unfold(Pairs,UPairs),!.

%% unfold('id_pair',[token(_,'('),ID1,token(_,','),ID2,token(_,')')],UID1-UID2):-
%% 	unfold(ID1,UID1),
%% 	unfold(ID2,UID2),!.

%% unfold('ids_coma',[ID],[UID]):-
%% 	unfold(ID,UID),!.
%% unfold('ids_coma',[ID,token(_,','),IDS],[UID|UIDS]):-
%% 	unfold(ID,UID),
%% 	unfold(IDS,UIDS),!.

%% unfold('val',[token(C,id(Id))],id(Id,C)):- !.
%% unfold('val',[token(C,int(Int))],int(Int,C)):- !.
%% unfold('val',[token(C,bool(B))],bool(B,C)):- !.


%% %% GENERIC RULES


%% unfold(Rule,_):- 
%% 	throw(xmg(unfolder_error(no_unfolding_rule(decls,Rule)))),	
%% 	!.





