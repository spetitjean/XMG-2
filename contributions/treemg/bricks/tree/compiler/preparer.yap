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

:- module(xmg_brick_tree_preparer).
:- use_module(library(apply), [include/3]).

:- xmg:edcg.
:-edcg:thread(name,edcg:counter).
:-edcg:using(xmg_brick_mg_preparer:preparer).
:-edcg:weave([name],[count/7,new_name/1]).

new_name(Name):--
	name::incr,
	name::get(N),
	atomic_concat(['X',N],Name).

prepare(syn(Syn,Trace),prepared(Family,Noteqs,Nodes,Doms,Precs,NotUnifs,Relations,NodeNames,plugins(OutPlugins),TableInvF,NodeList)):--  
	%%lists:remove_duplicates(Syn,SynD),
        remove_node_duplicates(Syn,Syn,SynD), 
        %%print_nodes(SynD),
	xmg_table:table_new(TableIn),
	xmg_table:table_new(TableInv),
	
	count(SynD,Nodes,Doms,Precs,0,TableIn,TableOut) with name(_),

	add_constraints(SynD,SynD,[],SynDC),

	%% écrire l'id de la classe courante
	Trace=[Family|_],

	%%xmg:send(info,TableOut),
	
	count_noteqs(SynDC,Noteqs),

	%% écrire les couples de noeuds qui ne peuvent pas unifier

	write_notunif(SynDC,NotUnifs,TableOut) ,

	%% écrire les lits

	write_lits(SynD,Relations,TableOut),

	include(is_node, SynD, GetNodes),
	
	xmg:get_plugins(tree,Plugins,OutPlugins),
	
	xmg:send(info,'\nPlugins: '),
	xmg:send(info,Plugins),

	xmg_table:table_new(Extras),
	xmg_table:table_put(Extras,nodes,GetNodes,TNodes),

	%%xmg:prepare_plugins(GetNodes,Plugins,prepared(OutPlugins,SynNC)) with preparer(TNodes,FNodes),
	%% To be removed when plugins are back (when YAP imports are cleaned):
	SynNC=GetNodes,

	xmg:send(info,'\nPlugins ignored'),
	
	%% xmg_brick_colors_preparer:prepare(SynD,prepared(Colors,SynNC)),
	%% xmg_brick_rank_preparer:prepare(SynNC,prepared(Ranks,SynNC)),
	%% xmg_brick_tag_preparer:prepare(SynNC,prepared(TagOps,SynNC)),
	%% xmg_brick_unicity_preparer:prepare(SynNC,prepared(Unicities,SynNC)),

	write_nodes(SynNC,NodeNames,NodeList,1,TableOut),

	%%Unicities=[],
	xmg_table:table_entries(TableOut,TableList),
	inverse_table(TableList,TableInv,TableInvF),

	!.

remove_node_duplicates([],_,[]).
remove_node_duplicates([Node|T],Syn,H1):-
    is_node(Node),
    node_in(Node,T),!,
    xmg:send(debug,'\nRemoving one duplicate node: '),
    xmg:send(debug,Node),
    remove_node_duplicates(T,T,H1),!.
remove_node_duplicates([H|T],Syn,[H|T1]):-
    remove_node_duplicates(T,Syn,T1),!.
node_in(node(_,_,N),[node(_,_,N1)|_]):-
    N==N1,!.
node_in(Node,[_|T]):-
    node_in(Node,T),!.

is_node(node(_,_,_)).


write_notunif([],[],_):--
	!.

write_notunif([noteq(A,B)|T],[noteq(A1,B1)|T1],Table):--
	xmg_table:table_get(Table,A,A1),
	xmg_table:table_get(Table,B,B1),
	write_notunif(T,T1,Table),!.
	

write_lits([],[],Table):--
	!.

write_lits([H|T],L,Table):--
	write_lit(H,H1,Table),
	write_lits(T,T1,Table),
	(	
	    H1='none' 
	-> 
	(
	    L=T1
	)
    ;
	L=[H1|T1]
    ),
	!.

write_lit(node(PropAVM,FeatAVM,N),'none',Table):--
	!.

