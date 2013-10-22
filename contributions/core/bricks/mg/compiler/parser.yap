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



:-module(xmg_brick_mg_parser).

:- dynamic(lastError/2).

:- edcg:thread(stack,edcg:stack).
:- edcg:thread(stack2,edcg:stack).
:- edcg:thread(steps,edcg:counter).
:- edcg:thread(errors,edcg:stack).

:- edcg:weave([stack,stack2],[preAction/1 ]).
:- edcg:weave([stack],[makeAction/3, buildAction/4 ]).
:- edcg:weave([stack2],[makeBody/3 ]).
:- edcg:weave([errors],[throw_errors/0,parse_sem/3]).
:- edcg:weave([stack,steps,errors],[parse_sem/2]).


%% Parser for the following grammar : 
%% S' -> S
%% S -> CC
%% C -> cC|d

%% State |  Action   |  Next
%% _________________________
%%       |  c  d  $  |  S  C
%% _________________________
%%    0  | d3 d4     |  1  2   
%%    1  |       acc |       
%%    2  | d6 d7     |     5  
%%    3  | d3 d4     |     8  
%%    4  | r3 r3     |       
%%    5  |        r1 |       
%%    6  | d6 d7     |     9  
%%    7  |        r3 |       
%%    8  | r2 r2     |       
%%    9  |        r2 |       
%%  _________________________            


%% rule(1,rule('S',['C','C'])).
%% rule(2,rule('C',['c','C'])).
%% rule(3,rule('C',['d'])).

%% %% To each rule we associate an action, which states what will be accumulated

%% action(1,[A1,A2|T],['S'(A1,A2)|T]):-!.
%% action(2,[A1,A2|T],['C'(A1,A2)|T]):-!.
%% action(3,[A|T],['C'(A)|T]):-!.

%% makeAction([]):--!.
%% makeAction([H|T]):--
%% 	stack::pop(H1),
%% 	stack2::push(H1),
%% 	makeAction(T),!.

%% makeAction: 2 steps. 1st is to pop all the rightsize of the rule and accumulate it in a temp list. Then, go through the action list. When the element is a number, get the nth element of the temp list and push it into stack2. Else, push the element into stack2. 

preAction(0):-- !.
preAction(N):--
	M is N-1,
	stack::pop(Element),
	stack2::push(Element),
	preAction(M),!.

makeAction(PreAction,Left,Action):--
	xmg_brick_mg_compiler:send(info,Action),
	buildAction(PreAction,Left,Action,_),
	stack::push(Left),!.

buildAction(PreAction,Left,pred(Head,Body),Pred):--
	ref_or_not(PreAction,Left,Head,RHead),
	(
	    RHead=token(_,id(IDHead))
	;
	IDHead=RHead
    ),
	makeBody(PreAction,Left,Body) with stack2([],MBody),
	%%xmg_brick_mg_compiler:send(info,RHead),
	%%xmg_brick_mg_compiler:send(info,MBody),
	Pred=..[IDHead|MBody],!.
buildAction(PreAction,Left,listenum(List),MList):--
	!,
	makeBody(PreAction,Left,List) with stack2([],MList),!.
buildAction(PreAction,Left,listcons(H,T),[H1|T1]):--
	!,
	ref_or_not(PreAction,Left,H,H1),
	ref_or_not(PreAction,Left,T,T1),!.
buildAction(PreAction,Left,eq(E1,E2),none):--!,
	ref_or_not(PreAction,Left,E1,RE1),
	buildAction(PreAction,Left,E2,RE2),
	RE1 = RE2,!.
buildAction(PreAction,Left,Id,RId):--
	ref_or_not(PreAction,Left,Id,RId),!.

	

makeBody(PreAction,Left,[]):-- !.
makeBody(PreAction,Left,[H|T]):--
	ref_or_not(PreAction,Left,H,RH),
	makeBody(PreAction,Left,T),
	stack2::push(RH),!.

ref_or_not(PreAction,Left,get('left'),Left):-!.
ref_or_not(PreAction,Left,get(Ref),Elt):-
	lists:nth(Ref,PreAction,Elt),!.
ref_or_not(PreAction,Left,put(Put),Put):-!.
	


