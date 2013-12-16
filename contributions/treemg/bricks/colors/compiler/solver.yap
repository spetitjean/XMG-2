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

:- module(xmg_brick_colors_solver, []).

:- use_module(library(gecode)).
:- use_module('xmg/brick/tree/compiler/dominance').


:- op(500, xfx, ':=:').


colors(Space,NodeList,Colors):-
	%xmg_compiler:send(info,Colors),
	do_cposts(Space,NodeList,Colors,1).



do_cposts(_,[],[],N):- !.

do_cposts(Space,[Node|T],[color(red)|TC],N):-
	post(Space,Node,isred,N),
	M is N+1,
	do_cposts(Space,T,TC,M),!.

do_cposts(Space,[Node|T],[color(black)|TC],N):-
	post(Space,Node,isblack,N),
	M is N+1,
	do_cposts(Space,T,TC,M),!.

do_cposts(Space,[Node|T],[color(white)|TC],N):-
	post(Space,Node,iswhite,N),
	M is N+1,
	do_cposts(Space,T,TC,M),!.

do_cposts(Space,[Node|T],[color(none)|TC],N):-
	xmg_compiler:send(info,'unknown color '),
	post(Space,Node,isnone,N),
	M is N+1,
	do_cposts(Space,T,TC,M),!.


post(Space,X,isred,XN):-
	IntVar:=intvar(Space,XN,XN),
	RB :=: rb(X),
	Space += rel(RB,'SRT_EQ', IntVar),
	Eq :=: eq(X),
	Space += cardinality(Eq,1,1),
	!.

post(Space,X,isblack,XN):-
	IntVar:=intvar(Space,XN,XN),
	RB :=: rb(X),
	Space += rel(RB,'SRT_EQ', IntVar),
	!.

post(Space,X,iswhite,XN):-
	IntVar:=intvar(Space,XN,XN),
	RB :=: rb(X),
	Space += rel(RB,'SRT_DISJ', IntVar),
	Eq :=: eq(X),
	xmg_tree:nbNodes(Nodes),
	Space += cardinality(Eq,2,Nodes),
	!.

post(Space,X,isnone,XN):-
	Eq :=: eq(X),
	xmg_tree:nbNodes(Nodes),
	Space += cardinality(Eq,2,Nodes),
	!.
