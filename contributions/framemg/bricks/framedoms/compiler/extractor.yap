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

extract(Model,ModelEE):-
    xmg:send(debug,'\nExtracting frame: '),
    xmg:send(debug,Model),
    remove_subframes(Model,Model,ModelE),
    xmg:send(debug,'\nExtracted'),
    remove_duplicates(ModelE,ModelEE),
    xmg:send(debug,'\nExtracted frame: '),
    xmg:send(debug,ModelEE),
    !.

remove_duplicates([],[]):-!.
remove_duplicates([H|T],T1):-
    has_duplicate(H,T),
    remove_duplicates(T,T1),!.
remove_duplicates([H|T],[H|T1]):-
    remove_duplicates(T,T1),!.

has_duplicate(H,[H1|T]):-
    xmg_brick_havm_havm:h_avm(H,_,V),
    xmg_brick_havm_havm:h_avm(H1,_,V1),
    xmg:send(debug,V),
    xmg:send(debug,H),
    xmg:send(debug,V1),
    xmg:send(debug,H1),
    
    H==H1,
    xmg:send(debug,'\nFound duplicate.'),!.
has_duplicate(H,[_|T]):-
    has_duplicate(H,T),!.

remove_subframes([],_,[]):-!.
remove_subframes([H|T],Frames,T1):-
    is_subframe(H,Frames),!,
    xmg:send(info,'\nRemoved a frame'),
    remove_subframes(T,Frames,T1),!.
remove_subframes([H|T],Frames,[H|T1]):-
    not(is_subframe(H,Frames)),
    remove_subframes(T,Frames,T1),!.

is_subframe(Frame,[H|T]):-
    not(Frame==H),
    xmg:send(debug,'\nStarting is_subframe1 '),
    is_subframe_1(Frame,[],H),
    xmg:send(debug,'\ndone '),
    !.
is_subframe(Frame,[H|T]):-
    is_subframe(Frame,T),!.

is_subframe_1(Frame,Seen,Frame1):-
    Frame==Frame1,!.
is_subframe_1(Frame,Seen,Frame1):-
    attvar(Frame1),
    not(seen(Frame1,Seen)),
    xmg_brick_havm_havm:h_avm(Frame1,_,List),
    is_subframe_list(Frame,[Frame1|Seen],List),
    %%is_subframe_list(Frame,Seen,List),
    !.

is_subframe_list(Frame,Seen,[A-Frame1|T]):-
    is_subframe_1(Frame,Seen,Frame1),!.
is_subframe_list(Frame,Seen,[_|T]):-
    is_subframe_list(Frame,Seen,T),!.

seen(A,[H|T]):-
    A==H,!.
seen(A,[H|T]):-
    seen(A,T),!.
    



