%% -*- prolog -*-

:- module(xmg_brick_mg_errors, []).
:- use_module(library(lists)).
:- use_module(library(charsio)).
:- use_module(edcg).

:- multifile user:generate_message_hook/3.
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

user:generate_message_hook(error(unhandled_exception,xmg(Exc)), In, Out) :--
	xmg_message(Exc,Msg),
	format_msg(Msg) with queue(Out, Int).
user:generate_message_hook(xmg(Exc), In, Out) :--
	xmg_message(Exc,Msg),
	format_msg(Msg) with queue(Out, In).

format_msg(Msg) -->>
	nonvar(Msg),
	Msg =.. [Label,Title,Specs],
	format_title(Title,Label),
	format_specs(Specs),
	format_footer,!.

format_title(Title, Label) -->>
	vs_to_string(Title) with queue(STitle,[]),
	vs_to_string(Label) with queue(SLabel,[]),
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

format_spec(hint(L,M)) -->> !,
	vs_to_string(L) with queue(LL,[]),
	vs_to_string(M) with queue(MM,[]),
	queue::enq("~t~s~12+: ~s"-[LL,MM]),
	queue::enq(nl).
format_spec(coord(F,L,C)) -->> !,
	format_spec(hint(filename,F)),
	format_spec(hint(line,L)),
	format_spec(hint(column,C)).
format_spec(line(VS)) -->> !,
	vs_to_string(VS) with queue(S,[]),
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
vs_to_string(write(T)) -->> !,
	write_to_chars(T,S),
	queue::enq_list(S).
vs_to_string(L) -->>
	queue::enq_list(L).

%% map exception term to message record

xmg_message(parser_error(expected(E,T,C)), Msg) :- !,
	Msg=error(parser,[hint(expected,E,T),C]).
xmg_message(parser_error(unsupported(T,C)), Msg) :- !,
	Msg=error(parser,[hint(unsupported,T),C]).
xmg_message(syntax_error(unexpected_definition(D)), Msg) :- !,
	Msg=error(syntax,[hint('unexpected definition',write(D))]).
xmg_message(syntax_error(intervalle(I,J,C)), Msg) :- !,
	Msg=error(syntax,[hint('illegal interval',"["#I#".."#J#"]"),C]).
xmg_message(unfolder_error(cycle_detected_with_class(A,C)),Msg):- !,
	Msg=error(unfolder,[hint('cycle detected with class',A),C]).
xmg_message(unfolder_error(no_class_value),Msg):- !,
	Msg=error(unfolder,[hint('no class set to be valued',''),coord('',0,0)]).
%% errors in type checking
xmg_message(type_error(property_not_declared(X,C)),Msg):- !,
	Msg=error(unfolder,[hint('property not declared',X),C]).
xmg_message(type_error(feature_not_declared(X,C)),Msg):- !,
	Msg=error(unfolder,[hint('feature not declared',X),C]).
xmg_message(type_error(value_not_in_range(X,C)),Msg):- !,
	Msg=error(unfolder,[hint('value not in range',X),C]).
xmg_message(type_error(variable_not_declared(X,C)),Msg):- !,
	Msg=error(unfolder,[hint('variable not declared',X),C]).

%% Modules errors
xmg_message(compiler_error(unknown_module(Module)), Msg):- !,
	Msg=error(compiler,[hint('unknown module',Module),C]).



xmg_message(Exc,_) :-
	writeln(xmg_message(Exc)),
	throw(xmg_message(Exc)).
