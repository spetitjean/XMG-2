%==============================================================================
% VARIABLE ASSIGNMENT FORMULA
%
% F ::= var(X)=V | var(X)==var(Y)
%     | and(F,F) |  or(F,F) | not(F)
%     |  if(F,F) | iff(F,F) | xor(F,F)
%
% xmg_xsat:eval(F,M)
%     enumerates (through backtracking) the structural models M of F.
%==============================================================================

:- module(xmg_xsat).

:- use_module(library(rbtrees)).
:- use_module(library(lists)).
:- use_module(library(ordsets)).

rename_vars(F1,F2,DecodingRecord) :-
    rb_new(T1), rename_vars(F1,F2,T1,T2,1,_),
    rb_visit(T2,KeyVals),
    exchange_keyvals(KeyVals,ValKeys),
    sort(ValKeys,ValKeysSorted),
    just_seconds(ValKeysSorted,Keys),
    DecodingRecord =.. [recoding|Keys].

rename_var(X,Y,T1,T2,I1,I2) :-
    rb_lookup(X,Y,T1) -> (T2=T1,I2=I1)
    ; (Y=var(I1), rb_insert(T1,X,Y,T2), I2 is I1+1).

rename_vars(var(X)=V,Y=V,T1,T2,I1,I2) :-
    rename_var(var(X),Y,T1,T2,I1,I2).
rename_vars(var(X)==var(Y),G1==G2,T1,T2,I1,I2) :-
    rename_var(var(X),G1,T1,T,I1,I),
    rename_var(var(Y),G2,T,T2,I,I2).
rename_vars(and(F1,F2),and(G1,G2),T1,T2,I1,I2) :-
    rename_vars(F1,G1,T1,T,I1,I),
    rename_vars(F2,G2,T,T2,I,I2).
rename_vars(or(F1,F2),or(G1,G2),T1,T2,I1,I2) :-
    rename_vars(F1,G1,T1,T,I1,I),
    rename_vars(F2,G2,T,T2,I,I2).
rename_vars(not(F),not(G),T1,T2,I1,I2) :-
    rename_vars(F,G,T1,T2,I1,I2).
rename_vars(if(F1,F2),if(G1,G2),T1,T2,I1,I2) :-
    rename_vars(F1,G1,T1,T,I1,I),
    rename_vars(F2,G2,T,T2,I,I2).
rename_vars(iff(F1,F2),iff(G1,G2),T1,T2,I1,I2) :-
    rename_vars(F1,G1,T1,T,I1,I),
    rename_vars(F2,G2,T,T2,I,I2).
rename_vars(xor(F1,F2),xor(G1,G2),T1,T2,I1,I2) :-
    rename_vars(F1,G1,T1,T,I1,I),
    rename_vars(F2,G2,T,T2,I,I2).

exchange_keyvals([],[]).
exchange_keyvals([K-V|L1],[V-K|L2]) :- exchange_keyvals(L1,L2).

just_seconds([],[]).
just_seconds([F-S|L1],[S|L2]) :- just_seconds(L1,L2).

%==============================================================================
% R=recoding(X1,...,Xn)
%     Xi is the var(Ti) term representing a user variable.  Xi is coded var(i)
%     in the solver.  R makes it easy to convert var(i) back into var(Ti) when
%     we return a solved form.
%
% E=env(E1,...,En)
%     Ei is the term to which var(i) is currently bound
%
% A=avoid(A1,...,An)
%     Ai is a mutable variable containing the current ordered list of values
%     that var(i) must be distinct from
%
% D=diff(D1,...Dn)
%     Di is a mutable variable containing the current ordered list of var(j)
%     that var(i) must be distinct from
%==============================================================================

eval(F,M) :-
    rename_vars(F,G,R),
    functor(R,_,N),
    functor(E,env,N),
    functor(A,avoid,N),
    create_mutables(A,N),
    functor(D,diff,N),
    create_mutables(D,N),
    peval(G,E,A,D),
    extract_solved_form(R,E,A,D,1,N,[],M).

create_mutables(R,I) :-
    arg(I,R,M),
    create_mutable([],M),
    (I=1 -> true ; J is I-1, create_mutables(R,J)).

peval(var(I)=V,E,A,D) :-
    arg(I,E,EV), EV=V,
    arg(I,A,AV), get_mutable(AL,AV), \+ ord_member(V,AL).
