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


xmg:xml_convert_term(morphlp:solved(Fields,Atom,Form), elem(morph, children([elem(features,children(CForm)),elem(string,features([value-Atom])),elem(fields,children(CFields))]))) :--
    %%print_fields(Fields),

    xmg:xml_convert_term(avm:avm(Form),CForm),
    %%xmg:send(info,Fields),
    
    xmg:xml_convert_term(morphlp:fields(Fields),CFields),

	%% xmg_convert_avm:xmlFeats(L1,Feats) with name(0,N1),
	%% xmlMorph(List,Stems),
	!.

print_fields([]).
print_fields([(_,FS)|T]):-
    xmg_brick_avm_avm:avm(FS,AVM),
    xmg:send(info,AVM),!,
    print_fields(T).
print_fields([H|T]):-
    print_fields(T).

xmg:xml_convert_term(morphlp:fields([]),[]):--!.
xmg:xml_convert_term(morphlp:fields([H|T]),[H1|T1]):--
    xmg:xml_convert_term(morphlp:field(H),H1),
    xmg:xml_convert_term(morphlp:fields(T),T1),!.

xmg:xml_convert_term(morphlp:field((string(String),Feats)),H1):--
    atom_codes(Atom,String),
    XMLString=elem(string,features([value-Atom])),
    xmg_brick_avm_avm:avm(Feats,AVMFeats),
    xmg:xml_convert_term(avm:avm(AVMFeats),CFeats),
    H1=elem(field,children([XMLString,elem(feats,children([elem(fs,children(CFeats))]))])),
    !.
xmg:xml_convert_term(morphlp:field(field(_,_)),H1):--
    XMLString=elem(string,features([value-''])),
    H1=elem(field,children([XMLString,elem(feats,children([]))])),
    !.
xmg:xml_convert_term(morphlp:field(H,Feats),H1):--
    xmg:send(info,'\nUnexpected value: '),
    xmg:send(info,H),
    !.


xmlMorph([],[]):-
	!.
xmlMorph([H|T],[elem(morpheme,features([value-H]))|T1]):- 
	xmlMorph(T,T1),!.
