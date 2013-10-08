class reduce(object):
    
    def __init__(self,rule,ruleNumber,grammar):
        self._rule    = rule
        self._attr  = ruleNumber
        self.rulenumber = ruleNumber
        
    @property    
    def attr(self):
        return self._attr
  
    @property    
    def rule(self):
        return self._rule 

    def execute(self,parser,token,sem,coord):
        lsem=[]
        for _ in range(len(self.rule.body)) :
            parser.states.pop()
            popsem=parser.sem.pop()
            if popsem is not None:
                lsem.append(popsem)
        s=parser.states[len(parser.states)-1]
        A=self.rule.head
        # do something with sem and A
        lsem.reverse()
        parser.sem.append((str(A),lsem))
        parser.states.append(parser.grammar.lr1.table[s][A].state)
        return "reduce"
