%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% adjectives.mg
%%%%%%%%%%%%%%%%%%%%%%%%%%
% light verb construction with adjectives
% epithets
%dummies

class adjective
import dummy[]
       adjectiveProperty[]
declare ?L  ?S
{
<syn>{
	node xDummy[cat=adj,top=[index=?X,label=?L]]}*=[label0=L,arg0=X]}

class ** Epith[]
import
	adjectiveProperty[]
	footProj1[]
	modifierSem[]
	modifierArg0Linking[]
%	EpithOrCanSubj[]
export	
	 ?xHead ?xFoot
declare
	 ?xHead ?xFoot ?fT ?fU ?fW ?fX ?fY ?fZ ?fG ?fK ?fI ?fM ?fST %?X 
{
	<syn>{
		node xR(color=black)[cat = n,bot=[mass=?fM,idx=?fI,det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar = 1,neg-adv = ?fG,neg-nom = ?fK,semtype=?fST]]{
			node xHead(color=red,mark=anchor)[cat = adj,top=[num = ?fY,gen = ?fZ]]};
		node xR{
			node xFoot(color=black,mark=foot)[cat = n,top=[semtype=?fST,mass=?fM,idx=?fI,neg-adv = ?fG,neg-nom = ?fK,det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar = @{0,1}],bot=[det = - ]]
		}
	}
	;
        xFoot = xSemFoot;
 	xFoot = xModifier
}

class ** EpithAnte[]
import
	Epith[]
{
	<syn>{
		node xR{
		     node xHead
		     node xFoot
		     }}}

class ** EpithPost[]
import
	Epith[]
{
	<syn>{
		node xR{
		     node xFoot
		     node xHead
		     }}}



% %%%%%%%%%%%%%%%%%%%%%%%%%%
% %  adjectives classes
% %%%%%%%%%%%%%%%%%%%%%%%%%%
% %Jean est joyeux; un joyeux depart

