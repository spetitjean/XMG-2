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

:-module(xmg_brick_lemma_typer).

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_typer:types]).

%% statement type with default parameters
xmg:stmt_type(lemma,Dim,Dim:lemma(FeatsType)):-!.
%% statement type with given parameters
xmg:stmt_type_constr(lemma,lemma).


xmg:type_stmt(lemma:feat(Att,Val),Lemma:lemma(FeatsType)):--
	!.

xmg:type_stmt(lemma:equation(_,_,_),Lemma:lemma(FeatsType)):--
	     !.

xmg:type_stmt(lemma:coanchor(_,_,_),Lemma:lemma(FeatsType)):--
	!.




xmg:type_stmt(lemma:X,_):--
	xmg:send(info,'\n\nDid not type lemma statement:\n'),
	xmg:send(info,X),!,
	fail.

