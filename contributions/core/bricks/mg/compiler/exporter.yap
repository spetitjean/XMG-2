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

export_metagrammar('MetaGrammar'(_,Classes,Values)):-
	%% before doing the export, check for cycles and order classes
	lists:length(Classes,L),
	asserta(classNumber(L)),
	xmg_compiler:send(info,' ordering classes '),xmg_compiler:send_nl(info),
	order_classes(Classes,OClasses),!,
	xmg_compiler:send(info,' classes ordered '),xmg_compiler:send_nl(info),
	retract(classNumber(L)),
	export_classes(OClasses).

%% Order classes

order_classes(Classes,OClasses):-
	order_classes(Classes,[],[],OClasses,0),!.

order_classes([],[],_,[],_):- !.
order_classes([],Classes,Acc,OClasses,Laps):-!,
	classNumber(Num),
	(
	    ( 
		Laps<Num,
		MLaps is Laps+1,!,
		order_classes(Classes,[],Acc,OClasses,MLaps)
	    )
	;
	(
	    xmg_compiler:send(info,'Could not order classes for exports\n'),!,
	    xmg_compiler:send(info,Classes),
	    whatsWrong(Classes,Acc)
	)
    ).
order_classes([Mutex|Classes],MClasses,Acc,OClasses,Laps):-
	(
	    Mutex=mutex(_)
	;
	Mutex=mutex_add(_,_)
    ;
	Mutex=semantics
    ),
	order_classes(Classes,MClasses,Acc,OClasses,Laps).
order_classes([Class|Classes],MClasses,Acc,[Class|OClasses],Laps):-
	class_before(Class,Acc),!,
	Class=class(id(ClassId),_,_),
	order_classes(Classes,MClasses,[ClassId|Acc],OClasses,Laps).
order_classes([Class|Classes],MClasses,Acc,OClasses,Laps):-
	order_classes(Classes,[Class|MClasses],Acc,OClasses,Laps).

class_before(class(_,class(_,I,_,_,_),_),Acc):-
	flush_output,
	imports_before(I,Acc).

imports_before([],_):-!.
imports_before([import(id(H,C),_)|T],Acc):-
	lists:member(H,Acc),
	imports_before(T,Acc).

whatsWrong([],Acc):-!.
whatsWrong([class(id(Class),class(_,I,_,_,_),_)|T],Acc):-
	xmg_compiler:send(info,' in class '),xmg_compiler:send(info,Class),xmg_compiler:send(info,'\n'),
	whichImport(I,Acc),!,
	whatsWrong(T,Acc).

whichImport([id(H,C)|T],Acc):-
	lists:member(H,Acc),!,
	whichImport(T,Acc).
whichImport([id(H,C)|T],Acc):-
	xmg_compiler:send(info,'Error while importing class '),xmg_compiler:send(info,H),xmg_compiler:send(info,' at '),xmg_compiler:send(info,C),xmg_compiler:send(info,'\n'),!,
	whichImport(T,Acc).

%% Export variables

export_classes([]):- 
	xmg_compiler:send(info,' exported '),xmg_compiler:send_nl(info),!.
export_classes([H|T]):-
	export_class(H),!,
	export_classes(T).

export_class(class(id(Name),class(P,I,E,D,_),_)):-
	imports_exports(I,E,D,Exps),
	%%xmg_compiler:send(debug,Exps),
	%% check exported variables have whether been declared or imported
	exports_declared(E,Exps,D),!,
	%% open unification
	%%lists:append(Exps,E,FExps),	
	add_vars(Exps,E,FExps),
	asserta(exports(Name,FExps)),
	%%lists:append(Exps,D,Decls),
	add_vars_no_duplicates(Exps,D,Decls),

	add_vars_no_duplicates(Decls,P,AllDecls),
	asserta(declared(Name,AllDecls)),!.

add_vars(Exps,[],Exps).
add_vars(Exps,[id(H,C)|T],T1):-
	lists:member(id(H,_)-_,Exps),!,
	add_vars(Exps,T,T1).
add_vars(Exps,[H|T],[H-_|T1]):-
	add_vars(Exps,T,T1).

add_vars_no_duplicates(Exps,[],Exps).
add_vars_no_duplicates(Exps,[id(H,C)|T],T1):-
	lists:member(id(H,_)-_,Exps),!,
	xmg_compiler:send(info,' Multiple declarations of variable '),
	xmg_compiler:send(info,H),
	xmg_compiler:send(info,C),
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
	    xmg_compiler:send_nl(info),xmg_compiler:send(info,'Did not find exports for class '),
	    xmg_compiler:send(info,I),xmg_compiler:send(info,' at '), xmg_compiler:send(info,C),xmg_compiler:send_nl(info)
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
	    %% xmg_compiler:send_nl(info),
	    %% xmg_compiler:send(info,'variable '),
	    %% xmg_compiler:send(info,H),
	    %% xmg_compiler:send(info,' exported but not declared '),
	    %% xmg_compiler:send(info,C),xmg_compiler:send_nl(info)
	    throw(xmg(exporter_error(variable_not_declared(H,C))))
	)
    )
,
	exports_declared(T,Exps,D).
