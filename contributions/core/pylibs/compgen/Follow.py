# -*- coding: utf-8 -*-

from xmg.compgen.Symbol import NT, AXIOM, EOF

class Follow(object):

    def __init__(self):
        self._follow = None
        super(Follow, self).__init__()

    def follow(self, x):
        """returns a constant set of all terminals that may immediately follow
        the expansion of x (a non-terminal) in some derivation."""
        assert isinstance(x, NT)
        if self._follow is None:
            self._compute_follow()
        return self._follow[x]

    def _compute_follow(self):
        follow = {}
        forward_to = {}
        for x in self.NT:
            follow[x] = set()
            forward_to[x] = set()
        forwarding = [(AXIOM,EOF)]
        for rule in self.rules:
            head = rule.head
            body = rule.body
            n = len(body)
            for i in range(n):
                x = body[i]
                if x.is_NT:
                    for t in self.first(body[i+1:]):
                        forwarding.append((x,t))
            for i in range(len(body)-1,-1,-1):
                x = body[i]
                if x.is_NT:
                    forward_to[head].add(x)
                if not self.nullable(x):
                    break
        while forwarding:
            to,t = forwarding.pop()
            if t in follow[to]:
                continue
            follow[to].add(t)
            for x in forward_to[to]:
                forwarding.append((x,t))
        def freeze(item):
            key,val = item
            return key,frozenset(val)
        self._follow = dict(map(freeze,follow.items()))
