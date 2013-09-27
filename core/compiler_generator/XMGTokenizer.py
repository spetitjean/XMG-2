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

from pylr.Tokenizer import Token, TokenizerEngine, TokenizerBuilder
import re

#==============================================================================
# XMGTokenizer
#==============================================================================

class XMGTokenizerEngine(TokenizerEngine):
    """a tokenizer engine extended with support for special kinds of tokens.

    The special kinds of tokens are:

    DIMENSION:
        a dimension token looks like <FOO>.  its name is FOO.
    BOOLEAN:
        a boolean token is either + or -.
    INCLUDE:
        an include token has one of the following forms:
            include XYZ
            include "XYZ"
            include 'XYZ'
            include <XYZ>
        it is never returned to the parser.  such a token is purely internal
        to the tokenizer.
    MACRO:
        a macro token has the following form:
            macro XYZ UUUUUUUU
        the name of the macro is XYZ and its text is UUUUUUUU (up to the end
        of line).  such a token is never returned to the parser.  it is purely
        internal to the tokenizer.
    """

    DIMENSION = re.compile("<(\\s+)>")
    BOOLEAN = re.compile("[-+]")
    INCLUDE = re.compile("include\\s+(\\S+)")
    MACRO = re.compile("macro\\s+(\\w+)\\s+(.*)$")

    def early_special_token(self):
        m = self.DIMENSION.match(self.line, self.colno)
        if m:
            coord = self.coord()
            self.colno = m.end()
            return self.token_dimension(m.group(1), coord)
        m = self.INCLUDE.match(self.line, self.colno)
        if m:
            coord = self.coord()
            self.colno = m.end()
            return self.token_include(m.group(1), coord)
        m = self.MACRO.match(self.line, self.colno)
        if m:
            coord = self.coord()
            self.colno = m.end()
            return self.token_macro(m.group(1), m.group(2), coord)
        return super(XMGTokenizerEngine, self).early_special_token()

    def late_special_token(self):
        m = self.BOOLEAN.match(self.line, self.colno)
        if m:
            coord = self.coord()
            self.colno = m.end()
            return self.token_boolean(m.group(), coord)
        return super(XMGTokenizerEngine, self).late_special_token()

    def token_dimension(self, name, coord):
        return TokenDimension(name, coord)

    def token_boolean(self, name, coord):
        return TokenBoolean(name, coord)

    def token_include(self, filename, coord):
        if filename[0] == '"':
            if filename[-1] != '"':
                raise TokenizerError("filename syntax error", coord)
            return TokenInclude(filename[1:-1], coord)
        if filename[0] == "'":
            if filename[-1] != "'":
                raise TokenizerError("filename syntax error", coord)
            return TokenInclude(filename[1:-1], coord)
        if filename[0] == "<":
            if filename[-1] != ">":
                raise TokenizerError("filename syntax error", coord)
            return TokenInclude(filename[1:-1], coord)
        return TokenInclude(filename, coord)

    def token_macro(self, name, text, coord):
        return TokenMacro(name, text, coord)

class TokenDimension(Token):
    __slots__ = ("name",)
    def __init__(self, name, coord):
        super(TokenDimension, self).__init__(coord)
        self.name = name
    def abbrev(self):
        return "dimension %s" % self.name

class TokenBoolean(Token):
    __slots__ = ("name",)
    def __init__(self, name, coord):
        super(TokenBoolean, self).__init__(coord)
        self.name = name
    def abbrev(self):
        return "boolean %s" % self.name

XMGTokenizer = TokenizerBuilder(XMGTokenizerEngine)

XMGTokenizer.operators([
    "...+", ",,,+", "...", ",,,", ";;;",
    "->*", "->+", "->", ">>*", ">>+", ">>",
    "-L>", "-R>", "::", ":=", "+=", "-=",
    "=+", "=-", "=~", "=|", "<<", "..", "!=",
    "**", "{", "}", "&", "|", "[", "]", ",",
    "(", ")", "?", "~", ":", "=", "<", ">",
    ".", ";", "@", "!", "*="])

XMGTokenizer.keywords([
    "node", "class", "mutex", "export", "import", "type",
    "property", "feature", "as", "yielding", "declare",
    "except", "shadow", "value", "use", "with", "dims",
    "extern", "highlight", "semantics", "props", "feats",
    "leftm", "rightm"])

XMGTokenizer.eol_comment("%")
