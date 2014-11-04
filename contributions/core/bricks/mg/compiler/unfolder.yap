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

:-module(xmg_brick_mg_unfolder).
:- xmg:edcg.
:-edcg:using([xmg_brick_mg_accs:constraints,xmg_brick_mg_accs:name,xmg_brick_mg_accs:vars, xmg_brick_mg_accs:consts]).

:-edcg:weave([constraints, name, vars, consts],[unfold_class/1]).
:-edcg:weave([vars],[put_in_table/1]).
%%:-edcg:weave([vars],[build_context/3, add_decls/1]).

:-multifile(xmg:unfold/2).



%% SPECIFIC RULES

unfold(mg:mg(Decls,Classes,Values),mg(OUDecls,UClasses,UValues)):--
	xmg:send(info,' unfolding decls\n'),
	xmg:unfold(Decls,UDecls),
	xmg:send(debug,UDecls),

	xmg_brick_decls_unfolder:sort_decls(UDecls,OUDecls),!,
	%%xmg_compiler:send(info,OUDecls),
	
	xmg:send(info,' \n\n typing decls \n'),
	xmg_brick_mg_typer:type_mg_decls(OUDecls,Type_Decls),!,

	xmg:send(info,' \n\n typing classes \n'),
	xmg_brick_mg_typer:do_type_classes(Classes,Type_Decls),!,
	xmg:send(info,'\n\ntyped\n\n'),

	xmg:send(info,' unfolding classes '),
	%%xmg:send(info,Classes),
	xmg:unfold(Classes,UClasses),
	%%xmg_brick_mg_compiler:send(info,UClasses),
	xmg:send(info,' unfolding values '),
	xmg:unfold(Values,UValues),
	!.
xmg:unfold([],[]):- !.
xmg:unfold([H|T],[H1|T1]):-
	xmg:unfold(H,H1),
	xmg:unfold(T,T1),!.
xmg:unfold([H|T],[H1|T1]):-
	throw(xmg(unfolder_error(no_unfolding(H)))).



xmg:unfold(mg:class(token(Coord,id(N)),P,I,E,D,S),class(N,UP,UI,UE,UD,built(Constraints,TableVF),Coord)):--
	xmg:send(info,'\nUnfolding class '),
	xmg:send(info,N),

	xmg_table:table_new(TableV),
	xmg_table:table_new(TableC),

	%%build_context(I,E,D) with (vars(TableV,TableVO), consts(TableC,TableCO)),

	xmg_brick_mg_exporter:declared(N,List),

	%%xmg_table:table_new(TableIn),
	put_in_table(List) with vars(TableV,TableVO),

	%%xmg_brick_mg_compiler:send(info,Vars),
	unfold_vars(P,UP),
	unfold_vars(I,UI),
	unfold_vars(E,UE),
	unfold_vars(D,UD),
	
	%%xmg:send(info,'\nunfolded vars'),

	unfold_class(S) with (constraints([]-Constraints,[]-[]), name(0,_), vars(TableVO,TableVF), consts(TableC,_)),
	%%xmg_brick_mg_compiler:send(info,Constraints),
	!.

xmg:unfold(mg:value(token(_,id(ID))),value(ID)):-!.

unfold_vars(none,[]):-!.
unfold_vars(some(Vars),UVars):-
	unfold_vars(Vars,UVars),!.
unfold_vars(mg:declare(Vars),UVars):-
	unfold_vars(Vars,UVars),!.
unfold_vars(mg:export(Vars),UVars):-
	unfold_vars(Vars,UVars),!.
unfold_vars(mg:import(Vars),UVars):-
	unfold_vars(Vars,UVars),!.
unfold_vars([],[]):-!.
unfold_vars([H|T],[H1|T1]):-
	unfold_var(H,H1),
	unfold_vars(T,T1),!.

xmg:token_to_id(token(Coord,id(VAR)), id(VAR,Coord)).

unfold_var(value:var(Token),ID):- xmg:token_to_id(Token,ID), !.
unfold_var(value:var_or_const(Token),ID):- xmg:token_to_id(Token,ID), !.
unfold_var(value:const(Token),ID):- xmg:token_to_id(Token,ID), !.
unfold_var(mg:iclass(Token,Params,AS),import(ID,UAS)):- xmg:token_to_id(Token,ID), unfold_as(AS,UAS),!.
unfold_var(Token,ID):- xmg:token_to_id(Token,ID), !.

unfold_as(none,none).
unfold_as(some(AS),UAS):-
	unfold_some_as(AS,UAS).

unfold_some_as([],[]).
unfold_some_as([P|T],[P1|T1]):-
	unfold_as_pair(P,P1),
	unfold_some_as(T,T1),!.

unfold_as_pair(mg:ias(E1,none),UE1-none):-
	unfold_as_elem(E1,UE1),!.
unfold_as_pair(mg:ias(E1,E2),UE1-UE2):-
	unfold_as_elem(E1,UE1),
	unfold_as_elem(E2,UE2),!.


unfold_as_elem(value:var(token(_,id(X))),v(X)).
unfold_as_elem(value:var_or_const(token(_,id(X))),v(X)).
unfold_as_elem(value:const(token(_,id(X))),c(X)).
unfold_as_elem(none,none).

unfold_class(C):--
	%%xmg_brick_mg_compiler:send(info,C),!,
	xmg:unfold_stmt(C),!,
	!.

xmg:unfold_stmt(none):--
	!.

put_in_table([]):-- !.
put_in_table([id(A,_)-B|T]):--
	vars::tput(A,B),
	put_in_table(T),!.
put_in_table([const(A,_)-const(N,_)|T]):--
	%% skolemize ?
	vars::tput(A,sconst(N,_)),
	put_in_table(T),!.

