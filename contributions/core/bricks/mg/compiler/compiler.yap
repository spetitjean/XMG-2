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

:-module(xmg_brick_mg_compiler).

xmg:import(File):-
    %%xmg:send(info,'\nGetting path'),
    xmg:path(XMG),
    %%xmg:send(info,'\nPath:'),
    %%xmg:send(info,XMG),
    atom_concat([XMG,File],Concat),
    load_files([Concat],[silent(true)]).
xmg:import(File,Import):-
    xmg:path(XMG),
    atom_concat([XMG,File],Concat),
    use_module(Concat,Import).
 
:-xmg:import('xmg/brick/mg/compiler/prelude.yap').

:-dynamic(principle/1).
:-dynamic(xmg:principle/3).
:-dynamic(unicity/1).
:-dynamic(current/1).
:-dynamic(debug_mode/0).
:-dynamic(xmg:more_mode/0).
:-dynamic(json_output/0).
:-dynamic(xmg:notype_mode/0).

:-dynamic(xmg:print_appendix/0).

%% Customizing tags in the output
:-dynamic(xmg:grammar_tags/1). 
:-dynamic(xmg:entry_tag/1).
%% Delete the trace from the output
:-dynamic(xmg:trace_off/0).

:-multifile(xmg:send_others/2).

%% xmg:eval extracts the models from a description. 
:-multifile(xmg:eval/6).
:-multifile(xmg:eval/8).


%encoding(iso_latin_1).
%encoding(utf8).
%debug_mode(false).

debug_mode_on:-
    asserta(debug_mode).

more_mode_on:-
    asserta(xmg:more_mode).

json_output_on:-
    asserta(json_output).

notype_mode_on:-
	asserta(xmg:notype_mode).


xmg:send(I,Mess):-
    xmg:send_others(I,Mess),!.
xmg:send(info,Mess):-
        print(user_error,Mess),!.
xmg:send(debug,Mess):-
	debug_mode,!,
	%%xmg:send(info,'\nDEBUG: '),
	print(user_error,Mess),!.
xmg:send(debug,Mess):-
	not(debug_mode),!.
xmg:send(out,Mess):-
	print(user_output,Mess),!.
xmg:send_nl(info):-
	xmg:send(info,'\n'),!.
xmg:send_nl(info,1):-
	xmg:send(info,'\n'),!.
xmg:send_nl(info,N):-
	xmg:send(info,'\n'),!,
	M is N -1,!,
	xmg:send_nl(info,M),!.

send(O,M):-!, xmg:send(O,M),!.


compile_file(File,Eval,Encoding,Debug,JSON,NoTypes,More):-
	asserta(encoding(Encoding)),
	(
	    Debug='on'
	    ->
	     ( debug_mode_on, xmg:send(info,'\n\nDebug Mode ON\n\n\n'))
             ;
	     ( true, xmg:send(info,'\n\nDebug Mode OFF. To activate, please use the option --debug\n\n\n'))
	),
	(
	    JSON='on'
	    ->
	     ( json_output_on, xmg:send(info,'\n\nOutput language set to JSON\n\n\n'))
             ;
	     ( true, xmg:send(info,'\n\nUsing XML as output language. To switch to JSON, please use the option --json\n\n\n'))
	),
	(
	    NoTypes='on'
	    ->
	     ( notype_mode_on, xmg:send(info,'\n\nType checking OFF.\n\n\n'))
             ;
	     (true)
	),!,
	
	(
	    More='on'
	    ->
	     ( more_mode_on, xmg:send(info,'\n\nPrinting of additional files activated.\n\n\n'))
             ;
	     (true)
	),!,
	 catch(compile_file(File,Eval),Exception,true),
	 (
	     not(var(Exception))->
	       print_message(error, Exception)
	       ;
	       true
	   ),
	 halt.


compile_file(File,Eval):-
	xmg:send(info,'\n\n\nInitializing'),

	xmg_compiler_conf:init,
	%%findall(Module,xmg_modules_def:module_def(_,Module),Modules),
	%%xmg:xmg:send(info,Modules),
	%%xmg_brick_mg_modules:load_modules(Modules),

	xmg:send(info,'\n\n\nInitializing threads'),
	xmg_compiler_conf:init_threads,

	xmg:send(info,'\nloaded '),
	xmg:send(info,'\nparsing '),

	xmg_brick_mg_parser:parse_file(File,[Parse]),!,
	xmg:send(info,' parsed '),
	xmg:send(debug,'\n'),
	xmg:send(debug,Parse),
	xmg:send_nl(info),

	%%xmg_brick_mg_pprint:pprint(Parse),
	%%xmg:send(info,Parse),

	xmg_brick_mg_exporter:export_metagrammar(Parse,Ordered),!,
	xmg:send(info,' exported '),
	xmg:send_nl(info),

	%% xmg_brick_mg_typer:type_metagrammar(Ordered),!,
	%% xmg:send(info,' typed '),
	%% xmg:send_nl(info),

	xmg_brick_mg_unfolder:unfold(Ordered,Unfolded),!,
	xmg:send(info,'\nUnfolded '),
	%%xmg:send(info,'\n'),
	%%xmg:send(info,Unfolded),
	xmg:send_nl(info),	
	xmg_brick_decls_principles:principles(Unfolded),!,
	xmg:send(debug,' principles done '),


	xmg_brick_mg_generator:generate(Unfolded),!,
	xmg:send_nl(info),	
	xmg:send(info,' generated '),
	xmg:send_nl(info),	

	retractall(xmg_brick_mg_exporter:declared(_,_)),
	retractall(xmg_brick_mg_exporter:exports(_,_)),
	
	asserta(current(0)),

	print_header,
	xmg:send(debug,'\nEval starting'),
	eval,
	xmg:send(info,'\nPrinting appendices'),
    	maybe_print_appendices,
	xmg:send(info,'\nEnd').



