:- module(xmg_brick_tree_edcg, []).
:- use_module(library(gecode)).
%%:- xmg:import('xmg/brick/tree/compiler/dominance').

:- edcg:method(preparer_get_nodes(Nodes), Old, New,
	       (xmg_table:table_get(Old, nodes, Nodes), Old=New)).
:- edcg:method(preparer_set_nodes(Nodes), Old, New,
	       xmg_table:table_put(Old, nodes, Nodes, New)).
:- edcg:class(preparer_class, [get_nodes=preparer_get_nodes, set_nodes=preparer_set_nodes]).
:- edcg:thread(preparer, preparer_class).

:- edcg:method(solver_dom(Node1, Rel, Node2), Old, New,
	       (xmg_table:table_get(Old, onodes, ONodeList),
		xmg_table:table_get(Old, nodes, NodeList),
		xmg_table:table_get(Old, intvars, IntVars),
		xmg_table:table_get(Old, space, Space),
		xmg_brick_tree_edcg:do_post(Space, IntVars, ONodeList, NodeList, (Node1, Rel, Node2)),
		Old=New)).
:- edcg:class(solver_class, [dom=solver_dom]).
:- edcg:thread(solver, solver_class).


do_post(Space, IntVars, ONodeList, NodeList, (Node1, Rel, Node2)) :-
    get_node(Node1, ONodeList, Num1),
    get_node(Node2, ONodeList, Num2),
    rel_to_step(Num1, Rel, Num2, Step),
    xmg_brick_tree_solver:do_post(Space,IntVars,IntPVars,NodeList,hstep(more,Num1,Num2)),
    !.

get_node(node(_,F,N),[Num-node(_,F1,N1)|_],Num):-
    N==N1,!.
get_node(node(_,F,N),[Num-node(_,F1,N1)|T],M):-
    not(N==N1),
    get_node(node(_,F,N),T,M),!.

rel_to_step(Num1, '->' , Num2, vstep(one , Num1, Num2)).
rel_to_step(Num1, '->*', Num2, vstep(any , Num1, Num2)).
rel_to_step(Num1, '->+', Num2, vstep(more, Num1, Num2)).
rel_to_step(Num1, '>>' , Num2, hstep(one , Num1, Num2)).
rel_to_step(Num1, '>>*', Num2, hstep(any , Num1, Num2)).
rel_to_step(Num1, '>>+', Num2, hstep(more, Num1, Num2)).
