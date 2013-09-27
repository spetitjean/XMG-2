from pylr.compiler_generator.Item import LR0Item 
from pylr.compiler_generator.utils import Counter, indent, unicode_indent

class LR0(object):

    def __init__(self, gram):
        self._grammar = gram
        self._begin = self.closure([LR0Item((gram.axiom_rule,0))])
        self._graph = None
        self._index = None
        self._rindex = None

    @property
    def grammar(self):
        return self._grammar

    @property
    def begin(self):
        return self._begin

    @property
    def graph(self):
        if self._graph is None:
            self._compute_graph()
        return self._graph

    def index(self, state):
        return self._index[state]

    def rindex(self, n):
        return self._rindex[n]

    def closure(self, items):
        done = set()
        clos = set()
        todo = list(items)
        while todo:
            it = todo.pop()
            clos.add(it)
            if it.complete:
                continue
            nxt = it.next
            if nxt.is_T or nxt in done:
                continue
            done.add(nxt)
            for r in self.grammar.rules:
                if r.head is nxt:
                    it = LR0Item((r,0))
                    if it not in clos:
                        todo.append(it)
        return frozenset(clos)

    def transition(self,I,X): 
        J=set()
        for item in I:
            rule_=item.rule
            index=item.index
            if not item.complete:
                if X==item.suffix[0]:
                    shift=LR0Item((rule_,index+1,))
                    J.add(shift)
        return self.closure(J)

    # just in case this is still needed
    @property
    def items(self):
        return self.graph

    def _compute_graph(self):
        stack=[self.begin]
        index=dict()
        rindex=dict()
        count=Counter()
        graph=dict()
        def enter(state):
            n = count.get()
            index[state] = n
            rindex[n] = state
        enter(self.begin)
        while stack:
            I=stack.pop()
            table=dict()
            for X in self.grammar.symbols:
                transition=self.transition(I,X)
                if transition:
                    table[X]=transition
                    if transition not in index:
                        enter(transition)
                        stack.append(transition)
            graph[I]=table
        self._graph=graph
        self._index=index
        self._rindex=rindex

    def __str__(self):
        return self._str(str,indent)

    def __unicode__(self):
        return self._str(unicode,unicode_indent)

    def _str(self,tostring,indent):
        first=True
        lines=[]
        for state,table in self.graph.items():
            if not first:
                lines.append("")
            else:
                first=False
            lines.append("State %d:" % self.index(state))
            for item in state:
                lines.append(indent(4, tostring(item)))
            lines.append("")
            for symbol,state2 in table.items():
                lines.append(indent(4,"%s -> State %d" %
                                    (tostring(symbol),self.index(state2))))
        return "\n".join(lines)
