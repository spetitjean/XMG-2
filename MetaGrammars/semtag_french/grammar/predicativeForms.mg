% predicate trees for light verb constructions based on N, A or PP
% copulaI is the index on the copula node that will be bound by the copula semantics jan(x) devenir(x) grand(x)

class predicativeForm
import
	TopLevelClass[]
export
   xVN xHead
declare
	?xVN ?xCop ?xHead ?fX ?fZ ?fU ?fW ?A  ?fT ?fMode ?fSecant 
{
  <syn>{
	node xS(color=black)[cat = s,bot=[mode = ?fX]]{
		node xVN(color=black)[cat = vp,top=[mode = ?fX],bot=[mode = ?fMode,gen = ?fU,num = ?fZ,pers=?fW]]{
	        	node xCop(color=black,mark=subst)[cat = v,top=[tense=?fT,mode=?fMode,aspect=?fSecant,cop = + ,pers=?fW,num=?fZ]]
			node xHead(color=black)[cat = @{v,adj,n,pp},top=[gen=?fU,num=?fZ]]}}}*=[tense=?fT,mode=?fMode,aspect=?fSecant] }
% Adjectival predicate 
% s(vn(v[vsup = +] <adj>))
% etre apte

class ** adjectivalPredicate
import 
	predicativeForm[]
	anchorProj2[]
	VerbSem[]
{
	<syn>{	node xHead(mark=anchor)};
	xHead = xAnchor;
	xHead = xVerbSem 
}


class ** participialPredicativeform
import 
	adjectivalPredicate[]
{
	<syn>{	node xHead[cat = v,top=[mode=@{ppart,ppst}]]}}

class ** AdjectivalPredicativeform
import 
	adjectivalPredicate[]
{
	<syn>{	node xHead[cat = adj]}}



% Nominal predicate
% s(vn(v[vsup = +] n(det,<n>)) )
% pousser un cri
%% unchecked (06/12/05)

class ** NominalPredicativeform
import
	anchorProj2[]
	predicativeForm[]
	VerbSem[]
%declare
%	?xHead 
{
	<syn>{	node xHead(mark=anchor)[cat = n]};
	xHead = xAnchor;
	xHead = xVerbSem 
}

% Prepositional predicate

% s(vn(v[vsup = +] pp(prep <n>)))
% eprouver de l'etonnement
%% unchecked (06/12/05)

class ** PrepositionalPredicativeformWithNP
import	 
	 anchorProj3[]
	 predicativeForm[]
	VerbSem[]
declare
	?xPrep ?xPrepLex %?xN 
{
	<syn>{	node xHead[cat = pp]{
			node xPrep(color=black)[cat = p]{
			     node xPrepLex(color=black,name = vppPrep,mark=flex)}
	                     node xN(color=black,mark=anchor)[cat = n]	}};
	xN = xAnchor;
	xN = xVerbSem 
}

class ** PrepositionalPredicativeformWithAdj
import
	anchorProj3[]
	predicativeForm[]
	VerbSem[]
declare
	?xPrep ?xPrep2 ?xAdj
{
  <syn>{node xHead[cat = pp]{
		node xPrep(color=black)[cat=p]{
		     node xPrep2(color=black,name = vppPrep,mark=flex)}
                     node xAdj(color=black,mark=anchor)[cat = adj]
			}};
	xAdj = xAnchor;
	xAdj = xVerbSem 
}

class  PrepositionalPredicativeform{
	 PrepositionalPredicativeformWithAdj[] 
	|  PrepositionalPredicativeformWithNP[]}

	
