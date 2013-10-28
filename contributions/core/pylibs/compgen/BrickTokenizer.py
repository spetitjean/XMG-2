## -*- python -*-

from xmg.compgen.Tokenizer import Token, TokenizerEngine, TokenizerBuilder, TokenKeyword
import re

#==============================================================================
# BrickTokenizer
#==============================================================================

class BrickTokenizerEngine(TokenizerEngine):

    PERCENTKEYWORD = re.compile("%\\w+")
    #DOLLARKEYWORD  = re.compile(r"\$(\$|\d+)")
    POST_DOLLAR_RE = re.compile(r"\$|\d+")


    def early_special_token(self):
        m = self.PERCENTKEYWORD.match(self.line, self.colno)
        if m:
            coord = self.coord()
            self.colno = m.end()
            return self.token_percentkeyword(m.group(), coord)
        # m = self.DOLLARKEYWORD.match(self.line, self.colno)
        # if m:
        #     coord = self.coord()
        #     self.colno = m.end()
        #     index = m.group(1)
        #     if index != "$":
        #         index = int(index)
        #     return self.token_dollarkeyword(index, coord)
        c = self.line[self.colno]
        if c == '{':
            self.colno += 1
            return self.read_action(self.coord())
        return super(BrickTokenizerEngine, self).early_special_token()

    def read_action(self, coord):
        contents = []
        max_param = 0
        bracecount = 1
        while True:
            if self.colno >= len(self.line):
                if not self.nextline():
                    raise TokenizerError("unterminated action", coord)
                self.colno = 0
            else:
                c=self.line[self.colno]
                self.colno += 1
                if c=='}':
                    bracecount -= 1
                    if not bracecount:
                        return self.token_action(("".join(contents),max_param), coord)
                    else:
                        contents.append(c)
                elif c=='{':
                    bracecount += 1
                    contents.append(c)
                elif c=='"':
                    text = self.read_string(self.DOUBLE_QUOTED, coord, eval=False)
                    contents.append('"%s"' % text)
                elif c=="'":
                    text = self.read_string(self.SINGLE_QUOTED, coord, eval=False)
                    contents.append("'%s'" % text)
                elif c=="$":
                    m = self.POST_DOLLAR_RE.match(self.line, self.colno)
                    if not m:
                        raise TokenizerError("bad $XXX in action", coord)
                    index = m.group()
                    self.colno = m.end()
                    if index=="$":
                        contents.append(" VAR__RESULT ")
                    else:
                        index = int(index)
                        if index > max_param:
                            max_param = index
                        contents.append(" VAR__PARAM__%d " % index)
                else:
                    contents.append(c)

    def token_percentkeyword(self, name, coord):
        return TokenPercentKeyword(name, coord)

    # def token_dollarkeyword(self, name, coord):
    #     return TokenDollarKeyword(name, coord)

    def token_action(self, text, coord):
        return TokenActionKeyword(text, coord)


class TokenPercentKeyword(TokenKeyword):
    __slots__ = ()
    def __init__(self, name, coord):
        super(TokenPercentKeyword, self).__init__(name,coord)
    def abbrev(self):
        return "percent keyword %s" % self.name

# class TokenDollarKeyword(TokenKeyword):
#     __slots__ = ()
#     def __init__(self, index, coord):
#         super().__init__(index, coord)
#     def abbrev(self):
#         return "dollar keyword %s" % self.name

class TokenActionKeyword(TokenKeyword):
    __slots__ = ()
    def __init__(self, text, coord):
        super().__init__(text, coord)
    def abbrev(self):
        return "action keyword %s" % self.name

BrickTokenizer = TokenizerBuilder(BrickTokenizerEngine)

BrickTokenizer.operators([
    "%%",":","|",";",'{','}','=',',','(',')','[',']','*','+','?','//' ])

BrickTokenizer.keywords([
   ])

BrickTokenizer.balanced_comment("/*","*/")
