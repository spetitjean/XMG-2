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


:-module(xmg_loader_syn).

load_module:-
	add_to_path('contributions/syn/bricks/syn/compiler'),
	use_module('xmg_compiler_syn'),
	use_module('xmg_unfolder_syn'),
	use_module('xmg_generator_syn'),
	use_module('xmg_preparer_syn'),
	use_module('xmg_convert_tag_syn'),
	add_to_path('contributions/syn/principles'),
	use_module('xmg_tree'),
	%% this should be done optionally
	use_module('xmg_unicity'),
	use_module('xmg_colors'),
	use_module('xmg_rank'),
	use_module('xmg_tag'),
	add_to_path('contributions/syn/libraries'),
	use_module('xmg_engine_syn'),
	use_module('xmg_most'),
	use_module('xmg_nodename'),
	use_module('xmg_polarity'),
	!.