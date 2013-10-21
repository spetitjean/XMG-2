# -*- coding: utf-8 -*-


def nofirst(X):
    return X[1:]

class Rule(object):
    """represents a grammar rule (head and body), plus an optional
    precedence (an int) and an optional action (a function to get a 
    tuple from the body)."""

    def __init__(self, head, body, prec=None, action=None):
        self.head   = head
        self.body   = body
        self.prec   = prec
        self.action = action

    def __str__(self):
        return "%s -> %s" % (str(self.head)," ".join(map(str,self.body)))

    def __unicode__(self):
        return "%s → %s" % (unicode(self.head)," ".join(map(unicode,self.body)))