write_lit(dom(node(_,_,A),'->',node(_,_,C),_),vstep(one,A2,C2),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(dom(node(_,_,A),'-L>',node(_,_,C),_),vstep(oneleft,A2,C2),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(dom(node(_,_,A),'-R>',node(_,_,C),_),vstep(oneright,A2,C2),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(dom(node(_,_,A),'->+',node(_,_,C),_),vstep(more,A2,C2),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(dom(node(_,_,A),'->*',node(_,_,C),_),vstep(any,A2,C2),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(prec(node(_,_,A),'>>',node(_,_,C),_),hstep(one,A2,C2),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(prec(node(_,_,A),'>>+',node(_,_,C),_),hstep(more,A2,C2),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(prec(node(_,_,A),'>>*',node(_,_,C),_),hstep(any,A2,C2),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(notprec(node(_,_,A),'>>',node(_,_,C),_),not(hstep(one,A2,C2)),Table):--
	xmg_brick_syn_nodename:nodename(A,A1),
	xmg_table:table_get(Table,A1,A2),
	xmg_brick_syn_nodename:nodename(C,C1),
	xmg_table:table_get(Table,C1,C2),
	!.

write_lit(synarity(node(A,_,_),node(_,_,C)),'none',Table):--
	 !.

write_lit(Lit,_,_):--
	 xmg:send(info,'\nUnsupported litteral: '),
         xmg:send(info,Lit),
         false,
	 !.

write_nodes([],[],[],_,Table):--
	!.

write_nodes([H|T],L,NodeList,N,Table):--
	write_node(H,H1,Table),
	(
	    H1='none'->
	    (
		L=T1, 
		NodeList=NodeList1,
		M is N
	    );
	    (
		L=[H1|T1], 
		NodeList=[N-H|NodeList1],
		M is N+1
	    )	
	),
	write_nodes(T,T1,NodeList1,M,Table),
	!.

write_node(node(PropAVM,FeatAVM,N),N2,Table):--
	xmg_brick_syn_nodename:nodename(N,N1),
	xmg_table:table_get(Table,N1,N2),
	!.

write_node(A,'none',Table):-- !.





count([],0,0,0,_,Table,Table):-- !.

count([node(_,_,N)|T],Nodes,Doms,Precs,I,TableIn,TableOut):--
	J is I+1,
	xmg_brick_syn_nodename:nodename(N,Nodename),
	xmg_table:table_get(TableIn,Nodename,_),
	xmg:send(debug,Nodename),
	xmg:send(debug,' CONFLICT '),!,

	new_name(New),
	xmg_brick_syn_nodename:nodename(M,New),
	M=N,
	xmg_brick_syn_nodename:nodename(N,NewNodename),
	xmg:send(debug,' New ID given\n'),
	xmg_table:table_put(TableIn,NewNodename,J,Table),
	%%xmg:send(info,Table),
	count(T,NodesR,Doms,Precs,J,Table,TableOut),
	Nodes is NodesR +1,!.

count([node(_,_,N)|T],Nodes,Doms,Precs,I,TableIn,TableOut):--
	J is I+1,!,
	xmg_brick_syn_nodename:nodename(N,Nodename),
	xmg_table:table_put(TableIn,Nodename,J,Table),
	count(T,NodesR,Doms,Precs,J,Table,TableOut),
	Nodes is NodesR +1,!.



count([dom(_,_,_,_)|T],Nodes,Doms,Precs,I,Table,TableOut):--
	count(T,Nodes,DomsR,Precs,I,Table,TableOut),
	Doms is DomsR +1,!.

count([prec(_,_,_,_)|T],Nodes,Doms,Precs,I,Table,TableOut):--
	count(T,Nodes,Doms,PrecsR,I,Table,TableOut),
	Precs is PrecsR +1,!.

count([H|T],Nodes,Doms,Precs,I,Table,TableOut):--
	count(T,Nodes,Doms,Precs,I,Table,TableOut),!.

count_noteqs([],0):- !.

count_noteqs([_|T],Noteqs):-
	count_noteqs(T,NoteqsR),
	Noteqs is NoteqsR +1,!.


add_constraints([],[],L,L):- !.

add_constraints([_|T],[],L,L1):-
	add_constraints(T,T,L,L1),!.

add_constraints([node(A,B,C)|H],[node(A1,B1,C1)|H1],L,L1):-
	!,
	add_constraint(node(A,B,C),node(A1,B1,C1),L,L2),
	add_constraints([node(A,B,C)|H],H1,L,L3),
	lists:append(L2,L3,L1),
	!.

add_constraints([_|H],[node(A1,B1,C1)|H1],L,L1):-
	add_constraints(H,[node(A1,B1,C1)|H1],L,L1),!.

add_constraints([node(A,B,C)|H],[_|H1],L,L1):-
	add_constraints([node(A,B,C)|H],H1,L,L1),!.

add_constraints([_|H],[_|H1],L,L1):-
	add_constraints(H,H1,L,L1),!.



add_constraint(node(Props1,Feats1,_),node(Props2,Feats2,_),L,L):-
	no_color(Props1,PropsNC1),
	no_color(Props2,PropsNC2),
	not(not(PropsNC1=PropsNC2)),
	not(not(Feats1=Feats2)),!.
add_constraint(node(_,Feats1,Node1),node(_,Feats2,Node2),L,[noteq(Nodename1,Nodename2)|L]):-

	xmg_brick_syn_nodename:nodename(Node1,Nodename1),
	xmg_brick_syn_nodename:nodename(Node2,Nodename2),

	%% xmg:send(info,Nodename1),
	%% xmg:send(info,'\n'),
	%% xmg:send(info,Nodename2),
	%% xmg_brick_avm_avm:print_avm(Feats1),
	%% xmg_brick_avm_avm:print_avm(Feats2),
	%% xmg:send(info,'\n\n'),
	!.

inverse_table([],T,T):-!.
inverse_table([H-H1|T],Table,Table2):-
	xmg_table:table_put(Table,H1,H,Table1),
	inverse_table(T,Table1,Table2),!.

no_color(AVM,NCAVM):-
	xmg_brick_avm_avm:avm(AVM,LAVM),
	lists:member(color-C,LAVM),!,
	lists:delete(LAVM,color-C,NCLAVM),
	xmg_brick_avm_avm:avm(NCAVM,NCLAVM),!.

no_color(AVM,AVM):-
	!.

print_nodes([]):- !.
print_nodes([H|T]):-
	print_node(H),!,
	print_nodes(T),!.

print_node(node(P,F,N)):-
	xmg:send(info,node(P,F,N)),
	xmg:send_nl(info),
	xmg_brick_syn_nodename:nodename(N,Name),
	xmg_brick_avm_avm:avm(P,AP),
	xmg_brick_avm_avm:avm(F,AF),
	xmg:send(info,Name),
	xmg_brick_avm_avm:print_avm(P),
	xmg_brick_avm_avm:print_avm(F),
	
	xmg:send_nl(info,2),!.
print_node(H):-
	xmg:send(info,H),
	xmg:send_nl(info,2),!.