class  n0vAPost[]
{
        n0vAPredicative[]
     	|EpithPost[]			
	|dummyAdjective[]
}
class  n0vAAnte[]
{
        n0vAPredicative[]
     	|EpithAnte[]			
	|dummyAdjective[]
}
class  n0vAPredicative[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      RealisedSubject[]
%declare %?xS
{
 	<syn>{	node xS[top=[mass = - ]]}; xS = xSubject; 
	unaryRelBase[];
        AdjectivalPredicativeform[]
}
class  n0vParticipialPredicative[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      RealisedSubject[]
%declare %?xS
{
 	<syn>{	node xS[top=[mass = - ]]}; xS = xSubject; 
	unaryRelBase[];
        participialPredicativeform[]
}
class  n0vAcs1[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      RealisedSubject[]
%declare %?xS
{
 	<syn>{	node xS[top=[mass = - ]]}; xS = xSubject; 
	binaryRelBase[];
        AdjectivalPredicativeform[];
 	CanonicalSententialObjectFinite[]
}
class s0vA[]
{
	s0vAPredicative[]
	|Epith[]			
	|dummyAdjective[]
}

class s0vAPredicative[]
import
      SententialSubjectArg1Linking[]
      VerbArg0Linking[]
{	
	unaryState[];
	SententialSubject[]; 
	AdjectivalPredicativeform[]
}
% %% binary adjectives

%jaloux de jean
class n0vAden1[]
{     n0vAden1Predicative[]
      |n0vAden1EpithPost[]
      |dummyAdjective[]
}
class n0vAden1Predicative[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      GenitiveArg2Linking[]
{	binaryState[];
	Subject[];
	AdjectivalPredicativeform[];
	Genitive[]
}
class n0vAden1EpithPost[]
import
      VerbArg0Linking[]
      GenitiveArg2Linking[]
{	binaryState[];
	EpithPost[];
	CanonicalGenitive[]
}

%attentif a jean
class n0vAan1[]
{
	n0vAan1Predicative[]
      	|n0vAan1EpithPost[]
      	|dummyAdjective[]
}
class n0vAan1Predicative[]
import
	SubjectArg1Linking[]
      	VerbArg0Linking[]
	IobjectArg2Linking[]
{	binaryState[];
	Subject[];
	AdjectivalPredicativeform[];
	Iobject[]
}
class n0vAan1EpithPost[]
import
      	VerbArg0Linking[]
	IobjectArg2Linking[]
{	binaryState[];
	EpithPost[];
	CanonicalIobject[]
}

%un enfant affectueux avec Jean; Jean est affectueux avec Marie
class n0vApn1[]
{	n0vApn1Predicative[]
	|n0vApn1EpithPost[]
	|dummyAdjective[]
}
class n0vApn1Predicative[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      ObliqueArg2Linking[]
{	binaryState[]; Subject[]; AdjectivalPredicativeform[];Oblique[]
}
class n0vApn1EpithPost[]
import
      VerbArg0Linking[]
      ObliqueArg2Linking[]
{	binaryState[];EpithPost[];CanonicalOblique[]}

%un enfant capable de partir; Jean est capable de partir
class n0vAdes1[]
{	n0vAdes1Predicative[]
	|n0vAdes1EpithPost[]
	|dummyAdjective[]
}
class n0vAdes1Predicative[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      SententialDeObjectArg2Linking[]
{     binaryState[];Subject[];AdjectivalPredicativeform[];SententialDeObject[]}

class n0vAdes1EpithPost[]
import
      VerbArg0Linking[]
      SententialDeObjectArg2Linking[]
{	binaryState[];Subject[];AdjectivalPredicativeform[];SententialDeObject[]}

% ternary adjectives
% un enfant superieur a Luc en Maths
class n0vAan1pn2[]
{	dummyAdjective[]|n0vAan1pn2Predicative[]|n0vAan1pn2EpithPost[]
}
class n0vAan1pn2Predicative[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      IobjectArg2Linking[]
      ObliqueArg3Linking[]
declare
       ?Prep
{	ternaryState[];{Subject[];AdjectivalPredicativeform[];Iobject[];Oblique[]*=[prep = ?Prep]}%*=[prep2 = ?Prep]
}
class n0vAan1pn2EpithPost[]
import
      VerbArg0Linking[]
      IobjectArg2Linking[]
      ObliqueArg3Linking[]
declare
       ?Prep
{	ternaryState[];{EpithPost[];CanonicalIobject[];CanonicalOblique[]*=[prep = ?Prep]}%*=[prep2 = ?Prep]
}

class n0vAan1den2[]
{	
	n0vAan1den2Predicative[]
	|n0vAan1den2EpithPost[]
	|dummyAdjective[]
}

class n0vAan1den2Predicative[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      IobjectArg2Linking[]
      GenitiveArg3Linking[]
{	ternaryState[];Subject[];AdjectivalPredicativeform[];Iobject[];Genitive[]}

class n0vAan1den2EpithPost[]
import
      VerbArg0Linking[]
      IobjectArg2Linking[]
      GenitiveArg3Linking[]
{	ternaryState[];EpithPost[];CanonicalIobject[];CanonicalGenitive[]}

class n0vAdes1pn2[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      IobjectArg2Linking[]
      ObliqueArg3Linking[]
declare 
	?Prep
{	n0vAdes1pn2Predicative[]
	|n0vAdes1pn2EpithPost[]
	|dummyAdjective[]
}

class n0vAdes1pn2Predicative[]
import
      SubjectArg1Linking[]
      VerbArg0Linking[]
      IobjectArg2Linking[]
      ObliqueArg3Linking[]
declare 
	?Prep
{	ternaryState[];Subject[];AdjectivalPredicativeform[];SententialDeObject[];Oblique[]*=[prep = ?Prep]
}


class n0vAdes1pn2EpithPost[]
import
      VerbArg0Linking[]
      IobjectArg2Linking[]
      ObliqueArg3Linking[]
declare 
	?Prep
{	ternaryState[];EpithPost[];SententialDeObject[];CanonicalOblique[]*=[prep = ?Prep]}


