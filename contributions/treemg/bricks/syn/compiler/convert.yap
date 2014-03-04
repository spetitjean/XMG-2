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


:- module(xmg_brick_syn_convert, []).
:- use_module('xmg/brick/syn/most').

%%:- edcg:using(xmg_convert_avm:name).
%% :- edcg:using(xmg_brick_mg_convert:name).

:- dynamic(dejavu/1).

%% :- edcg:weave([name],[new_name/2, xmlSyn/2, xmlSynList/2, xmlSem/2, xmlIface/2, xmlPred/2, xmlArgs/2, xmlArg/2]).

%% new_name(Prefixe, Name) :--
%% 	name::incr,
%% 	name::get(N),
%% 	atomic_concat([Prefixe,N],Name).

%% listToXML([],[]).
%% listToXML([H|T], [H1|T1]) :-- toXML(H,H1), listToXML(T,T1).

xmg:xml_convert_term(Node,Root):--
	Node=node(PropAVM,FeatAVM,N),

	xmg_brick_avm_avm:avm(PropAVM, Props),
	xmg_brick_avm_avm:avm(FeatAVM, Feats),

	xmg_brick_avm_avm:const_avm(FeatAVM,CAVM),
	%%xmg_brick_nodename_nodename:nodename(N,Name),
	
	xmg:xml_convert(syn:props(Props),props(Name,N,XMLMark)),

	(
	    var(CAVM)->
	    
	    (
		xmg:convert_new_name('@AVM',CAVM),
		xmg:xml_convert(avm:avm(Feats),XMLFeats),!,
		%%Elem=elem(fs,features([coref-CAVM]),children(XMLFeats))
	    	Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]),children(XMLFeats))]))]))
		)
	;
	(
	    %%Elem=elem(fs,features([coref-CAVM]))
	!,Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]))]))]))
	)
    ),!.


xmg:xml_convert_term(syn:props(Props),props(NName,N,XMLMark)):--
	%% xmg:send(info,'\n\nWe are here:'),
	%% xmg:send(info,Props),
	xmlName(Props,Name,N),
	%% xmg:send(info,Name),
	%% xmg:send(info,N),
	
	Name=NName,
	xmlMark(Props,XMLMark),!.

xmlMark([],'std'):-!.
xmlMark([mark-'flex'|T],'lex'):-!.

xmlMark([mark-Prop|T],Prop):-!.

xmlMark([_-_|T],Props):-
	xmlMark(T,Props),!.

xmlName([],Name,N):-
	xmg_brick_syn_nodename:nodename(N,Name),
	!.

xmlName([name-Prop|T],Prop,_):-!.

xmlName([_-_|T],Props,N):-
	xmlName(T,Props,N),!.

xmlBound([],'none'):-!.

xmlBound([bound-Prop|T],Bound):-
	xmg_most:most(Prop,Bound),
	!.

xmlBound([_-_|T],Props):-
	xmlBound(T,Props),!.

