%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2012  Denys Duchier, Simon Petitjean

%%  This program is free software: you can redistribute it and/or modify
%%  it under the terms of the GNU General Public License as published by
%%  the Free Software Foundation, either version 3 of the License, or
%%  (at your option) any later version.

%%  This program is distributed in the hope that it will be useful,
%%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%  GNU General Public License for more details.

%%  You should have received a copy of the GNU General Public License
%%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%% ========================================================================


:- module(xmg_brick_mg_tokenizer,[tokenize/2, tokenize/3]).

%%:- use_module('xmg/brick/mg/edcg.yap').
%%:- use_module(library(lists)).

:- xmg:edcg.

:- multifile(xmg:punctuation/1).
:- multifile(xmg:keyword/1).

:- edcg:thread(macros  ,edcg:table  ). % table of macros
:- edcg:thread(toks    ,edcg:queue  ). % accumulated tokens
:- edcg:thread(buf     ,edcg:queue  ). % buffer for accumulating the chars of a token
:- edcg:thread(file    ,edcg:stack  ). % top of stack is current filename
:- edcg:thread(chars   ,edcg:stack  ). % current file's content as a stack
:- edcg:thread(line    ,edcg:counter). % current line number
:- edcg:thread(col     ,edcg:counter). % current col number
:- edcg:thread(encoding,edcg:value  ). % current encoding (default utf-8)
:- edcg:thread(tokbuf  ,edcg:queue  ). % buffer of tokens inserted by macros

:- edcg:weave([chars, line, col],
	      [input_getc/1, input_gets/1, input_getline/1,
	       comment/0, to_eol/0,
	       fileName/1, maybeDotExt/1]).

:- edcg:weave([chars, line, col, file],
	      [spaces/0, space/0, resume_previous_file/0,
	       number/2, string/2, dimtype/2]).

:- edcg:weave([line, col],
	      [update_line_col_string/1, update_line_col_code/1]).

:- edcg:weave([chars, line, col, buf],
	      [word/0, more_word/0,
	       float/0, digit/0, digits/0, more_digits/0,
	       uint/0, sint/0, dot/0, optepn/0,
	       more_string/1,more_dimtype1/0,more_dimtype2/0]).

:- edcg:weave([tokbuf],[inserted/2]).

:- edcg:weave([chars, line, col, file, toks, macros, encoding, tokbuf],
	      [tokens/0, more_tokens/0, more_tokens_include/0,
	       more_tokens_macro/0, macro_tokens/0, macro_more_tokens/0,
	       token/2, identifier/2, punctuation/2]).

:- edcg:weave([line, col, file],[coord/1]).

:- edcg:weave([file],[resolve_file/3]).

:- edcg:weave([chars, line, col, file, encoding],[divert_to_file/1]).

%%=============================================================================
%% read a character or a (given) string from the chars buffer and update line
%% and col counters.
%%=============================================================================

input_getc(C) :-- chars::pop(C), update_line_col_code(C).
input_gets(S) :-- chars::pops(S), update_line_col_string(S).

update_line_col_code(C) :--
    C=0'\n %'
    ->  (line::incr, col::set(1))
    ;                col::incr.

update_line_col_string([]) :-- !.
update_line_col_string([H|T]) :--
	update_line_col_code(H),
	update_line_col_string(T).

