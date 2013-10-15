%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2012  Simon Petitjean

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


:- module(xmg_brick_mg_tokenizer).

:- use_module('xmg/brick/mg/edcg.yap').
:- use_module(library(lists)).


:- edcg:thread(macros,edcg:table).
:- edcg:thread(toks,edcg:queue).
:- edcg:thread(buf,edcg:queue).
:- edcg:thread(file,edcg:stack).
:- edcg:thread(chars,edcg:stack).
:- edcg:thread(line,edcg:counter).
:- edcg:thread(col,edcg:counter).


:- edcg:weave([macros],[tokenize_one_file/2,tokenize_one_file/3,
                        tokenize_string/4]).

:- edcg:weave([chars,line,col, file, toks, macros],[input_getc/1, input_gets/1, input_getC/1, update_line_col_string/1, update_line_col_code/1, spaces/0, space/0, comment/0, to_eol/0, tokens/1, macro_tokens/0, more_tokens/1, token/1, fileName/1, file/1, maybeDotExt/1, identifier/1, dim/1, number/1, string/1, punctuation/1, out_punctuation/1, bool/1,  dquote/0, bslash/0  ]).

:- edcg:weave([chars,line,col, file, toks, buf, macros],[word/0, more_word/0, float/0, digit/0, digits/0, more_digits/0, uint/0, sint/0, dot/0, optepn/0, more_string/0 ]).



%% :- edcg:weave(file,[tokens/1, macro_tokens/0, more_tokens/1, token/1  ]).

%% :- edcg:weave(toks,[tokens/1, macro_tokens/0, more_tokens/1, token/1, identifier/1  ]).

%% :- edcg:weave(macros,[tokenize_one_file/2, tokenize_one_file/3, tokenize_string/4, tokens/1, macro_tokens/0, more_tokens/1, token/1, identifier/1  ]).

%% :- edcg:weave(buf,[word/0, more_word/0, float/0, digit/0, digits/0, more_digits/0, uint/0, sint/0, dot/0, optepn/0, more_string/0]).


input_getc(C) :-- chars::pop(C), update_line_col_code(C).
input_gets(S) :-- chars::pops(S), update_line_col_string(S).

input_getC(C) :-- chars::pop(C), update_line_col_code(C).

update_line_col_code(C) :--
	C=0'\n %'
    ->  line::incr, 
	col::set(1)
	; 
	 col::incr.

update_line_col_string([]) :-- !.
update_line_col_string([H|T]) :--
	update_line_col_code(H),
	update_line_col_string(T).


spaces -->> space  , !, spaces.
spaces -->> comment, !, spaces.
spaces -->> [].
space  -->> input_getC(C), {code_type(C, end_of_file)}, !, file::pop(_).
space  -->> input_getC(C), {code_type(C, space)}.


