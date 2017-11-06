%% -*- prolog -*-

:- module(xmg_brick_mg_errors, []).

:- xmg:edcg.
:- use_module(library(lists)).
:- use_module(library(charsio)).
:- use_module(library(rbtrees)).

:-use_module(library(readutil)).

:- multifile(user:generate_message_hook/3).
% :- source.



:- edcg:thread(queue,edcg:queue).
:- edcg:weave([queue],
	       [format_msg/1,
		format_title/2,
		format_footer/0,
		format_specs/1,
		format_spec/1,
		vs_to_string/1]).

%% message: xmg(Message)

user:generate_message_hook(error(unhandled_exception,xmg(Exc)), In, Out):--
	xmg_message(Exc,Msg),
	format_msg(Msg) with queue([]-Out, []-In).
user:generate_message_hook(xmg(Exc), In, Out) :--
	xmg_message(Exc,Msg),
        format_msg(Msg) with queue([]-Out, []-In).

format_msg(Msg) -->>
	nonvar(Msg),
	Msg =.. [Label,Title,Specs],
	format_title(Title,Label),
	format_specs(Specs),
	format_footer,
	!.

format_title(Title, Label) -->>
	vs_to_string(Title) with queue([]-STitle,[]-[]),
	vs_to_string(Label) with queue([]-SLabel,[]-[]),
	queue::enq("-- ~s: ~s ~`-t~80+"-[STitle,SLabel]),
	queue::enq(nl).

format_footer -->>
	queue::enq("~`-t~80+"-[]),
	queue::enq(nl).

format_specs([]) -->> !.
format_specs([H|T]) -->>
	format_spec(H),
	format_specs(T).

%% format a line spec
%% <line> ::= hint(L,M) | coord(F,L,C) | line(VS) | unit

format_spec(hint(L)) -->> !,
        vs_to_string(L) with queue([]-LL,[]-[]),
	queue::enq("~t~s~12+"-[LL]),
	queue::enq(nl).
format_spec(hint(L,M)) -->> !,
	vs_to_string(L) with queue([]-LL,[]-[]),
	vs_to_string(M) with queue([]-MM,[]-[]),
	queue::enq("~t~s~12+: ~s"-[LL,MM]),
	queue::enq(nl).
format_spec(hint(L,M,N)) -->> !,
	vs_to_string(L) with queue([]-LL,[]-[]),
	vs_to_string(M) with queue([]-MM,[]-[]),
	vs_to_string(N) with queue([]-NN,[]-[]),
	queue::enq("~t~s~12+: ~s, got ~s"-[LL,MM,NN]),
	queue::enq(nl).
format_spec(coord(F,L,C)) -->> !,
	format_spec(hint(filename,F)),
	format_spec(hint(line,L)),
	format_spec(hint(column,C)).
format_spec(line(VS)) -->> !,
	vs_to_string(VS) with queue([]-S,[]-[]),
	queue::enq("~s"-[S]),
	queue::enq(nl).
format_spec(unit) -->> !,
	queue::enq(nl).
format_spec(L) -->> throw(format_line(L)).

%% virtual string to string

