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


:-module(xmg_unfolder_var).


unfold('Var',[ID],UID):-
	unfold(ID,UID).
unfold('Var',[token(_,'?'),ID],UID):-
	unfold(ID,UID).
unfold('Var',[token(_,'!'),ID],UID):-
	unfold(ID,UID).

unfold('id',[token(C,id(ID))],id(ID,C)).
 

%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	unfold(Head,Params,UTerm),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule('Var',Rule)))),	
	!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

unfold(Head,Params,UList):-
	unfold_type(Head,list),
	unfold_list(Params,UList),!.
unfold(Head,Params,UList):-
	unfold_type(Head,maybe),
	unfold_maybe(Params,UList),!.

%% PATTERNS

unfold_type(none,none).

unfold_list([''],[]):-!.
unfold_list([Elem],[UElem]):-
	unfold(Elem,UElem),!.
unfold_list([Elem,List],[UElem|UList]):-
	unfold(Elem,UElem),
	unfold(List,UList),!.

unfold_maybe([''],[]):-!.
unfold_maybe([Elem],UElem):-
	unfold(Elem,UElem),!.