print_header:-
    json_output,
    !.

print_header:-
    not(json_output),
    xmg:send(out,'<?xml version="1.0" encoding="UTF-8" standalone="no" ?>\n'),
    (xmg:grammar_tags(Tags)-> (print_tags(Tags,Out), xmg:send(out,Out))
    ; xmg:send(out,'<grammar>\n')),
    !.

print_tags([],''):-!.
print_tags([H|T],Out):-
    print_tag(H,Hout),
    print_tags(T,Tout),
    atom_concat([Hout,Tout],Out),!.

print_tag(Tag,Out):-
    atom_concat(['<',Tag,'>\n'],Out),!.


maybe_print_appendices:- xmg:print_appendix,fail.
maybe_print_appendices.



eval:-
    xmg:send(info,'\nEvaluating class '),
    %%xmg_brick_mg_generator:compute(Class,Computed),
	xmg:value_all(Computed,Class),
	
	xmg:send(info,'\nClass executed: '),
	xmg:send(debug,Computed),
	xmg:send(info,Class),

	%% xmg_dimensions:dims(Dims),
	%% Computed=dims(Dims),

	get_dim(trace,Computed,Trace),

	%%xmg:send(info,'\ngot trace\n'),

	findall(Mutex,xmg:mutex(Mutex),Mutexes),
	xmg:send(info,'\nMutexes:'),
	xmg:send(info,Mutexes),
	check_mutexes(Trace,Mutexes),

	xmg:send_nl(info),xmg:send_nl(info),xmg:send(info,'                Computed '),xmg:send(info,Class),xmg:send_nl(info),xmg:send_nl(info),

	%%xmg:send(info,Computed),
	
	iface_last(Computed,OComputed),

	eval_dims(OComputed,EDims,Class),
	current(Previous),
	Current is Previous + 1,
	retract(current(Previous)),
	asserta(current(Current)),
	xmg:do_xml_convert(mg:entry(Class,Trace,EDims,Previous),XML),
	print_solution(XML),
	xmg:send(info,'Printed model '),
	xmg:send(info,Previous),xmg:send_nl(info),xmg:send_nl(info),


	xmg:send(info,'________________________________________________\nDone class '),
	xmg:send(info,Class),
	xmg:send_nl(info),
	xmg:send_nl(info),
	fail.


print_solution(JSON):-
    json_output,
    xmg:printJSON(JSON,1),!.
print_solution(XML):-
    not(json_output),
    xmg:printXML(XML,1),!.


iface_last([],[]).
iface_last([iface-I|T],T1):-
	lists:append(T,[iface-I],T1),!.
iface_last([H|T],[H|T1]):-
	iface_last(T,T1),!.

eval:-
    print_end_file,
    xmg:send(info,'\n\n________________________________________________\n________________________________________________'),
    xmg:send(info,'\n\n      Process ended: '),
    current(Number),
    xmg:send(info,Number),
    xmg:send(info,' models found.\n________________________________________________\n________________________________________________\n\n'),
    !.

print_end_file:-
    json_output,
    !.
print_end_file:-
    not(json_output),
    (xmg:grammar_tags(Tags)-> (print_closing_tags(Tags,Out), xmg:send(out,Out))
     ; xmg:send(out,'</grammar>\n')),
    !.

print_closing_tags([],''):-!.
print_closing_tags([H|T],Out):-
    print_closing_tags(T,Tout),
    print_closing_tag(H,Hout),
    atom_concat([Tout,Hout],Out),!.

print_closing_tag(Tag,Out):-
    atom_concat(['</',Tag,'>\n'],Out),!.


eval_dims([],[],_):-!.
eval_dims([trace-Acc|T],T1,Class):-!,
	eval_dims(T,T1,Class).
eval_dims([skolem-Acc|T],T1,Class):-
	eval_dims(T,T1,Class).
eval_dims([Dim-Acc|T],[XML|T1],Class):-
	xmg:send(info,Dim),
	xmg:dimbrick(Dim,DimBrick),
	findall(Solver,xmg:solver(Dim,Solver),Solvers),
	xmg:eval(DimBrick,Dim,Solvers,Acc,XML,Class),
	xmg:send(info,'\nDone '),
	xmg:send(debug,Dim),
	xmg:send(debug,XML),
	
	eval_dims(T,T1,Class).

		
get_dim(Dim,[Dim-CDim|_],CDim):-!.
get_dim(Dim,[_|T],CDim):-
	get_dim(Dim,T,CDim),!.



check_mutexes(_,[]):- !.
check_mutexes(Trace,[H|T]):-
	check_mutex(Trace,H),!,
	check_mutexes(Trace,T),!.

check_mutex([],_):- !.
check_mutex([Class|T],Mutex):-
	xmg:mutex_add(Mutex,Class),!,
	fail_if_mutex(T,Class,Mutex),!.
check_mutex([Class|T],Mutex):-
	not(xmg:mutex_add(Mutex,Class)),!,
	check_mutex(T,Mutex),!.

fail_if_mutex([],_,_):- !.
fail_if_mutex([Class|T],Class,Mutex):-
	!,
	fail_if_mutex(T,Class,Mutex),!.
fail_if_mutex([Class|T],First,Mutex):-
	xmg:mutex_add(Mutex,Class),!,
	xmg:send(info,' mutex fail '),
	%%halt.
	fail.
fail_if_mutex([Class|T],First,Mutex):-
	%%not(xmg:mutex_add(Mutex,Class)),!,
	!,fail_if_mutex(T,First,Mutex),!.