acc(Acc,Acc).


pop2N(L,0,[],L):-!.
pop2N([H1,H2|T],N,[H1,H2|T1],L):-
	M is N-1,
	pop2N(T,M,T1,L),
	!.
pop2N([H1,H2|T],N,[H3,H4|T1],L):-
	M is N-1,
	pop2N(T,M,T1,L),
	!.


tokArgs(token(Coord,Token),Tok,Args):-
	Token=..[Tok|Args],!.



%% parse_sem([State|States],[Token|Tokens]):--
%% 	write(Token),nl,write(State),
%% 	lastError([error(State,_,_)|_],_),!,fail.

parse_sem([State|States],[Token|Tokens]):--
	tokArgs(Token,Tok,Args),
	generated_parser:action(State,Tok,'accept'),!.

parse_sem([State|States],[Token|Tokens]):--
	tokArgs(Token,Tok,Args),
	generated_parser:action(State,Tok,'reduce',NRule),
	generated_parser:action(State,Tok,'shift',NState),
	xmg_brick_mg_compiler:send(info,'reduce/shift confict'),false,!. 
parse_sem([State|States],[Token|Tokens]):--
	generated_parser:action(State,'','reduce',NRule),
	generated_parser:action(State,'','shift',NState),
	xmg_brick_mg_compiler:send(info,'reduce/shift confict'),false,!. 
parse_sem([State|States],[Token|Tokens]):--
	tokArgs(Token,Tok,Args),
	generated_parser:action(State,Tok,'reduce',NRule),
	generated_parser:action(State,'','shift',NState),
	xmg_brick_mg_compiler:send(info,'reduce/shift confict'),false,!. 
parse_sem([State|States],[Token|Tokens]):--
	tokArgs(Token,Tok,Args),
	generated_parser:action(State,'','reduce',NRule),
	generated_parser:action(State,Tok,'shift',NState),
	xmg_brick_mg_compiler:send(info,'reduce/shift confict'),false,!. 
	

parse_sem([State|States],[Token|Tokens]):--
	tokArgs(Token,Tok,Args),
	generated_parser:action(State,Tok,'reduce',NRule),
	steps::incr ,
	%% REDUCE
	generated_parser:rule(NRule,Left,RightSize),
	pop2N([State|States],RightSize,Pop,Stack),
	Stack=[Top|_],
	generated_parser:next(Top,Left,Next),
	generated_parser:ruleAction(NRule,Action),
	%%xmg_brick_mg_compiler:send(info,RightSize), 
	preAction(RightSize) with stack2([],PreAction),
	%%xmg_brick_mg_compiler:send(info,PreAction), 
	makeAction(PreAction,OneLeft,Action),
	parse_sem([Next,Left|Stack],[Token|Tokens]).
%% for the empty word
parse_sem([State|States],[Token|Tokens]):--
	tokArgs(Token,Tok,Args),
	generated_parser:action(State,'','reduce',NRule),
	%% REDUCE
	generated_parser:rule(NRule,Left,RightSize),
	pop2N([State|States],RightSize,Pop,Stack),
	Stack=[Top|_],
	generated_parser:next(Top,Left,Next),
	generated_parser:ruleAction(NRule,Action),
	preAction(RightSize) with stack2([],PreAction),
	makeAction(PreAction,OneLeft,Action),
	parse_sem([Next,Left|Stack],[Token|Tokens]).

parse_sem([State|States],[Token|Tokens]):--
	tokArgs(Token,Tok,Args),
	generated_parser:action(State,Tok,'shift',NState),
	steps::incr,
	%% SHIFT
	acc(Token,A),
	stack::push(A),
	parse_sem([NState,Token,State|States],Tokens)
    .
%% for rules with empty word
parse_sem([State|States],[Token|Tokens]):--
	tokArgs(Token,Tok,Args),
	generated_parser:action(State,'','shift',NState),
	stack::push(''),
	%% if we don't do that, errors are more precise, but parsing sometimes takes ages:
	steps::incr,
	parse_sem([NState,'',State|States],[Token|Tokens])
    .


