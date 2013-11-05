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

:-module(xmg_brick_avm_unfolder).

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name]).
:- edcg:weave([constraints,name],[unfold_expr/2,unfold_feats/2,unfold_feat/2]).

unfold_expr(avm:avm(Coord, Feats), Target) :--
    constraints::enq((Target,avm:avm)),
    unfold_feats(Feats, Target).

unfold_feats([], _).
unfold_feats([Feat|Feats], Target) :--
    unfold_feat(Feat, Target),
    unfold_feats(Feats, Target).

unfold_feat(avm:feat(F,V), Target) :--
    new_target_var(Target2),
    constraints::enq((Target,avm:feat(F,Target2))),
    unfold_expr(V, Target2).

unfold('AVM',[token(_,'['),Feats,token(_,']')],avm(UFeats)):-
	unfold(Feats,UFeats),!.

unfold('Feats',[Feat,token(_,','),Feats],[UFeat|UFeats]):-
	unfold(Feat,UFeat),
	unfold(Feats,UFeats),!.
unfold('Feats',[Feat],[UFeat]):-
	unfold(Feat,UFeat),!.

unfold('Feat',[ID,token(_,'='),In1],UID-UValue):-
	unfold(ID,UID),
	unfold(In1,UValue),!.
unfold('Feat',[ID],UID-default):-
	unfold(ID,UID),!.

unfold('Value',[Value],UValue):-
	unfold(Value,UValue),!.


unfold(token(C,id(ID)),id(ID,C)).
unfold(token(C,bool(ID)),bool(ID,C)).
unfold(token(C,int(ID)),int(ID,C)).
 

%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	head_name(Head,Name),
	(
	    (
		Module=avm,
		%%xmg_modules_def:module_def(Module,'avm'),
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(Module=avm),
	    %%not(xmg_modules_def:module_def(Module,'avm')),
	    xmg_brick_mg_modules:get_module(Module,unfolder,UModule),
	    UModule:unfold(Term,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(avm,Rule)))),	
	!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

head_name(Head,Name):-
	atomic_list_concat(A,'-',Head),
	A=[_,Name],!.


