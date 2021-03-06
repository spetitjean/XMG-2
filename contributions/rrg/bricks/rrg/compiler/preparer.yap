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

:- module(xmg_brick_rrg_preparer, []).

:- xmg:edcg.
:-edcg:thread(name,edcg:counter).
:-edcg:weave([name],[count/7,check_unique_name/3,new_name/1]).

new_name(Name):--
	name::incr,
	name::get(N),
	atomic_concat(['X',N],Name).

prepare(syn(Syn,Trace),prepared(Family,Noteqs,Nodes,Doms,Precs,NotUnifs,NoParents,Relations,NodeNames,plugins(OutPlugins),TableInvF,NodeList)):--  
	lists:remove_duplicates(Syn,SynD),
	%%print_nodes(SynD),
	xmg_table:table_new(TableIn),
	xmg_table:table_new(TableInv),
	count(SynD,Nodes,Doms,Precs,0,TableIn,TableOut) with name(_),

	xmg:send(debug,'\nName mapping:\n'),
	xmg:send(debug,TableOut),

	add_constraints(SynD,SynD,[],SynDC),
	%%add_parent_constraints(SynD,SynD,[],SynPC),

	%% écrire l'id de la classe courante
	Trace=[Family|_],

	%%xmg:send(debug,TableOut),

	count_noteqs(SynDC,Noteqs),

	%% écrire les couples de noeuds qui ne peuvent pas unifier
	write_notunif(SynDC,NotUnifs,TableOut) ,


	%% écrire les literaux
	write_lits(SynD,Relations,TableOut),

	xmg:get_plugins(Plugins,OutPlugins),
	
	%%xmg:send(debug,'\nPlugins: '),
	%%xmg:send(debug,Plugins),

	prepare_plugins(SynD,Plugins,prepared(OutPlugins,SynNC)),

	%% xmg_brick_colors_preparer:prepare(SynD,prepared(Colors,SynNC)),
	%% xmg_brick_rank_preparer:prepare(SynNC,prepared(Ranks,SynNC)),
	%% xmg_brick_tag_preparer:prepare(SynNC,prepared(TagOps,SynNC)),
	%% xmg_brick_unicity_preparer:prepare(SynNC,prepared(Unicities,SynNC)),


	%% écrire les noeuds

	write_nodes(SynNC,NodeNames,NodeList,1,TableOut),


	%%Unicities=[],
	xmg_table:table_entries(TableOut,TableList),
	inverse_table(TableList,TableInv,TableInvF),

	%% lister les noeuds non dominés explicitements (ils sont soit la racine, soit unifiés avec des noeuds n'ayant pas cette propriété)

	write_noparents(Nodes,Relations,NoParents) ,

	%%xmg:send(debug,prepared(Family,Noteqs,Nodes,Doms,Precs,NotUnifs,NoParents,Relations,NodeNames,plugins(OutPlugins),TableInvF,NodeList)),
	%%false,

	!.

%% this should go somewhere else
xmg:get_plugins(TreePlugins,OutPlugins):-
	findall(P,xmg:principle(P,Args,Dims),Plugins),
	filter_rrg_plugins(Plugins,[],TreePlugins,OutPlugins),!.

filter_rrg_plugins([],_,[],[]).
filter_rrg_plugins([H|T],Mem,[NH|T1],[_|T2]):-
	is_rrg_plugin(H,NH),
	not(lists:member(NH,Mem)),!,
	filter_rrg_plugins(T,[NH|Mem],T1,T2).
filter_rrg_plugins([H|T],Mem,T1,T2):-
	filter_rrg_plugins(T,Mem,T1,T2),!.

%%is_rrg_plugin(tag,tag).
is_rrg_plugin(rrgcolor,rrgcolors).
%%is_rrg_plugin(rank,rank).
%%is_rrg_plugin(unicity,unicity).

prepare_plugins(Syn,[],prepared([],Syn)):- !.
prepare_plugins(Syn,[Plugin|T],prepared([Plugin-Out|TOut],NNSyn)):-
	prepare_plugin(Syn,Plugin,prepared(Out,NSyn)),
	prepare_plugins(NSyn,T,prepared(TOut,NNSyn)),!.

%% calls a preparer plugin named Plugin, which is located in the module xmg_brick_Plugin_preparer
prepare_plugin(Syn,Plugin,Out):-
	atom_concat(['xmg_brick_',Plugin,'_preparer'],Module),
	xmg:send(debug,Module),
	Prepare=..[prepare,Syn,Out],
	Do=..[':',Module,Prepare],
	Do,
	!.
prepare_plugin(Syn,Plugin,Out):-
	xmg:send(info,'\nUnknown plugin:'),
	xmg:send(info,Plugin),
	false,
	!.

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

write_lit(synarity(node(A,_,_),node(_,_,C)),'none',Table):--
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



check_unique_name(N,NewNodeName,TableIn):--
	xmg_brick_syn_nodename:nodename(N,Nodename),
	xmg_table:table_get(TableIn,Nodename,_),!,
	xmg:send(debug,Nodename),
	xmg:send(debug,' CONFLICT '),!,

	new_name(New),
	xmg_brick_syn_nodename:nodename(M,New),
	M=N,
	xmg_brick_syn_nodename:nodename(N,NewNodeName),
	xmg:send(debug,'\nNew ID given\n'),
	%%xmg:send(debug,NewNodeName),
	
	!.
check_unique_name(Node,NodeName,_):--
	xmg_brick_syn_nodename:nodename(Node,NodeName),!.

count([],0,0,0,_,Table,Table):-- !.

count([node(_,_,N)|T],Nodes,Doms,Precs,I,TableIn,TableOut):--
	J is I+1,!,
	%% xmg_brick_syn_nodename:nodename(N,Nodename),
	%% xmg_table:table_get(TableIn,Nodename,_),
	%% xmg:send(debug,Nodename),
	%% xmg:send(debug,' CONFLICT '),!,

	%% new_name(New),
	%% xmg_brick_syn_nodename:nodename(M,New),
	%% M=N,
	%% xmg_brick_syn_nodename:nodename(N,NewNodename),
	%% xmg:send(debug,' New ID given\n'),
	check_unique_name(N,NewNodename,TableIn),
	xmg_table:table_put(TableIn,NewNodename,J,Table),
	%%xmg:send(debug,Table),
	count(T,NodesR,Doms,Precs,J,Table,TableOut),
	Nodes is NodesR +1,!.

%% count([node(_,_,N)|T],Nodes,Doms,Precs,I,TableIn,TableOut):--
%% 	J is I+1,!,
%% 	xmg_brick_syn_nodename:nodename(N,Nodename),
%% 	xmg_table:table_put(TableIn,Nodename,J,Table),
%% 	count(T,NodesR,Doms,Precs,J,Table,TableOut),
%% 	Nodes is NodesR +1,!.



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
	add_constraint(node(A,B,C),node(A1,B1,C1),L,L2),!,
	add_constraints([node(A,B,C)|H],H1,L,L3),!,
	lists:append(L2,L3,L1),
	!.

add_constraints([_|H],[node(A1,B1,C1)|H1],L,L1):-
	!,
	add_constraints(H,[node(A1,B1,C1)|H1],L,L1),!.

add_constraints([node(A,B,C)|H],[_|H1],L,L1):-
	!,
	add_constraints([node(A,B,C)|H],H1,L,L1),!.

add_constraints([_|H],[_|H1],L,L1):-
	add_constraints(H,H1,L,L1),!.



add_constraint(node(Props1,Feats1,Node1),node(Props2,Feats2,Node2),L,L):-
	xmg:send(debug,'\n\nChecking noteq: '),
	xmg_brick_avm_avm:avm(Feats1,F1),
	xmg:send(debug,F1),
	xmg_brick_avm_avm:avm(Feats2,F2),
	xmg:send(debug,F2),
	
	no_color(Props1,PropsNC1),
	no_color(Props2,PropsNC2),
	not(not(PropsNC1=PropsNC2)),
	not(not(Feats1=Feats2)),
	xmg:send(debug,'\nUnif okay: '),
	xmg_brick_syn_nodename:nodename(Node1,Nodename1),
	xmg_brick_syn_nodename:nodename(Node2,Nodename2),

	xmg:send(debug,Nodename1),
	xmg:send(debug,', '),
	xmg:send(debug,Nodename2),
	!.
add_constraint(node(_,Feats1,Node1),node(_,Feats2,Node2),L,[noteq(Nodename1,Nodename2)|L]):-

	xmg_brick_syn_nodename:nodename(Node1,Nodename1),
	xmg_brick_syn_nodename:nodename(Node2,Nodename2),

	xmg:send(debug,'\nnoteq: '),
	xmg:send(debug,Nodename1),
	xmg:send(debug,', '),
	xmg:send(debug,Nodename2),
	%% xmg_brick_avm_avm:print_avm(Feats1),
	%% xmg_brick_avm_avm:print_avm(Feats2),
	%% xmg:send(debug,'\n\n'),
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


write_noparents(0,_,[]):-!.
write_noparents(N,Doms,NoParents):-
	M is N - 1,
	no_parent(N,Doms,NoParent),
	write_noparents(M,Doms,MoreNoParents),
	lists:append(NoParent,MoreNoParents,NoParents),!.


no_parent(A,Doms,[]):-
	lists:member(vstep(_,_,A),Doms),!.
no_parent(A,Doms,[A]):-
	!.