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

:- module(xmg_brick_polAvm_convert).


xmg_brick_avm_convert:xmlFeat(A-value(V,P),elem(f,features(Features1),children(Children))):--
	xmg_brick_avm_convert:xmlFeat(A-V,elem(f,features(Features),children(Children))),
	xmg_brick_polAvm_polarity:polarity(P,Pol),
	convertPolarity(Pol,CPol),
	lists:append(Features,[pol-CPol],Features1),
	!.

convertPolarity('=','0'):- !.
convertPolarity('=-','~1'):- !.
convertPolarity('=~','0v'):- !.
convertPolarity('=+','1'):- !.

