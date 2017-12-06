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

:- module(xmg_brick_morpho_convert).

:- xmg:edcg.


xmg:xml_convert_term(morpho:solved(M), elem(morph, features([lex-Morph]),children([elem(lemmaref,features([cat-Cat, name-Lemma]))]))) :--
	lists:member(feat(morph,string(SMorph)),M),
        atom_codes(Morph,SMorph),
        lists:member(feat(lemma,string(SLemma)),M),
        atom_codes(Lemma,SLemma),
	lists:member(feat(cat,Cat),M),
	xmg:xml_convert_term(morpho:feats(Morph),Feats),
	!.

xmg:xml_convert_term(morpho:feats(M),Feats):--
        %% 
	Feats=[],
	!.



