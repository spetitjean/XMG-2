%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2015  Simon Petitjean

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

:-module(xmg_brick_iface_compiler).

xmg:eval(iface,_,I, elem(interface, children([elem(fs, children(XML))])),_):-
	%%xmg:send(info,'\n Here comes the interface'),
	xmg_brick_avm_avm:avm(I,IAVM),
	%%xmg:send(info,IAVM),
	%%xmg_brick_avm_convert:xmlFeats(IAVM,XML,1,_).
    	xmg:do_xml_convert(avm:avm(IAVM),XML)
	%%xmg:send(info,'\nDone')
	.
	%%xmg:send(info,'\nDone').
xmg:eval(iface,_,[], elem(interface, children([])),_).

