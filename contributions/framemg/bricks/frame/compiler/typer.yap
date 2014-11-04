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

%% statement type with default parameters
xmg:stmt_type(frame,Dim,Dim:frame(FType)):-
	xmg_brick_havm_havm:h_avm(FType,_,[]).
%% statement type with given parameters
xmg:stmt_type_constr(frame,frame).


xmg:type_stmt(frame:F,_):-- !.


%% xmg:type_stmt(syn:X,_):--
%% 	xmg:send(info,'\n\nDid not type frame statement:\n'),
%% 	xmg:send(info,X),!,
%% 	fail.

