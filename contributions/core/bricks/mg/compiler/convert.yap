:- module(xmg_brick_mg_convert, []).

:- edcg:thread(name,edcg:counter).

:- edcg:weave([name],[new_name/2]).

new_name(Prefixe, Name) :--
	name::incr,
	name::get(N),
	atomic_concat([Prefixe,N],Name).

listToXML([],[]).
listToXML([H|T], [H1|T1]) :-- toXML(H,H1), listToXML(T,T1).

toXML(entry(Trace,Dims), elem(entry, features([name-Name]),children([elem(family, data(Family)),elem(trace, children(Trace1))|Dims])),Number) :--
	xmlTrace(Trace,Trace1),!,
	Trace=[Family|_],!,
	atomic_concat([Family,'_',Number],Name),
	!.

xmlTrace([A],[elem(class, data(A))]) :-- !.
xmlTrace([H|T],[H1|T1]):--
	xmlTrace([H],[H1]),!, xmlTrace(T,T1),!.
