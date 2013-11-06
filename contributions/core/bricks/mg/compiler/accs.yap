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
:-edcg:thread(vars,edcg:queue).
:-edcg:thread(consts,edcg:queue).
:-edcg:thread(name,edcg:counter).

%%:-multifile(xmg:unfold_stmt/1).
:-multifile(xmg:unfold_stmt/9).
%%:-multifile(xmg:unfold_expr/2).
:-multifile(xmg:unfold_expr/10).

:-edcg:weave([name],[new_target_var/2,new_target_var/1]).
:-edcg:weave([constraints,vars,consts,name],[xmg:unfold_stmt/1,xmg:unfold_expr/2]).

new_target_var(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),!.

new_target_var(Name):--
	name::incr,
	name::get(Get),
	atomic_concat(['XMG_VAR_',Get],Name),!.