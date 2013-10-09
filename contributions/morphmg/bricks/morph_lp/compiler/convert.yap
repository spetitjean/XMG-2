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

:- module(xmg_convert_morph).


:- edcg:using(xmg_convert:name).

:- edcg:weave([name],[new_name/2, xmlFeats/2, xmlMorph/2]).

new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).


toXML(solved(List,Form), elem(morph, children([elem(form,features([value-Form])),elem(morphemes,children(Stems))])),Number) :--
	%%xmg_convert_avm:xmlFeats(L1,Feats) with name(0,N1),
	xmlMorph(List,Stems) with name(N1,_),
	!.

xmlMorph([],[]):--
	!.
xmlMorph([const(Value,_)|T],[elem(morpheme,features([value-Value]))|T1]):-- 
	xmlMorph(T,T1),!.
