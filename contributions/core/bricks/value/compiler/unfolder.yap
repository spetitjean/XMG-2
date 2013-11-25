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

:-module(xmg_brick_value_unfolder).

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).

%% xmg:unfold_expr(token(C,id(ID)),ID):--
%% 	constraints::enq(eq(ID,id(ID,C))),!.
	
xmg:unfold_expr(token(C,id(ID)),Target):--
	vars::tget(ID,G),
	constraints::enq(eq(Target,var(ID))),!.
xmg:unfold_expr(token(C,id(ID)),Target):--
	constraints::enq(eq(Target,id(ID,C))),!.
	
 
unfold('Value',[Value],UValue):-
	unfold(Value,UValue).
unfold('Value',[token(_,'?'),Value],UValue):-
	unfold(Value,UValue).
unfold('Else',[Value],UValue):-
	unfold(Value,UValue).
unfold('ADisj',[V],UV):-
	add_to_path('ADisj'),
	use_module(xmg_unfolder_adisj),
	xmg_brick_adisj_unfolder:unfold(V,UV),!.


unfold(token(C,id(ID)),id(ID,C)).
unfold(token(C,string(ID)),string(ID,C)).
unfold(token(C,int(ID)),int(ID,C)).
unfold(token(C,bool(ID)),bool(ID,C)).

%% GENERIC RULES

unfold(Term,UTerm):-
	Term=..[Head|Params],
	head_module(Head,Module),
	head_name(Head,Name),
	(
	    (
		Module=value,
		%%xmg_modules_def:module_def(Module,'value'),
		unfold(Name,Params,UTerm)
	    )
	;
	(
	    not(Module=value),
	    %%not(xmg_modules_def:module_def(Module,'value')),
	    xmg_brick_mg_modules:get_module(Module,unfolder,UModule),
	    UModule:unfold(Term,UTerm)
	)
    ),!.

unfold(Rule,_):- 
	throw(xmg(unfolder_error(no_unfolding_rule(value,Rule)))),	
	!.

head_module(Head,Module):-
	atomic_list_concat(A,'-',Head),
	A=[Module|_],!.

head_name(Head,Name):-
	atomic_list_concat(A,'-',Head),
	A=[_,Name],!.
