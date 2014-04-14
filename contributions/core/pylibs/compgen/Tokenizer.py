## -*- python -*-
##=============================================================================
## Copyright (C) 2012 by Denys Duchier
##
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU Lesser General Public License as published by the
## Free Software Foundation, either version 3 of the License, or (at your
## option) any later version.
## 
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
## more details.
## 
## You should have received a copy of the GNU Lesser General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##=============================================================================

import re, os.path

#==============================================================================
# FileProxy
#==============================================================================

class FileProxy:
    """line-oriented file reader.

    Attributes:
        filename: pathname of the file being read
        lineno: current line number (starts at 0)
        colno: current column number (starts at 0)
        line: text of current line
    """

    __slots__ = ("filename","_stream","colno","lineno","line")

    def __init__(self, filename, encoding="UTF-8"):
        if isinstance(filename, str):
            self.filename = filename
            self._stream = open(filename, encoding=encoding)
        else:
            self.filename = "<unknown>"
            self._stream = filename
            #print(self._stream.getvalue())
        self.colno = 0
        self.lineno = 0
        self.line = self._stream.readline()

    def coord(self):
        """return a coordinate object for the current read-point."""
        return Coord(self)

    def nextline(self):
        """move to the next line.

        return a boolean indicating whether there is in fact a next line.
        if True, the lineno has been updated, but not the colno (not sure why
        I did this).
        """
        self.line = self._stream.readline()
        if self.line:
            self.lineno += 1
            return True
        else:
            return False

#==============================================================================
# MacroProxy
#==============================================================================

class MacroProxy:
    """line-oriented reader for the replacement text of a macro.

    This is similar to FileProxy except that it doesn't read from
    a file but from the replacement text of a macro.
    """

    __slots__ = ("filename","colno","lineno","line")

    def __init__(self, proxy, macro, colno):
        self.filename = proxy.filename
        self.colno = colno
        self.lineno = proxy.lineno
        self.line = macro.text

    def coord(self):
        return Coord(self)

    def nextline(self):
        return False

#==============================================================================
# Coord
#==============================================================================

class Coord:
    """A coordinate object represents a point in a file.

    Attributes:
        filename: pathname of the file
        lineno: line number
        colno: column number
    """

    __slots__ = ("filename","colno","lineno")

    def __init__(self, proxy):
        self.filename = proxy.filename
        self.colno = proxy.colno
        self.lineno = proxy.lineno

    def __str__(self):
        return "<line=%s col=%s file=%s>" % (self.lineno, self.colno, self.filename)

#==============================================================================
# TokenizerBuilder
#==============================================================================

class TokenizerBuilder:
    """helps build a full tokenizer.

    Every tokenizer needs to recognize comments, ints, floats, strings,
    identifiers, keywords, operators.  A TokenizerBuilder allows you to state
    simply what kinds of comments you want to support, which identifiers
    are keywords, what operators you want to recognize.

    The builder is a callable: calling the builder instantiates a
    TokenizerEngine and sets appropriate attributes to recognize the right
    comments, keywords and operators.
    """

    def __init__(self, engine):
        """make a builder that create instance of "engine"."""
        self._eol_comments = set()
        self._balanced_comments = set()
        self._operators = set()
        self._keywords = set()
        self._engine = engine

    def __call__(self, filename, encoding="UTF-8"):
        t = self._engine(filename, encoding=encoding)
        t.EOL_COMMENTS = self.re_eol_comments()
        t.BALANCED_COMMENTS, t.BALANCED_COMMENTS_ENDS = self.re_balanced_comments()
        t.OPERATORS = self.re_operators()
        t.KEYWORDS = self.set_of_keywords()
        t.SINGLE_QUOTED = self.re_single_quoted()
        t.DOUBLE_QUOTED = self.re_double_quoted()
        t.FLOAT = self.re_float()
        t.INT = self.re_int()
        t.IDENTIFIER = self.re_identifier()
        return t

    def eol_comment(self, beg):
        """state that "beg" starts a comment that goes on to the end of the line."""
        assert isinstance(beg, str)
        self._eol_comments.add(beg)

    def eol_comments(self, begs):
        """state that every element in "begs" starts a comment that goes on
        to the end of the line."""
        for beg in begs:
            self.eol_comment(beg)

    def balanced_comment(self, beg, end):
        """state that "beg" starts a balanced comment that ends with "end"."""
        assert isinstance(beg, str)
        assert isinstance(end, str)
        self._balanced_comments.add((beg,end))

    def balanced_comments(self, delims):
        """state that every element in "delims" defines a balanced comment."""
        for beg, end in delims:
            self.balanced_comment(beg, end)

    def operator(self, op):
        """state that "op" is an operator."""
        assert isinstance(op, str)
        self._operators.add(op)

    def operators(self, ops):
        """state that every element in "ops" is an operator."""
        for op in ops:
            self.operator(op)

    def keyword(self, key):
        """state that identifier "key" is a keyword."""
        assert isinstance(key, str)
        self._keywords.add(key)

    def keywords(self, keys):
        """state that every element in "keys" is a keyword."""
        for key in keys:
            self.keyword(key)

    def re_eol_comments(self):
        if not self._eol_comments:
            return None
        l = list(map(re.escape, list(self._eol_comments)))
        return re.compile("|".join(l))

    def re_balanced_comments(self):
        if not self._balanced_comments:
            return None, None
        l = []
        d = {}
        for beg, end in self._balanced_comments:
            l.append(re.escape(beg))
            d[beg] = (end,re.compile(re.escape(end)))
        return re.compile("|".join(l)), d

    def re_operators(self):
        if not self._operators:
            return None
        # we want the list of operators sorted by decreasing length
        def schwartz(x):
            return len(x),x
        def unschwartz(y):
            return y[1]
        l = list(map(re.escape, list(self._operators)))
        l = list(map(schwartz, l))
        l.sort()
        l.reverse()
        l = list(map(unschwartz, l))
        return re.compile("|".join(l))

    def set_of_keywords(self):
        return frozenset(self._keywords)

    def re_single_quoted(self):
        return re.compile("(?:[^'\\\\]|\\.)*'")

    def re_double_quoted(self):
        return re.compile('(?:[^"\\\\]|\\.)*"')

    def re_float(self):
        return re.compile("[0-9]+\\.[0-9]+([eE][+-]?[0-9]+)?")

    def re_int(self):
        return re.compile("[0-9]+")

    def re_identifier(self):
        return re.compile("\\w+")
            
