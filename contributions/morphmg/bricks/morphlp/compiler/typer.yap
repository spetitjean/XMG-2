%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2014  Simon Petitjean

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

:-module(xmg_brick_morphlp_typer).

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_typer:types]).

%% statement type with default parameters
xmg:stmt_type(morphlp,Dim,Dim:morph(FieldsType,FeatsType)):-!.
%% statement type with given parameters
xmg:stmt_type_constr(morphlp,morph).


xmg:type_stmt(morphlp:infield(token(_,id(Field)),Contrib),Morphlp:morph(FieldsType,FeatsType)):--
	xmg:send(debug,'\n\ntyping infield with type '),
	xmg:send(debug,FieldsType),
	%% xmg_brick_avm_avm:dot(FieldsType,Field,T1),
	xmg:type_expr(F2,T1),	
	!.

xmg:type_stmt(morphlp:field(token(_,id(Field)),Feats),_):--
        xmg:type_expr(Feats,TFeats),
	!.

xmg:type_stmt(morphlp:fieldprec(token(_,id(Field1)),token(_,id(Field2))),_):--
	!.

xmg:type_stmt(morphlp:meq(token(_,id(F1)),F2),Morphlp:morph(FieldsType,FeatsType)):--
	xmg:send(debug,'\n\ntyping eq with type '),
	xmg:send(debug,FeatsType),
	%% xmg_brick_avm_avm:dot(FeatsType,F1,T1),
	xmg:type_expr(F2,T1),
	!.



xmg:type_stmt(morphlp:X,_):--
	xmg:send(info,'\n\nDid not type morphlp statement:\n'),
	xmg:send(info,X),!,
	fail.

