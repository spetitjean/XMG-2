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

:- module(xmg_brick_avm_convert).

:- xmg:edcg.

:- edcg:using(xmg_brick_mg_convert:name).

:- multifile(xmlFeat/4).

:- edcg:weave([name],[xmlFeats/2,xmlFeat/2]).

xmg:xml_convert_term(avm:avm(Feats),Convert):--
    xmg:send(info,'\nHere in AVM convert'),
	xmlFeats(Feats,Convert),!.

xmlFeats([],[]):-- !.
xmlFeats([H|T],[H1|T1]):--
xmg:send(info,'\nDoing xmlFeat'),
	xmlFeat(H,H1),
	xmlFeats(T,T1),!.

xmlFeat(A-V,elem(f,features([name-A]),children([elem(sym,features([varname-V]))]))):--
         var(V),
         xmg:send(info,'\nHere in AVM convert with var'),
         xmg:convert_new_name('@V',V),
	 xmg:send(info,'\nConverted the name'),
	!.
%% xmlFeat(A-V,elem(f,features([name-A,varname-V]))):--
%% 	atom(V),
%% 	atom_chars(V,['@'|_]),
%% 	!.
xmlFeat(A-V,elem(f,features([name-A]),children([elem(sym,features([varname-V]))]))):--
	atom(V),
	atom_chars(V,['@'|_]),
	!.

xmlFeat(A-string(V),elem(f,features([name-A]),children([elem(sym,features([value-V1]))]))):--
xmg:send(info,'\nHere atom_codes'),
	atom_codes(V1,V),!.
xmlFeat(A-V,elem(f,features([name-A]),children([elem(sym,features([value-V]))]))):--
xmg:send(info,'\nHere atom'),
xmg:send(info,V),

	(atom(V)
        ;
	integer(V)
        ),
	xmg:send(info,'\nDone'),
	!.


xmlFeat(A-AVM,H1):--
xmg:send(info,'\nHere before AVM'),
	xmg_brick_avm_avm:avm(AVM,LAVM),
	xmg_brick_avm_avm:const_avm(AVM,CAVM),
	xmg:send(info,'\nHere AVM'),

	((
		var(CAVM),!,
		xmg:send(info,'\nConverting new name'),
	    xmg:convert_new_name('@AVM',CAVM),
	    xmlFeats(LAVM,LAVM1),
	    H1=elem(f, features([name-A]),children([elem(fs,features([coref-CAVM]),children(LAVM1))]))
	)
    ;
	(
	    %%!,H1=elem(f, features([name-A]),children([elem(fs,features([value-CAVM]))]))
	    !,H1=elem(f, features([name-A]),children([elem(fs,features([coref-CAVM]))]))
	)),
	!.

xmlFeat(A-AVM,H1):--
xmg:send(info,'\nHere failing AVM'),
fail.

%%%%%%%%%%%%%%%


xmlFeat(A-AD,H1):--
xmg:send(info,'\nHere adisj'),
	xmg_brick_adisj_adisj:adisj(AD,LAD),
	xmg_brick_adisj_adisj:const_adisj(AD,CLAD),!,
	((
	    var(CLAD),!,
	    xmg:convert_new_name('@AD',CLAD),
	    xmg:xml_convert(adisj:adisj(LAD),LAD1),
	    H1=elem(f, features([name-A]),children([elem(vAlt, features([coref-CLAD]),children(LAD1))]))
	)
    ;
	(
	    %%!,H1=elem(f, features([name-A]),children([elem(vAlt, features([value-CLAD]))]))
	    !,H1=elem(f, features([name-A]),children([elem(vAlt, features([coref-CLAD]))]))
	)),
	!.







