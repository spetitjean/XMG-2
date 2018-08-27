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

:- xmg:edcg.


%%:- use_module('xmg/brick/syn/most').
:-edcg:thread(nodes,edcg:queue).
:-edcg:thread(dominances,edcg:queue).
:-edcg:thread(precedences,edcg:queue).
:-edcg:thread(arities,edcg:queue).
:-edcg:using(xmg_brick_mg_convert:name).

:- edcg:weave([nodes,dominances,precedences,arities,name],[xmlSyn/1,xmlSyn1/1]).


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

xmlName([],NName,N):-
    xmg_brick_syn_nodename:nodename(N,Name),
    Prefix='XMGVAR_',
    atom_concat(Prefix,Name,NName),
	!.

xmlName([name-Prop|T],Prop,_):-!.

xmlName([_-_|T],Props,N):-
	xmlName(T,Props,N),!.

xmlBound([],'none'):-!.

xmlBound([bound-Prop|T],Bound):-
	xmg_brick_syn_most:most(Prop,Bound),
	!.

xmlBound([_-_|T],Props):-
	xmlBound(T,Props),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Convert descriptions (nodes and relations)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmg:xml_convert_term(syn:desc(Syn,Family,Number),elem(syntactic_desc,children(Syn1))):--
	handle_most(Syn,SynH),!,
	lists:remove_duplicates(SynH,SynD),!,
	xmlSyn(SynD) with (nodes([]-A,[]-[]), dominances([]-B,[]-[]), precedences([]-C,[]-[]), arities([]-D,[]-[])),!,
	Syn1=[elem(nodes, children(A)), elem(dominances, children(B)), elem(precedences, children(C))|D],!,
	!.



xmlSyn([]):-- !.
xmlSyn([H|T]):--
	xmlSyn1(H),!,
	xmlSyn(T),!.

xmlSyn1(node(PropAVM,FeatAVM,N)):--
	!,

	xmg_brick_avm_avm:avm(PropAVM, Props),
	xmg_brick_avm_avm:avm(FeatAVM, Feats),

	xmg_brick_avm_avm:const_avm(FeatAVM,CAVM),
	xmg_brick_syn_nodename:nodename(N,Name),

	xmlBound(Props,XMLBound),
	xmlMark(Props,XMLType),
	clean_props(Props,CProps),
	%% fs const is var
	(
	    var(CAVM)->
	    
	    (
		xmg:convert_new_name('@AVM',CAVM),
		xmg:xml_convert(avm:avm(Feats),XMLFeats),!,
	    	nodes::enq(elem(node, features([type-XMLType,name-Name,bound-XMLBound|XMLProps]), children([elem(fs,features([coref-CAVM]),children(XMLFeats))])))
		)
	;
	(
	    %%Elem=elem(fs,features([coref-CAVM]))
	nodes::enq(elem(node, features([type-XMLType,name-Name,bound-XMLBound|XMLProps]), children([elem(fs,features([coref-CAVM]))])))
	)
    ),!.


	
xmlSyn1(dom(A,'->',C,AVM)):--
	!,
	  A=node(_,_,A1),
	  C=node(_,_,C1),
	  xmg_brick_syn_nodename:nodename(A1,A1Name),
	  xmg_brick_syn_nodename:nodename(C1,C1Name),
	  (
	      xmg_brick_avm_avm:avm(AVM, Feats)
	      ->
	      (
		  xmg:xml_convert(avm:avm(Feats),XFeats),!,
	      dominances::enq(elem(dominance, features([type-strict, from-A1Name, to-C1Name]),children([elem('edge_constraint',children([elem(fs,children(XFeats))]))])))
	  )
      ;
	dominances::enq(elem(dominance, features([type-strict, from-A1Name, to-C1Name])))
    ),
	    !.