#==============================================================================
# TokenizerEngine
#==============================================================================
    
class TokenizerEngine:
    """an engine that performs the actual tokenization.

    Much of the parametrization of this engine is provided by the builder
    that instantiates it.  However, TokenizerEngine can easily be subclassed
    to provide extended functionality:

    TOKEN CREATION: a token of type XYZ is created by calling a method
    token_XYZ(..., coord).  Such a method can be overridden.

    NEW KINDS OF TOKENS: it is possible to recognize new kinds of tokens by
    overridding methods early_special_token() or late_special_token().
    early_special_token() is called (after skipping spaces and comments)
    before recognizing operators; late_special_token() is called after.

    These two methods can return:

        None: to indicate that they did not succeed in recogizing a token;
          in that case, the coordinate should not have changed, and the
          tokenizer tries to recognize the other possibilities (float, int,
          keyword, identifier, string).

        TokenInclude: to indicate that an include directive has been
          recognized.  Such a token is never returned to the parser; it is
          purely internal to the tokenizer.

        TokenMacro: to indicate that a macro directive has been recognized.
          Such a token is never returned to the parser; it is purely internal
          to the tokenizer.

        else: any other type of token which is then returned to the parser.
    """

    EOL_COMMENTS = None
    BALANCED_COMMENTS = None
    BALANCED_COMMENTS_ENDS = None
    OPERATORS = None
    KEYWORDS = None
    SINGLE_QUOTED = None
    DOUBLE_QUOTED = None
    FLOAT = None
    INT = None
    IDENTIFIER = None

    def __init__(self, filename, encoding="UTF-8"):
        """create a tokenizer starting on file "filename".

        keyword argument "encoding" defaults to "UTF-8".
        """
        #filename = os.path.abspath(filename)
        #if not os.path.exists(filename):
        #    raise TokenizerError("input file not found: %s" % filename, None)
        self.encoding = encoding
        self.proxy = FileProxy(filename, encoding=encoding)
        self.stack = []
        self.macros = {}

    def __iter__(self):
        """a tokenizer is iterable."""
        while True:
            t = self.next_token()
            yield t
            if t.is_eof:
                return

    @property
    def colno(self):
        """reference to the column number in the current file."""
        return self.proxy.colno

    @colno.setter
    def colno(self, n):
        self.proxy.colno = n

    @property
    def line(self):
        """reference to the line number in the current file."""
        return self.proxy.line

    def nextline(self):
        """move to the next line in the current file.

        returns True iff there was a next line.
        """
        return self.proxy.nextline()

    def coord(self):
        """returns a coordinate object for the current read point."""
        return self.proxy.coord()

    def _skip_spaces(self):
        # loop for skipping spaces across stacked files
        while True:
            # loop for skipping spaces in the current file
            line = self.line
            n = len(line)
            i = self.colno
            while True:
                # falling off the end of the line
                if i>=n:
                    # EOF, go on to next file
                    self.colno = i # record that we have skipped up to i
                    if not self.nextline():
                        break
                    # else, just update the info on the current line
                    line = self.line
                    n = len(line)
                    i = self.colno = 0
                elif line[i].isspace():
                    i += 1
                else:
                    # we have reached a non-space
                    self.colno = i
                    return True
            # EOF was reached, try the next stacked file
            if self.stack:
                self.proxy = self.stack.pop()
            else:
                # end of all files was reached
                return False

    def skip_balanced_comment(self,end):
        # loop for skipping balanced comments in the current file
        while True:
            line = self.line
            n = len(line)
            i = self.colno
            while True:
                # found end of comment on current line
                search= end[1].search(line,self.colno)
                if search:
                    self.colno=search.end()
                    return True
                # else, go to next line
                else:
                    self.nextline()
                    line = self.line
                    i = self.colno = 0
                    i += 1
            return True

    def next_token(self):
        """returns the next available token."""
        while True:
            if not self._skip_spaces():
                return self.token_eof(self.coord())
            #----
            if self.EOL_COMMENTS and \
               self.EOL_COMMENTS.match(self.line, self.colno):
                self.colno = len(self.line)
                continue
            #----
            if self.BALANCED_COMMENTS:
                m = self.BALANCED_COMMENTS.match(self.line, self.colno)
                if m:
                    self.colno = m.end()
                    re_end = self.BALANCED_COMMENTS_ENDS[m.group()]
                    self.skip_balanced_comment(re_end)
                    continue
            #----
            m = self.early_special_token()
            if m:
                if m.is_include:
                    self.push_proxy(m)
                    continue
                if m.is_macro:
                    self.record_macro(m)
                    continue
                return m
            #----
            if self.OPERATORS:
                m = self.OPERATORS.match(self.line, self.colno)
                if m:
                    coord = self.coord()
                    self.colno = m.end()
                    return self.token_operator(m.group(), coord)
            #----
            m = self.late_special_token()
            if m:
                if m.is_include:
                    self.push_proxy(m)
                    continue
                if m.is_macro:
                    self.record_macro(m)
                    continue
                return m
            #----
            if self.FLOAT:
                m = self.FLOAT.match(self.line, self.colno)
                if m:
                    coord = self.coord()
                    self.colno = m.end()
                    return self.token_float(float(m.group()), coord)
            #----
            if self.INT:
                m = self.INT.match(self.line, self.colno)
                if m:
                    coord = self.coord()
                    self.colno = m.end()
                    return self.token_int(int(m.group()), coord)
            #----
            if self.IDENTIFIER:
                m = self.IDENTIFIER.match(self.line, self.colno)
                if m:
                    coord = self.coord()
                    self.colno = m.end()
                    name = m.group()
                    macro = self.macros.get(name)
                    if macro:
                        self.push_macro_proxy(macro, m.start())
                        continue
                    if self.KEYWORDS and name in self.KEYWORDS:
                        return self.token_keyword(name, coord)
                    return self.token_identifier(name, coord)
            #----
            c = self.line[self.colno]
            coord = self.coord()
            #----
            if c == '"':
                self.colno += 1
                return self.read_double_quoted_string(coord)
            #----
            if c == "'":
                self.colno += 1
                return self.read_single_quoted_string(coord)
            #----
            raise TokenizerError("unrecognized token", coord)

    def push_proxy(self, include):
        proxy = os.path.join(os.path.dirname(self.proxy.filename), include.filename)
        proxy = os.path.abspath(proxy)
        if not os.path.exists(proxy):
            raise TokenizerError("include file not found: %s" % include.filename,
                                 include.coord)
        proxy = FileProxy(proxy, encoding=self.encoding)
        self.stack.append(self.proxy)
        self.proxy = proxy

    def push_macro_proxy(self, macro, colno):
        proxy = MacroProxy(self.proxy, macro, colno)
        self.stack.append(self.proxy)
        self.proxy = proxy

    def record_macro(self, macro):
        if macro.name in self.macros:
            raise TokenizerError("redefining macro: %s" % macro.name, macro.coord)
        self.macros[macro.name] = macro

    def early_special_token(self):
        return None

    def late_special_token(self):
        return None
    
    def read_double_quoted_string(self, coord):
        text = self.read_string(self.DOUBLE_QUOTED, coord)
        return self.token_double_quoted_string(text, coord)

    def read_single_quoted_string(self, coord):
        text = self.read_string(self.SINGLE_QUOTED, coord)
        return self.token_single_quoted_string(text, coord)

    def read_string(self, re_end, coord, eval=True):
        contents = []
        while True:
            m = re_end.match(self.line, self.colno)
            if m:
                contents.append(m.group()[:-1])
                self.colno = m.end()
                text = "".join(contents)
                return self.backslash_eval(text) if eval else text
            if not self.nextline():
                raise TokenizerError("unterminated string", coord)
            self.colno = 0

    def backslash_eval(self, text):
        return _RE_BACKSLASH.sub(_backslash_rep, text)

    def token_eof(self, coord):
        return TokenEOF(coord)

    def token_operator(self, name, coord):
        return TokenOperator(name, coord)

    def token_double_quoted_string(self, text, coord):
        return TokenDoubleQuotedString(text, coord)

    def token_single_quoted_string(self, text, coord):
        return TokenSingleQuotedString(text, coord)

    def token_float(self, value, coord):
        return TokenFloat(value, coord)

    def token_int(self, value, coord):
        return TokenInt(value, coord)

    def token_keyword(self, name, coord):
        return TokenKeyword(name, coord)

    def token_identifier(self, name, coord):
        return TokenIdentifier(name, coord)
        
