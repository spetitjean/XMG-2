%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2016  Simon Petitjean

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

:- module(xmg_brick_framedoms_preparer, []).

:- xmg:edcg.
:-edcg:thread(name,edcg:counter).
:-edcg:weave([name],[count/7,new_name/1]).

new_name(Name):--
	name::incr,
	name::get(N),
	atomic_concat(['X',N],Name).

prepare(frame(Frame,Trace),prepared(Frames,Doms)):--  
	lists:remove_duplicates(Frame,FrameD),
	xmg_table:table_new(TableIn),
	xmg_table:table_new(TableInv),

	%% écrire l'id de la classe courante
	Trace=[Family|_],

	write_lits(SynD,Relations,TableOut),

	!.

