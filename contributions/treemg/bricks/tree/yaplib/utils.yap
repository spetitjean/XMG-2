%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2017  Denys Duchier

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

:- module(xmg_brick_tree_utils).
%% :- module(xmg_brick_tree_utils, [
%% 	      node_with_propq/2,
%% 	      node_with_featq/2,
%% 	      node_with_prop_or_featq/2,
%% 	      node_with_prop/2,
%% 	      node_with_feat/2,
%% 	      node_with_prop_or_feat/2
%% 	  ]).

:- use_module(library(lists), [member/2]).
:- xmg:import('xmg/utils').
%% :- xmg:import('xmg/utils', [memberq/2]).
xmg:import('xmg/brick/avm/avm').
%% :- xmg:import('xmg/brick/avm/avm', [avm/2]).


%==============================================================================
% these use == rather than = for testing if there is a certain prop/value or
% feat/value pair.  to be used when you want to check for a particular value
% without risking to instantiate a variable while doing so.
%==============================================================================

node_with_propq(FV, node(P,_,_)) :-
    xmg_brick_avm_avm:avm(P, PL),
    xmg_utils:memberq(FV, PL), !.

node_with_featq(FV, node(_, F, _)) :-
    xmg_brick_avm_avm:avm(F, FL),
    (xmg_utils:memberq(FV, FL);
     (member(top-TOP, FL),xmg_brick_avm_avm:avm(TOP, TL),xmg_utils:memberq(FV, TL));
     (member(bot-BOT, FL),xmg_brick_avm_avm:avm(BOT, BL),xmg_utils:memberq(FV, BL))),
    !.

node_with_prop_or_featq(FV, Node) :-
    xmg:send(info,'\nIn node_with_prop_or_featq'),
    (node_with_propq(FV, Node); node_with_featq(FV, Node)),
    !.


%==============================================================================
% these use unification to check for a certain prop or feat.  to be used when
% you want to unify with the value (e.g. to get it back). in that case, the
% value that you provide should be a free var.
%==============================================================================

node_with_prop(PV, node(P,_,_)) :-
    xmg_brick_avm_avm:avm(P, PL), member(PV, PL), !.

node_with_feat(FV, node(_,F,_)) :-
    xmg_brick_avm_avm:avm(F, FL),
    (member(FV, FL);
     (member(top-TOP, FL), xmg_brick_avm_avm:avm(TOP, TL), member(FV, TL));
     (member(bot-BOT, BL), xmg_brick_avm_avm:avm(BOT, BL), member(FV, BL))),
    !.

node_with_prop_or_feat(FV, Node) :-
    (node_with_prop(FV, Node) ; node_with_feat(FV, Node)),
    !.
