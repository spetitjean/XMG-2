%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2013  Simon Petitjean

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


:- module(xmg_brick_mg_modules).


%% Get a compiler Module corresponding to a Language Brick and a Compiling Step
%% get_module('SAVM',unfolder,Get) should unificate Get and 'xmg_unfolder_avm' 

get_module(Brick,Step,Get):-
	xmg_modules_def:module_def(Brick,Module),!,
	get_module_c(Module,Step,Get),!.
get_module(Brick,Step,Get):-
	%% Error : No Module associated to Brick Brick
	throw(xmg(unfolder_error(no_module_defined_for_brick(Brick)))),
	!.

%% Get a compiler module corresponding to a Compiler Brick and a Compiling Step


get_module_c(Brick,unfolder,Unfolder):-
	atomic_concat('xmg/brick/',BrickTmp,Brick),
	atomic_concat(BrickName,'/compiler/loader',BrickTmp),
	atom_concat(['xmg_brick_',BrickName,'_unfolder'],Unfolder),
	xmg_brick_mg_compiler:send(info,Unfolder),!.
get_module_c(Module,Step,_):- 
	%% Error : Step Step not defined for Module Module 
	throw(xmg(unfolder_error(no_step_defined_for_module(Step,Module)))),	
	!.


load_modules([]):-!.
load_modules([Module|Modules]):-
	load_module(Module),
	load_modules(Modules),!.



load_module(Module):-
	xmg_brick_mg_compiler:send(info,Module),
	use_module(Module),!.

load_module(Module):-
	throw(xmg(compiler_error(unknown_module(Module)))),!.
