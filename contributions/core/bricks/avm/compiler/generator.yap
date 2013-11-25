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


:-module(xmg_brick_avm_generator).

:-edcg:using(xmg_brick_mg_generator:decls).
:-edcg:using(xmg_brick_mg_generator:name).
:-edcg:using(xmg_brick_mg_generator:code).

:-edcg:weave([decls,name], [new_name/2,var_or_const/2,generate/5]).

xmg:generate_instr((Target,avm:avm)) :--
	decls::tget(Target,Var),
    code::enq(xmg_brick_avm_avm:avm(Var,[])),
    !.
xmg:generate_instr((Target,avm:feat(F,Target2))):--
	decls::tget(Target,Var),
    code::enq(xmg_brick_avm_avm:avm(Var,[F-Target2])),	
    !.

%% new_name(Name,Prefix):--
%% 	name::incr,
%% 	name::get(Get),
%% 	atomic_concat([Prefix,Get],Name),!.
%% 
%% generate(avm,[],[],[],C):--!.
%% generate(avm,[ID1-adisj(AD)|Feats],[TID1-const(ADisj,_)|TFeats],[ADP|TOut],C):--!,
%% 	%%var_or_const(ID1,feat(TID1)),
%% 	get_feat(ID1,TID1),
%% 	generate(adisj,AD,TAD),
%% 	ADP=xmg_adisj:adisj(ADisj,TAD),
%% 	generate(avm,Feats,TFeats,TOut,C).
%% generate(avm,[ID1-avm(AVM)|Feats],[TID1-NAVM|TFeats],[AVMP|TOut],C):--!,
%% 	%%var_or_const(ID1,feat(TID1)),
%% 	get_feat(ID1,TID1),
%% 
%% 	%%xmg_brick_mg_compiler:send(debug,AVM),
%% 	generate(avm,AVM,TAVM,Out,C),
%% 	AVMP=xmg_brick_avm_avm:avm(NAVM,TAVM),
%% 	generate(avm,Feats,TFeats,TOut,C).
%% generate(avm,[ID1-ID2|Feats],[TID1-TID2|TFeats],TOut,C):--
%% 	%%var_or_const(ID1,feat(TID1)),
%% 	get_feat(ID1,TID1),
%% 
%% 	var_or_const(ID2,TID2),
%% 	check_type(TID1,TID2,TID3),
%% 	generate(avm,Feats,TFeats,TOut,C).
%% generate(avm,[ID1-default|Feats],[TID1-const(default,_)|TFeats],TOut,C):--
%% 	%%var_or_const(ID1,feat(TID1)),
%% 	get_feat(ID1,TID1),
%% 	generate(avm,Feats,TFeats,TOut,C).
%% 
%% generate(h_avm,[],[],[],C):--!.
%% generate(h_avm,[ID1-adisj(AD)|Feats],[TID1-const(ADisj,_)|TFeats],[ADP|TOut],C):--
%% 	%%var_or_const(ID1,feat(TID1)),
%% 	get_feat(ID1,TID1),
%% 	generate(adisj,AD,TAD),
%% 	ADP=xmg_adisj:adisj(ADisj,TAD),
%% 	generate(h_avm,Feats,TFeats,TOut,C).
%% generate(h_avm,[ID1-avm(AVM)|Feats],[TID1-NAVM|TFeats],[AVMP|TOut],C):--
%% 	%%var_or_const(ID1,feat(TID1)),
%% 	%%xmg_brick_mg_compiler:send(debug,AVM),
%% 	get_feat(ID1,TID1),
%% 	generate(h_avm,AVM,TAVM,Out,C),
%% 	AVMP=xmg_h_avm:h_avm(NAVM,TAVM),
%% 	generate(h_avm,Feats,TFeats,TOut,C).
%% generate(h_avm,[ID1-ID2|Feats],[TID1-TID3|TFeats],TOut,C):--
%% 	%%var_or_const(ID1,feat(TID1)),
%% 	get_feat(ID1,TID1),
%% 	var_or_const(ID2,TID2),
%% 	check_type(TID1,TID2,TID3),
%% 	generate(h_avm,Feats,TFeats,TOut,C).
%% 
%% 
%% generate(adisj,[],[]):- !.
%% generate(adisj,[id(ID,_)|AD],[ID|AD1]):-
%% 	generate(adisj,AD,AD1),!.
%% generate(adisj,[int(ID,_)|AD],[ID|AD1]):-
%% 	generate(adisj,AD,AD1),!.
%% generate(adisj,[bool(ID,_)|AD],[ID|AD1]):-
%% 	generate(adisj,AD,AD1),!.
%% 
%% get_feat(id(A,C),A):-
%% 	xmg_brick_mg_typer:feat(A,_),!.
%% get_feat(id(A,C),A):-
%% 	xmg_brick_mg_typer:property(A,_),!.
%% get_feat(id(A,C),A):-
%% 		xmg_brick_mg_compiler:send(info,'Warning : feat '),xmg_brick_mg_compiler:send(info,A),xmg_brick_mg_compiler:send(info,' was not declared '),xmg_brick_mg_compiler:send(info,C),xmg_brick_mg_compiler:send_nl(info),!.
%% 
%% 
%% var_or_const(Var,var(NVar)):--
%% 	var(Var),!,
%% 	new_name(Name,'xmgnode'),
%% 	Var=id(Name,no_coord),
%% 	decls::tput(Name,NVar),!.
%% 
%% var_or_const(id(A,C),Var):--
%% 	%%xmg_brick_mg_compiler:send(info,List),
%% 	decls::tget(A,Var),!.
%% %% var_or_const(id(A,C),feat(A)):--
%% %% 	xmg_brick_mg_typer:feat(A,_),!.
%% %% var_or_const(id(A,C),feat(A)):--
%% %% 	xmg_brick_mg_typer:property(A,_),!.
%% 
%% var_or_const(id(A,C),A):--
%% 	xmg_brick_mg_typer:field(A,_),!.
%% var_or_const(id(A,C),const(A,T)):--
%% 	xmg_brick_mg_typer:type(T,TD),
%% 	lists:member(id(A,_),TD),!.
%% var_or_const(bool(A,C),const(A,bool)):--!.
%% var_or_const(int(A,C),const(A,int)):--!.
%% var_or_const(id(A,C),const(A,unknown)):--
%% 	xmg_brick_mg_compiler:send(info,'Warning : '),xmg_brick_mg_compiler:send(info,A),xmg_brick_mg_compiler:send(info,' was not declared '),xmg_brick_mg_compiler:send(info,C),xmg_brick_mg_compiler:send_nl(info).
%% var_or_const(id(A,C),A):--
%% 	xmg_brick_mg_compiler:send(info,'Warning : '),xmg_brick_mg_compiler:send(info,A),xmg_brick_mg_compiler:send(info,' was not declared '),xmg_brick_mg_compiler:send(info,C),xmg_brick_mg_compiler:send_nl(info).
%% %% var_or_const(id(A,C),feat(A)):--
%% %% 		xmg_brick_mg_compiler:send(info,'Warning : feat '),xmg_brick_mg_compiler:send(info,A),xmg_brick_mg_compiler:send(info,' was not declared '),xmg_brick_mg_compiler:send(info,C),xmg_brick_mg_compiler:send_nl(info),!.
%% 
%% 
%% 
%% var_or_const(string(A,C),const(A,string)):-- !.
%% 
%% %% should be in another file
%% check_type(Attr,A,A):-
%% 	var(A),!.
%% check_type(Attr,const(C,_),const(C,label)):-
%% 	xmg_brick_mg_typer:type(Attr,label),!.
%% check_type(Attr,const(C,Type),const(C,Type)):-
%% 	xmg_brick_mg_typer:feat(Attr,Type),!.
%% check_type(Attr,const(C,Type),const(C,Type)):-
%% 	xmg_brick_mg_typer:property(Attr,Type),!.
%% check_type(Attr,Val,const(C,_)):-
%% 	Val=const(C,_),
%% 	xmg_brick_mg_compiler:send(info,'Warning : '),xmg_brick_mg_compiler:send(info,Attr),xmg_brick_mg_compiler:send(info,' and '),xmg_brick_mg_compiler:send(info,Val),xmg_brick_mg_compiler:send(info,' do not share the same type'),xmg_brick_mg_compiler:send_nl(info).
%% check_type(Attr,Val,sconst(_,_)):- !.
%% check_type(Attr,Val,const(C,_)):-
%% 	xmg_brick_mg_compiler:send(info,Val),false.