comment -->>
	input_getc(0'%), %'
	to_eol, !.
to_eol  -->>
	input_getc(C), !,
	(C=0'\n -> true; to_eol), !. %'
to_eol  -->> [].



tokens(Encoding) -->> spaces, more_tokens(Encoding).
more_tokens(Encoding) -->>
	token(T), T='include', !, spaces,
	%% token(id(File)),
	fileName(File),
	atom_codes(AFile,File),
		xmg_compiler:send(info,'including '),
		xmg_compiler:send(info,AFile),
		xmg_compiler:send_nl(info),
	(exists(AFile) -> tokenize_one_file(AFile,TFile,Encoding) ;
	    (
		file::top(CFile),

		get_path(CFile,Path),
		append(Path,File,MFile),
		atom_codes(NFile,MFile),
		tokenize_one_file(NFile,TFile,Encoding)
	    )
	),
	toks::enq_list(TFile), tokens(Encoding).

more_tokens(Encoding) -->>
	token(macro), !,
	spaces, 
	token(id(A)),
	spaces,
	macro_tokens with toks(B,[]), 
	macros::tput(A,B),
	tokens(Encoding),
	%% ajout dans la table de macros
	!.
more_tokens(Encoding) -->>
	line::get(L), col::get(C), file::top(F),
	token(T), !, toks::put(coord(F,L,C)), toks::put(T), tokens(Encoding).
more_tokens(Encoding) -->> [].


macro_tokens -->> 
	line::get(L), col::get(C), file::top(F),
	token(T), !, toks::put(coord(F,L,C)), toks::put(T), macro_tokens.
macro_tokens -->> spaces,!.

	



%%token(T) -->>         dim(T), !.
token(T) -->>  identifier(T), !.
token(T) -->>      number(T), !.
token(T) -->>      string(T), !.
token(T) -->> punctuation(T), !.
token(T) -->>        bool(T), !.



fileName(N) -->> file(F),
	maybeDotExt(E),
	{append(F,E,N)}.

get_path(File,Path) :--
	absolute_file_name(File,Absolute),
	file_base_name(File,Base),
	atom_codes(Absolute, Absolute_codes),
	atom_codes(Base,Base_codes),
	get_path(Absolute_codes, Base_codes, Path),
	!.

get_path(Absolute, Base, Path) :--
	append(Path, Base, Absolute),!.

file(F) -->> word with buf([]-F,[]-[]).

maybeDotExt(E) -->>
	input_gets("."   ),
	word with buf(_-Ext,[]-[]), {append(".",Ext,E)}.




identifier(I) -->>
	word with buf([]-L,[]-[]),
	{ atom_codes(A,L),
	  ( 
	      (
	  	  dim(A) -> T=dim(A)
	      )
	  ;
	  (
	      keyword(A) -> T = A
	  )
      %% ; upperini(L)-> T = var(A)   
      ; 
        T =  id(A) ) },
	  ( macros::tget(A,M) -> (
		append(MB,[ME],M),
	      toks::pop(MB), 
	      I=ME
	  )
	  ;	  I=T)
	  
	  .

upperini([H|_]) :- code_type(H, upper).

word      -->> input_getc(C), {is_word_ini(C)},    buf::put(C), more_word.
more_word -->> input_getc(C), {is_word_mid(C)}, !, buf::put(C), more_word.
more_word -->> [].

is_word_ini(C) :- ( code_type(C, alpha); C=0'_ ), !. %'
is_word_mid(C) :- ( code_type(C, alnum); C=0'_ ; C=0'- ), !. %'

keyword(include).
keyword(node).
keyword(class).
keyword(mutex).
keyword(export).
keyword(import).
keyword(type).
keyword(property).
keyword(feature).
keyword(field).
keyword(feat).
keyword(as).
keyword(yielding).
keyword(declare).
keyword(except).
keyword(shadow).
keyword(value).
keyword(use).
keyword(with).
keyword(dims).
keyword(extern).
keyword(highlight).
keyword(semantics).
keyword(props).
keyword(feats).
keyword(leftm).
keyword(rightm).
keyword(macro).

keyword(edge).
keyword(hierarchy).

keyword(morpheme).
%%%%%%%%%%%%%%%%%%%%

dim(syn).
dim(sem).
dim(morph).
dim(pg).
dim(frame).

%% %% this might be useless
%% dim(dim(syn))   -->> input_gets("syn"  ), !.
%% dim(dim(morph)) -->> input_gets("morph"), !.
%% dim(dim(pg))    -->> input_gets("pg"   ), !.
%% dim(dim(sem))   -->> input_gets("sem"  ), !.

%% %% and this too (punctuation)
%% dim('<syn>')   -->> input_gets("<syn>"  ), !.
%% dim('<morph>') -->> input_gets("<morph>"), !.
%% dim('<pg>')    -->> input_gets("<pg>"   ), !.
%% dim('<sem>')   -->> input_gets("<sem>"  ), !.

number(float(F)) -->> float with buf(_-L,[]-[]), !, {number_codes(F,L)}.
number(  int(I)) -->> sint  with buf(_-L,[]-[]), !, {number_codes(I,L)}.

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


string(string(S)) -->> dquote, more_string with buf([]-S,[]-[]).
more_string -->> dquote, !.
more_string -->> bslash, !,
	input_getc(C), bslash_code(C,C2), buf::put(C2), more_string.
more_string -->> input_getc(C), buf::put(C), more_string.
dquote -->> input_getc(C), {C=0'"}. %"'
bslash -->> input_getc(C), {C=0'\\}. %'

bslash_code(0'n,0'\n) :- !.
bslash_code(0't,0'\t) :- !.
bslash_code(C,C).

%% PG

punctuation('<sem>'  ) -->> input_gets("<sem>"  ), !.
punctuation('<pg>'  ) -->> input_gets("<pg>"  ), !.
punctuation('<morph>'  ) -->> input_gets("<morph>"  ), !.
punctuation('<syn>'  ) -->> input_gets("<syn>"  ), !.
punctuation('<frame>'  ) -->> input_gets("<frame>"  ), !.

punctuation('<syn1>'  ) -->> input_gets("<syn1>"  ), !.
punctuation('<syn2>'  ) -->> input_gets("<syn2>"  ), !.


punctuation('=>'  ) -->> input_gets("=>"  ), !.
punctuation('<=!>'  ) -->> input_gets("<=!>"  ), !.
punctuation('-!-'  ) -->> input_gets("-!-"  ), !.

punctuation('<-'  ) -->> input_gets("<-"  ), !.
punctuation('...+') -->> input_gets("...+"), !.
punctuation(',,,+') -->> input_gets(",,,+"), !.
punctuation('...' ) -->> input_gets("..." ), !.
punctuation(',,,' ) -->> input_gets(",,," ), !.
punctuation(';;;' ) -->> input_gets(";;;" ), !.
punctuation('->*' ) -->> input_gets("->*" ), !.
punctuation('->+' ) -->> input_gets("->+" ), !.
punctuation('->'  ) -->> input_gets("->"  ), !.
punctuation('>>*' ) -->> input_gets(">>*" ), !.
punctuation('>>+' ) -->> input_gets(">>+" ), !.
punctuation('>>'  ) -->> input_gets(">>"  ), !.
punctuation('-L>' ) -->> input_gets("-L>" ), !.
punctuation('-R>' ) -->> input_gets("-R>" ), !.
punctuation('::'  ) -->> input_gets("::"  ), !.
punctuation(':='  ) -->> input_gets(":="  ), !.
punctuation('+='  ) -->> input_gets("+="  ), !.
punctuation('-='  ) -->> input_gets("-="  ), !.
punctuation('=+'  ) -->> input_gets("=+"  ), !.
punctuation('=-'  ) -->> input_gets("=-"  ), !.
punctuation('=~'  ) -->> input_gets("=~"  ), !.
punctuation('=|'  ) -->> input_gets("=|"  ), !.
punctuation('<<'  ) -->> input_gets("<<"  ), !.
%%punctuation('..'  ) -->> input_gets(".."  ), !.
punctuation('!='  ) -->> input_gets("!="  ), !.
punctuation('**'  ) -->> input_gets("**"  ), !.
%%punctuation('{'   ) -->> input_gets("{"   ), !.
punctuation('}'   ) -->> input_gets("}"   ), !.
punctuation('&'   ) -->> input_gets("&"   ), !.
punctuation('|'   ) -->> input_gets("|"   ), !.
punctuation('['   ) -->> input_gets("["   ), !.
punctuation(']'   ) -->> input_gets("]"   ), !.
punctuation(','   ) -->> input_gets(","   ), !.
punctuation('('   ) -->> input_gets("("   ), !.
punctuation(')'   ) -->> input_gets(")"   ), !.
punctuation('?'   ) -->> input_gets("?"   ), !.
punctuation('~'   ) -->> input_gets("~"   ), !.
punctuation(':'   ) -->> input_gets(":"   ), !.
punctuation('='   ) -->> input_gets("="   ), !.
punctuation('<'   ) -->> input_gets("<"   ), !.
punctuation('>'   ) -->> input_gets(">"   ), !.
punctuation('.'   ) -->> input_gets("."   ), !.
punctuation(';'   ) -->> input_gets(";"   ), !.
punctuation('@'   ) -->> input_gets("@"   ), !.
punctuation('!'   ) -->> input_gets("!"   ), !.
punctuation('*='   ) -->> input_gets("*="   ), !.

punctuation(P) :-- out_punctuation(P),!.

out_punctuation(P):--
	xmg_tokenizer_punct:punctuation(P),
	atom_codes(P,S),
	input_gets(S),
	!.


bool(bool('+')) -->> input_getc(0'+), !. %'
bool(bool('-')) -->> input_getc(0'-)   . %'



tokenize_string(N,S,L,Encoding) :--
	tokens(Encoding) with (chars(S,[]), file([N],_), line(1,R), col(1,C), toks(_-L,[]-[coord(N,R,C)])).

				% lecture de fichiers
file_to_string(Path, String) :--
	file_to_string(Path, String, utf8),!.

file_to_string(Path, String,Encoding) :--
	open(Path, read, IStream,[encoding(Encoding)]),
	stream_read_all(IStream, String),
	close(IStream), !.
	
stream_read_all(IStream, String) :--
	get_char(IStream, C),
	( C=end_of_file -> String=[] ;
	  atom_codes(C,[A]),
	  String=[A|String2],
	  stream_read_all(IStream, String2) ).

tokenize_one_file(Path,Tokens) :--
	file_to_string(Path,String),
	tokenize_string(Path,String,Tokens,utf8).

tokenize_one_file(Path,Tokens,Encoding):--
	file_to_string(Path,String,Encoding),
	tokenize_string(Path,String,Tokens,Encoding).

tokenize_file(Path, Tokens) :--
	tokenize_file(Path,Tokens,utf8).

tokenize_file(Path, Tokens, Encoding) :--
	xmg_table:table_new(DIn),	
	tokenize_one_file(Path,Tokens,Encoding) with macros(DIn,DOut),!.

%%

tokenize(  file(Path  ), Tokens) :- !, tokenize_file(Path,Tokens).
tokenize(  file(Path  ), Tokens, Encoding) :- !, tokenize_file(Path,Tokens, Encoding).
tokenize(string(String), Tokens) :- !, tokenize_string('',String,Tokens).
tokenize(       Path   , Tokens) :- atom(Path), !, tokenize(file(Path), Tokens).
tokenize(       Path   , Tokens, Encoding) :- atom(Path), !, tokenize(file(Path), Tokens, Encoding).
tokenize(       String , Tokens) :- !, tokenize(string(String), Tokens).