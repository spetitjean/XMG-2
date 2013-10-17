:- module(xmg_bricks_tag_tag, []).

:- use_module(library(gecode)).
:- use_module('xmg/brick/tree/compiler/dominance').


:- op(500, xfx, ':=:').


post_tags(Space,NodeList,TagOps):-

	tagposts(Space,NodeList,TagOps),
	!.

tagposts(_,[],[]):- !.

tagposts(Space,[Node|T],[tagop(none)|TC]):-
	tagposts(Space,T,TC),!.

tagposts(Space,[Node|T],[tagop(_)|TC]):-
	NDown :=: down(Node),
	Space += cardinality(NDown,0,0),
	tagposts(Space,T,TC),!.