#==============================================================================
# backslash_rep
#==============================================================================

_RE_BACKSLASH = re.compile("\\.")

_BACKSLASH_REP = {
    "\\a": "\a",
    "\\b": "\b",
    "\\f": "\f",
    "\\n": "\n",
    "\\r": "\r",
    "\\t": "\t",
    "\\v": "\v" }
    
def _backslash_rep(m):
    """replaces a match-group for a backslash escape with its interpretation."""
    s = m.group()
    r = _BACKSLASH_REP.get(s)
    return r if r else s[0]

#==============================================================================
# TokenizerError
#==============================================================================

class TokenizerError(Exception):
    """raised by tokenizer engines.

    Attributes:
        msg: error string
        coord: coordinate object for where the error occurred
    """
    def __init__(self, msg, coord):
        self.msg = msg
        self.coord = coord

    def __str__(self):
        return "Tokenizer error: %s %s" % (self.msg,self.coord or "")

#==============================================================================
# Token
#==============================================================================

class Token:
    """Tokens are the elements consumed by a parser.

    Attributes:
        coord: a Coord object (or None) representing the origin of the token.
    """
    __slots__ = ("coord",)
    is_include = False
    is_macro = False
    is_eof = False
    def __init__(self, coord):
        self.coord = coord
    def __str__(self):
        """computes the informal representation of the token.

        this information representation is constructed by juxtaposition
        of the "abbrev" of the token and the information representation
        of its coordinate object.
        """
        return "%s %s" % (self.abbrev(), str(self.coord))
    def abbrev(self):
        """returns the abbreviated representation of the token."""
        raise NotImplemented

