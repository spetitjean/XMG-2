# -*- coding: utf-8 -*-

from pylr.compiler_generator.Symbol import AXIOM, EOF
from pylr.compiler_generator.Rule import Rule
from pylr.compiler_generator.Nullables import Nullables
from pylr.compiler_generator.First import First
from pylr.compiler_generator.Follow import Follow
from pylr.compiler_generator.LR0 import LR0
from pylr.compiler_generator.LR1 import LR1

class BasicGrammar(object):

    def __init__(self, rules, axiom=None):
        if axiom is None:
            self.axiom = rules[0].head
            self.axiom_rule=Rule(AXIOM,(self.axiom,))
        else:
            self.axiom = axiom
            self.axiom_rule = axiom_rule
        self.rules = (self.axiom_rule,) + rules
        self.T = set([EOF])          # set of terminals
        self.NT = set()         # set of non-terminals
        for r in self.rules:
            self.NT.add(r.head)
            for x in r.body:
                if x.is_T:
                    self.T.add(x)
                else:
                    self.NT.add(x)
        self.symbols = self.T | self.NT
        super(BasicGrammar, self).__init__()

class Grammar(BasicGrammar, Nullables, First, Follow):

    def __init__(self, *args, **kargs):
        super(Grammar, self).__init__(*args, **kargs)
        self.lr0 = LR0(self)
        self.lr1 = LR1(self)

