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

:- module(xmg_brick_morphlp_convert).

:- xmg:edcg.


xmg:xml_convert_term(morphlp:solved(List,Form), elem(morph, children([elem(features,features([value-Form])),elem(morph,features([value-List]))]))) :--
	%% xmg_convert_avm:xmlFeats(L1,Feats) with name(0,N1),
	%% xmlMorph(List,Stems),
	!.

xmlMorph([],[]):-
	!.
xmlMorph([H|T],[elem(morpheme,features([value-H]))|T1]):- 
	xmlMorph(T,T1),!.
