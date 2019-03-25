%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2015  Simon Petitjean

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

:-module(xmg_brick_morphlp_generator).

:-xmg:edcg.
:-xmg:generator_accs.

:-edcg:using(xmg_brick_mg_generator:decls).


xmg:generate_instr((v(TF),morphlp:field(c(F)),Dim)):--
	decls::tget(TF,TV),
	code::enq(xmg_brick_morphlp_engine:ifield(TV,F)),
	Acc=..['::',xmg_acc:Dim,put(TV)],
        code::enq(Acc),!.

xmg:generate_instr((v(Field),morphlp:feats(v(Feats)))):--
	decls::tget(Field,VField),
	decls::tget(Feats,VFeats),
	code::enq(xmg_brick_morphlp_engine:ifieldfeats(VField,VFeats)),
	!.

xmg:generate_instr((morphlp:eq(c(F),c(V)),Dim)):--
	Acc=..['::',xmg_acc:Dim,put(eq(F,V))],
	code::enq(Acc),!.


xmg:generate_instr((morphlp:fieldprec(c(F1),c(F2)),Dim)):--
	Acc=..['::',xmg_acc:Dim,put(fieldprec(F1,F2))],
	code::enq(Acc),!.

xmg:generate_instr((morphlp:infield(c(F),v(V)),Dim)):--
	decls::tget(V,VV),
	Acc=..['::',xmg_acc:Dim,put(infield(F,VV))],
	code::enq(Acc),!.
xmg:generate_instr((morphlp:infield(c(F),c(V)),Dim)):--
	Acc=..['::',xmg_acc:Dim,put(infield(F,V))],
	code::enq(Acc),!.