vs_to_string(S1#S2) -->> !,
	vs_to_string(S1),
	vs_to_string(S2).
vs_to_string(A) -->> atomic(A), !,
	name(A,S),
	queue::enq_list(S).
vs_to_string(coord(F,L,C)) -->> !,
	(F='' -> true;
	 name(F,FF),
	 queue::enq_list("file '"),
	 queue::enq_list(FF),
	 queue::enq_list("', ")),
	(name(L,LL),
	 queue::enq_list("line "),
	 queue::enq_list(LL)),
	(name(C,CC),
	 queue::enq_list(", column "),
	 queue::enq_list(CC)).
vs_to_string(exprs_types(E1,T1,_,T2))-->> 
	queue::enq_list("Incompatible types: "),
	get_first_coord(E1,C),
	vs_to_string(C),
	rec_name(T1,NT1),
	queue::enq_list("\n           Types are "),

	queue::enq_list(NT1),
	queue::enq_list(" and "),
	rec_name(T2,NT2),
	queue::enq_list(NT2),
	!.
vs_to_string(write(T)) -->> !,
	write_to_chars(T,S),
	queue::enq_list(S).
vs_to_string([H]) -->>
	atom(H),
	atom_codes(H,C),
	queue::enq_list(C),
	!.
vs_to_string([H|T]) -->>
	atom(H),
	atom_codes(H,C),
	queue::enq_list(C),
	queue::enq_list(" or "),
	vs_to_string(T),
	!.
vs_to_string(L) -->>
	queue::enq_list(L).
vs_to_string(A) -->>
	get_first_coord(A,C),
	queue::enq_list("\n        "),
	vs_to_string(C),
	C=coord(File,Line,_),
	get_lines(File,Line,Lines),
	queue::enq_list("\n        "),
	%%xmg:send(info,Lines),
	queue::enq_list(Lines),
	!.
vs_to_string(Term) -->>
	term_to_atom(Term,Atom),
	atom_codes(Atom,String),
	queue::enq_list(String),
	!.

rec_name(N,N1):-
	atom(N),
	name(N,N1),!.
rec_name(N,N1):-
	N=..[':',_,H|_],!,
	rec_name(H,N1),!.
rec_name(cavm(CAVM),AFSA):-
    %% That is clearly not what we want
    rb_visit(CAVM,FS),
    extract_only_attrs(FS,FSA),
    %%list_to_string(FSA,SFSA),
    atomic_list_concat(['C-AVM with these attributes: ['|FSA],CFSA),
    atom_codes(CFSA,AFSA),
    !.
rec_name(N,N1):-
	N=..[H|_],
	rec_name(H,N1),!.

extract_only_attrs([],[']']).
extract_only_attrs([H-_],[H,']']).
extract_only_attrs([H-_|T],[H,', '|T1]):-
    extract_only_attrs(T,T1),!.


get_first_coord(token(C,_),C):-!.
get_first_coord(N,C):-
	N=..[':',_,H|_],!,
	%%xmg:send(info,H),
	get_first_coord(H,C),!.
get_first_coord(N,C):-
	N=..[_,H|_],!,
	%%xmg:send(info,H),
	get_first_coord(H,C),!.



%% map exception term to message record

%% errors in tokenizer
xmg_message(tokenizer_error(unrecognized(T,C)), Msg) :- !,
	Msg=error(tokenizer,[hint(unrecognized,T),C]).

%% errors in parser
xmg_message(parser_error(expected(E,T,C)), Msg) :- !,
	Msg=error(parser,[hint(expected,E,T),C]).
xmg_message(parser_error(unsupported(T,C)), Msg) :- !,
	Msg=error(parser,[hint(unsupported,T),C]).
xmg_message(syntax_error(unexpected_definition(D)), Msg) :- !,
	Msg=error(syntax,[hint('unexpected definition',write(D))]).
xmg_message(syntax_error(intervalle(I,J,C)), Msg) :- !,
	Msg=error(syntax,[hint('illegal interval',"["#I#".."#J#"]"),C]).

%% errors in exporter
xmg_message(exporter_error(variable_not_declared(A,C)),Msg):- !,
	Msg=error(export,[hint('variable not declared',A),C]).
xmg_message(exporter_error(failed_import(A,C)),Msg):- !,
	Msg=error(export,[hint('failed to import class',A),C]).
xmg_message(exporter_error(failed_call(A,C)),Msg):- !,
	Msg=error(export,[hint('failed to call class '#A#" in class "#C)]).

%% errors in unfolder
xmg_message(unfolder_error(cycle_detected_with_class(A,C)),Msg):- !,
	Msg=error(unfolder,[hint('cycle detected with class',A),C]).
xmg_message(unfolder_error(no_class_value),Msg):- !,
	Msg=error(unfolder,[hint('no class set to be valued',''),coord('',0,0)]).
xmg_message(unfolder_error(no_unfolding(A)),Msg):- !,
	Msg=error(unfolder,[hint('Rule can not be unfolded',A)]).

%% errors in type checking
xmg_message(type_error(property_not_declared(X,C)),Msg):- !,
	Msg=error(types,[hint('property not declared',X),C]).
xmg_message(type_error(type_not_defined(X)),Msg):- !,
	Msg=error(types,[hint('type not defined',X)]).
xmg_message(type_error(feature_not_declared(X,C)),Msg):- !,
	Msg=error(types,[hint('feature not declared',X),C]).
xmg_message(type_error(value_not_in_range(X,C)),Msg):- !,
	Msg=error(types,[hint('value not in range',X),C]).
xmg_message(type_error(variable_not_declared(X,C)),Msg):- !,
	Msg=error(types,[hint('variable not declared',X),C]).
xmg_message(type_error(unknown_constant(X,C)),Msg):- !,
	Msg=error(types,[hint('unknown constant',X),C]).
xmg_message(type_error(incompatible_types(T1,T2,C)),Msg):- !,
	Msg=error(types,[hint('incompatible types',(T1,T2)),C]).
xmg_message(type_error(incompatible_exprs(expr(E1,T1),expr(E2,T2))),Msg):- !,
	 Msg=error(types,[hint('incompatible expressions',exprs_types(E1,T1,E2,T2))]).
xmg_message(type_error(multiple_type(X)),Msg):- !,
	Msg=error(types,[hint('multiple definitions of type',X)]).
xmg_message(type_error(multiple_const(X)),Msg):- !,
	Msg=error(types,[hint('multiple definitions of constant (in type definitions)',X)]).
xmg_message(type_error(multiple_feature(X)),Msg):- !,
	Msg=error(types,[hint('multiple definitions of feature',X)]).

xmg_message(type_error(no_frame_type),Msg):- !,
	Msg=error(types,[hint('no frame type declared, please use frame-types = {list_of_atomic_types}')]).

%% generator errors
xmg_message(generator_error(unknown_instruction(I)),Msg):- !,
	Msg=error(generator,[hint('unknown instruction',I)]).
xmg_message(generator_error(class_not_defined(I)),Msg):- !,
	Msg=error(generator,[hint('undefined class used for valuation',I)]).
xmg_message(generator_error(cannot_call(I)),Msg):- !,
	Msg=error(generator,[hint('undefined class used for call',I)]).

%% printer errors
xmg_message(printer_error(cannot_print(I)),Msg):- !,
	Msg=error(printer,[hint('cannot print',I)]).

%% Modules errors
xmg_message(compiler_error(unknown_module(Module)), Msg):- !,
	Msg=error(compiler,[hint('unknown module',Module)]).



xmg_message(Exc,_) :-
	writeln(xmg_message(Exc)),
	throw(xmg_message(Exc)).

%% Get some lines in the mg file to show the context of the error

get_lines(File,Line,Codes):-
	open(File,read,OFile),
	get_lines1(OFile,Line,Codes),!.
get_lines1(File,1,Codes):-
	read_line_to_codes(File,Codes),!.
get_lines1(File,N,Codes):-
	M is N - 1,
	read_line_to_codes(File,_),
	get_lines1(File,M,Codes),!.
