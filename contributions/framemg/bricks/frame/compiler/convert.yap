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

:- edcg:weave([name],[framesToXML/2, frameToXML/2, featsToXML/2, featToXML/2, valToXML/2, xmlSyn/2, xmlSynList/2, xmlSem/2, xmlIface/2, xmlPred/2, xmlArgs/2, xmlArg/2, paramsToXML/2, typeToXML/2]).
:-multifile(typeToXML/2).


listToXML([],[]).
listToXML([H|T], [H1|T1]) :-- toXML(H,H1), listToXML(T,T1).

xmg:xml_convert_term(frame:frame(Frames), elem(frame, features([]), children(UFeats))) :--
        xmg:send(debug,'\nConverting frames (duplicates removed):'),
        lists:remove_duplicates(Frames,DFrames),
	reorder(DFrames,RFrames),
        %%xmg:send(info,DFrames),
	framesToXML(RFrames,UFeats),
	!.

%% put the relations at the end (so frame ids are already created)
reorder([],[]).
reorder([relation(R,P)|T],New):-
    reorder(T,T1),
    lists:append(T1,[relation(R,P)],New),!.
reorder([H|T],[H|T1]):-
    reorder(T,T1),!.

framesToXML([],[]):-- !.
framesToXML([H|T],[H1|T1]):--
	   xmg:send(debug,'\nChecking havm for the last time'),
	   xmg_brick_havm_havm:verify_attributes(H,H,_),
	   frameToXML(H,H1),
	   framesToXML(T,T1).

frameToXML(dom(V1,Op,V2),XML ):--
	  xmg_brick_havm_havm:const_h_avm(V1,C1),
	  xmg_brick_havm_havm:const_h_avm(V2,C2),
	  
	  XML=elem(dominance, features([type-large, from-C1, to-C2])),
	  !.

frameToXML(relation(Rel,Params),XML ):--
          not(var(Rel)),
          paramsToXML(Params,XMLParams),
	  XML=elem(relation, features([name-Rel]) ,children(XMLParams)),
		   !.

frameToXML(Frame,Frame1 ):--
	  %%xmg_brick_havm_havm:print_h_avm(Frame,0),
	  xmg_brick_havm_havm:h_avm(Frame,VType,Feats),
          %%xmg:send(info,'\nType: '),
          %%xmg:send(info,VType),
          (var(VType)-> (xmg:send(debug,'\nFound a non instantiated type variable'),Type=VType)
	    ;
            ((atom(VType) -> (xmg:send(debug,'\nFound a constant as type'),Type=VType));xmg_brick_hierarchy_typer:fVectorToType(VType,Type))),
	  %%xmg:send(info,Type),  
	  xmg_brick_havm_havm:const_h_avm(Frame,Const),
	  typeToXML(Type,XMLType),
	(
	    (
		var(Const),!,
		xmg:convert_new_name('@Frame',New),
		%%xmg:send(info,New),
		New=Const,
		featsToXML(Feats,XMLFeats),
		Frame1=elem(fs,features([coref-Const]),children([XMLType|XMLFeats]))
	
	    )
	;
	    (
		%!, Frame1=elem(fs,features([coref-Const]), children([XMLType]))
	        !, Frame1=elem(fs,features([coref-Const]))
		)
	),
	!.

typeToXML(Type,elem(ctypevar,features([varname-Type]))):--
        var(Type),
        xmg:convert_new_name('@Type',Type).

typeToXML(Type,elem(ctypevar,features([varname-Type]))):--
        atom(Type).

typeToXML(Type,elem(ctype,children(AtomicTypes))):--
    atomicTypesToXML(Type,AtomicTypes).

atomicTypesToXML([],[]).
atomicTypesToXML([H|T],[elem(type,features([val-H]))|T1]):-
    atomicTypesToXML(T,T1),!.



featsToXML([],[]):-- !.
featsToXML([H|T],[H1|T1]):--
	featToXML(H,H1),
	featsToXML(T,T1),!.

featToXML(Attr-Value,elem(f,features([name-Attr]),children([XMLValue]))):--
	valToXML(Value,XMLValue),
	!.

paramsToXML([],[]):--!.
%% Case where the param is a variable
paramsToXML([H|T],[elem(sym,features([varname-H]))|T1]):--
	var(H),
	xmg:convert_new_name('@V',H),
        paramsToXML(T,T1),!.
%% Case where the param is a frame (possible?)
paramsToXML([H|T],[elem(sym,features([varname-Const]))|T1]):--
        var(H),
        xmg_brick_havm_havm:const_h_avm(H,Const),
	%% (
	%%     (
	%% 	var(Const),!,
	%% 	xmg:convert_new_name('@Frame',New),
	%% 	New=Const	
	%%     )
	%% ;
	%%     (
	%% 	true
	%% 	)
	%% ),
        paramsToXML(T,T1),!.
paramsToXML([H|T],[elem(sym,features([varname-H]))|T1]):--
        paramsToXML(T,T1),!.

valToXML(Frame,XMLFrame):--
	frameToXML(Frame,XMLFrame),!.
valToXML(Var,elem(sym,features([varname-Var]))):--
	var(Var),
	xmg:convert_new_name('@V',Var),
	!.
valToXML(Var,elem(sym,features([varname-Var]))):--
	atom(Var),
	atom_chars(Var,['@'|_]),
	!.

valToXML(const(Val,_),elem(sym,features([value-Val]))):-- !.
valToXML(Val,elem(sym,features([value-Val]))):-- !.

xmg_brick_avm_convert:xmlFeat(A-AVM,H1):--
	%% thread name does not seem to work, _ have to be replaced
	frameToXML(AVM,H),
	H1=elem(f, features([name-A]),children([H])),
	!.

		

