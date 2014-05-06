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

:- module(xmg_brick_mg_convert, []).

:- xmg:edcg.
:- edcg:thread(name,edcg:counter).
%% :- edcg:using(xmg_accs:name).

:- edcg:weave([name],[xmg:convert_new_name/2, xmg:xml_convert/2, xmg:xml_convert_free/2, xmg:xml_convert_attributed/2, xmg:xml_convert_term/2]).

:- multifile(xmg:xml_convert_attributed/4).
:- multifile(xmg:xml_convert_term/4).

xmg:convert_new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).

xmg:do_xml_convert(Term,Convert):--
	xmg:xml_convert(Term,Convert) with name(_).

xmg:xml_convert(Term,Convert):--
	not(var(Term)),
	xmg:xml_convert_term(Term,Convert),!.
xmg:xml_convert(Term,Convert):--
	xmg:xml_convert_attributed(Term,Convert),!.
xmg:xml_convert(Term,Convert):--
	xmg:xml_convert_free(Term,Convert),!.
xmg:xml_convert(Term,Expected):--
	xmg:send(info,'\n\nError: could not convert to xml \n'),
	xmg:send(info,Term),
	xmg:send(info,'\nI expected: \n' ),
	xmg:send(info,Expected),
	false,!.


xmg:xml_convert_free(Free,Convert):--
	var(Free),
	new_name("@V",Convert).

xmg:xml_convert_term(mg:entry(Class,Trace,Dims,Number),elem(entry, features([name-Name]),children([elem(family, data(Class)),elem(trace, children(Trace1))|Dims]))):--
	xmlTrace(Trace,Trace1),!,
	atomic_concat([Class,'_',Number],Name),
	!.

xmg:xml_convert_term([],[]):-- !.
xmg:xml_convert_term([H|T],[H1|T1]):--
	xmg:xml_convert(H,H1),
	xmg:xml_convert(T,T1),!.



%% listToXML([],[]).
%% listToXML([H|T], [H1|T1]) :-- toXML(H,H1), listToXML(T,T1).

%% toXML(entry(Trace,Dims), elem(entry, features([name-Name]),children([elem(family, data(Family)),elem(trace, children(Trace1))|Dims])),Number) :--
%% 	xmlTrace(Trace,Trace1),!,
%% 	Trace=[Family|_],!,
%% 	atomic_concat([Family,'_',Number],Name),
%% 	!.

xmlTrace([A],[elem(class, data(A))]) :-- !.
xmlTrace([H|T],[H1|T1]):--
	xmlTrace([H],[H1]),!, xmlTrace(T,T1),!.
