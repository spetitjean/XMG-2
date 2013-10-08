# -*- coding: utf-8 -*-

from xmg.compgen.Symbol import Symbol

class First(object):

    def __init__(self):
        self._first = None
        super(First, self).__init__()

    def first(self, x):
        """returns a constant set of all terminals that may appear first in the expansion
        of x (a Symbol or sequence of Symbols)."""
        if self._first is None:
            self._compute_first()
        if isinstance(x, Symbol):
            return self._first[x]
        else:
            s = set()
            for y in x:
                s |= self.first(y)
                if not self.nullable(y):
                    break
            return frozenset(s)

    def _compute_first(self):
        first = {}
        forward_to = {}
        for x in self.T:
            first[x] = set((x,))
        for x in self.NT:
            first[x] = set()
            forward_to[x] = set()
        forwarding = []
        for rule in self.rules:
            head = rule.head
            body = rule.body
            for x in body:
                if x.is_T:
                    forwarding.append((head,x))
                    break
                else:
                    forward_to[x].add(head)
                    if not self.nullable(x):
                        break
        while forwarding:
            to,t = forwarding.pop()
            if t in first[to]:
                continue
            first[to].add(t)
            for x in forward_to[to]:
                forwarding.append((x,t))
        def freeze(item):
            key,val = item
            return key,frozenset(val)
        self._first = dict(map(freeze,first.items()))
