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

%% SPECIFIC RULES

unfold('Decls',[''],[]):-
	unfold(Decls,UDecls),!.
unfold('Decls',[Decl,Decls],[UDecl|UDecls]):-
	unfold(Decl,UDecl),
	unfold(Decls,UDecls),!.

unfold('Decl',[Decl],UDecl):-
	unfold(Decl,UDecl),!.

unfold('ODecl',[ODecl],UODecl):-
	unfold(ODecl,UODecl),!.

unfold('Extern',_,extern):-
	xmg_compiler:send(info,' warning : extern not supported yet \n'),!.

unfold('Principle',[token(_,'use'),token(_,id(Principle)),token(_,'with'),token(_,'('),PrincipleFeat,token(_,')'),token(_,'dims'),token(_,'('),Dims,token(_,')')],principle(Principle,UFeat,UDims)):-
	unfold(PrincipleFeat,UFeat),
	asserta(xmg_compiler:principle(Principle)),
	unfold(Dims,UDims),!.

unfold('PrincipleFeat',[''],none):- !.
unfold('PrincipleFeat',[Id1,token(_,'='),Id2],eq(UId1,UId2)):-
	unfold(Id1,UId1),
	unfold(Id2,UId2),
	!.
unfold('PrincipleFeat',[Id],eq(UId,default)):-
	unfold(Id,UId),
	!.

unfold('Dims',[token(_,dim(DIM))],[DIM]):-
	!.
unfold('Dims',[token(_,dim(DIM)),Dims],[DIM|UT]):-
	unfold(Dims,UT),!.

unfold('Type',[token(_,type),token(_,id(Id)),token(_,'='),TypeDef],type(Id,UTypeDef)):- 
	unfold(TypeDef,UTypeDef),!.
unfold('Type',[token(_,type),token(_,id(Id)),token(_,'!')],type(Id,label)):- 
	!.


unfold('Property',[token(_,property),token(_,id(Id)),token(_,':'),token(_,id(Val)),MaybeAbbrev],property(Id,Val,UAbbrev)):-
	unfold_maybeAbbrev(MaybeAbbrev,UAbbrev),
	!.

unfold_maybeAbbrev(A,A):- !.


unfold('TypeDef',[token(_,'{'),Ids,token(_,'}')],enum(UIds)):-
	unfold(Ids,UIds).
unfold('TypeDef',[token(_,'['),token(_,int(Int1)),token(_,'.'),token(_,'.'),token(_,int(Int2)),token(_,']')],range(Int1,Int2)):- !.
unfold('TypeDef',[token(_,'['),Struct,token(_,']')],struct(UStruct)):-
	unfold(Struct,UStruct),!.

unfold('Structs',[Struct],[UStruct]):-
	unfold(Struct,UStruct),!.
unfold('Structs',[Struct,token(_,','),Structs],[UStruct|UStructs]):-
	unfold(Struct,UStruct),
	unfold(Structs,UStructs),!.

unfold('Struct',[A,token(_,':'),B],UA-UB):-
	unfold(A,UA),
	unfold(B,UB),!.



unfold(token(C,id(ID)),id(ID,C)):-!.
unfold(token(C,int(ID)),int(ID,C)):-!.
unfold(token(C,bool(ID)),bool(ID,C)):-!.

unfold('vals_coma',[Val],[UVal]):-
	unfold(Val,UVal),!.
unfold('vals_coma',[Val,token(_,','),Vals],[UVal|UVals]):-
	unfold(Val,UVal),
	unfold(Vals,UVals),!.

unfold('id_pairs',[Pair],[UPair]):-
	unfold(Pair,UPair),!.
unfold('id_pairs',[Pair,token(_,','),Pairs],[UPair|UPairs]):-
	unfold(Pair,UPair),
	unfold(Pairs,UPairs),!.

unfold('id_pair',[token(_,'('),ID1,token(_,','),ID2,token(_,')')],UID1-UID2):-
	unfold(ID1,UID1),
	unfold(ID2,UID2),!.

unfold('ids_coma',[ID],[UID]):-
	unfold(ID,UID),!.
unfold('ids_coma',[ID,token(_,','),IDS],[UID|UIDS]):-
	unfold(ID,UID),
	unfold(IDS,UIDS),!.

unfold('val',[token(C,id(Id))],id(Id,C)):- !.
unfold('val',[token(C,int(Int))],int(Int,C)):- !.
unfold('val',[token(C,bool(B))],bool(B,C)):- !.


%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	head_name(Head,Name),
	(
	    (
		Module='decls',
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(Module='decls'),
	    xmg_brick_mg_modules:get_module(Module,unfolder,UModule),
	    xmg_brick_mg_compiler:send(info, 'switching to '),
	    xmg_brick_mg_compiler:send(info, UModule),

	    UModule:unfold(Term,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(decls,Rule)))),	
	!.

unfold(Head,Params,UList):-
	unfold_type(Head,list),
	unfold_list(Params,UList),!.
unfold(Head,Params,UList):-
	unfold_type(Head,maybe),
	unfold_maybe(Params,UList),!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

head_name(Head,Name):-
	atomic_list_concat(A,'-',Head),
	A=[_,Name],!.


%% PATTERNS

unfold_list([''],[]):-!.
unfold_list([Elem],[UElem]):-
	unfold(Elem,UElem),!.
unfold_list([Elem,List],[UElem|UList]):-
	unfold(Elem,UElem),!,
	unfold(List,UList),!.

unfold_maybe([''],[]):-!.
unfold_maybe([Elem],UElem):-
	unfold(Elem,UElem),!.

%% USING PATTERNS 

unfold_type('Principles',list):- !.
unfold_type('Types',list):- !.
unfold_type('Properties',list):- !.
unfold_type('Feats',list):- !.
unfold_type('Fields',list):- !.
unfold_type('FieldPrecs',list):- !.

unfold_type('ids',list):- !.

unfold_type('DeclsOrNot',maybe):- !.
unfold_type('ImportsOrNot',maybe):- !.
unfold_type('ExportsOrNot',maybe):- !.
unfold_type('ParamsOrNot',maybe):- !.
