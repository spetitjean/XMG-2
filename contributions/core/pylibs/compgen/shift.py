class shift(object):
    
    def __init__(self,state,grammar):
        self._state   = state
        self._attr  = grammar.lr1.index(self.state)
        
    @property    
    def attr(self):
        return self._attr

    @property    
    def state(self):
        return self._state

    def execute(self,parser,token,sem,coord):
        parser.sem.append(sem)
        parser.states.append(self.state)
        return "shift"
