:- module(xmg_table, []).
:- use_module(library(rbtrees)).

table_new(T) :- rb_new(T).
table_put(T1,K,V,T2) :- rb_insert(T1,K,V,T2).
table_get(T,K,V) :- rb_lookup(K,V,T).
table_get(T,K,V,D) :- (rb_lookup(K,V,T);V=D),!. % avec defaut D
table_delete(T1,K,T2) :- rb_delete(T1,K,T2).
table_entries(T,L) :- rb_visit(T,L).
