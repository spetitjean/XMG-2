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




xmg:unfold(hierarchy:hierarchy(token(_,id(Id)),Pairs),hierarchy(Id,UPairs)):-
	unfold_pairs(Pairs,UPairs),!.

xmg:unfold(hierarchy:fconstraint(Type,Must,Cant,Supertypes,Compatible),fconstraint(UType,UMust,UCant,USupertypes,UCompatible)):-
	unfold_id(Type,UType),
	unfold_list(Must,UMust),
	unfold_list(Cant,UCant),
	unfold_list(Supertypes,USupertypes),
	unfold_list(Compatible,UCompatible),
	!.

unfold_id(token(_,id(ID)),ID).

unfold_list(none,[]).
unfold_list(some(List),UList):-
	unfold_list(List,UList).
unfold_list([],[]).
unfold_list([H|T],[H1|T1]):-
	unfold_id(H,H1),
	unfold_list(T,T1),!.


unfold_pairs([],[]):- !.
unfold_pairs([H|T],[UH|UT]):-
	unfold_pair(H,UH),
	unfold_pairs(T,UT),!.

unfold_pair(hierarchy:pair(token(_,id(ID1)),token(_,id(ID2))),ID1-ID2):-
	!.






%% unfold('Hierarchy',[token(_,hierarchy),token(_,id(Id)),token(_,'='),HierarchyDef],hierarchy(Id,UHierarchyDef)):- 
%% 	unfold(HierarchyDef,UHierarchyDef),!.

%% unfold('HierarchyDef',[token(_,'{'),Ids,token(_,'}')],UIds):-
%% 	unfold(Ids,UIds).


%% unfold(token(C,id(ID)),id(ID,C)):-!.
%% unfold(token(C,int(ID)),int(ID,C)):-!.
%% unfold(token(C,bool(ID)),bool(ID,C)):-!.



%% unfold('id_pairs',[Pair],[UPair]):-
%% 	unfold(Pair,UPair),!.
%% unfold('id_pairs',[Pair,token(_,','),Pairs],[UPair|UPairs]):-
%% 	unfold(Pair,UPair),
%% 	unfold(Pairs,UPairs),!.

%% unfold('id_pair',[token(_,'('),ID1,token(_,','),ID2,token(_,')')],UID1-UID2):-
%% 	unfold(ID1,UID1),
%% 	unfold(ID2,UID2),!.




%% %% GENERIC RULES

%% unfold(Term,UTerm):-
%% 	Term=..[Head|Params],
%% 	head_module(Head,Module),
%% 	head_name(Head,Name),
%% 	(
%% 	    (
%% 		xmg_modules_def:module_def(Module,'hierarchy'),
%% 		unfold(Name,Params,UTerm)
%% 	    )
%% 	;
%% 	(
%% 	    not(xmg_modules_def:module_def(Module,'hierarchy')),
%% 	    xmg_modules:get_module(Module,unfolder,UModule),
%% 	    UModule:unfold(Head,Params,UTerm)
%% 	)
%%     ),!.

%% unfold(Rule,_):- 
%% 	throw(xmg(unfolder_error(no_unfolding_rule(hierarchy,Rule)))),	
%% 	!.


%% unfold(Head,Params,UList):-
%% 	unfold_type(Head,list),
%% 	unfold_list(Params,UList),!.
%% unfold(Head,Params,UList):-
%% 	unfold_type(Head,maybe),
%% 	unfold_maybe(Params,UList),!.

%% head_module(Head,Module):-
%% 	atomic_list_concat(A,'-',Head),
%% 	A=[Module|_],!.

%% head_name(Head,Name):-
%% 	atomic_list_concat(A,'-',Head),
%% 	A=[_,Name],!.

%% unfold_type(none,none):-!.
