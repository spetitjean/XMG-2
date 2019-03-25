%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2019  Simon Petitjean

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

:- module(xmg_brick_morphlp_engine,[]).
:- xmg:edcg.
:- edcg:thread(cname,edcg:counter).

:- edcg:weave( [cname],
		 [gensym/1]).

gensym(Name) :--
	cname::incr,
	cname::get(N),
	atomic_concat(['XMGC',N],Name).

ifield(X,N) :-
        xmg:send(info,'In ifield'),
	xmg_brick_avm_avm:avm(F,[]),
	xmg:send(info,X),
	xmg:send(info,N),
	X = field(N,F),
        xmg:send(info,'\nFinished'),
	!. 


ifieldfeats(X,F) :-
    xmg:send(info,'In ifieldfeats'),
	X=field(_,F),!.