peval(var(I)==var(J),E,A,D) :-
    arg(I,E,EI), arg(J,E,EJ),
    (EI == EJ -> true
     ; EI=EJ,
       arg(I,D,DI), get_mutable(DIL,DI),
       \+ ord_member(var(J),DIL),
       arg(I,A,AI), get_mutable(AIL,AI), \+ ord_member(EI, AIL),
       arg(J,A,AJ), get_mutable(AJL,AJ), \+ ord_member(EJ, AJL),
       ord_union(AIL,AJL,AL), update_mutable(AL,AI), setarg(J,A,AI),
       arg(J,D,DJ), get_mutable(DJL,DJ),
       ord_union(DIL,DJL,DL), update_mutable(DL,DI), setarg(J,D,DI)).
peval(and(F1,F2),E,A,D) :- peval(F1,E,A,D), peval(F2,E,A,D).
peval(or(F1,F2),E,A,D) :- peval(F1,E,A,D); peval(F2,E,A,D).
peval(not(F),E,A,D) :- neval(F,E,A,D).
peval(if(F1,F2),E,A,D) :- peval(or(not(F1),F2),E,A,D).
peval(iff(F1,F2),E,A,D) :- peval(and(if(F1,F2),if(F2,F1)),E,A,D).
peval(xor(F1,F2),E,A,D) :- peval(or(and(F1,not(F2)),and(not(F1),F2)),E,A,D).

neval(var(I)=V,E,A,D) :-
    arg(I,E,EI),
    (\+ EI=V -> true
     ; arg(I,A,AI), get_mutable(AL,AI),
       (\+ ord_member(V,AL)
	-> ord_insert(AL,V,AL2), update_mutable(AL2,AI)
	; true)).
neval(var(I)==var(J),E,A,D) :-
    arg(I,E,EI), arg(J,E,EJ), EI \== EJ,
    (\+ EI=EJ -> true
     ; arg(I,D,DI), get_mutable(DIL,DI),
       (\+ ord_member(var(J),DIL)
	-> ord_insert(DIL,var(J),DIL2),
	   update_mutable(DIL2,DI)
	; true),
       arg(J,D,DJ), get_mutable(DJL,DJ),
       (\+ ord_member(var(I),DJL)
	-> ord_insert(DJL,var(I),DJL2),
	   update_mutable(DJL2,DJ)
	; true)).
neval(and(F1,F2),E,A,D) :- neval(F1,E,A,D); neval(F2,E,A,D).
neval(or(F1,F2),E,A,D) :- neval(F1,E,A,D), neval(F2,E,A,D).
neval(not(F),E,A,D) :- peval(F,E,A,D).
neval(if(F1,F2),E,A,D) :- neval(or(not(F1),F2),E,A,D).
neval(iff(F1,F2),E,A,D) :- neval(and(if(F1,F2),if(F2,F1)),E,A,D).
neval(xor(F1,F2),E,A,D) :- neval(or(and(F1,not(F2)),and(not(F1),F2)),E,A,D).

extract_solved_form(R,E,A,D,I,N,LI,LO) :-
    I>N -> LI=LO
    ; arg(I,E,EI),
      (EI='_coref_'(I)
       %% if we succeed, then the variable was unbound
       -> arg(I,A,AI), get_mutable(AIL,AI),
	  arg(I,D,DI), get_mutable(DIL,DI),
	  extract_solved_form_unbound(R,AIL,DIL,I,LI,LM)
       ; (EI='_coref_'(J)
	  %% if we succeed, then the variable was equated to
	  %% another (unbound) variable (of index J). we need
	  %% to extract the equality constraint. other constraints
	  %% were already extracted we processed var(J) earlier.
	  -> extract_solved_form_coref(R,I,J,LI,LM)
	  %% otherwise, the variable is bound to a value
	  ;  extract_solved_form_bound(R,EI,I,LI,LM))),
      I2 is I+1,
      extract_solved_form(R,E,A,D,I2,N,LM,LO).

extract_solved_form_unbound(R,AIL,DIL,I,LI,LO) :-
    arg(I,R,X),
    extract_avoid(AIL,X,LI,LM),
    extract_diff(DIL,X,I,R,LM,LO).

extract_avoid([],_,L,L).
extract_avoid([H|T],X,LI,LO) :-
    ord_insert(LI,not(X=H),LM),
    extract_avoid(T,X,LM,LO).

extract_diff([],_,_,_,L,L).
extract_diff([var(J)|T],X,I,R,LI,LO) :-
    arg(J,R,Y),
    (I<J -> G=(X==Y); G=(Y==X)),
    ord_insert(LI,not(G),LM),
    extract_diff(T,X,I,R,LM,LO).

extract_solved_form_coref(R,I,J,LI,LO) :-
    arg(I,R,X),
    arg(J,R,Y),
    (I<J -> G=(X==Y) ; G=(Y==X)),
    ord_insert(LI,G,LO).

extract_solved_form_bound(R,EI,I,LI,LO) :-
    arg(I,R,X),
    ord_insert(LI,(X=EI),LO).
