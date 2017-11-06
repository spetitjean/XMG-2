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

:- module(xmg_solver_frame, []).

solve(Frames,Frames).

solve(prepared(Nodes, Edges),solution(Tree)):-
	xmg_compiler:send(info,' solving frame '),
	%%check_vars(Nodes,Edges),
	%%xmg_compiler:send(info,' vars checked '),
	find_root(Nodes,Edges,Root),
	make_tree(Root,Edges,Tree),
	xmg_compiler:send(info,'\n frame solved\n').
		
	%%xmg_compiler:send(info,Tree).
	%%print_tree(Tree).


find_root([Node],[],Node):-!.
find_root(Nodes,[],_):-
	xmg_compiler:send(info,'no root found, candidates were: '),
	print_nodes(Nodes),
	xmg_compiler:send_nl(info,2),false,
	!.
find_root(Nodes,[edge(_,N,_)|T],Root):-
	%%xmg_compiler:send(debug,N),
	no_root(Nodes,N,NNodes),
	%%xmg_compiler:send(debug,NNodes),
	%%xmg_compiler:send_nl(info,3),
	
	find_root(NNodes,T,Root),!.

no_root([],_,[]):-!.
no_root([H|T],H1,T):-
	H==H1,!.
no_root([H|T],H1,[H|T1]):-
	no_root(T,H1,T1),!.

make_tree(Root,Edges,tree([],Root,Children)):-
	find_children(Root,Edges,Edges,Children,_),!.

find_children(_,_,[],[],[]):-!.
find_children(Root,Edges,[edge(N1,N2,P)|T],[tree(Label,N2,Children)|T1],Labels):-
	Root==N1,!,
	%% xmg_compiler:send(debug,'searching '),
	%% xmg_compiler:send(debug,N2),
	%% xmg_compiler:send(debug,Edges),
	%% xmg_compiler:send_nl(info,2),
	%%xmg_compiler:send(info,P),
	get_label(P,Label),
	check_subtype(N1,N2),
	find_children(N2,Edges,Edges,Children,_),
	find_children(Root,Edges,T,T1,TLabels),
	add_label(N1-Label,TLabels,Labels),!.
find_children(Root,Edges,[_|T],T1,Labels):-
	find_children(Root,Edges,T,T1,Labels),!.

print_tree(tree(node(P,_,N),C)):-
	xmg_nodename_frame:nodename(N,Name),
	xmg_compiler:send(info,Name),
	xmg_h_avm:h_avm(P,HP),
	xmg_compiler:send(info,HP),
	print_children(C),!.

print_children([]):- !.
print_children([H|T]):-
	print_tree(H),
	print_children(T),!.

	

get_label(P,L):-
	lists:member(id(label,_)-id(L,_),P),!.
get_label(_,none):- !.


add_label(_-none,Labels,Labels):-!.
add_label(Node-Label,Labels,[Label|Labels]):- 
	lists:member(Node1-Label,Labels),
	not(Node==Node1),!,
	xmg_compiler:send(info,'\n error in labels: multiple '),
	xmg_compiler:send(info,Label),
	xmg_compiler:send(info,'\n'),
	false,
	!.
add_label(Node-Label,Labels,[Node-Label|Labels]):- !.


check_vars([],_):- !.
check_vars([Node|NT],Edges):-
	check_var(Node,NT,Edges),!,
	check_vars(NT,Edges),!.

check_var(Node,Nodes,Edges):-
	get_var(Node,Var),!,
	get_eq_nodes(Var,Nodes,ENodes),!,
	check_identifiabilities(Node,ENodes,Edges),!.

get_var(node(A,_,_),Var):-
	xmg_h_avm:h_avm(A,AVMA),
	lists:member(var-Var,AVMA),!.
get_var(_,none):-!.


get_eq_nodes(Var,[Node|Nodes],[Node|Nodes1]):-
	var(Var),
	get_var(Node,Var1),
	Var==Var1,
	get_eq_nodes(Var,Nodes,Nodes1),!.
get_eq_nodes(Var,[_|Nodes],Nodes1):-
	var(Var),
	get_eq_nodes(Var,Nodes,Nodes1),!.
get_eq_nodes(none,_,[]):-!.

check_identifiabilities(_,[],_):- !.
check_identifiabilities(Node,[Node1,Nodes],Edges):-
	check_identifiability(Node,Node1,Edges),!,
	chek_identifiabilities(Node,Nodes,Edges),!.

check_identifiability(Node1,Node2,Edges):-
	%% check nodes are unifiable
	not(not(Node1=Node2)),
	%% check no incoming or outcoming edges have redundant labels
	check_incoming(Node1,Node2,Edges),
	check_outcoming(Node1,Node2,Edges),
	!.
check_identifiability(Node1,Node2,_):-
	xmg_compiler:send(info,'  identifiability failed  '),
	xmg_compiler:send(info,Node1),
	xmg_compiler:send(info,Node2),

	!.
	
check_incoming(Node1,Node2,Edges):-
	get_incoming(Node1,Edges,In1),
	get_incoming(Node2,Edges,In2),
	compatible_edges(In1,In2),!.

check_outcoming(Node1,Node2,Edges):-
	get_outcoming(Node1,Edges,Out1),
	get_outcoming(Node2,Edges,Out2),
	compatible_edges(Out1,Out2),!.

get_incoming(_,[],[]):- !.
get_incoming(Node,[edge(Node1,Node,P)|T],[Node1-L|T1]):- 
	!,
	get_label(P,L),
	get_incoming(Node,T,T1),!.
get_incoming(Node,[_|T],T1):- 
	get_incoming(Node,T,T1),!.

get_outcoming(_,[],[]):- !.
get_outcoming(Node,[edge(Node,Node1,P)|T],[Node1-L|T1]):- 
	!,
	get_label(P,L),
	get_outcoming(Node,T,T1),!.
get_outcoming(Node,[_|T],T1):- 
	get_outcoming(Node,T,T1),!.

	
	
compatible_edges(_,[]):- !.
compatible_edges(Edges,[H|T]):-
	add_label(H,Edges,NEdges),
	compatible_edges(NEdges,T),!.


check_subtype(Node1,Node2):-
	get_type(Node1,Type1),
	get_type(Node2,Type2),
	xmg_typer_hierarchy:subtype(_,Type2,Type1),!.
check_subtype(Node1,_):-
	get_type(Node1,none),!.
check_subtype(_,Node2):-
	get_type(Node2,none),!.
check_subtype(Node1,Node2):-
	get_type(Node1,Type1),
	get_type(Node2,Type2),	
	xmg_compiler:send(info,Type1),
	xmg_compiler:send(info,' is not a subtype of '),
	xmg_compiler:send(info,Type2),!.


get_type(node(A,_,_),Var):-
	xmg_h_avm:h_avm(A,AVMA),
	lists:member(ftype-Var,AVMA),!.
get_type(_,none):-!.

print_nodes([]):-!.
print_nodes([node(A,_,C)|T]):-
	xmg_h_avm:h_avm(A,_),
	%%xmg_compiler:send(info,AVMA),
	xmg_nodename_frame:nodename(C,NC),
	xmg_compiler:send(info,NC),
	print_nodes(T),!.






