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


:- module(xmg_modules).


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

get_module_c('Control',unfolder,'xmg_unfolder_control'):- !.
get_module_c('Decls',unfolder,'xmg_unfolder_decls'):- !.
get_module_c('hierarchy',unfolder,'xmg_unfolder_hierarchy'):- !.
get_module_c('feats',unfolder,'xmg_unfolder_feats'):- !.
get_module_c('fields',unfolder,'xmg_unfolder_fields'):- !.
get_module_c('syn',unfolder,'xmg_unfolder_syn'):- !.
get_module_c('frame',unfolder,'xmg_unfolder_frame'):- !.
get_module_c('morph',unfolder,'xmg_unfolder_morph'):- !.
get_module_c('morph2',unfolder,'xmg_unfolder_morph'):- !.
get_module_c('pg',unfolder,'xmg_unfolder_pg'):- !.
get_module_c('sem',unfolder,'xmg_unfolder_sem'):- !.
get_module_c('AVM',unfolder,'xmg_unfolder_avm'):- !.
get_module_c('Value',unfolder,'xmg_unfolder_value'):- !.
get_module_c('ADisj',unfolder,'xmg_unfolder_adisj'):- !.
get_module_c(Module,Step,_):- 
	%% Error : Step Step not defined for Module Module 
	throw(xmg(unfolder_error(no_step_defined_for_module(Step,Module)))),	
	!.


load_modules([]):-!.
load_modules([Module|Modules]):-
	load_module(Module),
	load_modules(Modules),!.

load_module('MG'):-
	add_to_path('contributions/MG'),
	use_module('compilers/xmg_errors'),
	use_module('tokenizer'),
	use_module('compilers/xmg_parser'),
	use_module('compilers/xmg_unfolder'),
	use_module('compilers/xmg_exporter'),
	use_module('compilers/xmg_typer'),
	use_module('compilers/xmg_generator'),
	use_module('compilers/xmg_convert'),
	use_module('compilers/xmg_printer'),!.

load_module('Decls'):-
	add_to_path('contributions/Decls'),
	use_module('compilers/xmg_unfolder_decls'),
	use_module('compilers/xmg_principles'),!.

load_module('Control'):-
	add_to_path('contributions/Control'),
	use_module('compilers/xmg_unfolder_control'),
	use_module('compilers/xmg_generator_control'),!.
	
load_module('morph'):-
	load_module('AVM'),
	add_to_path('contributions/morph'),
	use_module('compilers/xmg_unfolder_morph'),
	use_module('compilers/xmg_generator_morph'),
	use_module('compilers/xmg_solver_morph'),
	use_module('compilers/xmg_output_morph'),
	use_module('compilers/xmg_convert_morph'),
	use_module('compilers/xmg_xsat'),!.

load_module('morph2'):-
	add_to_path('contributions/morph2'),
	use_module('compilers/xmg_unfolder_morph'),
	use_module('compilers/xmg_generator_morph'),
	use_module('compilers/xmg_solver_morph'),
	use_module('compilers/xmg_output_morph'),
	use_module('compilers/xmg_convert_morph'),!.

load_module('syn'):-
	add_to_path('contributions/syn'),
	use_module('compilers/xmg_unfolder_syn'),
	use_module('compilers/xmg_generator_syn'),
	use_module('compilers/xmg_preparer_syn'),
	use_module('compilers/xmg_tree'),
	%% this should be done optionally
	use_module('compilers/xmg_unicity'),
	use_module('compilers/xmg_colors'),
	use_module('compilers/xmg_rank'),
	use_module('compilers/xmg_tag'),
	use_module('compilers/xmg_convert_tag_syn'),!.

load_module('AVM'):-
	add_to_path('contributions/AVM'),
	use_module('compilers/xmg_unfolder_avm'),
	use_module('compilers/xmg_generator_avm'),
	use_module('compilers/xmg_convert_avm'),
	use_module('compilers/xmg_convert_h_avm'),
	use_module('compilers/xmg_avm'),!.

load_module('Value'):-
	add_to_path('contributions/Value'),
	use_module('compilers/xmg_unfolder_value'),!.

load_module('ADisj'):-
	add_to_path('contributions/ADisj'),
	use_module('compilers/xmg_unfolder_adisj'),
	use_module('compilers/xmg_adisj'),!.

load_module('pg'):-
	add_to_path('contributions/pg'),
	use_module('compilers/xmg_unfolder_pg'),
	use_module('compilers/xmg_generator_pg'),
	use_module('compilers/xmg_output_pg'),!.

load_module('sem'):-
	add_to_path('contributions/sem'),
	use_module('compilers/xmg_unfolder_sem'),
	use_module('compilers/xmg_generator_sem'),
	use_module('compilers/xmg_output_sem'),
	use_module('compilers/xmg_convert_sem'),!.

load_module('frame'):-
	add_to_path('contributions/frame'),
	use_module('compilers/xmg_unfolder_frame'),
	use_module('compilers/xmg_generator_frame'),
	use_module('compilers/xmg_preparer_frame'),
	use_module('compilers/xmg_solver_frame'),
	use_module('compilers/xmg_convert_frame'),
	use_module('compilers/xmg_h_avm'),
	use_module('compilers/xmg_nodename_frame'),
	!.

load_module('hierarchy'):-
	add_to_path('contributions/hierarchy'),
	use_module('compilers/xmg_unfolder_hierarchy'),
	use_module('compilers/xmg_typer_hierarchy'),
	!.

load_module('feats'):-
	add_to_path('contributions/feats'),
	use_module('compilers/xmg_unfolder_feats'),
	!.

load_module('fields'):-
	add_to_path('contributions/fields'),
	use_module('compilers/xmg_unfolder_fields'),
	!.

load_module(Module):-
	throw(xmg(compiler_error(unknown_module(Module)))),!.