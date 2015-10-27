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

:-module(xmg_brick_value_typer).

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:type_decls,xmg_brick_mg_typer:dim_types]).
:-edcg:weave([xmg_brick_mg_typer:types,xmg_brick_mg_typer:global_context,xmg_brick_mg_typer:type_decls,xmg_brick_mg_typer:dim_types],type_disj/2).

xmg:type_expr(value:var(token(C,id(ID))),Type):--
	     types::tget(ID,Type1),
             xmg:check_types(Type,Type1,C),
        !.
xmg:type_expr(value:var(token(C,id(ID))),Type):--
             throw(xmg(generator_error(unknown_variable(ID,C)))).

xmg:type_expr(value:const(token(C,id(ID))),Type):--
	     types::tget(ID,Type1),
             xmg:check_types(Type,Type1,C),
        !.
xmg:type_expr(value:const(token(C,id(ID))),Type):--
        throw(xmg(generator_error(unknown_constant(ID,C)))).



xmg:type_expr(token(_,bool(_)),bool):--
	!.
xmg:type_expr(token(_,int(_)),int):--
	!.
xmg:type_expr(token(_,int(_)),IntType):--
	type_decls::tget(IntType,int),
	!.
xmg:type_expr(token(_,string(_)),string):--
	!.

xmg:type_expr(value:disj(Values),Type):--
	type_disj(Values,Type),
!.


%% Case where ID has no ? and could possibly be constant or variable
xmg:type_expr(token(C,id(ID)),Type):--
	     type_decls::tget(const(ID),Type1),
             types::tget(ID,Type1),
	     C=coord(File,Line,Col),
	     atomic_concat(['In file ',File,', line ',Line,', column ',Col,', ',ID,' could refer to both a constant and a variable.'],Mess),
	     print_message(warning,Mess),
	     xmg:check_types(Type,Type1,C),
	     !.

xmg:type_expr(token(C,id(ID)),Type):--
      			  types::tget(ID,Type1),
			  xmg:check_types(Type,Type1,C),
        !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% typing a constant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


xmg:type_expr(token(C,id(ID)),Type):--
	     type_decls::tget(const(ID),Type1),
             xmg:check_types(Type,Type1,C),
	     !.




xmg:type_expr(token(C,id(ID)),Type):--
	type_decls::tget(const(ID),T),!,
	throw(xmg(type_error(incompatible_types(ID,Type,C)))),
	!.

xmg:type_expr(token(C,id(ID)),Type):--
	throw(xmg(type_error(unknown_constant(ID,C)))),
	!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% typing a disjunction of values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type_disj([Value],Type):--
	 xmg:type_expr(Value,Type),!.
type_disj([Value|Values],Type):--
	 xmg:type_expr(Values,Type),
         type_disj(Values,Type),
	 !.
