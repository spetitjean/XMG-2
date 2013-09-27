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

:- module(xmg_preparer_frame, []).

prepare(Frame,prepared(Nodes,Edges)):-  
	lists:remove_duplicates(Frame,FrameD),
	separate(FrameD,Nodes,Edges),
	!.

separate([],[],[]):-!.
separate([node(A,B,C)|T],[node(A,B,C)|T1],T2):-
	separate(T,T1,T2),!.
separate([edge(N1,N2,P)|T],T1,[edge(N1,N2,P)|T2]):-
	check_node(N1),
	check_node(N2),
	separate(T,T1,T2),!.
separate([H|T],T1,T2):-
	xmg_compiler:send(info,'problem with '),
	xmg_compiler:send(info,H),
	xmg_compiler:send_nl(info,2),!,
	false,!,
	separate(T,T1,T2),
	!.


check_node(V1):-
	not(var(V1)),!.


