# -*- coding: utf-8 -*-

class LR0Item(tuple):
    """represents a LR(0) item, i.e. a grammar rule with a dot in its body."""

    @property
    def rule(self):
        return self[0]

    @property
    def index(self):
        return self[1]

    @property
    def head(self):
        return self.rule.head

    @property
    def body(self):
        return self.rule.body

    @property
    def prefix(self):
        return self.body[0:self.index]

    @property
    def complete(self):
        return len(self.body)==self.index

    @property
    def next(self):
        return self.body[self.index]

    @property
    def suffix(self):
        return self.body[self.index:]

    def __str__(self):
        body = list(map(str, self.body))
        body[self.index:self.index] = ("*",)
        return "%s -> %s" % (str(self.head)," ".join(body))

    def __unicode__(self):
        body = list(map(unicode, self.body))
        body[self.index:self.index] = ("•",)
        return "%s → %s" % (unicode(self.head)," ".join(body))

    def first(self, grammar):
        return grammar.first(self.suffix)


class LR1Item(tuple):
    """represents a LR(1) item, i.e. a pair of a LR(0) item and a token."""

    @property
    def lr0(self):
        return self[0]

    @property
    def token(self):
        return self[1]

    @property
    def rule(self):
        return self.lr0.rule

    @property
    def index(self):
        return self.lr0.index

    @property
    def head(self):
        return self.lr0.head

    @property
    def body(self):
        return self.lr0.body

    @property
    def prefix(self):
        return self.lr0.prefix

    @property
    def suffix(self):
        return self.lr0.suffix

    @property
    def complete(self):
        return self.lr0.complete

    @property
    def next(self):
        return self.body[self.index]
    
    def __str__(self):
        body = list(map(str, self.body))
        body[self.index:self.index] = ("*",)
        return "[%s -> %s | %s]" % (str(self.head)," ".join(body),str(self.token))

    def __unicode__(self):
        body = list(map(unicode, self.body))
        body[self.index:self.index] = ("•",)
        return "[%s → %s | %s]" % (unicode(self.head)," ".join(body),unicode(self.token))

    def first(self, grammar):
        return grammar.first(self.suffix + (self.token,))
