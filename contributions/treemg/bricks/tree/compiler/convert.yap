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


:- module(xmg_brick_tree_convert, []).

%% deal with the constructor 'tree'

toXML(tree(Tree,Family), elem(tree, features([id-Name]),children([Syn1])),Number) :--
	lists:remove_duplicates(Sem,SemD),!,
	xmlSyn(Tree,Syn1) with name(1,_),!,
	atomic_concat([Family,'_',Number],Name),
	!.

xmlSyn(tree(H,Trees),Root):--
	H=node(PropAVM,FeatAVM,N),

	xmg_brick_avm_avm:avm(PropAVM, Props),
	xmg_brick_avm_avm:avm(FeatAVM, Feats),

	xmg_brick_avm_avm:const_avm(FeatAVM,CAVM),
	%%xmg_brick_nodename_nodename:nodename(N,Name),
	xmlName(Props,Name,N),
	xmlMark(Props,XMLMark),
	(
	    var(CAVM)->
	    
	    (
		new_name('@AVM',CAVM),
		xmg_brick_avm_convert:xmlFeats(Feats,XMLFeats),!,
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


