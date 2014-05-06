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


:-module(xmg_brick_mg_accs).
:- use_module(edcg, 'xmg/brick/mg/edcg.yap', all).
:-edcg:thread(constraints,edcg:queue).
:-edcg:thread(vars,edcg:table).
:-edcg:thread(consts,edcg:table).
:-edcg:thread(name,edcg:counter).

%%:-multifile(xmg:unfold_stmt/1).
:-multifile(xmg:unfold_stmt/9).
%%:-multifile(xmg:unfold_expr/2).
:-multifile(xmg:unfold_expr/10).
:-multifile(xmg:unfold_dimstmt/10).

:-edcg:weave([constraints,vars,consts,name],[xmg:unfold_stmt/1,xmg:unfold_dimstmt/2,xmg:unfold_expr/2, xmg:unfold_exprs/2,xmg:new_target_var/2,xmg:new_target_var/1]).



xmg:new_target_var(v(Name),Prefix) :--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),
	vars::tput(Name,_),!.

xmg:new_target_var(v(Name)):--
	name::incr,
	name::get(Get),
	atomic_concat(['XMG_VAR_',Get],Name),
	vars::tput(Name,_),!.



xmg:unfold_exprs([],[]) :-- !.
xmg:unfold_exprs([E|Es],[R|Rs]) :--
    (
	xmg:unfold_expr(E,R)->true
    ;
	xmg:send(info,'\nCould not unfold expr'),
	xmg:send(info,E),
	fail
	),
    xmg:unfold_exprs(Es,Rs).

%% ============================================================================
%% provide a simpler way for bricks to use xmg accs.
%% A file unfolder.yap now simply needs to do:
%%
%% :- xmg:unfolder_accs.
%% ============================================================================

unfolder_accs([xmg_brick_mg_accs:constraints,
	       xmg_brick_mg_accs:name,
	       xmg_brick_mg_accs:vars,
	       xmg_brick_mg_accs:consts]).

:- multifile user:term_expansion/2.

term_expansion((:- xmg:unfolder_accs), R) :-
    !, unfolder_accs(L), edcg:term_expansion((:- edcg:using(L)), R).

user:term_expansion(X,Y) :- xmg_brick_mg_accs:term_expansion(X,Y).

term_expansion((:- xmg:edcg), R) :-
    !, R=(:- use_module(edcg, 'xmg/brick/mg/edcg.yap', all)).