class TokenEOF(Token):
    __slots__ = ()
    is_eof = True
    def abbrev(self):
        return "EOF"

class TokenOperator(Token):
    __slots__ = ("name",)
    def __init__(self, name, coord):
        super(TokenOperator, self).__init__(coord)
        self.name = name
    def abbrev(self):
        return "operator %s" % self.name

class TokenNumber(Token):
    __slots__ = ("value",)
    def __init__(self, value, coord):
        super(TokenNumber, self).__init__(coord)
        self.value = value

class TokenFloat(TokenNumber):
    __slots__ = ()
    def abbrev(self):
        return "float %s" % self.value

class TokenInt(TokenNumber):
    __slots__ = ()
    def abbrev(self):
        return "int %s" % self.value

class TokenString(Token):
    __slots__ = ("text",)
    def __init__(self, text, coord):
        super(TokenString, self).__init__(coord)
        self.text = text
    def abbrev(self):
        return "string %s" % self.text

class TokenSingleQuotedString(TokenString):
    __slots__ = ()

class TokenDoubleQuotedString(TokenString):
    __slots__ = ()

class TokenBasicIdentifier(Token):
    __slots__ = ("name",)
    def __init__(self, name, coord):
        super(TokenBasicIdentifier, self).__init__(coord)
        self.name = name

class TokenIdentifier(TokenBasicIdentifier):
    __slots__ = ()
    def abbrev(self):
        return "identifier %s" % self.name

class TokenKeyword(TokenBasicIdentifier):
    __slots__ = ()
    def abbrev(self):
        return "keyword %s" % self.name

class TokenInclude(Token):
    __slots__ = ("filename",)
    is_include = True
    def __init__(self, filename, coord):
        super(TokenInclude, self).__init__(coord)
        self.filename = filename
    def abbrev(self):
        return "include %s" % self.filename

class TokenMacro(Token):
    __slots__ = ("name", "text",)
    is_macro = True
    def __init__(self, name, text, coord):
        super(TokenMacro, self).__init__(coord)
        self.name = name
        self.text = text
    def abbrev(self):
        return "macro %s %s" % (self.name, self.text)
