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


:-module(xmg_brick_mg_unfolder).
:-edcg:thread(constraints,edcg:queue).
:-edcg:thread(name,edcg:counter).

:-edcg:weave([constraints,name],[unfold_class/2,xmg_brick_control_unfolder:unfold_stmt/2]).
:-edcg:weave([name],[new_name/2]).

new_name(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),!.

%% SPECIFIC RULES

unfold(mg:mg(E,F,G),mg(OUDecls,UClasses,UValues)):-
	%%unfold(E,UDecls),
	%%xmg_brick_decls_unfolder:sort_decls(UDecls,OUDecls),
	%%xmg_compiler:send(info,OUDecls),
	unfold(F,UClasses),
	%%unfold(G,UValues),
	!.
unfold([],[]):- !.
unfold([H|T],[H1|T1]):-
	unfold(H,H1),
	unfold(T,T1),!.

unfold(mg:class(N,_,I,E,D,S),class(US,Constraints)):--
	unfold_class(S,US) with (constraints(Constraints,[]), name(0,_)),!.

unfold_class(C,UC):--
	%%xmg_brick_mg_compiler:send(info,C),!,
	xmg_brick_control_unfolder:unfold_stmt(C,UC),!,
	xmg_brick_mg_compiler:send(info,UC),
	!.

unfold('EDecls',[Decls],UDecls):-
	unfold(Decls,UDecls),!.

unfold('Principle',[token(_,id(Principle)),PrincipleFeat,Dims],principle(Principle,UFeat,UDims)):-
	unfold(PricipleFeat,UFeat),
	unfold(Dims,UDims),!.

unfold('PrincipleFeat',[''],none):- !.
unfold('PrincipleFeat',[Id1,token(_,'='),Id2],eq(UId1,UId2)):-
	unfold(Id1,UId1),
	unfold(Id2,UId2),!.
unfold('PrincipleFeat',[Id],eq(UId)):-
	unfold(Id,UId),!.

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

unfold('Feat',[token(_,feature),token(_,id(Id)),token(_,':'),token(_,id(Type))],feat(Id,Type)).

unfold('Field',[token(_,field),token(_,id(Id))],field(Id)):- !.

unfold('Class',[token(_,class),Stars,token(C,Name),Params,Imports,Exports,Decls,Stmts],class(Name,class(UP,UI,UE,UD,US),C)):-
	unfold(Params,UP),
	unfold(Imports,UI),
	unfold(Exports,UE),
	unfold(Decls,UD),
	unfold(Stmts,US),!.

unfold('Class',[Mutex],UMutex):-
	unfold(Mutex,UMutex),!.

unfold('Params',[token(_,'['),Ids,token(_,']')],UIds):-
	unfold(Ids,UIds).
unfold('Params',[token(_,'['),token(_,']')],[]):-!.

unfold('Imports',[token(_,import),IClasses],UIds):-
	unfold(IClasses,UIds).

unfold('IClass',[ID,token(_,'['),MaybeParams,token(_,']'),MaybeAs],import(UID,UAs)):-
	unfold(ID,UID),
	unfold(MaybeAs,UAs),!.

unfold('MaybeAs',[''],[]):- !.
unfold('MaybeAs',[token(_,'as'),token(_,'['),AsList,token(_,']')],UList):-
	unfold(AsList,UList),!.

unfold('AsElem',[Var1,token(_,'='),Var2],UV1-UV2):-
	unfold(Var1,UV1),
	unfold(Var2,UV2),!.

unfold('Exports',[token(_,export),Ids],UIds):-
	unfold(Ids,UIds).

unfold('Decls',[token(_,declare),Ids],UIds):-
	unfold(Ids,UIds).

unfold('Stmts',[token(_,'{'),Stmt,token(_,'}')],Unfolded):-
	unfold(Stmt,Unfolded),!.
unfold('Stmts',[''],empty):-!.

unfold('Stmt',[Stmt],UStmt):-
	unfold(Stmt,UStmt).


unfold('Value',[token(_,value),token(_,id(V))],'Value'(V)).

unfold('Mutex',[token(_,mutex),ID],'mutex'(UID)):-
	unfold(ID,UID),!.
unfold('Mutex',[token(_,mutex),ID1,token(_,'+='),ID2],'mutex_add'(UID1,UID2)):-
	unfold(ID1,UID1),
	unfold(ID2,UID2),!.

unfold('Semantics',_,semantics):-
	!.

unfold(token(C,id(ID)),id(ID,C)):-!.

unfold('vals_coma',[Val],[UVal]):-
	unfold(Val,UVal),!.
unfold('vals_coma',[Val,token(_,','),Vals],[UVal|UVals]):-
	unfold(Val,UVal),
	unfold(Vals,UVals),!.

unfold('ids_coma',[ID],[UID]):-
	unfold(ID,UID),!.
unfold('ids_coma',[ID,token(_,','),IDS],[UID|UIDS]):-
	unfold(ID,UID),
	unfold(IDS,UIDS),!.

unfold('val',[token(C,id(Id))],id(Id,C)):- !.
unfold('val',[token(C,int(Int))],int(Int,C)):- !.
unfold('val',[token(C,bool(B))],bool(B,C)):- !.


unfold('Var',[token(_,'?'),token(C,id(Id))],id(Id,C)):- !.
unfold('Var',[token(_,'!'),token(C,id(Id))],const(Id,C)):- !.
unfold('Var',[token(C,id(Id))],id(Id,C)):- !.



%% GENERIC RULES



unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(mg,Rule)))),	
	!.


unfold(Head,Params,UList):-
	unfold_type(Head,list),
	unfold_list(Params,UList),!.
unfold(Head,Params,UList):-
	unfold_type(Head,maybe),
	unfold_maybe(Params,UList),!.


%% PATTERNS

unfold_list([],[]):-!.
unfold_list([Elem],[UElem]):-
	unfold(Elem,UElem),!.
unfold_list([Elem|List],[UElem|UList]):-
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
unfold_type('Classes',list):- !.
unfold_type('IClasses',list):- !.
unfold_type('Values',list):- !.
unfold_type('Vars',list):- !.
unfold_type('ids',list):- !.
unfold_type('AsList',list):- !.

unfold_type('DeclsOrNot',maybe):- !.
unfold_type('ImportsOrNot',maybe):- !.
unfold_type('ExportsOrNot',maybe):- !.
unfold_type('ParamsOrNot',maybe):- !.
