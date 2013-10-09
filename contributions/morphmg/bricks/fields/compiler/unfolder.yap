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


:-module(xmg_unfolder_fields).

%% SPECIFIC RULES

unfold('FieldDecl',[FieldDecl],UF):-
	unfold(FieldDecl,UF),!.

unfold('Field',[token(_,field),ID],field(UID)):- 
	unfold(ID,UID),!.

unfold('FieldPrec',[ID1,token(_,'>>'),ID2],fieldprec(UID1,UID2)):- 
	unfold(ID1,UID1),
	unfold(ID2,UID2),!.

unfold(token(C,id(ID)),id(ID,C)):-!.


%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	head_name(Head,Name),
	(
	    (
		xmg_modules_def:module_def(Module,'fields'),
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(xmg_modules_def:module_def(Module,'fields')),
	    xmg_modules:get_module(Module,unfolder,UModule),
	    UModule:unfold(Head,Params,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(fields,Rule)))),	
	!.


unfold(Head,Params,UList):-
	unfold_type(Head,list),
	unfold_list(Params,UList),!.
unfold(Head,Params,UList):-
	unfold_type(Head,maybe),
	unfold_maybe(Params,UList),!.

unfold_type(_,none):- !.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

head_name(Head,Name):-
	atomic_list_concat(A,'-',Head),
	A=[_,Name],!.

