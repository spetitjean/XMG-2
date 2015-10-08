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

:- module(xmg_brick_frame_convert).

:- xmg:edcg.

%%:- edcg:using(xmg_convert_avm:name).
:- edcg:using(xmg_brick_mg_convert:name).

:- edcg:weave([name],[framesToXML/2, frameToXML/2, featsToXML/2, featToXML/2, valToXML/2, xmlSyn/2, xmlSynList/2, xmlSem/2, xmlIface/2, xmlPred/2, xmlArgs/2, xmlArg/2]).


listToXML([],[]).
listToXML([H|T], [H1|T1]) :-- toXML(H,H1), listToXML(T,T1).

xmg:xml_convert_term(frame:frame(Frames), elem(frame, features([]), children(UFeats))) :--
	framesToXML(Frames,UFeats),
	!.


framesToXML([],[]):-- !.
framesToXML([H|T],[H1|T1]):--
	frameToXML(H,H1),
	framesToXML(T,T1).

frameToXML(Frame,Frame1 ):--
	xmg_brick_havm_havm:h_avm(Frame,VType,Feats),
	xmg_brick_hierarchy_typer:fVectorToType(VType,Type),
	xmg_brick_havm_havm:const_h_avm(Frame,Const),
	(
	    (
		var(Const),!,
		xmg:convert_new_name('@Frame',New),
		%%xmg:send(info,New),
		New=Const,
		featsToXML(Feats,XMLFeats),
		Frame1=elem(fs,features([coref-Const,type-Type]),children(XMLFeats))
	
	    )
	;
	    (
		!, Frame1=elem(fs,features([coref-Const,type-Type]))
		)
	),
	!.

featsToXML([],[]):-- !.
featsToXML([H|T],[H1|T1]):--
	featToXML(H,H1),
	featsToXML(T,T1),!.

featToXML(Attr-Value,elem(f,features([name-Attr]),children([XMLValue]))):--
	valToXML(Value,XMLValue),
	!.


valToXML(Frame,XMLFrame):--
	frameToXML(Frame,XMLFrame),!.
valToXML(Var,elem(sym,features([value-Var]))):--
	var(Var),
	xmg:convert_new_name('@V',Var),
	!.
valToXML(const(Val,_),elem(sym,features([value-Val]))):-- !.
valToXML(Val,elem(sym,features([value-Val]))):-- !.

xmg_brick_avm_convert:xmlFeat(A-AVM,H1):--
	%% thread name does not seem to work, _ have to be replaced
	frameToXML(AVM,H),
	H1=elem(f, features([name-A]),children([H])),
	!.

		

