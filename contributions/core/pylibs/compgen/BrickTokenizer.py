## -*- python -*-

from xmg.compgen.Tokenizer import Token, TokenizerEngine, TokenizerBuilder, TokenKeyword
import re

#==============================================================================
# BrickTokenizer
#==============================================================================

class BrickTokenizerEngine(TokenizerEngine):

    PERCENTKEYWORD = re.compile("%\\w+")


    def early_special_token(self):
        m = self.PERCENTKEYWORD.match(self.line, self.colno)
        if m:
            coord = self.coord()
            self.colno = m.end()
            return self.token_percentkeyword(m.group(), coord)
        return super(BrickTokenizerEngine, self).early_special_token()

    def token_percentkeyword(self, name, coord):
        return TokenPercentKeyword(name, coord)

class TokenPercentKeyword(TokenKeyword):
    __slots__ = ()
    def __init__(self, name, coord):
        super(TokenPercentKeyword, self).__init__(name,coord)
    def abbrev(self):
        return "percent keyword %s" % self.name

BrickTokenizer = TokenizerBuilder(BrickTokenizerEngine)

BrickTokenizer.operators([
    "%%",":","|",";",'{','}','=',',','(',')' ])

BrickTokenizer.keywords([
   ])

BrickTokenizer.balanced_comment("/*","*/")
