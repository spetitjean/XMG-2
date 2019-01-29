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

:-module(xmg_brick_mg_generator).

:- xmg:edcg.
:-edcg:thread(decls,edcg:table).
:-edcg:thread(name,edcg:counter).
:-edcg:thread(code,edcg:queue).

:-multifile(xmg:generate_instr/7).
:-dynamic(xmg:is_class/1).


:-edcg:weave([decls,name], [var_or_const/2,new_name/2, put_in_table/1, generate_class/2, import_calls/3,  unify_exports/3, unify_exports_as/4, do_unify_exports/4, list_exports/3, get_params/3, xmg_brick_control_generator:generate/4]).
:-edcg:weave([decls,name,code],[xmg:generate_instr/1, xmg:generate_instrs/1]).

%% :- edcg:thread(xmg_generator:skolem, edcg:counter).
%% :- edcg:weave([xmg_generator:skolem],[xmg_generator:init_skolems/1]).

xmg:value_all(Value,Class):-
	xmg:value(Class),
	xmg:send(info,'\nValue class '),
	xmg:send(info,Class),
	xmg:start_value_class(Class,Value).

new_name(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),!.

threads_([]):- !.
%% threads_([skolem-_|T]):-
%% 	threads_(T),!.
threads_([iface-_|T]):-
	edcg:edcg_thread(xmg_acc:iface, edcg:value),
	threads_(T),!.
threads_([Dim-_|T]):-
	edcg:edcg_thread(xmg_acc:Dim, edcg:queue),
	threads_(T),!.

prefix_for_weave([],[]):- !.
prefix_for_weave([Dim-_|T],[xmg_acc:Dim|T1]):-
	prefix_for_weave(T,T1),!.

xmg:generate_instrs([]):-- !.
xmg:generate_instrs([H|T]):--
	xmg:generate_instr(H),
	xmg:generate_instrs(T),!.
xmg:generate_instrs([H|T]):--
	throw(xmg(generator_error(unknown_instruction(H)))).

generate(mg(_,Classes,Values)):-
	%% xmg_dimensions:dims(Dims),
	%% threads_(Dims),
	%% xmg_table:table_new(TableIn),
	%% xmg_brick_mg_compiler:send_nl(info),
	%% xmg_brick_mg_compiler:send(info,' threading classes'),
	xmg_brick_mg_compiler:send(info,' generating classes'),
	
	generate_classes(Classes),
	generate_values(Values).





generate_classes([]):-- !.
generate_classes([mutex(id(M,_))|T]):--
	asserta(xmg_brick_mg_compiler:mutex(M)),
	generate_classes(T),!.
generate_classes([mutex_add(id(M,_),id(A,_))|T]):--
	asserta(xmg_brick_mg_compiler:mutex_add(M,A)),
	generate_classes(T),!.
generate_classes([semantics|T]):--
	generate_classes(T),!.
generate_classes([class(Class,P,I,_,_,built(Stmt,Vars),coord(_,_,_))|T]):--

	xmg_brick_mg_compiler:send(debug,'\n______________________________________________\n\n'),
	xmg_brick_mg_compiler:send(debug,'generating '),
	xmg_brick_mg_compiler:send(debug,Class),xmg_brick_mg_compiler:send(debug,'\n'),

	xmg_brick_mg_exporter:declared(Class,List),
	xmg_brick_mg_compiler:send(debug,'with vars: '),
	xmg_brick_mg_compiler:send(debug,Vars),

	%%xmg_table:table_new(TableIn),
	%%put_in_table(List) with (decls(Vars,TableOut),name(_,_)),
	%%xmg:send(info,TableOut),
	%%xmg:send(info,'\n\n'),

	%%xmg:send(info,Vars),
	%%xmg:send(info,'\n\n'),

	generate_class(class(Class,P,I,_,_,Stmt,coord(_,_,_)),List) with (decls(Vars,_),name(0,_)),!,
	%%xmg:send(info,TableOut),
	generate_classes(T).

