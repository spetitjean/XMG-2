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

:- module(xmg_unicity, []).

%:- use_module(library(gecode)).
:- use_module(xmg_dominance).

:- op(500, xfx, ':=:').

post_unicities(Space,Nodelist,IntVars,[]):- !.
post_unicities(Space,NodeList,IntVars,[U1|UT]):-
	%%xmg_compiler:send(info,' one unicity '),
	%%xmg_compiler:send(info,U1),
	post_unicities_first(Space,NodeList,IntVars,U1,1),
	%%xmg_compiler:send(info,' one done '),
	post_unicities(Space,NodeList,IntVars,UT),!.

post_unicities_first(Space,[],IntVars,[],_):- !.
post_unicities_first(Space,[Node|T],IntVars,['true'|TU],I1):-
	I2 is I1+1,
	post_unicities_others(Space,T,TU,IntVars,Node,I1,I2),!.
post_unicities_first(Space,[Node|T],IntVars,['false'|TU],I1):-
	I2 is I1 +1,
	post_unicities_first(Space,T,IntVars,TU,I2),!.



post_unicities_others(Space,[],[],IntVars,_,_,_):- !.
post_unicities_others(Space,[Node|T],[true|TU],IntVars,NodeU,I1,I2):-
	assert_node(Node),
	assert_node(NodeU),

	%% EqX       :=: eq(Node),      
	%% EqY       :=: eq(NodeU),      
	%% Space += rel(EqX,'SRT_EQ',EqY),

	xmg_tree:get_rel(I1,I2,IntVars,IntVar),
	Space += dom(IntVar,1),
    
	I3 is I2+1,
	%%xmg_compiler:send(info,' posted unicity'),

	%% post eq(Node)=eq(NodeU)
	post_unicities_others(Space,T,TU,IntVars,NodeU,I1,I3),!.
post_unicities_others(Space,[Node|T],[false|TU],IntVars,NodeU,I1,I2):-
	I3 is I2+1,
	post_unicities_others(Space,T,TU,IntVars,NodeU,I1,I3),!.

