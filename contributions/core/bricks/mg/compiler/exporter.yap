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
	xmg:send(info,' exploring classes for calls '),
	xmg_brick_mg_explorer:find_calls_in_classes(Classes,Calls),
	xmg:send(info,' explored '),
	xmg:send(info,Calls),

	%% before doing the export, check for cycles and order classes
	lists:length(Classes,L),
	asserta(classNumber(L)),
	xmg_brick_mg_compiler:send(info,' ordering classes '),xmg_brick_mg_compiler:send_nl(info),
	order_classes(Classes,Calls,OClasses),!,
	xmg_brick_mg_compiler:send(info,' classes ordered '),xmg_brick_mg_compiler:send_nl(info),
	%%xmg_brick_mg_compiler:send(info,OClasses),xmg_brick_mg_compiler:send_nl(info),
	retract(classNumber(L)),
	xmg_brick_mg_compiler:send(info,' exporting classes '),xmg_brick_mg_compiler:send_nl(info),
	export_classes(OClasses),
	xmg_brick_mg_compiler:send(info,' exported classes '),xmg_brick_mg_compiler:send_nl(info),!.


%% Order classes

mutex(mg:mutex(token(_,id(Mutex)))):-
	xmg:send(info,'\nMutex: '),
	xmg:send(info,Mutex),
	asserta(xmg:mutex(Mutex)),!.

mutex(mg:mutex_add(token(_,id(M)),token(_,id(V)))):-
	xmg:send(info,'\nMutex add: '),
	xmg:send(info,M),
	xmg:send(info,V),
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
	    xmg_brick_mg_compiler:send(info,'\n\nCould not order classes for exports\n'),!,
	    xmg_brick_mg_compiler:send(info,Classes),
	    whatsWrong(Classes,Acc)
	)
    ).
order_classes([Mutex|Classes],MClasses,Acc,OClasses,Laps,Calls):-
	mutex(Mutex),
	order_classes(Classes,MClasses,Acc,OClasses,Laps,Calls).
order_classes([Class|Classes],MClasses,Acc,[Class|OClasses],Laps,Calls):-
	class_before(Class,Acc,Calls),!,
	%%xmg:send(info,Class),
	Class=mg:class(token(_,id(ClassId)),_,_,_,_,_),
	%%xmg:send(info,ClassId),
	order_classes(Classes,MClasses,[ClassId|Acc],OClasses,Laps,Calls).
order_classes([Class|Classes],MClasses,Acc,OClasses,Laps,Calls):-
	order_classes(Classes,[Class|MClasses],Acc,OClasses,Laps,Calls).

class_before(mg:class(token(_,id(Class)),_,I,_,_,_),Acc,Calls):-
	imports_before(I,Acc),
	lists:member((Class,CCall),Calls),
	calls_before(CCall,Acc).

imports_before([],_):-!.
imports_before([mg:iclass(token(_,id(Class)),_,_)|T],Acc):-
	lists:member(Class,Acc),
	imports_before(T,Acc).

imports_before(none,_):-!.
imports_before(some(mg:import(I)),Acc):-
	imports_before(I,Acc),!.
imports_before(I,Acc):-
	xmg:send(info,'do not know what to do with '),
	xmg:send(info,I),
	xmg:send(info,Acc),
	false,!.

calls_before([],_):- !.
calls_before([Call|T],Acc):-
	%%xmg:send(info,Call),
	%%xmg:send(info,Acc),
	lists:member(Call,Acc),
	calls_before(T,Acc).


whatsWrong([],Acc):-!.
whatsWrong([mg:class(token(_,id(Class)),_,I,_,_,_)|T],Acc):-
	xmg_brick_mg_compiler:send(info,' in class '),xmg_brick_mg_compiler:send(info,Class),xmg_brick_mg_compiler:send(info,'\n'),
	whichImport(I,Acc),!,
	whatsWrong(T,Acc).

whichImport([id(H,C)|T],Acc):-
	lists:member(H,Acc),!,
	whichImport(T,Acc).
whichImport([id(H,C)|T],Acc):-
	xmg_brick_mg_compiler:send(info,'Error while importing class '),xmg_brick_mg_compiler:send(info,H),xmg_brick_mg_compiler:send(info,' at '),xmg_brick_mg_compiler:send(info,C),xmg_brick_mg_compiler:send(info,'\n'),!,
	whichImport(T,Acc).

