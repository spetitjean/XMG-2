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


:-module(xmg_brick_frame_generator).
:- xmg:edcg.

:-use_module('xmg/brick/frame/engine').

:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:name).
:-edcg:using(xmg_brick_mg_generator:code).

:-edcg:weave([decls,name], [new_name/2,var_Stmt/2,var_or_const/2,generate_Stmt/4]).

xmg:generate_instr((v(TFrame),frame:topframe,Frame)):--
	decls::tget(TFrame,VFrame),
	Enq=..['::',xmg_acc:Frame,put(VFrame)],
	%%xmg:send(info,Enq),
	code::enq(Enq),
	!.

xmg:generate_instr((v(TFrame),frame:frame,c(Type))):--
	decls::tget(TFrame,VFrame),	
	code::enq(xmg_brick_havm_havm:h_avm(VFrame,Type,[])),
	!.
%% When using type variables
xmg:generate_instr((v(TFrame),frame:frame,v(Type))):--
	decls::tget(TFrame,VFrame),
        decls::tget(Type,VType),
        code::enq(xmg_brick_havm_havm:h_avm(VFrame,VType,[])),
	!.

xmg:generate_instr((v(TFrame),frame:pair,c(Left)-v(Right))):--
	decls::tget(TFrame,VFrame),
	decls::tget(Right,VRight),
	code::enq(xmg_brick_havm_havm:h_avm(VFrame,_,[Left-VRight])),
	!.

xmg:generate_instr((frame:dom(v(N1),Op,v(N2)),Frame)):--

	decls::tget(N1,V1),
	decls::tget(N2,V2),
	AccDom=..['::',xmg_acc:Frame,put(dom(V1,Op,V2))],
	code::enq(AccDom),	
	!.


%% some older try:

xmg:generate_instr((TN,frame:node,Frame)):--
	%% xmg:send(info,'\nHere is a nodevar:\n'),
	%% xmg:send(info,TN),
	decls::tget(TN,TV),
	%%xmg:send(info,TV),
	code::enq(xmg_brick_frame_engine:inode(TV,id(TN,_))),
	Put=..[put,TV],
	Acc=Frame,
	AccNode=..['::',xmg_acc:Acc,Put],
	code::enq(AccNode),
	!.
xmg:generate_instr((N,frame:props(P))):--
	decls::tget(N,VN),
	decls::tget(P,VP),
	code::enq(xmg_brick_frame_engine:inodeprops(VN,VP)),
	!.
xmg:generate_instr((N,frame:feats(F))):--
	decls::tget(N,VN),
	decls::tget(F,VF),
	code::enq(xmg_brick_frame_engine:inodefeats(VN,VF)),
	!.
xmg:generate_instr((frame:edge(Props,N1,N2),Frame)):--

	decls::tget(N1,V1),
	decls::tget(N2,V2),
	Put=..[put,edge(Props,V1,V2)],
	Acc=Frame,
	AccDom=..['::',xmg_acc:Acc,Put],
	code::enq(AccDom),	
	!.













