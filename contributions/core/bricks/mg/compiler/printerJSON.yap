%% ========================================================================
%% Copyright (C) 2016  Daniel Laps

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

%% -*- prolog -*-

:- module(xmg_brick_mg_printerJSON).

xmg:printJSON(H, I) :-
  H=elem(_, features(Y)),
  printIndent(I),
  print('{\n'),
  J = I+1,
  printFeatures(Y, J),
  print('\n'),
  printIndent(I),
  print('}\n'),!.
xmg:printJSON(H, I) :-
  H=elem(_, children(Y)),
  printIndent(I),
  print('{\n'),
  J = I+1,
  printChildren(Y, J),
  print('\n'),
  printIndent(I),
  print('}\n'),!.
xmg:printJSON(H, I) :-
  H=elem(_, features(Y), children(Z)),
  printIndent(I),
  print('{\n'),
  J = I+1,
  printFeatures(Y, J),
  print(',\n'),
  printChildren(Z, J),
  print('\n'),
  printIndent(I),
  print('}\n'),!.
xmg:printJSON(H, I) :-
  printIndent(I),
  print('{\n'),
  printElem(H, I),
  print('\n'),
  printIndent(I),
  print('}\n'),!.

printIndent(0) :-!.
printIndent(I) :-
	print('  '),
  J is I-1,
  printIndent(J),!.

printElem(H, I) :-
  H=elem(X),
	printIndent(I),
	print('"'),
	print(X),
	print('": null'),!.

printElem(H, I) :-
  H=elem(X, features(Y)),
  printIndent(I),
  print('"'),
  print(X),
  print('": {\n'),
  J is I+1,
  printFeatures(Y, J),
  print('\n'),
  printIndent(I),
  print('}'),!.

printElem(H, I) :-
  	H=elem(X, children(Y)),
  	printIndent(I),
  	print('"'),
  	print(X),
  	print('": {\n'),
  	J is I+1,
  	printChildren(Y, J),
  	print('\n'),
    printIndent(I),
  	print('}'),!.

printElem(H, I) :-
  	H=elem(X, data(Y)),
  	printIndent(I),
  	print('"'),
  	print(X),
  	print('": "'),
  	printData(Y),
  	print('"'),!.

printElem(H, I) :-
  H=elem(X, features(Y), children(Z)),
  printIndent(I),
  print('"'),
  print(X),
  print('": {\n'),
  J is I+1,
  printFeatures(Y, J),
  print(',\n'),
  printChildren(Z, J),
  print('\n'),
  printIndent(I),
  print('}'),!.

printFeatures([], _):-!.
printFeatures([H1-H2], I) :-
  printIndent(I),
  print('"'),
  print(H1),
  print('": "'),
  print(H2),
  print('"'),!.
printFeatures([H1-H2|T], I) :-
  printIndent(I),
  print('"'),
  print(H1),
  print('": "'),
  print(H2),
  print('",\n'),
  printFeatures(T, I),!.

printChildren([],_):-!.
printChildren([H], I) :-
	printElem(H, I),!.
printChildren([H|T], I) :-
	printElem(H, I),
  print(',\n'),
  printChildren(T,I),!.