%% Export variables

export_classes([]):- !.
export_classes([H|T]):-
	export_class(H),!,
	export_classes(T).

export_class(mg:class(token(_,id(Name)),P,I,E,D,_)):-
	xmg:send(info,'exporting '),
	xmg:send(info,Name),
	xmg:send(info,': prepare\n'),

	untype([P,I,E,D],[UP,UI,UE,UD]),
	xmg:send(info,'imports exports\n'),
	imports_exports(UI,UE,UD,Exps),
	%% check exported variables have whether been declared or imported
	%%xmg:send(info,[UE,UD]),
	xmg:send(info,'exports declared\n'),
	exports_declared(UE,Exps,UD),!,

	xmg:send(info,'add vars \n'),

	add_vars(Exps,UE,FExps),
	asserta(exports(Name,FExps)),
	%%lists:append(Exps,D,Decls),
	add_vars_no_duplicates(Exps,UD,Decls),

	add_vars_no_duplicates(Decls,UP,AllDecls),
	asserta(declared(Name,AllDecls)),!.

untype([],[]):-!.
untype([H|T],[H1|T1]):-
	%%xmg:send(info,H),
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
untype_part(mg:iclass(token(_,id(ID)),[],none),import(id(ID,C),[])):-
	!.
untype_part(token(C,id(ID)),id(ID,C)):-
	!.
untype_part(value:const(token(C,id(ID))),id(ID,C)):-
	!.
untype_part(Decl,_):-
	xmg:send(info,'\n\nUnknown declaration: '),
	xmg:send(info,Decl),
	false,
	!.


add_vars(Exps,[],Exps).
add_vars(Exps,[id(H,C)|T],T1):-
	lists:member(id(H,_)-_,Exps),!,
	add_vars(Exps,T,T1).
add_vars(Exps,[H|T],[H-_|T1]):-
	add_vars(Exps,T,T1).

add_vars_no_duplicates(Exps,[],Exps).
add_vars_no_duplicates(Exps,[id(H,C)|T],T1):-
	lists:member(id(H,_)-_,Exps),!,
	xmg_brick_mg_compiler:send(info,' Multiple declarations of variable '),
	xmg_brick_mg_compiler:send(info,H),
	xmg_brick_mg_compiler:send(info,C),
	false,
	add_vars_no_duplicates(Exps,T,T1).
add_vars_no_duplicates(Exps,[H|T],[H-_|T1]):-
	add_vars_no_duplicates(Exps,T,T1).

imports_exports([],E,D,[]).
imports_exports([import(id(I,C),AS)|TI],E,D,Exps):-
	( 
	   import_exports(I,Exps1)
	;
	(
	    xmg_brick_mg_compiler:send_nl(info),xmg_brick_mg_compiler:send(info,'Did not find exports for class '),
	    xmg_brick_mg_compiler:send(info,I),xmg_brick_mg_compiler:send(info,' at '), xmg_brick_mg_compiler:send(info,C),xmg_brick_mg_compiler:send_nl(info)
	)
    ),
	!,
	replace_as(Exps1,AS,Exps1as),
	imports_exports(TI,E,D,Exps2),
	lists:append(Exps1as,Exps2,Exps).

replace_as([],_,[]):- !.
replace_as([id(H,_)-Var|T],AS,[R-Var|T1]):-
	lists:member(id(H,_)-R,AS),!,
	replace_as(T,AS,T1),!.
replace_as([H|T],AS,[H|T1]):-
	replace_as(T,AS,T1),!.

import_exports(I,Exp):-
	exports(I,Exp).

exports_declared([],_,_).
exports_declared([id(H,C)|T],Exps,D):-
	(	
	    ( lists:member(id(H,_)-_,Exps) ; lists:member(id(H,_),D) )
	;
	(
	    %% xmg_brick_mg_compiler:send_nl(info),
	    %% xmg_brick_mg_compiler:send(info,'variable '),
	    %% xmg_brick_mg_compiler:send(info,H),
	    %% xmg_brick_mg_compiler:send(info,' exported but not declared '),
	    %% xmg_brick_mg_compiler:send(info,C),xmg_brick_mg_compiler:send_nl(info)
	    throw(xmg(exporter_error(variable_not_declared(H,C))))
	)
    )
,
	exports_declared(T,Exps,D).