parse_sem([State|States],[token(coord(File,Line,Col),Token)|Tokens]):--
	%% error is before last
	steps::get(Steps),
	lastError(Err,StepE),
	%%errors::top(error(Err,StepE)),
	Steps < StepE,
	(
	    StepE - Steps > 10 ->
	    throw_errors;true
	),
	fail.

parse_sem([State|States],[token(Coord,Token)|Tokens]):--
	steps::get(Step),
	lastError(LastE,StepE),!,
	%%errors::top(error(LastE,StepE)),!,
	(
	    ( 
	       Step > StepE,
	       retractall(lastError(_,_)),
	       %%errors::drop,

	       %%xmg_brick_mg_compiler:send(debug,assert_last),
	       asserta(lastError([error(State,Token,Coord)],Step))
	       %%errors::push(error(error(State,Token,Coord),Step))
	   )
       ;
       	(
       	    Step = StepE,
       	    retractall(lastError(_,_)),
       	    Errors=[error(State,Token,Coord)|LastE],
	    %%xmg_brick_mg_compiler:send(debug,assert_same),
	    %%xmg_brick_mg_compiler:send(debug,Coord),
	    
       	    asserta(lastError(Errors,Step))
	    %%errors::push(error(error(State,Token,Coord),Step))
       	)
    ),
	fail.

throw_errors:--
	xmg_brick_mg_compiler:send(info,' ERROR :'),
	lastError(Errors,_),
	%%errors::top(Errors),
	
	xmg_brick_mg_compiler:send(debug,Errors),
	throw_error(Errors,[],0,none),!.

throw_error([],Expected,Coord,Token):-
	throw(xmg(parser_error(   expected(Expected,Token,Coord)))),
	!.

throw_error([H|T],Expected,_,_):-
	H=error(State,Token,Coord),
	expected_tokens(State,tokens(State,Expected1)),
	lists:append(Expected,Expected1,Expected2),
	throw_error(T,Expected2,Coord,Token),
	!.

parse_sem(States,Tokens,Sem):--
	asserta(lastError([none],0)),
	parse_sem(States,Tokens) with (stack([],Sem), steps(_)),!.
parse_sem(States,Tokens,Sem):--
	throw_errors,!.

parse_file(File,Sem):--
	xmg_brick_mg_compiler:encoding(Encoding),
	xmg_brick_mg_tokenizer:tokenize_file(File,Tokens,Encoding),
	xmg_brick_mg_compiler:send(info,tokenized),
	%%xmg_brick_mg_compiler:send(debug,Tokens),
	remove_coords(Tokens,Toks),
	%%xmg_brick_mg_compiler:send(debug,Toks),
	parse_sem([0],Toks,Sem) with errors(Errors,[error(error(none,none,none),0)]),!.

remove_coords([coord(A,B,C)],[token(coord(A,B,C),'(EOF)')]):- !.
remove_coords([Token],[token(coord(0,0,end),'(EOF)')]):-
	xmg_brick_mg_compiler:send(info,Token),!.
remove_coords([coord(A1,B1,C1),coord(A,B,C)|T],T1):-
	%xmg_brick_mg_compiler:send(info,H),
	remove_coords([coord(A,B,C)|T],T1),!.
remove_coords([coord(A,B,C),Token|T],[token(coord(A,B,C),Token)|T1]):- 
	remove_coords(T,T1),!.

remove_coords([H,coord(A,B,C)|T],[token(coord(A,B,C),H)|T1]):-
	%xmg_brick_mg_compiler:send(info,H),
	remove_coords([coord(A,B,C)|T],T1),!.




expected_tokens(State,tokens(State,Tokens)):-
	findall(Token,generated_parser:action(State,Token,_,_),Tokens),!.



%% parse(_,_,_):-
%% 	%% ERROR
%% 	!.

%% ?- parse([0],['d','d','$'],[],Trace).
%% Trace = ['S'('C'(d),'C'(d))]
%% ?- parse([0],['c','d','$'],[],Trace).
%% no
%% ?- parse([0],['c','c','d','$'],[],Trace).
%% no
%% ?- parse([0],['c','d','c','d','$'],[],Trace).
%% Trace = ['S'('C'('C'(d),c),'C'('C'(d),c))]
