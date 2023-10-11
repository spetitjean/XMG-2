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


:-module(xmg_brick_avm_generator).

:- xmg:edcg.


:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:name).
:-edcg:using(xmg_brick_mg_generator:code).

:-edcg:weave([decls,name], [new_name/2,var_or_const/2,generate/5]).

xmg:generate_instr((v(Target),avm:avm(Coord))) :--
	decls::tget(Target,Var),
	code::enq(xmg_brick_avm_avm:avm(Var,[])),
	!.
xmg:generate_instr((v(Target),avm:feat(c(F),v(Target2)))):--
	decls::tget(Target,Var),
	decls::tget(Target2,Var2),
	code::enq(xmg_brick_avm_avm:avm(Var,[F-Var2])),	
	!.
xmg:generate_instr((v(Target),avm:feat(c(F),c(Target2)))):--
	decls::tget(Target,Var),
	Var2=Target2,
	code::enq(xmg_brick_avm_avm:avm(Var,[F-Var2])),	
	!.


xmg:generate_instr((v(Var),avm:dot(v(Class),c(CVar)))):--
	xmg:send(debug,' generating dot '),
	decls::tget(Var,GV),
	decls::tget(Class,GC),
	
	Dot=..[avm_dot,CVar-GV,GC],
	code::enq(xmg:Dot),!.

xmg:avm_dot(Member-Value,List) :-
    %% xmg:send(info,'\nDOT 1'),
    not(var(List)),
    lists:member(Member-Value,List).
xmg:avm_dot(Member-Value,AVM) :-
    %% sometimes the avm does not have the given feature yet
    %% this should not happen for const_avms (export vectors)
    %%  xmg:send(info,'\nDOT 4'),
      xmg_brick_avm_avm:avm(AVM,List),
      not(lists:member(Member-Value,List)),!,
      xmg_brick_avm_avm:avm(AVM,[Member-Value]),
      !.

xmg:avm_dot(Member-Value,AVM) :-
     %% sometimes it seems that we have avm objects instead of lists
     %% xmg:send(info,'\nDOT 2'),
      xmg_brick_avm_avm:avm(AVM,List),!,
      xmg:avm_dot(Member-Value,List).
xmg:avm_dot(Member-Value,AVM) :-
    %% sometimes the AVM is not yet an AVM (free variable)
    %% xmg:send(info,'\nDOT 3'),
    var(AVM),
    %% not(attvar(AVM)),
    xmg_brick_avm_avm:avm(AVM,[Member-Value]),
    %% attvar(AVM),
    !.
		      
xmg:avm_dot(Member-_,List):-
	not(lists:member(Member-Value,List)),
	xmg:send(info,'\nDid not find key '),
	xmg:send(info,Member),
	xmg:send(info,' in '),
	xmg:send(info,List).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% generating an intersection of cavm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmg:generate_instr((v(Var),value:inter(v(V1),v(V2)))):--
		  xmg:send(info,'Generating a intersection\n'),
        xmg:send(info,(v(Var),value:inter(v(V1),v(V2)))),
	decls::tget(V1,CAVM1),
        decls::tget(V2,CAVM2),
        decls::tget(Var,CAVM),
	code::enq(xmg:send(info,'CAVM1:')),	
	code::enq(xmg:send(info,CAVM1)),
	
	code::enq(xmg:send(info,'CAVM2:')),
	code::enq(xmg:send(info,CAVM2)),!,	

	code::enq(xmg:send(info,' Trying intersection ')),
	code::enq(lists:intersection(CAVM1,CAVM2,CAVM)),
	xmg:send(info,intersection(CAVM1,CAVM2,CAVM)),
	code::enq(xmg:send(info,' done intersection: ')),
	code::enq(xmg:send(info,CAVM)),	
	!.
