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

:- module(xmg_brick_havm_convert).

%%:- edcg:thread(name,edcg:counter).

:- edcg:using(xmg_brick_mg_convert:name).

:- edcg:weave([name],[xmlHFeats/2, new_name/2]).

new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).

xmlHFeats([],[]):-- !.

xmlHFeats([A-V|T],[elem(f,features([name-A]),children([elem(sym,features([varname-V]))]))|T1]):--
	atom(V),
	xmlHFeats(T,T1),!.

xmlHFeats([A-const(V,Type)|T],[elem(f,features([name-A]),children([elem(sym,features([value-Val]))]))|T1]):--
	(
	    atom(V);
	    integer(V)
	
	),!, Val=V,
	xmlHFeats(T,T1),!.

xmlHFeats([A-AVM|T],[H1|T1]):--
	xmg_h_avm:h_avm(AVM,LAVM),
	xmg_h_avm:const_h_avm(AVM,CAVM),
	((
	    var(CAVM),!,
	    new_name('@AVM',CAVM),
	    xmlHFeats(LAVM,LAVM1),
	    H1=elem(f, features([name-A]),children([elem(fs,features([coref-CAVM]),children(LAVM1))]))
	)
    ;
	(
	    !,H1=elem(f, features([name-A]),children([elem(fs,features([coref-CAVM]))]))
	)),
	xmlHFeats(T,T1),!.

xmlHFeats([A-V|T],[elem(f,features([name-A]),children([elem(sym,features([varname-V]))]))|T1]):--
	var(V),
	new_name('@V',V),
	xmlHFeats(T,T1),!.

xmlHFeats([A-const(AD,_)|T],[H1|T1]):--
	%%write(AD),
	xmg_adisj:adisj(AD,LAD),
	xmg_adisj:const_adisj(AD,CLAD),!,
	((
	    var(CLAD),!,
	    new_name('@AD',CLAD),
	    xmlAdisj(LAD,LAD1),
	    H1=elem(f, features([name-A]),children([elem(vAlt, features([coref-CLAD]),children(LAD1))]))
	)
    ;
	(
	    !,H1=elem(f, features([name-A]),children([elem(vAlt, features([coref-CLAD]))]))
	)),
	    xmlHFeats(T,T1),!.


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
xmlAdisj([H|T],[elem(sym,features([value-H]))|T1]):--
	xmlAdisj(T,T1),!.