generate_class(class(Class,P,I,_,_,Stmt,coord(_,_,_)),List):--
	
	%%xmg_brick_mg_exporter:declared(Class,List),
	xmg_brick_mg_exporter:exports(Class,Exports),
	%%xmg:send(info,Exports),
	%%xmg:send(info,List),

	list_exports(Exports,List,LExports),

	import_calls(I,List,ICalls),

	get_params(P,List,GP),

	%%xmg:send(info,' got params '),
	
	xmg:generate_instrs(Stmt) with code([]-Generated,[]-[]),
	extract_code(Generated,EGenerated),

	%%xmg:send(info,EGenerated),

	Head=..[value_class,Class,params(GP),exports(LExports)],
	IGenerated=..[',',ICalls,EGenerated],

	%% add Class to Trace
	Put=..[put,Class],
	Trace=..['::',xmg_acc:trace,Put],

	%% add Debug info
	Debug=(xmg:send(info,Class),xmg:send(info,'\n'),xmg:send(info,IGenerated),xmg:send(info,'\n\n')),
	%% Debug=(xmg:send(info,Class),xmg:send(info,'\n\n')),

	DebugEnd=(xmg:send(info,Class),xmg:send(info,' executed \n'),xmg:send(info,'\n\n')),

	Gen=..[',',Trace,IGenerated],

	GenDebug=..[',',Debug,Gen],

	GenDebugEnd=..[',',GenDebug,DebugEnd],

	%%xmg:send(info,IGenerated),

	edcg:edcg_clause(xmg:Head, GenDebugEnd, Clause),
	xmg:send(info,'\nAsserting clause: '),
	xmg:send(info,Clause),
	asserta(Clause),
	xmg_brick_mg_compiler:send(debug,'generated '),
	xmg_brick_mg_compiler:send(debug,Class),
	xmg_brick_mg_compiler:send(debug,'\n'),
	xmg_brick_mg_compiler:send(debug,Clause),
	asserta(xmg:is_class(Class)),
	!.

extract_code([],true).
%% extract_code([or(A,B)],Code):-
%% 	extract_code(A,EA),
%% 	extract_code(B,EB),
%% 	Code=..[';',EA,EB],!.
extract_code([or(A,B)|T],Code):-
	extract_code(A,EA),
	extract_code(B,EB),
	DCode=..[';',EA,EB],
	extract_code(T,ECode),
	Code=..[',',DCode,ECode],!.
extract_code([H|T],Code):-
	extract_code(T,ECode),
	Code=..[',',H,ECode],!.

generate_values([]).
%% generate_values([value(Value)|T]):-
%% 	%% Value part
%% 	xmg_dimensions:dims(Dims),
%% 	callDims(Dims,CDims),
%% 	Head=..[compute,Value,dims(Dims)],
%% 	Call=..[Value,params(_),exports(_)|CDims],
%% 	Compute=..[':-',Head,xmg_class:Call],
%% 	asserta(Compute),
%% 	generate_values(T).
generate_values([value(Value)|T]):-
    %% Value part
    xmg:is_class(Value),
	asserta(xmg:value(Value)),
	generate_values(T).
generate_values([value(Value)|T]):-
    %% Value part
    not(xmg:is_class(Value)),
    throw(xmg(generator_error(class_not_defined(Value)))).



import_calls([],_,true):--!.
import_calls([import(id(Class,C),P,AS)|T],List,ICalls):--
	xmg_brick_mg_exporter:exports(Class,E),
        do_unify_exports(E,List,AS,Exports),
        get_params(P,List,UP),
	Call=..[value_class,Class,params(UP),exports(Exports)],
	ICall=..[':',xmg,Call],
	%% add Call to Trace
	%%Put=..[put,Class],
	%%Trace=..['::',xmg_generator:trace,Put],
	Gen=ICall,
	import_calls(T,List,T1),
	ICalls=..[',',Gen,T1],!.
import_calls([H|T],List,ICalls):--
	throw(xmg(generator_error(cannot_call(H)))),!.

