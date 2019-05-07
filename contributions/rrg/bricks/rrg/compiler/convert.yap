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


:- module(xmg_brick_rrg_convert, []).

:- xmg:edcg.


%% deal with the constructor 'tree'

xmg:xml_convert_term(tree:tree(Tree,Family,Number), elem(tree, features([id-Name]),children([Syn1]))):--
	lists:remove_duplicates(Sem,SemD),!,
 	xmg:xml_convert(Tree,Syn1),!,
	%%xmg:send(info,Syn1),
	%%xmg:send(info,Family),
	%%xmg:send(info,Number),
 	atomic_concat([Family,'_',Number],Name),
 	!.
	
xmg:xml_convert_term(tree:tree(H,Trees), Root):--
	H=node(PropAVM,FeatAVM,N),

	xmg_brick_avm_avm:avm(PropAVM, Props),
	xmg_brick_avm_avm:avm(FeatAVM, Feats),

	xmg_brick_avm_avm:const_avm(FeatAVM,CAVM),
	%%xmg_brick_nodename_nodename:nodename(N,Name),
	xmg:xml_convert(syn:props(Props),props(Name,N,XMLMark,More)),
	(
	    var(CAVM)->
	    
	    (
		xmg:convert_new_name('@AVM',CAVM),
		xmg:xml_convert(avm:avm(Feats),XMLFeats),!,
		%%Elem=elem(fs,features([coref-CAVM]),children(XMLFeats))
	    	Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]),children(XMLFeats))]))|Trees1]))
		)
	;
	(
	    %%Elem=elem(fs,features([coref-CAVM]))
	!,Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]))]))|Trees1]))
	)
    ),
	xmg:xml_convert(Trees,Trees1),!.
	


%% xmlSyn(tree(H,Trees),Root):--
%% 	H=node(PropAVM,FeatAVM,N),

%% 	xmg_brick_avm_avm:avm(PropAVM, Props),
%% 	xmg_brick_avm_avm:avm(FeatAVM, Feats),

%% 	xmg_brick_avm_avm:const_avm(FeatAVM,CAVM),
%% 	%%xmg_brick_nodename_nodename:nodename(N,Name),
%% 	xmlName(Props,Name,N),
%% 	xmlMark(Props,XMLMark),
%% 	(
%% 	    var(CAVM)->
	    
%% 	    (
%% 		new_name('@AVM',CAVM),
%% 		xmg_brick_avm_convert:xmlFeats(Feats,XMLFeats),!,
%% 		%%Elem=elem(fs,features([coref-CAVM]),children(XMLFeats))
%% 	    	Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]),children(XMLFeats))]))|Trees1]))
%% 		)
%% 	;
%% 	(
%% 	    %%Elem=elem(fs,features([coref-CAVM]))
%% 	!,Root=elem(node, features([type-XMLMark, name-Name]), children([elem(narg,children([elem(fs,features([coref-CAVM]))]))|Trees1]))
%% 	)
%%     ),
%% 	xmlSynList(Trees,Trees1),!.


