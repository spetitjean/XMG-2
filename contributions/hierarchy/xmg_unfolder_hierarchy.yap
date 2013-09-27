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


:-module(xmg_unfolder_hierarchy).

%% SPECIFIC RULES


unfold('Hierarchy',[token(_,hierarchy),token(_,id(Id)),token(_,'='),HierarchyDef],hierarchy(Id,UHierarchyDef)):- 
	unfold(HierarchyDef,UHierarchyDef),!.

unfold('HierarchyDef',[token(_,'{'),Ids,token(_,'}')],UIds):-
	unfold(Ids,UIds).


unfold(token(C,id(ID)),id(ID,C)):-!.
unfold(token(C,int(ID)),int(ID,C)):-!.
unfold(token(C,bool(ID)),bool(ID,C)):-!.



unfold('id_pairs',[Pair],[UPair]):-
	unfold(Pair,UPair),!.
unfold('id_pairs',[Pair,token(_,','),Pairs],[UPair|UPairs]):-
	unfold(Pair,UPair),
	unfold(Pairs,UPairs),!.

unfold('id_pair',[token(_,'('),ID1,token(_,','),ID2,token(_,')')],UID1-UID2):-
	unfold(ID1,UID1),
	unfold(ID2,UID2),!.




%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	head_name(Head,Name),
	(
	    (
		xmg_modules_def:module_def(Module,'hierarchy'),
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(xmg_modules_def:module_def(Module,'hierarchy')),
	    xmg_modules:get_module(Module,unfolder,UModule),
	    UModule:unfold(Head,Params,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(hierarchy,Rule)))),	
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

unfold_type(none,none):-!.
