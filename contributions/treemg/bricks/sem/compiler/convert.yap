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


:- module(xmg_brick_sem_convert).

:- xmg:edcg.

:- edcg:using(xmg_brick_mg_convert:name).

:- edcg:weave([name],[new_name/2, xmlSem/2, xmlPred/2, xmlArgs/2, xmlArg/2, xmlID/2]).

new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).


xmg:xml_convert_term(sem:sem(Sem), elem(semantics,children(Sem1))) :--
    %%xmg:send(info,'\nHere before sem'),
      %%lists:remove_duplicates(Sem,SemD),!,
      %%xmg:send(info,'\nHere before xmlsem'),
	xmlSem(Sem,Sem1),
	!.

xmlSem([],[]):-- !.

xmlSem([H|T],[H1|T1]):--
	xmlPred(H,H1),
	xmlSem(T,T1),!.

xmlPred(LP,elem(literal,features([negated-'no']),children([elem(label,children([elem(sym,features([value-XL]))])),elem(predicate,children([elem(sym,features(FXPred))]))|Args1]))):--
       LP=..[':',L,P],

       P=..['@',Pred,Args],

	xmlID(L,XL),
	xmlID(Pred,XPred),
	value_or_var(XPred,FXPred),
	xmlArgs(Args,Args1),!.

%% xmlPred(P,elem(literal,features([negated-'no']),children([elem(predicate,children([elem(sym,features([varname-XPred]))]))|Args1]))):--
%% 	P=..['@',Pred,Args],
%% 	xmlID(Pred,XPred),
%% 	xmlArgs(Args,Args1),!.

xmlPred(P,elem(literal,features([negated-'no']),children([elem(label,children([elem(sym,features([varname-Label]))])),elem(predicate,children([elem(sym,features(FXPred))]))|Args1]))):--
       P=..['@',Pred,Args],
       xmlID(Pred,XPred),
       value_or_var(XPred,FXPred),

	xmlArgs(Args,Args1),
	new_name('@V',Label),
	!.

xmlPred(P,elem(semdominance,features([op-'ge']),children([elem(sym,features([varname-V1])),elem(sym,features([varname-V2]))]))):--
	P=..['<<',E1,E2],
	xmlID(E1,V1),
	xmlID(E2,V2),!.

xmlID(ID,ID):--
	var(ID),
	new_name('@V',ID),!.
xmlID(c(ID),ID):-- !.
xmlID(s(ID),ID):--
	var(ID),
	new_name('!C',ID),!.
xmlID(s(ID),ID):-- !.
xmlID(v(ID),VID):--
     atomic_concat(['@V',ID],VID),!.
%% Should not happen, but does when class parameters are used as predicates
xmlID(ID,ID):--
	not(var(ID)),!.


value_or_var(X,[varname-X]):-
    atom_chars(X,['@','V'|_]),!.

value_or_var(X,[value-X]).
    
xmlArgs([],[]):--!.

xmlArgs([H|T],[H1|T1]):--
	xmlArg(H,H1),
	xmlArgs(T,T1),!.

xmlArg(A,elem(arg,children([elem(sym,features([varname-A]))]))):--
var(A),
new_name('@V',A), !.

xmlArg(A,elem(arg,children([elem(sym,features([varname-A]))]))):-- !.



