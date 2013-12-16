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

:- module(xmg_brick_colors_preparer, []).

prepare(Syn,prepared(Colors,SynNC)):-  
	write_colors_or_not(Syn,Colors,SynNC),
	!.

write_colors_or_not(Nodes,Colors,NodesNC):-
	xmg_brick_mg_compiler:principle(color),!,
	write_colors(Nodes,Colors,NodesNC),!.
write_colors_or_not(Nodes,[],Nodes):- !.

write_colors([],[],[]):- !.

write_colors([node(Prop,Feat,Name)|T],[H1|T1],[node(PropNC,Feat,Name)|T2]):-
	write_color(Name,Prop,H1),!,
	no_color(Prop,PropNC),!,
	write_colors(T,T1,T2),!.

write_colors([H|T],Colors,[H|T1]):-
	write_colors(T,Colors,T1),!.

write_color(Name,PropAVM,color(C)):-
	xmg_brick_avm_avm:avm(PropAVM, Props),!,
	xmg_brick_syn_nodename:nodename(Name,NodeName),!,
	search_color(NodeName,Props,C),!.


search_color(Name,[],none):-
	throw(xmg(principle_error(undefined_color(Name)))),	

	!.

search_color(_,[color-const(C,_)|_],C):-!.

search_color(Name,[_|T],C):-
	search_color(Name,T,C),!.




no_color(AVM,NCAVM):-
	xmg_brick_avm_avm:avm(AVM,LAVM),
	lists:member(color-C,LAVM),!,
	lists:delete(LAVM,color-C,NCLAVM),
	xmg_brick_avm_avm:avm(NCAVM,NCLAVM),!.

no_color(AVM,AVM):-
	!.

