import xmg.compgen.Tokenizer, xmg.compgen.BrickTokenizer
from xmg.compgen.brick_parser import semicolon,colon,pipe,arrow,endsection,openAction,closeAction,_id,sqstring,coma,equal,openpred,closepred,openlist,closelist,star,plus,T,NT,EXT,action
from xmg.compgen.Symbol import EOF

def convertEOF(token) : 
    return EOF,None,token.coord

opt={
    ";":semicolon,
    ":":colon,
    "|":pipe,
    "->":arrow,
    "%%":endsection,
    "{":openAction,
    "}":closeAction,
    "=":equal,
    ',':coma,
    '(':openpred,
    ')':closepred,
    '[':openlist,
    ']':closelist,
    '*':star,
    '+':plus
    
    }

def convertOperator(token) :
    return opt[token.name],None,token.coord

def convertFloat (token) :
    return T("float"),token.value,token.coord

def convertInt (token) :
    return T("int"),token.value,token.coord

def convertSingleQuotedString (token) :
    return sqstring,token.text,token.coord

def convertDoubleQuotedString (token) :
    return T("string"),token.text,token.coord

def convertIdentifier (token) :
    return _id,token.name,token.coord

def convertKeyword (token) : 
    return T("keyword"),token.name,token.coord

kopt={
    "%token":T,
    "%type":NT,
    "%ext":EXT
    }

def convertPercentKeyword (token) : 
    return kopt[token.name],None,token.coord

def convertActionKeyword(token):
    return action,token.name,token.coord

TABLE={
    xmg.compgen.Tokenizer.TokenEOF:convertEOF,
    xmg.compgen.Tokenizer.TokenOperator:convertOperator,
    xmg.compgen.Tokenizer.TokenFloat:convertFloat,
    xmg.compgen.Tokenizer.TokenInt:convertInt,
    xmg.compgen.Tokenizer.TokenSingleQuotedString:convertSingleQuotedString,
    xmg.compgen.Tokenizer.TokenDoubleQuotedString:convertDoubleQuotedString,
    xmg.compgen.Tokenizer.TokenIdentifier:convertIdentifier,
    xmg.compgen.Tokenizer.TokenKeyword:convertKeyword,
    xmg.compgen.BrickTokenizer.TokenPercentKeyword:convertPercentKeyword,
    xmg.compgen.BrickTokenizer.TokenActionKeyword:convertActionKeyword,
    }

def convert(token):
    return TABLE[type(token)](token)
