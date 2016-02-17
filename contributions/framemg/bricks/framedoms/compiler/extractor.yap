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

:- module(xmg_brick_framedoms_extractor, []).

extract(Model,ModelE):-
    remove_subframes(Model,Model,ModelE),!.

remove_subframes([],_,[]):-!.
remove_subframes([H|T],Frames,T1):-
    is_subframe(H,Frames),
    remove_subframes(T,Frames,T1),!.
remove_subframes([H|T],Frames,[H|T1]):-
    not(is_subframe(H,Frames)),
    remove_subframes(T,Frames,T1),!.

is_subframe(Frame,[H|T]):-
    not(Frame==H),
    is_subframe_1(Frame,H),!.
is_subframe(Frame,[H|T]):-
    is_subframe(Frame,T).

is_subframe_1(Frame,Frame1):-
    Frame==Frame1,!.
is_subframe_1(Frame,Frame1):-
    attvar(Frame1),
    xmg_brick_havm_havm:h_avm(Frame1,_,List),
    is_subframe_list(Frame,List),!.

is_subframe_list(Frame,[_-Frame1|T]):-
    is_subframe_1(Frame,Frame1),!.
is_subframe_list(Frame,[_|T]):-
    is_subframe_list(Frame,T).





