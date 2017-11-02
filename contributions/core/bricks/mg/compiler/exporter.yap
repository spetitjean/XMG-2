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

:-module(xmg_brick_mg_exporter).
:-dynamic(exports/2).
:-dynamic(declared/2).
:-dynamic(classNumber/1).
:-dynamic(xmg:mutex/1).
:-dynamic(xmg:mutex_add/2).

export_metagrammar(mg:mg(Decls,Classes,Values),mg:mg(Decls,OClasses,Values)):-
	xmg:send(debug,' exploring classes for calls '),
	xmg_brick_mg_explorer:find_calls_in_classes(Classes,Calls),
	xmg:send(info,' explored '),
	%%xmg:send(debug,Calls),

	%% before doing the export, check for cycles and order classes
	lists:length(Classes,L),
	asserta(classNumber(L)),!,
	xmg_brick_mg_compiler:send(debug,' ordering classes\n'),
	order_classes(Classes,Calls,OClasses),!,
	xmg_brick_mg_compiler:send(debug,' classes ordered\n'),
	%%xmg_brick_mg_compiler:send(debug,OClasses),xmg_brick_mg_compiler:send_nl(info),
	retract(classNumber(L)),
	xmg_brick_mg_compiler:send(debug,' exporting classes\n'),
	export_classes(OClasses),
	xmg_brick_mg_compiler:send(debug,' exported classes\n'),!.


%% Order classes

mutex(mg:mutex(token(_,id(Mutex)))):-
	xmg:send(debug,'\nMutex: '),
	xmg:send(debug,Mutex),
	asserta(xmg:mutex(Mutex)),!.

mutex(mg:mutex_add(token(_,id(M)),token(_,id(V)))):-
	xmg:send(debug,'\nMutex add: '),
	xmg:send(debug,M),
	xmg:send(debug,V),
	asserta(xmg:mutex_add(M,V)),!.

mutex(mg:semantics).


order_classes(Classes,Calls,OClasses):-
	order_classes(Classes,[],[],OClasses,0,Calls),!.

order_classes([],[],_,[],_,_):- !.
order_classes([],Classes,Acc,OClasses,Laps,Calls):-!,
						   classNumber(Num),
	(
	    ( 
		Laps<Num,
		MLaps is Laps+1,!,
		order_classes(Classes,[],Acc,OClasses,MLaps,Calls)
	    )
	;
	(
	    %%xmg_brick_mg_compiler:send(info,'\n\nCould not order classes for exports\n'),!,
	    %%xmg_brick_mg_compiler:send(info,Classes),
	    whatsWrong(Classes,Acc),
	    whatsWrongCalls(Calls,Acc),
	    halt
	)
    ).
order_classes([Mutex|Classes],MClasses,Acc,OClasses,Laps,Calls):-
	mutex(Mutex),
	order_classes(Classes,MClasses,Acc,OClasses,Laps,Calls).
order_classes([Class|Classes],MClasses,Acc,[Class|OClasses],Laps,Calls):-
	class_before(Class,Acc,Calls),!,
	%%xmg:send(debug,Class),
	Class=mg:class(token(_,id(ClassId)),_,_,_,_,_),
	%%xmg:send(debug,ClassId),
	order_classes(Classes,MClasses,[ClassId|Acc],OClasses,Laps,Calls).
order_classes([Class|Classes],MClasses,Acc,OClasses,Laps,Calls):-
	order_classes(Classes,[Class|MClasses],Acc,OClasses,Laps,Calls).

class_before(mg:class(token(_,id(Class)),_,I,_,_,_),Acc,Calls):-
        imports_before(I,Acc),!,
	lists:member((Class,CCall),Calls),
	calls_before(CCall,Acc),!.

imports_before([],_):-!.
imports_before([mg:iclass(token(_,id(Class)),_,_)|T],Acc):-
	lists:member(Class,Acc),
	imports_before(T,Acc).

imports_before(none,_):-!.
imports_before(some(mg:import(I)),Acc):-
	imports_before(I,Acc),!.
imports_before(_,_):-
	%% xmg:send(debug,'\n\nDo not know what to do with import: '),
	%% xmg:send(debug,I),
	%% xmg:send(debug,Acc),
	%% xmg:send(debug,'\n'),

	false,!.

calls_before([],_):- !.
calls_before([Call|T],Acc):-
	%%xmg:send(debug,Call),
	%%xmg:send(debug,Acc),
	lists:member(Call,Acc),
	calls_before(T,Acc).


whatsWrong([],_):-!.
whatsWrong([mg:class(token(_,id(_)),_,I,_,_,_)|T],Acc):-
    %%xmg_brick_mg_compiler:send(info,' in class '),xmg_brick_mg_compiler:send(info,Class),xmg_brick_mg_compiler:send(info,'\n'),
    whichImport(I,Acc),!,
	whatsWrong(T,Acc).

whichImport(none,_):-
    !.
whichImport(some(mg:import(I)),Acc):-
    whichImport(I,Acc),!.
whichImport([],_):-
	!.
whichImport([mg:iclass(token(_,id(H)),_,_)|T],Acc):-
	lists:member(H,Acc),!,
	whichImport(T,Acc).
whichImport([mg:iclass(token(Coord,id(H)),_,_)|_],_):-
    throw(xmg(exporter_error(failed_import(H,Coord)))).


whatsWrongCalls([],_):-!.
whatsWrongCalls([(Class,Calls)|T],Acc):-
    whichCall(Class,Calls,Acc),
    whatsWrongCalls(T,Acc).

