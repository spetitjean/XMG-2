%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2017  Simon Petitjean

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

:- module(xmg_brick_morpho_solver).

:- use_module(library(assoc)).

eval(Morph,morpho:solved(MergedMorph)):-
    merge_feats(Morph,Morph,[],MergedMorph),
    !.

merge_feats([],_,_,[]).
merge_feats([H|T],Morph,Seen,MT):-
    H=feat(F,_),
    lists:member(F,Seen),
    merge_feats(T,Morph,Seen,MT),!.
merge_feats([H|T],Morph,Seen,[MH|MT]):-
    H=feat(F,_),
    merge_feat(H,Morph,MH),
    merge_feats(T,Morph,[F|Seen],MT),!.

merge_feat(F,[],F).
merge_feat(feat(F,V),[feat(F1,_)|T],Merge):-
    not(F=F1),
    merge_feat(feat(F,V),T,Merge),!.
merge_feat(feat(F,V),[feat(F,V1)|T],Merge):-
    V=V1,
    merge_feat(feat(F,V),T,Merge),!.

    
