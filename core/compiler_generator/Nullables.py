# -*- coding: utf-8 -*-

from pylr.compiler_generator.Symbol import Symbol

class Nullables(object):

    def __init__(self):
        self._nullables = None
        super(Nullables, self).__init__()

    @property
    def nullables(self):
        if self._nullables is None:
            self._compute_nullables()
        return self._nullables

    def _compute_nullables(self):
        nullables = set()
        suspended = {}
        for x in self.NT:
            suspended[x] = set()
        stack = [(r.head,r.body) for r in self.rules]
        while stack:
            head,body = stack.pop()
            if head in nullables:
                continue
            while body and body[0] in nullables:
                body = body[1:]
            if body:
                if body[0].is_NT:
                    suspended[body[0]].add((head,body[1:]))
            else:
                nullables.add(head)
                stack.extend(suspended[head])
                del suspended[head]
        self._nullables = nullables

    def nullable(self, x):
        """returns True iff its argument (Symbol or sequence of Symbols) is nullable."""
        if isinstance(x, Symbol):
            return x in self.nullables
        for y in x:
            if y not in self.nullables:
                return False
        return True
