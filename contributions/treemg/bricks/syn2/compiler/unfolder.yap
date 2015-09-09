%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2012  Simon Petitjean

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


:-module(xmg_brick_syn2_unfolder).

:- xmg:edcg.

:- edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars,xmg_brick_mg_accs:consts]).

:- edcg:weave([constraints,name,vars,consts],[unfold_lex/3]).


xmg:unfold_dimstmt(Syn,syn:node(N,P,F,L)):--
       xmg_brick_syn_unfolder:unfold_node(Syn,syn:node(N,P,F),UN),
       unfold_lex(Syn,L,UN),
       !.


unfold_lex(Syn,some(syn2:lex(L)),UN):--
	  xmg:unfold_expr(L,c(UL)),
        xmg_brick_syn_unfolder:unfold_node(Syn,syn:node(none,avm:avm(_,[avm:feat(token(_,id(mark)),token(_,id(lex)))]),avm:avm(_,[avm:feat(token(_,id(cat)),token(_,id(UL)))])),LN),
	constraints::enq((syn:dom(UN,'->',LN,C),Syn)),
	!.
unfold_lex(Syn,none,_):--!.

xmg_brick_syn_unfolder:unfold_children(Syn,URoot,some(Children),UChild):--
	xmg_brick_syn_unfolder:unfold_children(Syn,URoot,Children,UChild),
        !.
xmg_brick_syn_unfolder:unfold_children(Syn,URoot,none,none):--
	!.

xmg_brick_syn_unfolder:unfold_node(Syn,syn:node(N,P,F,L),UN):--
	 xmg_brick_syn_unfolder:unfold_node(Syn,syn:node(N,P,F),UN),
         unfold_lex(Syn,L,UN),
	!.

