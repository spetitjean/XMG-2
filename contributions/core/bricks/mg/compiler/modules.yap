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


:- module(xmg_bricks_mg_modules).


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

get_module_c('control',unfolder,'xmg_unfolder_control'):- !.
get_module_c('decls',unfolder,'xmg_unfolder_decls'):- !.
get_module_c('hierarchy',unfolder,'xmg_unfolder_hierarchy'):- !.
get_module_c('feats',unfolder,'xmg_unfolder_feats'):- !.
get_module_c('fields',unfolder,'xmg_unfolder_fields'):- !.
get_module_c('syn',unfolder,'xmg_unfolder_syn'):- !.
get_module_c('frame',unfolder,'xmg_unfolder_frame'):- !.
get_module_c('morph',unfolder,'xmg_unfolder_morph'):- !.
get_module_c('morph2',unfolder,'xmg_unfolder_morph'):- !.
get_module_c('pg',unfolder,'xmg_unfolder_pg'):- !.
get_module_c('sem',unfolder,'xmg_unfolder_sem'):- !.
get_module_c('avm',unfolder,'xmg_unfolder_avm'):- !.
get_module_c('value',unfolder,'xmg_unfolder_value'):- !.
get_module_c('adisj',unfolder,'xmg_unfolder_adisj'):- !.
get_module_c(Module,Step,_):- 
	%% Error : Step Step not defined for Module Module 
	throw(xmg(unfolder_error(no_step_defined_for_module(Step,Module)))),	
	!.


load_modules([]):-!.
load_modules([Module|Modules]):-
	load_module(Module),
	load_modules(Modules),!.

load_module('mg'):-
	use_module('xmg/bricks/mg/compiler/xmg_loader_mg'),
	xmg_loader_mg:load_module,!.


load_module('decls'):-
	use_module('contributions/Decls/bricks/Decls/compiler/xmg_loader_decls'),
	xmg_loader_decls:load_modules,!.

load_module('control'):-
	use_module('contributions/Control/bricks/Control/compiler/xmg_loader_control'),
	xmg_loader_control:load_modules,!.

	
load_module('morph'):-
	load_module('AVM'),
	add_to_path('contributions/morph/bricks/morph/compiler'),
	use_module('xmg_unfolder_morph'),
	use_module('xmg_generator_morph'),
	use_module('xmg_solver_morph'),
	use_module('xmg_output_morph'),
	use_module('xmg_convert_morph'),
	use_module('xmg_xsat'),!.

load_module('morph2'):-
	add_to_path('contributions/morph2/bricks/morph2/compiler'),
	use_module('xmg_unfolder_morph'),
	use_module('xmg_generator_morph'),
	use_module('xmg_solver_morph'),
	use_module('xmg_output_morph'),
	use_module('xmg_convert_morph'),!.

load_module('syn'):-
	use_module('contributions/syn/bricks/syn/compiler/xmg_loader_syn'),
	xmg_loader_syn:load_module,!.

load_module('avm'):-
	use_module('contributions/AVM/bricks/AVM/compiler/xmg_loader_avm'),
	xmg_loader_avm:load_module,!.

load_module('value'):-
	add_to_path('contributions/Value/bricks/Value/compiler'),
	use_module('xmg_unfolder_value'),!.


load_module('adisj'):-
	use_module('contributions/ADisj/bricks/ADisj/compiler/xmg_loader_adisj'),
	xmg_loader_adisj:load_module,!.

load_module('pg'):-
	add_to_path('contributions/pg'),
	use_module('xmg_unfolder_pg'),
	use_module('xmg_generator_pg'),
	use_module('xmg_output_pg'),!.

load_module('sem'):-
	use_module('contributions/sem/bricks/sem/compiler/xmg_loader_sem'),
	xmg_loader_sem:load_module,!.

load_module('frame'):-
	add_to_path('contributions/frame'),
	use_module('xmg_unfolder_frame'),
	use_module('xmg_generator_frame'),
	use_module('xmg_preparer_frame'),
	use_module('xmg_solver_frame'),
	use_module('xmg_convert_frame'),
	use_module('xmg_h_avm'),
	use_module('xmg_nodename_frame'),
	!.

load_module('hierarchy'):-
	add_to_path('contributions/hierarchy'),
	use_module('xmg_unfolder_hierarchy'),
	use_module('xmg_typer_hierarchy'),
	!.

load_module('feats'):-
	use_module('contributions/feats/bricks/feats/compiler/xmg_loader_feats'),
	xmg_loader_feats:load_module,!.

load_module('fields'):-
	add_to_path('contributions/fields'),
	use_module('xmg_unfolder_fields'),
	!.

load_module(Module):-
	use_module(M,Module,_),!.

load_module(Module):-
	throw(xmg(compiler_error(unknown_module(Module)))),!.