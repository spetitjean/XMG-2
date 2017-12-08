%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2016  Simon Petitjean

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

:-module(xmg_brick_lemma_generator).

:-xmg:edcg.
:-xmg:generator_accs.

:-edcg:using(xmg_brick_mg_generator:decls).

xmg:generate_instr((lemma:feat(c(F),v(V)),Dim)):--
	decls::tget(V,VV),
		  
	%%Set=..['::',xmg_acc:Dim,get(VAVM)],
        %%code::enq(Set),

	
	
	Acc=..['::',xmg_acc:Dim,put(feat(F,VV))],
	code::enq(Acc),
	!.
xmg:generate_instr((lemma:feat(c(F),c(C)),Dim)):--
	Acc=..['::',xmg_acc:Dim,put(feat(F,C))],
	code::enq(Acc),!.
xmg:generate_instr((lemma:equation(c(P1),v(P2),c(P3)),Dim)):--
	decls::tget(P2,V),	
	Acc=..['::',xmg_acc:Dim,put(equation(P1,V,P3))],
        code::enq(Acc),!.
xmg:generate_instr((lemma:equation(c(P1),c(P2),v(P3)),Dim)):--
	decls::tget(P3,V),	
	Acc=..['::',xmg_acc:Dim,put(equation(P1,P2,V))],
        code::enq(Acc),!.
xmg:generate_instr((lemma:equation(c(P1),c(P2),c(P3)),Dim)):--
	Acc=..['::',xmg_acc:Dim,put(equation((P1,P2,P3),VV))],
        code::enq(Acc),!.
xmg:generate_instr((lemma:coanchor(c(C),v(V),c(C1)),Dim)):--
	decls::tget(V,VV),
	Acc=..['::',xmg_acc:Dim,put(coanchor(C,VV,C1))],
	code::enq(Acc),!.
xmg:generate_instr((lemma:coanchor(c(C),c(C2),c(C1)),Dim)):--
	Acc=..['::',xmg_acc:Dim,put(coanchor(C,C2,C1))],
	code::enq(Acc),!.