xmlSyn1(dom(A,'->+',C,AVM)):--
	!,
	  A=node(_,_,A1),
	  C=node(_,_,C1),
	  xmg_brick_syn_nodename:nodename(A1,A1Name),
	  xmg_brick_syn_nodename:nodename(C1,C1Name),
	  (
	      xmg_brick_avm_avm:avm(AVM, Feats)
	      ->
	      (
		  xmg:xml_convert(avm:avm(Feats),XFeats),!,
	      dominances::enq(elem(dominance, features([type-strict, from-A1Name, to-C1Name]),children([elem('edge_constraint',children([elem(fs,children(XFeats))]))])))
	  )
      ;
	dominances::enq(elem(dominance, features([type-strict, from-A1Name, to-C1Name])))
    ),
	    !.
xmlSyn1(dom(A,'->*',C,AVM)):--
	!,
	A=node(_,_,A1),
	C=node(_,_,C1),
	xmg_brick_syn_nodename:nodename(A1,A1Name),
	xmg_brick_syn_nodename:nodename(C1,C1Name),
	  (
	xmg_brick_avm_avm:avm(AVM, Feats)
    ->
	  (
	      xmg:xml_convert(avm:avm(Feats),XFeats),!,
	      dominances::enq(elem(dominance, features([type-large, from-A1Name, to-C1Name]),children([elem('edge_constraint',children([elem(fs,children(XFeats))]))])))
	  )
      ;
	dominances::enq(elem(dominance, features([type-large, from-A1Name, to-C1Name])))
    ),!.


xmlSyn1(dom(A,'-L>',C,AVM)):--
	!,
	A=node(_,_,A1),
	C=node(_,_,C1),
	xmg_brick_syn_nodename:nodename(A1,A1Name),
	xmg_brick_syn_nodename:nodename(C1,C1Name),!.
xmlSyn1(dom(A,'-R>',C,AVM)):--
	!,
	A=node(_,_,A1),
	C=node(_,_,C1),
	xmg_brick_syn_nodename:nodename(A1,A1Name),
	xmg_brick_syn_nodename:nodename(C1,C1Name),!.

%% For precedences
xmlSyn1(prec(A,'>>',C,_)):--
	!,
	A=node(_,_,A1),
	C=node(_,_,C1),
	xmg_brick_syn_nodename:nodename(A1,A1Name),
	xmg_brick_syn_nodename:nodename(C1,C1Name),
	precedences::enq(elem(precedence, features([type-strict, from-A1Name, to-C1Name]))),!.
xmlSyn1(prec(A,'>>*',C,_)):--
	!,
	A=node(_,_,A1),
	C=node(_,_,C1),
	xmg_brick_syn_nodename:nodename(A1,A1Name),
	xmg_brick_syn_nodename:nodename(C1,C1Name),
	precedences::enq(elem(precedence, features([type-large, from-A1Name, to-C1Name]))),!.

%% For arities
xmlSyn1(synarity(node(A,_,_),B)):--
	!,
	arities::enq(elem(arity, features([mother-A]), children(C))),
	aritychildren(B,C),!.

handle_most([],[]):-!.

handle_most([dom(A,'-L>',C,D)|T],[dom(A,'->',C,D)|T1]):-
	C=node(P,_,_),
	xmg_brick_syn_most:most(Most,left),
	xmg_brick_avm_avm:avm(P,[bound-Most]),!,
	handle_most(T,T1),!.

handle_most([dom(A,'-R>',C,D)|T],[dom(A,'->',C,D)|T1]):-
	C=node(P,_,_),
	xmg_brick_syn_most:most(Most,right),
	xmg_brick_avm_avm:avm(P,[bound-Most]),!,
	handle_most(T,T1),!.

handle_most([node(P,A,B)|T],[node(P,A,B)|T1]):-
	xmg_brick_syn_most:most(Most,none),
	xmg_brick_avm_avm:avm(P,[bound-Most]),!,
	handle_most(T,T1),!.

handle_most([H|T],[H|T1]):-
	handle_most(T,T1),!.

clean_props([],[]).
clean_props([mark-_|T],T1):-
	!,
	clean_props(T,T1),!.
clean_props([bound-_|T],T1):-
	!,
	clean_props(T,T1),!.
clean_props([H|T],[H|T1]):-
	clean_props(T,T1),!.