input_getline(S) :--		% read up to the end-of-line
    chars::pop(C), update_line_col_code(C),
    (C=0'\n -> S=[] ; (S=[C|T], input_getline(T))).

%%=============================================================================
%% skip white spaces, comments or to end of line
%%=============================================================================

spaces -->> chars::empty, !, (resume_previous_file -> spaces ; true).
spaces -->> space  , !, spaces.
spaces -->> comment, !, spaces.
spaces -->> [].

space  -->> input_getc(C), {code_type(C, space)}.

resume_previous_file -->>
    file::pop(_), file::pop((Chars, Line, Col)),
    chars::set(Chars), line::set(Line), col::set(Col).

comment -->>
    input_getc(0'%), %'
    to_eol, !.

to_eol  -->>
    input_getc(C), !,
    (C=0'\n -> true; to_eol), !. %'
to_eol  -->> [].

%%=============================================================================
%% read and enqueue tokens (in the toks queue).
%%
%% two tokens are treated specially: the atom 'include' indicates to the
%% tokenizer that it should perform a "file include".  the atom 'macro'
%% indicates to the tokenizer that it should read and record a macro.
%%
%% we might want to make these atoms configurable...
%%=============================================================================

tokens -->> spaces, more_tokens.

coord(coord(F,L,C)) -->>
    line::get(L), col::get(C), file::top(F).

more_tokens -->>
    token(T,C), !,
	%% xmg:send(info,T),
	%% xmg:send(info,'\n'),
    (T=id(include) -> more_tokens_include ;
     T=id(macro)   -> more_tokens_macro ;
     (toks::put(C), toks::put(T))),
    tokens.
more_tokens -->> [].
more_tokens -->>
	    line::get(L), col::get(C), file::top(F), Coord=coord(F,L,C), input_getline(S),
            throw(xmg(tokenizer_error(unrecognized(S,Coord)))).

%%=============================================================================
%% proceed to perform a "file include"
%%=============================================================================

more_tokens_include -->>
    spaces,
    fileName(File),
    atom_codes(AFile,File),
    resolve_file(AFile, File, Path),
    divert_to_file(Path),
    tokens.

resolve_file(AFile, File, Path) -->>
    exists(AFile) -> Path=AFile ;
    ( file::top(CFile),
      get_path(CFile, CPath),
      lists:append(CPath, File, MFile),
      atom_codes(Path, MFile) ).

divert_to_file(AFile) -->>
    encoding::get(Encoding),
    file_to_string(AFile, Text, Encoding),
    chars::value(Chars), line::get(Line), col::get(Col),
    file::push((Chars, Line, Col)),
    file::push(AFile),
    chars::set(Text), line::set(1), col::set(1).

fileName(N) -->>
    word with buf([]-F,[]-[]),
    maybeDotExt(E),
    {lists:append(F,E,N)}.

maybeDotExt(E) -->>
    input_gets(".")
    -> (word with buf(_-Ext,[]-[]), {lists:append(".",Ext,E)})
    ; E=[].

get_path(File, Path) :-
    absolute_file_name(File, Absolute),
    file_base_name(File, Base),
    atom_codes(Absolute, Absolute_codes),
    atom_codes(Base, Base_codes),
    get_path(Absolute_codes, Base_codes, Path),
    !.
get_path(Absolute, Base, Path) :-
    lists:append(Path, Base, Absolute),!.

%%=============================================================================
%% proceed to read and record a macro
%%=============================================================================

more_tokens_macro -->>
    spaces, 
    token(id(A),_),
    line::get(L), col::get(C),
    input_getline(S),
    macro_tokens with (chars(S,[]),
		       toks([]-B, []-[]),
		       line(L,_),
		       col(C,_),
		       tokbuf(TB-TB, []-[])),
    macros::tput(A,B), !.

macro_tokens -->> spaces, macro_more_tokens.

macro_more_tokens -->> 
    token(T,_), !, toks::put(T), macro_tokens.
macro_more_tokens -->> [].

%%=============================================================================
%% read and return the next token.
%%=============================================================================

token(T,C) -->>     dimtype(T,C), !.
token(T,C) -->>    inserted(T,C), !.
token(T,C) -->> punctuation(T,C), !.
token(T,C) -->>  identifier(T,C), !.
token(T,C) -->>      number(T,C), !.
token(T,C) -->>      string(T,C), !.

inserted(T,C) -->> tokbuf::get((T,C)). % was actually contributed by macro expansion

identifier(T,C) -->>
    coord(C1),
    word with buf([]-L,[]-[]),
    atom_codes(A,L),
    ( macros::tget(A,Ts)
      -> (add_coord(Ts,Ps,C1), tokbuf::enq_list(Ps), token(T,C))
      ; identifier_to_token(A,T), C=C1 ).

add_coord([],[],_).
add_coord([H|T],[(H,C)|L],C) :- add_coord(T,L,C).

word      -->> input_getc(C), {is_word_ini(C)},    buf::put(C), more_word.
more_word -->> input_getc(C), {is_word_mid(C)}, !, buf::put(C), more_word.
more_word -->> [].

is_word_ini(C) :- ( code_type(C, alpha); C=0'_ ), !. %'
is_word_mid(C) :- ( code_type(C, alnum); C=0'_ ; C=0'- ), !. %'

%% converting an identifier into a token:
%% if xmg:keyword(A) then A is used as the token
%% if xmg:identifier_to_token(A,T) provides a conversion then T is used
%% otherwise id(A) is used as the token.

:- dynamic(xmg:identifier_to_token/2).

identifier_to_token(A,A) :- xmg:keyword(A),!.
identifier_to_token(A,T) :- xmg:identifier_to_token(A,T),!.
identifier_to_token(A,id(A)).


%%=============================================================================
%% read a float or an int
%%=============================================================================

number(float(F),C) -->> coord(C), float with buf(_-L,[]-[]), !, {number_codes(F,L)}.
number(  int(I),C) -->> coord(C), sint  with buf(_-L,[]-[]), !, {number_codes(I,L)}.

float       -->> sint, dot, uint, optepn.
digit       -->> input_getc(C), {code_type(C, digit)}, buf::put(C).
digits      -->> digit, more_digits.
more_digits -->> digit, !, more_digits.
more_digits -->> [].
uint        -->> digits.
sint        -->> input_getc(C), {C=0'+ ; C=0'-}, !, buf::put(C), uint.
sint        -->> uint.
dot         -->> input_getc(C), {C=0'.}, buf::put(C). %'
optepn      -->> input_getc(C), {C=0'e ; C=0'E}, !, buf::put(C), sint.
optepn      -->> [].

%%=============================================================================
%% read a delimited string
%%=============================================================================

string_delimiters(0'", 0'",  string). % should be dstring?
%string_delimiters(0'', 0'', sstring).
%string_delimiters(0'«, 0'», gstring).

string(R,C) -->>
    coord(C),
    input_getc(C1),
    string_delimiters(C1, C2, Cons),
    more_string(C2) with buf([]-S, []-[]),
    R =.. [Cons, S].

more_string(D) -->> input_getc(D), !.
more_string(D) -->>
    input_getc(0'\\), !,
    input_getc(C), bslash_code(C,C2), buf::put(C2),
    more_string(D).
more_string(D) -->>
    input_getc(C), buf::put(C),
    more_string(D).

bslash_code(0'n,0'\n) :- !.
bslash_code(0't,0'\t) :- !.
bslash_code(C,C).

%%=============================================================================
%% read a dimension type
%%=============================================================================

dimtype(R,C) -->>
    coord(C),
    input_getc(0'<),%'
    more_dimtype1 with buf([]-S1, []-[]),
    atom_codes(L1,S1),
    more_dimtype2 with buf([]-S2, []-[]),
    atom_codes(L2,S2),
    R =dimtype(L1,L2).

more_dimtype1 -->> input_getc(0':), %' 
	!.
more_dimtype1 -->>
    input_getc(C), 
    is_word_mid(C),	
    buf::put(C),
    more_dimtype1.

more_dimtype2 -->> input_getc(0'>), %'
	!.
more_dimtype2 -->>
    input_getc(C), 
    is_word_mid(C),	
    buf::put(C),
    more_dimtype2.

%%=============================================================================
%% all punctuation should be externalized!
%%
%% read a string, convert it to an atom, transform it into a token.
%% xmg:punctuation(A) is a predicate that is automatically generated for each
%% metagrammar, based on declarations collecte from the various bricks.  A is
%% an atom, it is converted into a string S, which is then (tentatively) read
%% from the input. when that succeeds, A is then converted into a token by
%% xmg:punctuation_to_token(A,T) which is a multifile predicate provided by
%% bricks. if no such conversion is found, then A is used as the token itself.
%%=============================================================================

%    xmg_tokenizer_punct:punctuation(P),
punctuation(T,C) :--
    coord(C),
    xmg:punctuation(A),
    atom_codes(A,S),
    input_gets(S), !,
    punctuation_to_token(A,T).

punctuation_to_token(A,T) :-
    xmg:punctuation_to_token(A,T), !.
punctuation_to_token(A,A).

%%=============================================================================
%% read a + or - as a boolean
%%=============================================================================
%% DENYS!!!
%% move this out to where it belongs

xmg:punctuation('+').
xmg:punctuation('-').

xmg:punctuation_to_token('+', bool('+')).
xmg:punctuation_to_token('-', bool('-')).

%%=============================================================================
%% read a file and return its contents as a string.
%%=============================================================================

file_to_string(Path, String, Encoding) :-
    open(Path, read, IStream,[encoding(Encoding)]),
    stream_read_all(IStream, String),
    close(IStream), !.
	
stream_read_all(IStream, String) :--
    get_char(IStream, C),
    ( C=end_of_file -> String=[] ;
      atom_codes(C,[A]),
      String=[A|String2],
      stream_read_all(IStream, String2) ).

%%=============================================================================
%% tokenize a string or a file.
%%=============================================================================

tokenize_string(Name, Text, Tokens, Encoding) :--
    xmg_table:table_new(DIn),
    tokens with (chars(Text,[]),
		 file([Name],_),
		 line(1,R),
		 col(1,C),
		 toks([]-Tokens,[]-[coord(Name,R,C)]),
		 tokbuf(TB-TB,[]-[]),
		 encoding(Encoding,_),
		 macros(DIn,_)).

tokenize_file(Path, Tokens, Encoding) :--
    file_to_string(Path, String, Encoding),
    tokenize_string(Path, String, Tokens, Encoding).

%%=============================================================================
%% main entry points to the tokenizer
%%=============================================================================

tokenize(  file(Path  ), Tokens)           :- !, tokenize_file(Path, Tokens, utf8).
tokenize(  file(Path  ), Tokens, Encoding) :- !, tokenize_file(Path, Tokens, Encoding).
tokenize(string(String), Tokens)           :- !, tokenize_string('<string>', String, Tokens, utf8).
tokenize(string(String), Tokens, Encoding) :- !, tokenize_string('<string>', String, Tokens, Encoding).
tokenize(       Path   , Tokens)           :- atom(Path), !, tokenize(file(Path), Tokens, utf8).
tokenize(       Path   , Tokens, Encoding) :- atom(Path), !, tokenize(file(Path), Tokens, Encoding).
tokenize(       String , Tokens)           :- !, tokenize(string(String), Tokens).
