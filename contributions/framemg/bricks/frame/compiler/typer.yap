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

:-module(xmg_brick_frame_typer).

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_typer:types]).

:- asserta(xmg:type(frame:frame)).

%% statement type with default parameters
xmg:stmt_type(frame,Dim,Dim:frame(FType)):-
	xmg_brick_havm_havm:h_avm(FType,_,[]).
%% statement type with given parameters
xmg:stmt_type_constr(frame,frame).


xmg:type_stmt(frame:frame(L,T,F),Dim:frame(FType)):--
	     xmg:type_expr(frame:frame(L,T,F),Dim:frame(FType)),
             xmg:send(debug,'\nDim '),
             xmg:send(debug,Dim),
             xmg:send(debug,' has now type '),
             xmg_brick_havm_havm:h_avm(FType,_,HAVM),
             xmg:send(debug,HAVM),
	     !.
xmg:type_stmt(frame:dom(F1,F2,_),Dim:frame(FType)):--
	     xmg:type_expr(F1,Dim:frame),
	     xmg:type_expr(F2,Dim:frame),
	     !.

xmg:type_stmt(frame:relation(Rel,Params),Dim:frame(FType)):--
	     %%xmg:type_expr(Rel,Dim:frame),
	     %%xmg:type_expr(Params,Dim:frame),
	     !.

xmg:type_expr(frame:frame(L,T,F),Dim:frame(FType)):--
	     xmg:type_expr(L,Dim:frame),
             xmg:type_expr(T,Dim:frame_type),
             xmg:type_expr(F,FType),
	     !.

xmg:type_expr(frame:pair(token(_,id(A)),V),FType):--
	     xmg:type_expr(V,T),
             xmg_brick_havm_havm:h_avm(FType,_,[A-T]),
	     !.
xmg:type_expr(frame:pair(token(C,id(A)),V),FType):--
	     xmg:type_expr(V,T),
             xmg:send(info,'\nWarning: inconsistent types\n'),
             xmg:send(info,V),
             xmg:send(info,'\n'),
             xmg:send(info,C),
	     !.


%% xmg:type_stmt(syn:X,_):--
%% 	xmg:send(info,'\n\nDid not type frame statement:\n'),
%% 	xmg:send(info,X),!,
%% 	fail.

