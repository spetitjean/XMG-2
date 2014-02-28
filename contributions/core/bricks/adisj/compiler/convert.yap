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

:- module(xmg_brick_adisj_convert).

%%:- edcg:thread(name,edcg:counter).

:- edcg:using(xmg_brick_mg_convert:name).

:- edcg:weave([name],[xmlAdisj/2]).

xmg:xml_convert_term(adisj:adisj(ADisj),Convert):--
	xmlAdisj(ADisj,Convert),!.

xmlAdisj([],[]) :-- !.

xmlAdisj([H|T],[elem(sym,features([value-Val]))|T1]):--
	H=string(String),
	not(var(String)),!,
	atom_codes(Val,String),
	xmlAdisj(T,T1),!.
xmlAdisj([H|T],[elem(sym,features([value-Int]))|T1]):--
	H=int(Int),
	not(var(Int)),!,
	xmlAdisj(T,T1),!.
xmlAdisj([H|T],[elem(sym,features([value-Bool]))|T1]):--
	H=bool(Bool),
	not(var(Bool)),!,
	xmlAdisj(T,T1),!.
xmlAdisj([H|T],[elem(sym,features([value-Val]))|T1]):--
	H=Val,
	xmlAdisj(T,T1),!.

