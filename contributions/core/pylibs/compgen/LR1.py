from xmg.compgen.Symbol import NT, EOF
from xmg.compgen.Item import LR0Item, LR1Item
from xmg.compgen.First import First
from xmg.compgen.utils import Counter, indent, unicode_indent
from xmg.compgen.shift import shift
from xmg.compgen.reduce import reduce
from xmg.compgen.next import next
from xmg.compgen.accept import accept

class LR1(object):

    def __init__(self, gram):
        self._grammar = gram
        self._begin   = self.closure([LR1Item((LR0Item((gram.axiom_rule,0,)),EOF))])
        self._graph   = None
        self._index   = None
        self._rindex  = None
        self._table   = None
        self._states  = None
        self._sem     = None

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

    @property
    def table(self):
        if self._table is None:
            self._compute_table()
        return self._table

    @property
    def states(self):
        if self._states is None:
            self._states=[self._begin]
        return self._states

    @property
    def sem(self):
        if self._sem is None:
            self._sem=[]
        return self._sem

    def reset_states(self):
        self._states=[self._begin]


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
            #print "item",map(str,it)
            clos.add(it)
            if it.complete:
                continue
            nxt = it.next
            if nxt.is_T :#or (nxt,it.token) in done:
                continue
            done.add((nxt,it.token))
            first= self.grammar.first(it.suffix[1:]+(it.token,))
            #print "FIRST:",map(str,it.suffix[1:]+(it.token,)),"->",map(str,list(first))
            for r in self.grammar.rules:
                if r.head is nxt:
                    for b in first: 
                        it = LR1Item((LR0Item((r,0)),b))
                        if it not in clos:
                            todo.append(it)
        return frozenset(clos)

    def transition(self,I,X):
        J=set()
        for item in I :
            rule_=item.rule
            index=item.index
            if not item.lr0.complete:
                if X==item.suffix[0]:
                    shift=LR1Item((LR0Item((rule_,index+1,)),item.token,))
                    J.add(shift)
        #print "CLOSURE:",map(str,J)
        return self.closure(J)

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


    def _compute_table(self):
        Items=self.graph
        table=dict()
        ruleNumber=dict()
        Count =0
        for R in self.grammar.rules:
            ruleNumber[R]=Count
            Count=Count+1
        Count=0
        for state in Items:
            table[state]=dict()
            for item in state: 
                if item.lr0.complete:
                    if item.token==EOF and item.rule==self.grammar.axiom_rule:
                        table[state][EOF]=accept()
                    else : table[state][item.token]=reduce(item.rule,ruleNumber[item.rule],self.grammar) 
                else : 
                    if item.next.is_T:
                        table[state][item.next]=shift(Items[state][item.next],self.grammar)
                    else : table[state][item.next]=next(Items[state][item.next])
        self._table=table

    def parser(self,path): 
        Table=self.table
        lines=[]
        i=0
        lines.append(":-module(generated_parser).\n \n")
        lines.append(":-module(generated_parser).\n \n")
        lines.append("get_coord(token(Coord,_),Coord). \n \n")

        # information about rules : rule(Number,Left,Rightsize)
        for r in self.grammar.rules:
            left=r.head
            rightsize=len(r.body)
            lines.append("rule("+str(i)+",\'"+str(left)+"\',"+str(rightsize)+").\n")
            if r.action is None :
                if str(left) != "(AXIOM)":
                    raise Exception("No action for rule",str(r))
                action=r.body
                nbActions=rightsize#len(action)
                if nbActions==0:
                    lines.append("ruleAction("+str(i)+",VAR__RESULT,[]):-\n    VAR__RESULT=none.\n")
                else:
                    params="[VAR__PARAM__"+",VAR__PARAM__".join(map(str,(range(1,nbActions+1))))+"]"
                    lines.append("ruleAction("+str(i)+",VAR__RESULT,"+params+"):-\n    VAR__RESULT=pred(VAR__PARAM__"+",VAR__PARAM__".join(map(str,(range(1,nbActions+1))))+").\n")

            else:
                (action,max_param)=r.action
                if max_param > rightsize:
                    raise Exception("Parameter out of range",str(r))
                if rightsize==0:
                    params="[]"
                else:
                    params="[VAR__PARAM__"+",VAR__PARAM__".join(map(str,(range(1,rightsize+1))))+"]"
                lines.append("ruleAction("+str(i)+",VAR__RESULT,"+params+"):-\n    "+action+".\n")
                    
            i=i+1
        for Item in Table:
            for J in Table[Item]:
                Action=Table[Item][J]
                if type(Action).__name__=="accept":
                    lines.append("action("+str(self.index(Item))+",\'"+str(J)+"\',"+"\'accept\').\n")
                elif type(Action).__name__=='next':
                    lines.append("next("+str(self.index(Item))+",\'"+str(J)+"\',"+str(self.index(Action.attr))+").\n")
                else : 
                    lines.append("action("+str(self.index(Item))+",\'"+str(J)+"\',"+"\'"+str(type(Action).__name__)+"\',"+str(Action.attr)+").\n")
                        
        # actions
        # accumulations
        # information about next : next(StateI,Token,StateO)
        # information about shift : action(StateI,Token,'shift',StateO)
        # information about reduce : action(StateI,Token,'reduce',StateO)
        # information about accept : action(StateI,Token,'accept')
        file=open(path,"w")
        file.writelines(lines)
        file.close()
        print("Code generated in file "+path)


    def parse(self,tokenizer):
        table=self.table
        for token in tokenizer: # token, coord, sem
            token,sem,coord=convert(token)
            shift=False
            while not shift:
                print(self.states)
                state=self.states[len(self.states)-1]
                if token in table[state]:
                    t=table[state][token]
                    if t == "accept":
                        return self.sem
                    elif type(t).__name__=='shift':
                        t.execute(token)
                        shift=True
                    elif type(t).__name__=='reduce':
                        t.execute(state,token)
                else : return False  # error


    def __str__(self):
        return self._str(str,indent)

    def __unicode__(self):
        return self._str(unicode,unicode_indent)

    def _str(self,tostring,indent):
        first=True
        lines=[]
        items = [(self.index(state),state,table) for (state,table) in self.graph.items()]
        items.sort()
        for index,state,table in items:
            if not first:
                lines.append("")
            else:
                first=False
            lines.append("State %d:" % index)
            for item in state:
                lines.append(indent(4, tostring(item)))
            lines.append("")
            for symbol,state2 in table.items():
                lines.append(indent(4,"%s -> State %d" %
                                    (tostring(symbol),self.index(state2))))
        return "\n".join(lines)


