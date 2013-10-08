# -*- coding: utf-8 -*-

from xmg.compgen.Symbol import AXIOM, EOF
from xmg.compgen.Rule import Rule
from xmg.compgen.Nullables import Nullables
from xmg.compgen.First import First
from xmg.compgen.Follow import Follow
from xmg.compgen.LR0 import LR0
from xmg.compgen.LR1 import LR1

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

