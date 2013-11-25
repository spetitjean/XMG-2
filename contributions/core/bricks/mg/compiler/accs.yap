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



xmg:new_target_var(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),
	vars::tput(Name,_),!.

xmg:new_target_var(Name):--
	name::incr,
	name::get(Get),
	atomic_concat(['XMG_VAR_',Get],Name),
	vars::tput(Name,_),!.



xmg:unfold_exprs([],[]) :-- !.
xmg:unfold_exprs([E|Es],[R|Rs]) :--
    xmg:unfold_expr(E,R),
    xmg:unfold_exprs(Es,Rs).