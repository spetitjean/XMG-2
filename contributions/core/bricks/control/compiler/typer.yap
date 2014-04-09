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

:-module(xmg_brick_control_typer).

:-edcg:using([xmg_brick_mg_typer:types]).

xmg:type_stmt(control:and(S1,S2),Type):--
	xmg:type_stmt(S1,Type),!,
	xmg:type_stmt(S2,Type),!.	

xmg:type_stmt(control:or(S1,S2),Type):--
	xmg:type_stmt(S1,Type),!,
	xmg:type_stmt(S2,Type),!.

%% this should be in dim brick:
xmg:type_stmt(dim:dim(Dim,S),void):--
	xmg:send(info,'\n\ndim statement:\n'),
	xmg:send(info,S),
	xmg:send(info,Dim),

	xmg:stmt_type(Dim,Type),
	xmg:send(info,'\nexpected type:\n'),
	xmg:send(info,Type),

	xmg:type_stmt(S,Type),
	xmg:send(info,'\ndim typed\n'),

	!.

xmg:type_stmt(control:eq(S1,S2),void):--
	!.

xmg:type_stmt(control:call(S1,S2),void):--
	!.	

xmg:type_stmt(control:dot(S1,S2),void):--
	!.

xmg:type_stmt(control:X,void):--
	xmg:send(info,'\n\nDid not type control statement:\n'),
	xmg:send(info,X),
	fail.

