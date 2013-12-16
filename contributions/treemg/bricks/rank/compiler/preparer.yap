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

:- module(xmg_brick_rank_preparer, []).

prepare(Syn,prepared(Ranks,Syn)):-  
	write_ranks(Syn,Ranks),
	!.

write_ranks([],[]):- !.

write_ranks([node(Prop,_,_)|T],[H1|T1]):-
	write_rank(Prop,H1),
	write_ranks(T,T1),!.

write_ranks([_|T],Ranks):-
	write_ranks(T,Ranks),!.

write_rank(PropAVM,rank(C)):-
	xmg_brick_avm_avm:avm(PropAVM, Props),
	search_rank(Props,C),
	!.

search_rank([],none):-
	!.

search_rank([rank-const(R,int)|_],R):-!.

search_rank([_|T],C):-
	search_rank(T,C),!.



