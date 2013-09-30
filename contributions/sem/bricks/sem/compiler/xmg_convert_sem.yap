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


:- module(xmg_convert_sem, []).
:- edcg:thread(name,edcg:counter).

:- edcg:weave([name],[new_name/2, xmlSem/2, xmlPred/2, xmlArgs/2, xmlArg/2, xmlID/2]).

new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).

listToXML([],[]).
listToXML([H|T], [H1|T1]) :-- toXML(H,H1), listToXML(T,T1).

toXML(Sem, elem(semantics,children(Sem1))) :--
	lists:remove_duplicates(Sem,SemD),!,
	xmlSem(Sem,Sem1) with name(0,_),
	!.

xmlSem([],[]):-- !.

xmlSem([H|T],[H1|T1]):--
	xmlPred(H,H1),
	xmlSem(T,T1),!.

xmlPred(LP,elem(literal,features([negated-'no']),children([elem(label,children([elem(sym,features([value-XL]))])),elem(predicate,children([elem(sym,features([varname-XPred]))]))|Args1]))):--
	LP=..[':',L,P],
	P=..['@',Pred,Args],
	xmlID(L,XL),
	xmlID(Pred,XPred),
	xmlArgs(Args,Args1),!.

xmlPred(P,elem(literal,features([negated-'no']),children([elem(predicate,children([elem(sym,features([varname-XPred]))]))|Args1]))):--
	P=..['@',Pred,Args],
	xmlID(Pred,XPred),
	xmlArgs(Args,Args1),!.

xmlID(ID,XID):--
	var(ID),
	new_name('@V',XID),!.
xmlID(const(ID,_),ID):-- !.
xmlID(sconst(ID,_),XID):--
	var(ID),
	new_name('!C',XID),!.
xmlID(sconst(ID,_),ID):-- !.
xmlID(ID,ID):-- !.


%% xmlPred(LP,elem(literal,features([negated-'no']),children([elem(label,children([elem(sym,features([value-L]))])),elem(predicate,children([elem(sym,features([varname-Pred]))]))|Args1]))):--
%% 	LP=..[':',L,P],
%% 	P=..['@',Pred,Args],
%% 	var(Pred),
%% 	new_name('@V',Pred),
%% 	xmlArgs(Args,Args1),!.

%% xmlPred(LP,elem(literal,features([negated-'no']),children([elem(label,children([elem(sym,features([value-L]))])),elem(predicate,children([elem(sym,features([varname-Pred]))]))|Args1]))):--
%% 	LP=..[':',L,P],
%% 	P=..['@',Pred,Args],
%% 	xmlArgs(Args,Args1),!.

%% xmlPred(LP,elem(literal,features([negated-'no']),children([elem(predicate,children([elem(sym,features([varname-Pred]))]))|Args1]))):--
%% 	var(Pred),
%% 	new_name('@V',Pred),
%% 	P=..['@',Pred,Args],
%% 	xmlArgs(Args,Args1),!.

%% xmlPred(LP,elem(literal,features([negated-'no']),children([elem(predicate,children([elem(sym,features([varname-Pred]))]))|Args1]))):--
%% 	P=..['@',Pred,Args],
%% 	xmlArgs(Args,Args1),!.

xmlArgs([],[]):--!.

xmlArgs([H|T],[H1|T1]):--
	xmlArg(H,H1),
	xmlArgs(T,T1),!.

xmlArg(A,elem(arg,children([elem(sym,features([varname-A]))]))):--
var(A),
new_name('@V',A), !.

xmlArg(A,elem(arg,children([elem(sym,features([varname-A]))]))):-- !.



