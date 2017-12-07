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


xmg:xml_convert_term(morpho:solved(M), elem(morph, features([lex-Morph]),children([elem(lemmaref,features([cat-Cat, name-Lemma]),children([Feats]))]))) :--
	lists:member(feat(morph,string(SMorph)),M),
        atom_codes(Morph,SMorph),
        lists:member(feat(lemma,string(SLemma)),M),
        atom_codes(Lemma,SLemma),
	lists:member(feat(cat,Cat),M),
	xmg:send(info,M),
	xmg:xml_convert_term(morpho:feats(M),Feats),
	xmg:send(info,Feats),
	!.

xmg:xml_convert_term(morpho:feats(M),elem(fs, children(Feats))):-- 
    convert_feats(M,Feats),
    !.

%% There should never be variables here
convert_feats([],[]).
convert_feats([feat(cat,_)|T],Feats):-
    convert_feats(T,Feats).
convert_feats([feat(lemma,_)|T],Feats):-
    convert_feats(T,Feats).
convert_feats([feat(morph,_)|T],Feats):-
    convert_feats(T,Feats).
convert_feats([feat(A,V)|T],[elem(f, features([name-A]), children([elem(sym,features([value-V]))]))|Feats]):-
      convert_feats(T,Feats).



