import xmg.compgen.BrickTokenizer
import xmg.compgen.Parser
import xmg.compgen.brick_parser
import xmg.compgen.Unfold
import xmg.compgen.Symbol
import xmg.compgen.Grammar

class BrickGrammar(object):

    def __init__(self, file, dim=False, prefix=None):
        self._file = file
        self._prefix=prefix
        self._dim=dim
        self._grammar = xmg.compgen.Parser.Parser(xmg.compgen.brick_parser.G,xmg.compgen.BrickTokenizer.BrickTokenizer,file)
        self._connections=dict()
        self._dims=[]
        self._dimsp=[]
        self._punctuation=self._grammar.punctuation
        self._unfolded=False
        self._unfold=xmg.compgen.Unfold.Unfold(self)

    def connect(self, ext, brick, sym):
        if not ext in self._connections:
            self._connections[ext]=[]
        self._connections[ext].append((brick,sym))


    def generate_parser(self, file):
        #G=xmg.compgen.Unfold.Unfold(self)
        G=self._unfold.build_grammar()
        for Rule in G.rules:
            print(Rule)
        G.lr1.parser(file)
        

