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

:-module(xmg_brick_polAvm_unfolder).

:- xmg:edcg.


:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).
%%:- edcg:weave([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts],[unfold_feat/2]).


xmg_brick_avm_unfolder:unfold_feat(polAvm:feat(F,V,token(_,Pol)), Target) :--
	xmg:new_target_var(Value),
	xmg:new_target_var(PolVar),

	xmg:unfold_expr(F, Target1),
	xmg:unfold_expr(V, Target2),
	(
	    var(Target2)
	-> 
	    Value=Target2
       ;
	    true
	),
	constraints::enq((PolVar,polAvm:polarity(Pol))),
	constraints::enq((Target,polAvm:feat(Target1,Target2,PolVar))),
	!.


