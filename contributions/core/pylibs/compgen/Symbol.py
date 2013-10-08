# -*- coding: utf-8 -*-

class Symbol(object):
    """base class for grammar symbols."""

    is_T = False
    is_NT = False

    def __init__(self, name, assoc=None, prec=None):
        """assoc is None, 'left', or 'right'. prec is None or an int."""
        self.name = name
        self.assoc = assoc
        self.prec = prec

    def __str__(self):
        return "%s" % self.name

    def __unicode__(self):
        return "%s" % self.name


class T(Symbol):
    """terminal symbol."""
    is_T = True

EOF = T("(EOF)")

EPSILON = T("")


class NT(Symbol):
    """non-terminal symbol."""
    is_NT = True

AXIOM = NT("(AXIOM)")
