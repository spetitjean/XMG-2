# -*- coding: utf-8 -*-

from pylr.Symbol import Symbol, NT, T
from pylr.Closure import compute_closure, compute_closure_1
from pylr.Rule import Rule
from pylr.Grammar import BasicGrammar
from pylr.Transition import compute_transition, compute_transition_1
from pylr.Item import LR0Item

# class Items():

#     def __init__(self):
#         self._Items = None
#         super(Items, self).__init__()

#     def Items(self, G):
#         """returns the closure of the set of the items [A->alpha X.beta] such than [A -> alpha.X beta] belongs to I"""
#         assert isinstance(G, Grammar)
#         if self._items is None:
#             self._compute_items(G)
#         return self._transition[G]

def compute_items(G,S):
    FRule=G.rules[0]
    FItem=LR0Item((FRule,0,))
    C = [(compute_closure([FItem],G))]
    States=dict()
    Graph=dict()
    while C :
        print('fixpoint not reached : Items built : ')
        print(C)
        I=C.pop()
        Table=dict()
            # for X in G.symbols:
        for X in S:
            transition=compute_transition(I,X,G)
            print(transition)
            if len(transition)>0 :
                print('will be added')
                Table.update({X:transition})
                if transition not in C : C.append(transition)
                print(' State added, States :')
                print(C)
        Graph.update({frozenset(I):Table})
    return Graph

def compute_items_1(G,S):
    FRule=G.rules[0]
    dollar=NT("$")
    FItem=LR1Item(LR0Item((FRule,0,)),dollar)
    C = [(compute_closure_1([FItem],G))]
    States=dict()
    Graph=dict()
    while C :
        print('fixpoint not reached : Items built : ')
        print(C)
        I=C.pop()
        Table=dict()
            # for X in G.symbols:
        for X in S:
            transition=compute_transition_1(I,X,G)
            print(transition)
            if len(transition)>0 :
                print('will be added')
                Table.update({X:transition})
                if transition not in C : C.append(transition)
                print(' State added, States :')
                print(C)
        Graph.update({frozenset(I):Table})
    return Graph


def print_items(Items):
    for I in Items : 
        print "State"
        for J in I:
            print J
        print ""
        for J in I:
            print "Table"
            for J in Items[I] : 
                print "transition by "
                print J
                for K in Items[I][J]:
                    print K
                print ""
        print "  ___________________  "

