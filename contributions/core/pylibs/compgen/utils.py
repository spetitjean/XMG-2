def indent(n, s):
    lines = s.split("\n")
    prefix = " "*n
    lines[0] = "%s%s" % (prefix,lines[0])
    prefix = "\n"+prefix
    return prefix.join(lines)

def indent_rest(n, s):
    lines = s.split("\n")
    prefix = " "*n
    prefix = "\n"+prefix
    return prefix.join(lines)

def unicode_indent(n, s):
    lines = s.split("\n")
    prefix = " "*n
    lines[0] = "%s%s" % (prefix,lines[0])
    prefix = "\n"+prefix
    return prefix.join(lines)

def unicode_indent_rest(n, s):
    lines = s.split("\n")

    prefix = " "*n
    prefix = "\n"+prefix
    return prefix.join(lines)

class Counter(object):

    __slots__ = ('_n',)

    def __init__(self, n=0):
        self._n = n

    def get(self):
        n = self._n
        self._n = n+1
        return n
