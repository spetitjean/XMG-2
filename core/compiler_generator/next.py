class next(object):
    
    def __init__(self,state):
        self._state= state
        self._attr  = self.state
        
    @property    
    def attr(self):
        return self._attr
        
    @property    
    def state(self):
        return self._state

        
