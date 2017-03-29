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

:- module(xmg_brick_tag_preparer, []).



prepare_instances(Syn,prepared(TagOps,Syn)):-  
	prepare_instance(Syn,TagOps),
	!.


prepare_instance([],[]):- !.

prepare_instance([node(Prop,_,_)|T],[H1|T1]):-
	prepare(Prop,H1),
	prepare_instance(T,T1),!.

prepare_instance([_|T],Tagops):-
	prepare_instance(T,Tagops),!.

prepare(PropAVM,tagop(C)):-
	xmg_brick_avm_avm:avm(PropAVM, Props),
	search_tagop(Props,C),
	!.


search_tagop([],none):-
	!.
search_tagop([mark-nadj|_],none):-!.
search_tagop([mark-adj|_],none):-!.

search_tagop([mark-Mark|_],Mark):-!.

search_tagop([_|T],C):-
	search_tagop(T,C),!.