do_unify_exports(E,List,none,Exports):--
	unify_exports(E,List,Exports),!.
do_unify_exports(E,List,AS,Exports):--
	unify_exports_as(E,List,AS,Exports),!.

unify_exports([],_,[]):-- !.
unify_exports([id(ID,C)-_|T],List,[ID-V|T1]):--
	decls::tget(ID,V),
	%%lists:member(id(ID,_)-V,List),
	unify_exports(T,List,T1),!.

unify_exports_as([],_,_,[]):-- !.
unify_exports_as([id(A,C)-_|T],List,AS,[A-VA|T1]):--
	lists:member(v(A)-none,AS),!,
	%%xmg:send(info,'\nAS none'),
	decls::tget(A,VA),	
	unify_exports_as(T,List,AS,T1),!.
unify_exports_as([id(A,C)-_|T],List,AS,[A-VA|T1]):--
	lists:member(v(A)-v(B),AS),!,
	%%xmg:send(info,'\nAS value'),
	decls::tget(B,VA),
	unify_exports_as(T,List,AS,T1),!.
unify_exports_as([id(A,C)-_|T],List,AS,[A-_|T1]):--
	unify_exports_as(T,List,AS,T1),!.


list_exports([],_,[]):-- !.
list_exports([id(ID,C)-_|T],List,[ID-V|T1]):--
	decls::tget(ID,V),
	%lists:member(id(ID,_)-V,List),
	list_exports(T,List,T1),!.

get_params([],_,[]):-- !.
get_params([id(ID,_)|T],List,[Var|T1]):--
	decls::tget(ID,Var),
	%lists:member(id(ID,_)-Var,List),
        get_params(T,List,T1),!.
get_params([id(ID,_)|T],List,[ID|T1]):--
	%% Here ID is a constant
	get_params(T,List,T1),				 
	  !.

callDims([],[]):-!.
callDims([iface-IFace|T],[IFace,_|T1]):-
	callDims(T,T1),!.
callDims([Dim-CDim|T],[_-CDim,[]-[]|T1]):-
	callDims(T,T1),!.


var_or_const(Var,NVar):--
	var(Var),!,
	new_name(Name,'xmgvar'),
	Var=id(Name,no_coord),
	decls::tput(Name,NVar),!.
var_or_const(id(A,C),Var):--
	decls::tget(A,Var),!.
var_or_const(id(A,C),const(A,T)):--
	xmg_brick_mg_typer:type(T,TD),
	lists:member(id(A,_),TD),
	!.
var_or_const(id(A,C),feat(A)):--
	xmg_brick_mg_typer:feat(A,_),!.
var_or_const(id(A,C),field(A)):--
	xmg_brick_mg_typer:field(A,_),!.


var_or_const(id(A,C),var(B)):--
	throw(xmg(generator_error(variable_not_declared(A,C)))),!.
var_or_const(id(A,C),const(A,unknown)):--
	throw(xmg(generator_error(unknown_constant(A,C)))),!.
var_or_const(id(A,C),const(A,unknown)):--
	throw(xmg(generator_error(unknown_identifier(A,C)))),!.

var_or_const(string(A,C),const(A,string)):-- !.
var_or_const(int(A,C),const(A,int)):-- !.
var_or_const(bool(A,C),const(A,bool)):-- !.

%% put_in_table([]):-- !.
%% put_in_table([id(A,_)-B|T]):--
%% 	decls::tput(A,B),
%% 	put_in_table(T),!.
%% put_in_table([const(A,_)-const(N,_)|T]):--
%% 	%% skolemize ?
%% 	decls::tput(A,sconst(N,_)),
%% 	put_in_table(T),!.

%% init_skolems([]):-- !.
%% init_skolems([_-H|T]):--
%% 	var(H),!,
%% 	init_skolems(T),!.
%% init_skolems([_-const(H,_)|T]):--
%% 	var(H),!,
%% 	skolem::incr,
%% 	skolem::get(H),
%% 	init_skolems(T),!.
%% init_skolems([_|T]):--
%% 	init_skolems(T),!.
