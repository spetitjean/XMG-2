import xmg.compgen.Grammar
import xmg.compgen.Tokenizer
import re, string
from xmg.compgen.convert import convert
from xmg.compgen.brick_parser import sqstring

class ParserFactory(object):

    def __init__(self, gram, tokenizer):
        self._grammar = gram
        self._tokenizer = tokenizer
        
    
    def __call__(self,filename,encoding="UTF-8"):
        return Parser(self,self._grammar,self._tokenizer,filename,encoding=encoding)

class Parser(object):
    
    def __init__(self,grammar,tokenizer,filename,encoding="UTF-8"):
        tokenizer=tokenizer(filename,encoding=encoding)
        self.sem=[]
        self.punctuation=[]
        self.keywords=[]
        self.states=[grammar.lr1.begin]
        self.table=grammar.lr1.table
        self.grammar=grammar
        for token in tokenizer:
            token,sem,coord=convert(token)
            if token == sqstring:
                id_regex = re.compile(r"^([A-Za-z][A-Za-z0-9]*)$")
                m = id_regex.match(sem)
                if m:
                    self.keywords.append(sem)
                elif sem[-1] in string.punctuation:
                    self.punctuation.append(sem)
                else:
                  raise Exception("Forbidden token: "+sem+coord)                 
            while True:
                state=self.states[len(self.states)-1]
                if token in self.table[state]:
                    t=self.table[state][token]
                    status=t.execute(self,token,sem,coord)
                    if status == "accept":
                        assert len(self.sem)==1
                        return
                    elif status=='shift':
                        break                        
                else : 
                    raise Exception("Parser error: no transition for token %s and state %s at %s" % (token,grammar.lr1.index(state),coord))  # error
        
        