whichCall(_,[],_):-!.
whichCall(Class,[H|T],Acc):-
    lists:member(H,Acc),!,
	whichCall(Class,T,Acc).
whichCall(Class,[Call|_],_):-
    throw(xmg(exporter_error(failed_call(Call,Class)))).

%% Export variables

export_classes([]):- !.
export_classes([H|T]):-
	export_class(H),!,
	export_classes(T).

export_class(mg:class(token(_,id(Name)),P,I,E,D,_)):-
	xmg:send(debug,'exporting '),
	xmg:send(debug,Name),
	xmg:send(debug,': prepare\n'),
	xmg:send(debug,E),

	maybe_star(E,D,StarE),
	xmg:send(debug,' star done '),
	untype([P,I,StarE,D],[UP,UI,UE,UD]),
	xmg:send(debug,'imports exports\n'),
	imports_exports(UI,UE,UD,Exps),
	%% check exported variables have whether been declared or imported
	%%xmg:send(debug,[UE,UD]),
	xmg:send(debug,'exports declared\n'),
	exports_declared(UE,Exps,UD),!,

	xmg:send(debug,'add vars \n'),

	add_vars(Exps,UE,FExps),
	asserta(exports(Name,FExps)),
	%%lists:append(Exps,D,Decls),
	add_vars_no_duplicates(Exps,UD,Decls),

	add_vars_no_duplicates(Decls,UP,AllDecls),
	xmg:send(debug,declared(Name,AllDecls)),
	asserta(declared(Name,AllDecls)),!.

maybe_star(some(mg:export(all)),D,D).
maybe_star(E,_,E).

untype([],[]):-!.
untype([H|T],[H1|T1]):-
	%%xmg:send(debug,H),
	untype(H,H1),
	untype(T,T1),!.
untype(none,[]):-!.
untype(some(S),US):-
	S=..[':',mg,MS],
	MS=..[_,List],
	untype_one(List,US),!.
untype(some(S),US):-
	untype_one(S,US),!.
untype_one([],[]):-!.
untype_one([H|T],[H1|T1]):-
	untype_part(H,H1),
	untype_one(T,T1),!.

untype_part(value:var_or_const(token(C,id(ID))),id(ID,C)):-!.
untype_part(value:var(token(C,id(ID))),id(ID,C)):-!.
untype_part(mg:iclass(token(C,id(ID)),Params,AS),import(id(ID,C),Params,AS)):-
	!.
untype_part(token(C,id(ID)),id(ID,C)):-
	!.
untype_part(value:const(token(C,id(ID))),id(ID,C)):-
	!.
untype_part(Decl,_):-
	xmg:send(info,'\n\nUnknown declaration: '),
	xmg:send(info,Decl),
	halt,
	!.


add_vars(Exps,[],Exps).
add_vars(Exps,[id(H,_)|T],T1):-
	lists:member(id(H,_)-_,Exps),!,
	add_vars(Exps,T,T1).
add_vars(Exps,[H|T],[H-_|T1]):-
	add_vars(Exps,T,T1).

add_vars_no_duplicates(Exps,[],Exps).
add_vars_no_duplicates(Exps,[id(H,C)|T],T1):-
	lists:member(id(H,_)-_,Exps),!,
	xmg:send(info,'\n\nWarning: Multiple declarations of variable '),
	xmg:send(info,H),
	xmg:send(info,', '),
	xmg:send(info,C),
	xmg:send(info,'\n\n'),
	add_vars_no_duplicates(Exps,T,T1).
add_vars_no_duplicates(Exps,[H|T],[H-_|T1]):-
	add_vars_no_duplicates(Exps,T,T1).

imports_exports([],_,_,[]).
imports_exports([import(id(I,C),_,AS)|TI],E,D,Exps):-
	( 
	   import_exports(I,Exps1)
	;
	(
	    xmg:send_nl(info),xmg:send(info,'Did not find exports for class '),
	    xmg:send(info,I),xmg:send(info,' at '), xmg:send(info,C),xmg:send_nl(info)
	)
    ),
	!,
	%%xmg:send(info,Exps1),
	%%xmg:send(info,AS),
	replace_as(Exps1,AS,Exps1as),
	imports_exports(TI,E,D,Exps2),
	lists:append(Exps1as,Exps2,Exps).

replace_as(Exps,none,Exps):- !.
replace_as(Exps,some(List),NExps):- 
	replace_as(Exps,List,NExps),!.
replace_as(_,[],[]).
replace_as(Exps,[mg:ias(value:var(token(C,id(H))),none)|T],[id(H,C)-Var|T1]):-
	%%xmg:send(info,'HERE NONE'),
	lists:member(id(H,_)-Var,Exps),!,
	replace_as(Exps,T,T1),!.
%% replace_as(Exps,[mg:ias(value:var(token(C,id(H))),value:var(token(_,id(H2))))|T],[id(H2,C)-H|T1]):-
%% 	%%xmg:send(info,'HERE VAR'),
%% 	replace_as(Exps,T,T1),!.

import_exports(I,Exp):-
	exports(I,Exp).

exports_declared([],_,_).
exports_declared([id(H,C)|T],Exps,D):-
	(	
	    ( lists:member(id(H,_)-_,Exps) ; lists:member(id(H,_),D) )
	;
	(
	    %% xmg:send_nl(info),
	    %% xmg:send(info,'variable '),
	    %% xmg:send(info,H),
	    %% xmg:send(info,' exported but not declared '),
	    %% xmg:send(info,C),xmg:send_nl(info)
	    throw(xmg(exporter_error(variable_not_declared(H,C))))
	)
    )
,
	exports_declared(T,Exps,D).
