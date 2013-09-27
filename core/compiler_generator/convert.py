import pylr.compiler_generator.Tokenizer, pylr.compiler_generator.BrickTokenizer
from pylr.compiler_generator.user_parser import semicolon,colon,pipe,arrow,endsection,_id,sqstring,T,NT,EXT
from pylr.compiler_generator.Symbol import EOF

def convertEOF(token) : 
    return EOF,None,token.coord

opt={
    ";":semicolon,
    ":":colon,
    "|":pipe,
    "->":arrow,
    "%%":endsection,
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

TABLE={
    pylr.compiler_generator.Tokenizer.TokenEOF:convertEOF,
    pylr.compiler_generator.Tokenizer.TokenOperator:convertOperator,
    pylr.compiler_generator.Tokenizer.TokenFloat:convertFloat,
    pylr.compiler_generator.Tokenizer.TokenInt:convertInt,
    pylr.compiler_generator.Tokenizer.TokenSingleQuotedString:convertSingleQuotedString,
    pylr.compiler_generator.Tokenizer.TokenDoubleQuotedString:convertDoubleQuotedString,
    pylr.compiler_generator.Tokenizer.TokenIdentifier:convertIdentifier,
    pylr.compiler_generator.Tokenizer.TokenKeyword:convertKeyword,
    pylr.compiler_generator.BrickTokenizer.TokenPercentKeyword:convertPercentKeyword,
    }

def convert(token):
    return TABLE[type(token)](token)
