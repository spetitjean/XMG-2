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


:- module(xmg_convert_tag_syn, []).
:- use_module('xmg_most').

%%:- edcg:using(xmg_convert_avm:name).
:- edcg:using(xmg_convert:name).

:- dynamic(dejavu/1).

:- edcg:weave([name],[new_name/2, xmlSyn/2, xmlSynList/2, xmlSem/2, xmlIface/2, xmlPred/2, xmlArgs/2, xmlArg/2]).

new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).

listToXML([],[]).
listToXML([H|T], [H1|T1]) :-- toXML(H,H1), listToXML(T,T1).

toXML(tree(Tree,Family), elem(tree, features([id-Name]),children([Syn1])),Number) :--
	lists:remove_duplicates(Sem,SemD),!,
	xmlSyn(Tree,Syn1) with name(1,_),!,
	atomic_concat([Family,'_',Number],Name),
	!.

xmlSynList([],[]):-- !.
xmlSynList([H|T],[H1|T1]):--
	xmlSyn(H,H1),
	xmlSynList(T,T1),!.


xmlSyn([],[]):-- !.


%% For nodes
xmlSyn(Node,Root):--
	Node=node(PropAVM,FeatAVM,N),

	xmg_avm:avm(PropAVM, Props),
	xmg_avm:avm(FeatAVM, Feats),

	xmg_avm:const_avm(FeatAVM,CAVM),
	%%xmg_nodename:nodename(N,Name),
	xmlName(Props,Name,N),
	xmlMark(Props,XMLMark),
	%%xmlBound(Props,XMLBound),
	%% fs const is var
	(
	    var(CAVM)->
	    
	    (
		new_name('@AVM',CAVM),
		xmg_convert_avm:xmlFeats(Feats,XMLFeats),!,
		%%Elem=elem(fs,features([coref-CAVM]),children(XMLFeats))
	    	Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]),children(XMLFeats))]))]))
		)
	;
	(
	    %%Elem=elem(fs,features([coref-CAVM]))
	!,Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]))]))]))
	)
    ),!.

xmlSyn(tree(H,Trees),Root):--
	H=node(PropAVM,FeatAVM,N),

	xmg_avm:avm(PropAVM, Props),
	xmg_avm:avm(FeatAVM, Feats),

	xmg_avm:const_avm(FeatAVM,CAVM),
	%%xmg_nodename:nodename(N,Name),
	xmlName(Props,Name,N),
	xmlMark(Props,XMLMark),
	(
	    var(CAVM)->
	    
	    (
		new_name('@AVM',CAVM),
		xmg_convert_avm:xmlFeats(Feats,XMLFeats),!,
		%%Elem=elem(fs,features([coref-CAVM]),children(XMLFeats))
	    	Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]),children(XMLFeats))]))|Trees1]))
		)
	;
	(
	    %%Elem=elem(fs,features([coref-CAVM]))
	!,Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]))]))|Trees1]))
	)
    ),
	xmlSynList(Trees,Trees1),!.


xmlMark([],'std'):--!.
xmlMark([mark-const('flex',_)|T],'lex'):--!.

xmlMark([mark-const(Prop,_)|T],Prop):--!.

xmlMark([_-_|T],Props):--
	xmlMark(T,Props),!.

xmlName([],Name,N):--
	xmg_nodename:nodename(N,Name),
	!.

xmlName([name-value(Prop,_)|T],Prop,_):--!.

xmlName([_-_|T],Props,N):--
	xmlName(T,Props,N),!.

xmlBound([],'none'):--!.

xmlBound([bound-Prop|T],Bound):--
	xmg_most:most(Prop,Bound),
	!.

xmlBound([_-_|T],Props):--
	xmlBound(T,Props),!.

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

aritychildren([],[]):-- !.
aritychildren([H|T],[H1|T1]):--
	H=node(A,_,_),
	H1=elem(child,features([num-A])),
	aritychildren(T,T1),!.

convertPolarity('=','0'):-- !.
convertPolarity('=-','~1'):-- !.
convertPolarity('=~','0v'):-- !.
convertPolarity('=+','1'):-- !.

handle_most([],[]):--!.

handle_most([dom(A,'-L>',C,D)|T],[dom(A,'->',C,D)|T1]):--
	C=node(P,_,_),
	xmg_most:most(Most,left),
	xmg_avm:avm(P,[bound-Most]),
	handle_most(T,T1),!.

handle_most([dom(A,'-R>',C,D)|T],[dom(A,'->',C,D)|T1]):--
	C=node(P,_,_),
	xmg_most:most(Most,right),
	xmg_avm:avm(P,[bound-Most]),
	handle_most(T,T1),!.

handle_most([node(P,A,B)|T],[node(P,A,B)|T1]):--
	xmg_most:most(Most,none),
	xmg_avm:avm(P,[bound-Most]),
	handle_most(T,T1),!.

handle_most([H|T],[H|T1]):--
	handle_most(T,T1),!.

retrace([],[]):- !.
retrace([Class|T],[Class1|T1]):-
	atom_concat('class_',Class1,Class),
	retrace(T,T1),!.
		

