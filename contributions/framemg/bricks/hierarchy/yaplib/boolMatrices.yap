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


:- module(xmg_brick_hierarchy_boolMatrix,[msquare/2,fixpoint/2,get_row/3,and_rows/3,get_type/3]).
:- use_module(library(maplist)).
%% looks like there is a conflict with atts
%:- use_module(library(matrix)).
:- use_module(library(lists)).

or(0,0,0):-!.	
or(_,_,1).

and(1,1,1):-!.
and(_,_,0).

and_rows([],[],[]).
and_rows([H1|T1],[H2|T2],[H3|T3]):-
	and(H1,H2,H3),
	and_rows(T1,T2,T3).

get_row(N,Matrix,Elt):-
	lists:nth(N,Matrix,Elt).

get_type(Matrix,Row,Type):-
	lists:nth(Type,Matrix,Row).

mmultiply([],_,[]).
mmultiply([V0|Rest], V1, [Result|Others]):-  
            mmultiply(Rest, V1, Others),
                multiply(V1,V0,Result).

multiply([],_,[]).
multiply([V0|Rest], V1, [Result|Others]):-  
            multiply(Rest, V1, Others),
                vmul(V0,V1,Result).

vmul([],[],0).
vmul([H1|T1], [H2|T2], Result):-
        vmul(T1,T2, Newresult),
	and(H1,H2,And),
	or(And,Newresult,Result).

lists_to_list([],[]).
lists_to_list([H|T],List):-
	lists_to_list(T,T1),
	lists:append(H,T1,List).

list_to_lists([],_,[]).
list_to_lists(List,Len,[LList|T1]):-
	build_len_list(List,Len,LList,Left),
	list_to_lists(Left,Len,T1).

build_len_list(List,0,[],List).
build_len_list([H|T],N,[H|T1],Left):-
	M is N - 1,
	build_len_list(T,M,T1,Left).

msquare(M,S):-
	lists:length(M,Len),
	lists_to_list(M,ML),
	matrix:matrix_new(ints,[Len,Len],ML,Matrix),
	matrix:matrix_transpose(Matrix,Transposed),
	matrix:matrix_to_list(Transposed,TL),
	list_to_lists(TL,Len,T),
	mmultiply(M,T,S).

fixpoint(M,M):-
	msquare(M,M),!.

fixpoint(M,F):-
	msquare(M,M2),!,
	write(M2),
	write('\n'),
	fixpoint(M2,F).


%% Example from Gerald Penn:
%% ?- fixpoint([[1,1,1,1,0,0,0],[0,1,0,0,1,1,0],[0,0,1,0,1,0,1],[0,0,0,1,0,1,1],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,1]],A).
%% A = [[1,1,1,1,1,1,1],[0,1,0,0,1,1,0],[0,0,1,0,1,0,1],[0,0,0,1,0,1,1],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,1]].

%% number of steps is bounded by the depth of the largest path in the type hierarchy

%% This example: depth is 3
%% ?- fixpoint([[1,1,0,0],[0,1,1,0],[0,0,1,1],[0,0,0,1]],A).
%% [[1,1,1,0],[0,1,1,1],[0,0,1,1],[0,0,0,1]]
%% [[1,1,1,1],[0,1,1,1],[0,0,1,1],[0,0,0,1]]
%% A = [[1,1,1,1],[0,1,1,1],[0,0,1,1],[0,0,0,1]].

%% This example: depth is 4
%% ?- fixpoint([[1,1,0,0,0],[0,1,1,0,0],[0,0,1,1,0],[0,0,0,1,1],[0,0,0,1,1]],A).

%% ?- fixpoint([[1,1,1,1,0,0,0],[0,1,0,0,1,1,0],[0,0,1,0,1,0,1],[0,0,0,1,0,1,1],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,1]],A), get_row(2,A,R1),get_row(4,A,R2),and_rows(R1,R2,R3),get_type(A,R3,Type).
