%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2014  Simon Petitjean

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


:-module(xmg_brick_syn_edcg).

%% À générer dans un fichier du compiler
%% :-edcg:thread(xmg_acc:nom_dim, xmg_brick_syn_edcg:accu_type).

:-edcg:class_alias(accu_type, edcg:stack).