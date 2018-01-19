%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2016  Simon Petitjean

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

:- module(xmg_brick_lemma_convert).

:- xmg:edcg.


xmg:xml_convert_term(lemma:solved(Lemma), elem(lemma, features([name-Entry, cat-CAT]),children([Tree]))) :--
	lists:member(feat(entry,string(SEntry)),Lemma),
        atom_codes(Entry,SEntry),
        lists:member(feat(cat,CAT),Lemma),
	lists:member(feat(fam,Fam),Lemma),
	atom_concat(['family[@name=',Fam,']'],FamFeat),
	%%filter_or_not(Lemma,Filter),
	get_filters(Lemma,Filters),
	FFilters=[elem(filter,children([elem(fs,children(Filters))]))],
	%%Tree=elem(anchor, features([tree_id-FamFeat]),children([elem(filter,children([elem(fs)]))|Feats])),
	Tree=elem(anchor, features([tree_id-FamFeat]),children(FFeats)),
	xmg:xml_convert_term(lemma:feats(Lemma),Feats),
	lists:append(FFilters,Feats,FFeats),
	!.

xmg:xml_convert_term(lemma:feats(Lemma),Feats):--
        convert_feats(Lemma,Feats),
	!.

get_filters([],[]).
get_filters([filter(A,B)|T],[elem(f,features([name-A]),children([elem(sym,features([value-B]))]))|TT]):-
    get_filters(T,TT),!.
get_filters([_|T],TT):-
    get_filters(T,TT),!.

filter_or_not(Lemma,[]):-
    lists:member(filter(_,_),Lemma),!.
filter_or_not(_,[elem(filter,children([elem(fs)]))]):-!.

convert_feats([],[]).
convert_feats([feat(cat,_)|T],Feats):-
    convert_feats(T,Feats).
convert_feats([feat(entry,_)|T],Feats):-
    convert_feats(T,Feats).
convert_feats([feat(fam,Fam)|T],T1):-
	convert_feats(T,T1),!.
convert_feats([coanchor(Node,string(SLex),Cat)|T],[Coanchor|Feats]):-
    atom_codes(Lex,SLex),
    Coanchor=elem(coanchor,features([node_id-Node,cat-Cat]),children([elem(lex,data(Lex))])),
    convert_feats(T,Feats).
convert_feats([filter(Att,Val)|T],Feats):-
    %% Already taken care of
    %%Filter=elem(filter,children([elem(fs,children([elem(f,features([name-Att]),children([elem(sym,features([value-Val]))]))]))])),
    convert_feats(T,Feats).
convert_feats([equation(Node,Att,Val)|T],[Equation|Feats]):-
    %% not sure what type=bot means
    Equation=elem(equation,features([type-bot,node_id-Node]),children([elem(fs,children([elem(f,features([name-Att]),children([elem(sym,features([value-Val]))]))]))])),
    convert_feats(T,Feats).
convert_feats([H|_],_):-
    xmg:send(info,'\n\nError: unsupported instruction: '),
    xmg:send(info,H),false.

