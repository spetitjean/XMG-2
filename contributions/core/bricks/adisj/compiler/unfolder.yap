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


:-module(xmg_brick_adisj_unfolder).

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).

xmg:unfold_expr(adisj:adisj(Adisj),id(Target,_)):--
	xmg:new_target_var(Target),
	xmg:unfold_exprs(Adisj,UAdisj),
	constraints::enq((Target,adisj:adisj,UAdisj)),
	%%xmg_brick_adisj_adisj:adisj(Target,UAdisj),
	!.

%% unfold('ADISJ',[token(_,'@'),token(_,'{'),IDS,token(_,'}')],adisj(UADisj)):-
%% 	unfold(IDS,UADisj),!.

%% unfold('vals_coma',[Val],[UVal]):-
%% 	unfold(Val,UVal),!.
%% unfold('vals_coma',[Val,token(_,','),Vals],[UVal|UVals]):-
%% 	unfold(Val,UVal),
%% 	unfold(Vals,UVals),!.

%% unfold('val',[token(C,id(Id))],id(Id,C)):- !.
%% unfold('val',[token(C,int(Id))],int(Id,C)):- !.
%% unfold('val',[token(C,bool(Id))],bool(Id,C)):- !.
%% unfold('val',[token(C,string(Id))],string(Id,C)):- !.

%% %% GENERIC RULES

%% unfold(Term,UTerm):-
%% 	Term=..[Head|Params],
%% 	head_module(Head,Module),
%% 	head_name(Head,Name),
%% 	(
%% 	    (
%% 		xmg_modules_def:module_def(Module,'ADisj'),
%% 		unfold(Name,Params,UTerm)
%% 	    )
%% 	;
%% 	(
%% 	    not(xmg_modules_def:module_def(Module,'ADisj')),
%% 	    xmg_modules:get_module(Module,unfolder,UModule),
%% 	    UModule:unfold(Term,UTerm)
%% 	)
%%     ),!.

%% unfold(Rule,_):- 
%% 	throw(xmg(unfolder_error(no_unfolding_rule(adisj,Rule)))),	
%% 	!.

%% head_module(Head,Module):-
%% 	atomic_list_concat(A,'-',Head),
%% 	A=[Module|_],!.

%% head_name(Head,Name):-
%% 	atomic_list_concat(A,'-',Head),
%% 	A=[_,Name],!.
