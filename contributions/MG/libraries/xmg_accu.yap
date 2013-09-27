%% file to be included in others
:- use_module(library(lists)).
:- use_module('xmg_logthreads').
:- use_module('table').

:- thread_method(  get(X),      Old, New, (X=Old,     Old=New) ).
:- thread_method(  set(X),      Old, New, (X=New             ) ).
:- thread_method(  inc   ,      Old, New, (New is Old+1      ) ).
:- thread_method(  dec   ,      Old, New, (New is Old-1      ) ).
:- thread_method(  incn(N), Old, New, (New is Old+N     ) ).
:- thread_method(  decn(N), Old, New, (New is Old-N     ) ).

:- thread_method( push(X),      Old, New, (New=[X|Old]       ) ).
:- thread_method(  pop(X),      Old, New, (Old=[X|New]       ) ).
:- thread_method( pops(L),      Old, New, (append(L,New,Old) ) ).
:- thread_method(  top(X),      Old, New, (Old=[X|_], Old=New) ).
:- thread_method(  reset,      Old, New, New=[] ).

:- thread_method(  enq(X),      Old, New, (Old=[X|New]       ) ).
:- thread_method(  enq_list(L), Old, New, (append(L,New,Old) ) ).
:- thread_method(  deq,         Old, New, (New=[_|Old]       ) ).
:- thread_method( getf(X),      Old, New, (Old=[X|_], New=Old) ).

:- thread_method(add_head(T), Old, New, ([T|Old]=New) ).
:- thread_method(add_queue(T), Old, New, (append(Old,[T],New))).

:- thread(  file, [enq, deq, getf] ).
:- thread(  line, [get, set, inc, dec, incn, decn]).
:- thread(   col, [get, set, inc, dec, incn, decn]).
:- thread( chars, [pop, pops] ).
:- thread(  toks, [pop, pops, top, enq, enq_list] ).
:- thread(   buf, [enq] ).
:- thread( queue, [enq] ).
%% name factory
:- thread(  name, [inc, get]).

:- thread( text, [add_head,add_queue,pop,get,reset]).

%% assoc tables
:- thread_method( tput(K,V), Old, New,  xmg_table:table_put(Old,K,V,New) ).
:- thread_method( tdel(K), Old, New,  xmg_table:table_delete(Old,K,New) ).
:- thread_method( tget(K,V), Old, New, (xmg_table:table_get(Old,K,V), New=Old) ).

% :- thread_method( tentries(L), Old, New, (xmg_table:table_entries(Old,L), New=Old) ).

:- thread( types  , [tput, tget], _ ).
:- thread( props  , [tput, tget], _ ).
:- thread( feats  , [tput, tget], _ ).
:- thread( externs, [tput, tget], _ ).
:- thread( dejavu , [tput, tget], _ ).
:- thread( consts , [tput, tget], _ ).
:- thread( abbrevs, [tput, tget], _ ).
:- thread( decls,   [tput, tget], _ ).
:- thread( gdecls,   [tput, tget], _ ).
:- thread( ldecls,   [tput, tget], _ ).
:- thread( exps,   [tput, tget], _ ).
:- thread( lexps,   [tput, tget], _ ).
:- thread( imps,   [tput, tget], _ ).
:- thread( limps,   [tput, tget], _ ).
:- thread( declImps,   [tput, tget], _ ).
:- thread( ldeclImps,   [tput, tget], _ ).

:- thread( macros,   [tput, tget], _ ).

:- thread(   nodes, [enq] ).
:- thread(   dominances, [enq] ).
:- thread(   precedences, [enq] ).
:- thread(   arities, [enq] ).
