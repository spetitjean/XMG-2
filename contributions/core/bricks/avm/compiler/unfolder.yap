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

:- xmg:edcg.

:-multifile(unfold_feat/10).

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).
:- edcg:weave([constraints,name,vars,consts],[unfold_expr/2,unfold_feats/2,unfold_feat/2]).

xmg:unfold_expr(avm:avm(Coord, Feats), Target) :--
	constraints::enq((Target,avm:avm(Coord))),
	unfold_feats(Feats, Target)	.

unfold_feats([], _):-- !.
unfold_feats([Feat|Feats], Target) :--
	unfold_feat(Feat, Target),
	unfold_feats(Feats, Target).

unfold_feat(avm:feat(F,V), Target) :--
	%%xmg:new_target_var(Target1),
        %%xmg:new_target_var(Target2),
	xmg:new_target_var(Value),
	xmg:unfold_expr(F, Target1),
	xmg:unfold_expr(V, Target2),
	%%constraints::enq(eq(Value,Target2)),
	(
	    var(Target2)
	-> 
	    Value=Target2
       ;
	    true
	),
    
	constraints::enq((Target,avm:feat(Target1,Target2))),!.


xmg:unfold_expr(avm:dot(Var1,Var2),Target):--
	xmg:new_target_var(Target),	
	xmg:unfold_expr(Var1,T1),
	xmg:unfold_expr(Var2,c(T2)),
	constraints::enq((Target,avm:dot(T1,c(T2)))),
	!.




