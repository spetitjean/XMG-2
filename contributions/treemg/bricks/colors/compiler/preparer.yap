%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2012  Simon Petitjean

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

:- module(xmg_brick_colors_preparer, []).

:-edcg:using(xmg_brick_mg_preparer:preparer).
:-edcg:weave([preparer],[prepare/2]).

get_instances([color]).


prepare(I,Out):--
	preparer::tget(nodes,Nodes),
        prepare_list(Nodes,I,Out,NNodes),
        preparer::tput(nodes,NNodes),!.


prepare_list([],I,[],[]):-
    !.

prepare_list([Node|T],I,[H1|T1],[PNode|T2]):-
	prepare_one(Node,I,H1,PNode),!,
	prepare_list(T,I,T1,T2),!.

prepare_list([H|T],I,Colors,[H|T1]):-
		prepare_list(T,I,Colors,T1),!.



prepare_one(node(P,F,N),I,color(C),node(PNC,F,N)):-
	xmg_brick_avm_avm:avm(P, Props),
	%%xmg:send(info,Props),
	xmg_brick_syn_nodename:nodename(N,NodeName),
	search_color(NodeName,Props,C),
	no_color(P,PNC),!.

prepare_one(node(P,F,N),I,none,node(P,F,N)):-
	%%throw(xmg(principle_error(undefined_color(Name)))),	
        xmg:send(info,'\nNo color for node '),
    	xmg_brick_syn_nodename:nodename(N,NodeName),

	xmg:send(info,N),
	xmg:send(info,'. This should not happen.\n\n'),
	!.

%%search_color(_,[color-const(C,_)|_],C):-!.
search_color(_,[color-C|_],C):-!.

search_color(Name,[_|T],C):-
	search_color(Name,T,C),!.


no_color(AVM,NCAVM):-
	xmg_brick_avm_avm:avm(AVM,LAVM),
	lists:member(color-C,LAVM),!,
	lists:delete(LAVM,color-C,NCLAVM),
	xmg_brick_avm_avm:avm(NCAVM,NCLAVM),
	xmg:send(debug,'\nremoved color!'),!.

no_color(AVM,AVM):-
	!.

