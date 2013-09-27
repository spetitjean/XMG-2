import pylr.compiler_generator.BrickTokenizer
import pylr.compiler_generator.Parser
import pylr.compiler_generator.user_parser
import pylr.compiler_generator.Unfold
import pylr.compiler_generator.Symbol
import pylr.compiler_generator.Grammar

class BrickGrammar(object):

    def __init__(self, file, dim=False, prefix=None):
        self._file = file
        self._prefix=prefix
        self._dim=dim
        self._grammar = pylr.compiler_generator.Parser.Parser(pylr.compiler_generator.user_parser.G,pylr.compiler_generator.BrickTokenizer.BrickTokenizer,file)
        self._connections=dict()
        self._dims=[]
        self._dimsp=[]
        self._punctuation=self._grammar.punctuation
        self._unfolded=False
        self._unfold=pylr.compiler_generator.Unfold.Unfold(self)

    def connect(self, ext, brick):
        if not ext in self._connections:
            self._connections[ext]=[]
        self._connections[ext].append(brick)


    def generate_parser(self, file):
        #G=pylr.Unfold.Unfold(self)
        G=self._unfold.build_grammar()
        for Rule in G.rules:
            print(Rule)
        G.lr1.parser(file)
        

