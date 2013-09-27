%%%%%%%%%%%%%%%%%%%
% verbs.mg
%%%%%%%%%%%%%%%%%%%


class VerbalMorphology
import
	anchorProj2[]
	VerbSem[]
	TopLevelClass[]
export
    xVN xV 
declare
    ?xVN ?xV   ?fX ?fT
{
        <syn>{
                node xS(color=black)[cat = s,bot=[mode=?fX,tense=?fT]]{
                        node xVN(color=black)[cat = vp,
			top=[mode=?fX,tense=?fT],
			bot=[neg-nom = - ]]{
                           node xV(color=black)[cat = v,top=[tense=?fT]]
                        }
                } ;
		 xV = xAnchor;
		 xV = xVerbSem
        }
}

class ** activeVerbMorphology
import
	VerbalMorphology[]
export 	
	?fNum ?fGen ?fPers
declare 
	?fX ?fNum ?fGen ?fPers ?fS ?fT ?fO ?fP ?fK ?fG ?fT ?fMode ?fSecant ?fN ?fMode1
{
	<syn>{
		node xVN[top=[neg-nom = ?fG],bot=[mode=fMode, num = ?fNum,gen = ?fGen,pers=?fPers,pp-gen = ?fS,pp-num=?fN,inv = ?fO,neg-adv = ?fK]]{
			node xV(mark=anchor)[top=[num = ?fNum,gen = ?fGen,pers=?fPers,mode=?fMode,tense=?fT,aspect=?fSecant,inv = ?fO,pp-gen= ?fS, pp-num = ?fN,neg-adv = ?fK,neg-nom = ?fG, aux-refl= - ]]
		}			
	}*=[tense=?fT,mode=?fMode,aspect=?fSecant] 
}
%%CG 23/05/05 added ndaj constraint on participle node to block
%% ** jean est aime beaucoup de Marie
class ** passiveVerbMorphology
import
   VerbalMorphology[]
export
   xInfl
declare
   ?xInfl ?fS ?fT  ?fM ?fS0 ?fT0 ?fM0 ?fU ?fV ?fX ?fY ?fZ ?fW ?f0 ?fK ?fG  ?fCleft
{
        <syn>{
		     node xVN[top=[neg-nom = ?fG,mode=?fM,tense=?fT,aspect=?fS],bot=[mode=?fM0,tense=?fT0,aspect=?fS0, num = ?fX, gen = ?fY, pers = ?fZ,inv = ?f0,neg-adv = ?fK]]{
                     	node xInfl(color=black,mark=subst)[cat = v,top=[mode=?fM0,tense=?fT0,aspect=?fS0,num = ?fX, gen = ?fY, pers = ?fZ, cop = +,inv = ?f0,neg-adv = ?fK,neg-nom = ?fG],bot=[lemanchor=etre,aux=avoir, cleft= ?fCleft]]
                     	node xV(mark=anchor)[cat = v,top=[pp-gen=?fY,pp-num=?fX,aux-pass= -],bot=[aux-refl = - ,mode = ppart,passivable = + ,cleft= ?fCleft]]
		     }		              
        }*=[tense=?fT,mode=?fM,aspect=?fS]      
}

%I put the middle and intrinsic reflexives here (and not w/ clitics)
% because auxiliary  

class affixalVerbMorphology
import
   VerbalMorphology[]
export
   xClitic
declare
   ?xClitic ?fX ?fY ?fZ ?fW ?fU ?fK ?fG ?fT ?fM ?fS
{
        <syn>{
	    node xVN[top=[neg-nom = ?fK],bot=[num = ?fX, pers = ?fY, gen=?fZ,mode = ?fW,inv = ?fU,neg-adv = ?fG]]{
               	node xClitic(color=red,rank=2)[cat = cl]
               	,,,node xV(mark=anchor)[cat = v,top=[tense=?fT,mode=?fM,aspect=?fS,num = ?fX, pers = ?fY, gen=?fZ,mode=?fW,inv = ?fU,neg-nom = ?fK,neg-adv = ?fG],bot=[aux = etre,aux-refl = +,inv = -]]
	    }		              
        }*=[tense=?fT,mode=?fM,aspect=?fS]      
}

class ** middleVerbMorphology
import
   affixalVerbMorphology[]
{
        <syn>{	    
		node xVN[bot=[pers=3,tense=pres]]{
               		node xClitic(mark=subst,color=red)[top=[refl = + , func = obj, pers = 3],bot=[lemanchor=se]]}}}

class ** reflexiveVerbMorphology
import
   affixalVerbMorphology[]
declare
   ?fX ?fY
{
	<syn>{
		node xVN[top=[num=?fX,pers=?fY]]{
			node xClitic(mark=subst)[bot=[lemanchor=se],top=[num=?fX,pers=?fY,refl = +]]
		}
	}
}

class ** AccReflexiveMorphology
import
	 reflexiveVerbMorphology[]
declare
   ?I
{
	<syn>{
		node xClitic[top=[func = obj]]
	}
}

class ** DatReflexiveMorphology
import
	 reflexiveVerbMorphology[]
declare
   ?I
{
	<syn>{
		node xClitic[top=[func = iobj]]
	}
}
% -------------------------------------------------------
% Diatheses
% -------------------------------------------------------

class dian0VActive[]
import 
	SubjectArg1Linking[]
{
                Subject[] ; 
		activeVerbMorphology[]
}

class dian0Vimpersonal[]
import 
	ObjectArg1Linking[]
{
	ImpersonalSubject[] ; 
	activeVerbMorphology[];
	Object[]
}

class dian0Vn1Active[]
import 
	SubjectArg1Linking[]
	ObjectArg2Linking[]
{
                Subject[] ; 
                Object[] ; 
		activeVerbMorphology[]
}

class dian0Vn1Passive[]
import 
 	SubjectArg2Linking[]
 	CAgentArg1Linking[]
 {
                 PassiveSubject[] ; 
 		passiveVerbMorphology[];
 		CAgent[]
 }
class dian0Vn1dePassive[]
import 
 	SubjectArg2Linking[]
 	GenitiveArg1Linking[]
{
                PassiveSubject[] ; 
		Genitive[]  ;
                passiveVerbMorphology[]
}
class dian0Vn1ShortPassive[]
import 
 	SubjectArg2Linking[]
{
                PassiveSubject[] ; 
		passiveVerbMorphology[]
} 
class dian0Vn1ImpersonalPassive[]
import 
 	ObjectArg2Linking[]
{
                ImpersonalSubject[] ; 
		Object[];
		passiveVerbMorphology[]
}
class dian0Vn1middle[]
import 
 	SubjectArg2Linking[]
{
                Subject[] ; 
		middleVerbMorphology[]
}
class dian0Vn1Reflexive[]
import 
 	SubjectArg2Linking[]
 	SubjectArg1Linking[]
{
	Subject[]; 
	AccReflexiveMorphology[]
} 
class dian0Van1Active[]
import 
 	SubjectArg1Linking[]
 	IobjectArg2Linking[]
{
	Subject[] ;
	Iobject[] ; 
	activeVerbMorphology[]
}
class dian0Van1Reflexive[]
import 
 	SubjectArg1Linking[]
 	SubjectArg2Linking[]
{
	Subject[] ; 
	DatReflexiveMorphology[]
}
class dian0Vden1[]
import 
 	SubjectArg1Linking[]
 	GenitiveArg2Linking[]
{
	Subject[] ; 
	Genitive[] ; 
	activeVerbMorphology[]
}

% Jean reve de partir/qu'il ira a Bilbao
%?? partir est rêvé par Jean
class dian0Vcs1Passive[]
import 
 	SententialSubjectArg2Linking[]
 	CAgentArg1Linking[]
	SubjectControlLinking[]
{
	SententialSubject[];
	passiveVerbMorphology[];
	CAgent[]}

%?? partir est rêvé 
class dian0Vcs1shortPassive[]
import 
 	SententialSubjectArg2Linking[]
{
	SententialSubject[];
 	passiveVerbMorphology[]
}
%?? il est rêvé de partir
class dian0Vdes1ImpersonalPassive[]
import 
 	SententialDeObjectArg2Linking[]
{
	ImpersonalSubject[];
	SententialDeObject[];
	passiveVerbMorphology[]
}
%Jean rêve de partir
%Subject control
class dian0Vdes1Active[]
import 
 	SubjectArg1Linking[]
	SententialDeObjectArg2Linking[]
	SubjectControlLinking[]
{
	Subject[];
	SententialDeObject[];
	activeVerbMorphology[]
}

% -------------------------------------------------------
% Familles
% -------------------------------------------------------

% IMPERSONAL VERBS

% % il neige; Neige-t'il
% % l:neige(e)

class ilV
declare ?V
{
	state[];
	{ImpersonalSubject[] | InvertedIlSubject[]};
	V = activeVerbMorphology[];
	V.fNum = sg; V.fGen = m
}

% il faut un ingénieur
% l0:exists(x lr ls) lr:ingenieur(x) ls:necessaire(x)

class ilVn1
import 
 	ObjectArg0Linking[]
{
	ImpersonalSubject[];
	activeVerbMorphology[];
	Object[];
	basicProperty[]
}
% il faut que jean parte; il faut partir
% faut(l) l:partir(e) agent(e x)

class ilVcs1
{	
	modalRel[];
	ImpersonalSubject[];
	activeVerbMorphology[];
   	SententialCObject[]
}

class  ilvAcs1[]
import
      VerbArg0Linking[]
%declare ?xS
{
	modalRel[];
	ImpersonalSubject[];
        AdjectivalPredicativeform[];
   	CanonicalSententialObjectFinite[]
}

%		UNARY VERBS

class n0V
declare
	?X  ?E ?L
{
	unaryRel[];
	{
	dian0VActive[]}
%	|dian0Vimpersonal[]}
}

% %% REFLEXIVE VERBS
% %% Marie s'évanouit
class n0ClV[]
import 
 	SubjectArg1Linking[]
{
	unaryRel[];
	Subject[]; 
	reflexiveVerbMorphology[]
}

% % Jean s'offre un CD
% class n0ClVn1[]
% import 
%  	SubjectArg1Linking[]
%  	SubjectArg3Linking[]
%  	ObjectArg2Linking[]
% {
%  	ternaryRel[];
%  	Subject[]; 
% 	Object[]; 
% 	reflexiveVerbMorphology[]
% }
% % cet enfant s'appelle Marie
class n0ClVn1[]
import 
 	SubjectArg1Linking[]
 	ObjectArg2Linking[]
{
	binaryRel[];
	Subject[]; Object[]; 
	reflexiveVerbMorphology[]
}
% % Jean se bat contre Paul (reflechi autonome; agent1 theme agent2)
class n0ClVpn1[]
import 
 	SubjectArg1Linking[]
 	ObliqueArg3Linking[]
{
	binaryRel[];
	Subject[]; 
	Oblique[]; 
	reflexiveVerbMorphology[]
}
% % Jean se plaint de Marc (agent,recipient,theme)
class n0ClVden1[]
import 
 	SubjectArg1Linking[]
 	GenitiveArg3Linking[]
{
	binaryRel[];
	Subject[]; 
	Genitive[]; 
	reflexiveVerbMorphology[]
}
% % Jean s'inteéresse à Marc (agent,recipient,theme)
class n0ClVan1[]
import 
 	SubjectArg1Linking[]
 	LocativeArg3Linking[]
{
	binaryRel[];
	Subject[]; 
	Iobject[]; 
	reflexiveVerbMorphology[]
}
% % Jean se souvient de Marc (agent,theme)
class n0seVden1[]
import 
 	SubjectArg1Linking[]
 	GenitiveArg2Linking[]
{
	binaryRel[];
	Subject[]; 
	Genitive[]; 
	reflexiveVerbMorphology[]
}
% Qu'il neige en Aout arrive parfois
class s0V[]
import
	SubjectArg1Linking[]	
{
	unaryRel[];
	SententialSubject[]; 
	activeVerbMorphology[]
}
% %% BINARY VERBS
% % Jean regarde Marie
class n0Vn1[]
{
	binaryRel[];dian0Vn1[]
}

class dian0Vn1[]
{
	 dian0Vn1Active[]
 	| dian0Vn1Passive[]
% %	| dian0Vn1dePassive[]
% 	| dian0Vn1ShortPassive[]
% 	| dian0Vn1ImpersonalPassive[]
 	| dian0Vn1middle[]
% 	| dian0Vn1Reflexive[]
}
class n0Van1[]
{	binaryRel[];
        {dian0Van1Active[]
	|dian0Van1Reflexive[]}
}
class n0Vden1[]
{	binaryRel[];
	dian0Vden1[]
}
class n0Vpn1[]
import
	SubjectArg1Linking[]	
	ObliqueArg2Linking[]	
{
  	binaryRel[];
	Subject[];
	Oblique[];
	activeVerbMorphology[]
}

class n0Vloc1[]
import
	SubjectArg1Linking[]
	LocativeArg2Linking[]
{	binaryRel[];
	Subject[];
	Locative[];
	activeVerbMorphology[]
}	

% %% TERNARY -- WITH NOMINAL ARGUMENTS

% % not in valuation
% % Qu'il neige habitue Jean a se couvrir
% % Courir habitue Jean a se couvrir
% % object control
class s0Vn1acs2ControleObjet[]
import
	SententialSubjectArg1Linking[]
	ObjectArg2Linking[]
	SententialAObjectArg3Linking[]
	ObjectControlLinking[]
{
	ternaryRel[];
	SententialSubject[];
	Object[];
	SententialAObject[];
	activeVerbMorphology[]
}
% Jean parle de linguistique à Marie
class n0Van1den2[]
import
	GenitiveArg3Linking[]
{	ternaryRel[];
	n0Van1[];
	Genitive[]
}
% not in valuation
% Jean parle de ce livre avec Marie
class n0Vden1pn2[]
import
	SubjectArg1Linking[]
	ObliqueArg2Linking[]
	GenitiveArg3Linking[]
{
	ternaryRel[];
   	Subject[];
	Oblique[];
	Genitive[];
	activeVerbMorphology[]
}
% 
class n0Vn1pn2[]
import
	ObliqueArg3Linking[]
{	ternaryRel[];
	{ dian0Vn1Active[]
	| dian0Vn1Passive[]
%	| dian0Vn1dePassive[]
	| dian0Vn1ShortPassive[]
	| dian0Vn1ImpersonalPassive[]
	| dian0Vn1middle[]
	| dian0Vn1Reflexive[]};
	Oblique[]
}
%not in the valuation
class n0Vn1loc2[]
import
	LocativeArg3Linking[]
{	ternaryRel[];
	n0Vn1[];
	Locative[]
}

class n0Vn1an2[]
import
	IobjectArg3Linking[]
{
 	ternaryRel[];
	dian0Vn1[];
	Iobject[]
}
class n0Vn1den2[]
import
	GenitiveArg3Linking[]
{
 	ternaryRel[];
	dian0Vn1[];
	Genitive[]
}

% %%% SUBJECT CONTROL 

% %Subject control
% % Jean pense avoir raison / que Marie a raison
% % SubjectControl

class n0Vcs1
import
	SubjectArg1Linking[]
	VerbHandleArg2Linking[]
	SubjectControlLinking[]
{
	scopalBinaryRel[];
	Subject[]; 
	SententialCObject[];
	activeVerbMorphology[]
}
%Jean tient à venir
class n0Vas1[]
import
	SubjectArg1Linking[]
	VerbHandleArg2Linking[]
	SubjectControlLinking[]
{
	scopalBinaryRel[];
	Subject[]; 
	SententialAObjectInfinitive[];
	activeVerbMorphology[]
}
% Jean demande où aller
%Subject control
class n0Vs1int[]
import
	SubjectArg1Linking[]
	InterrogativeArg2Linking[]
	SubjectControlLinking[]
{
	scopalBinaryRel[];
	 Subject[]; 
	 SententialInterrogative[]; 
	 activeVerbMorphology[]
}
%Jean se demande où aller (reflechi autonome; agent recipient theme)
class n0ClVs1int[]
import
	SubjectArg1Linking[]
	InterrogativeArg2Linking[]
	SubjectControlLinking[]
{
	ternaryRel[];
	Subject[]; 
	SententialInterrogative[]; 
	reflexiveVerbMorphology[]
}

%% SUBJ/OBJ CONTROL 
% default = subject control

class n0Vdes1[]{
	binaryRel[];
	{dian0Vcs1Passive[]
	|dian0Vdes1ImpersonalPassive[]
	|dian0Vdes1Active[]
	|dian0Vcs1shortPassive[]}
}

%% TERNARY WITH SENTENTIAL ARGUMENTS
% Jean avertira Marie si Pierre part 
% ?? Jean avertira Marie de partir

class n0Vn1sint2[]
import
	InterrogativeArg3Linking[]
	ObjectControlLinking[]
{
	ternaryRel[];
	n0Vn1[];
	SententialInterrogative[]
}
% Jean demande à Marie si l'ingenieur vient
% ?? Jean demande à Marie si partir
% Jean demande à Marie où aller
% subject control
class n0Vs1intan2[]
import	SubjectArg1Linking[]
	InterrogativeArg2Linking[]
	IobjectArg3Linking[]
	SubjectControlLinking[]
{
	ternaryRel[];
	Subject[];
	SententialInterrogative[];
	activeVerbMorphology[];
	Iobject[]
}


% Jean force Marie à venir
% Object control
class n0Vn1acs2ControleObjet[]
import
	SententialAObjectArg3Linking[]
	ObjectControlLinking[]
{
	ternaryRel[];
	dian0Vn1[]; 
	SententialAObject[]
}
% Jean voit Marie partir
% Object control
class n0Vn1cs2ControleObjet[]
import
	SententialCObjectArg3Linking[]
	ObjectControlLinking[]
{
	ternaryRel[];
	dian0Vn1[]; 
	SententialCObject[]
}

% Subject Control
class n0Vn1cs2[]
import
	SententialCObjectArg3Linking[]
	SubjectControlLinking[]
{
	ternaryRel[];
	dian0Vn1[];
	SententialCObject[]
}
%% not in lexicon
class n0Vcs1decs2[]
import
	SubjectArg1Linking[]
	SententialCObjectArg2Linking[]
	SententialDeObjectArg3Linking[]
{
	ternaryRel[];
	Subject[];
	SententialCObject[];
	SententialDeObject[];
	activeVerbMorphology[]  
}
% Jean requiert de Marie qu'elle parte
class n0Vcs1den2[]
import
	SubjectArg1Linking[]
	SententialCObjectArg2Linking[]
	GenitiveArg3Linking[]
	SubjectControlLinking[]
{
	ternaryRel[];
	Subject[];
	SententialCObject[]; 
	Genitive[];
	activeVerbMorphology[]
}
% Jean persuade marie de partir
% Subject control
class n0Van1decs2[]
import
	IobjectArg3Linking[]
	SubjectControlLinking[]
{
	ternaryRel[];
	n0Vdes1[];
	Iobject[]
}
%Jean promet a Marie de partir
%Object control
class n0Van1decs2ControleObjet[]
import
	IobjectArg3Linking[]
	IobjectControlLinking[]
{
	ternaryRel[];
	n0Vdes1[];
	Iobject[]
}
%Jean convainc Marie de partir
% Object control
class n0Vn1decs2ControleObjet[]
import
	IobjectArg3Linking[]
	ObjectControlLinking[]
{
	ternaryRel[];
	n0Vdes1[]; 
	Object[]
}
class n0Vdes1pn2[]
import
	SubjectArg1Linking[]
	SententialDeObjectArg2Linking[]
	ObliqueArg3Linking[]
	SubjectControlLinking[]
declare
	?Prep
{
	ternaryRel[];
   {Subject[];
   Oblique[]*=[prep = ?Prep];
   SententialDeObject[];
   activeVerbMorphology[]
   }%*=[prep2 = ?Prep]
}
% Jean dit à l'entreprise avoir raison
class n0Vcs1an2[]
import
	SubjectArg1Linking[]
	IobjectArg2Linking[]
	SententialCObjectArg3Linking[]
	SubjectControlLinking[]
{
	ternaryRel[];
	Subject[];
	Iobject[]; 
	SententialCObject[];
	activeVerbMorphology[]
}
%% BINARY -- SENTENTIAL SUBJECT
% Que jean parte désole Marie
class s0Vn1[]
import
	SententialSubjectArg1Linking[]
	ObjectArg2Linking[]
{
	binaryRel[];
	SententialSubject[];
	Object[];
	activeVerbMorphology[]
}
% Que jean parte déplait à Marie
class s0Van1[]
import
	SententialSubjectArg1Linking[]
	IobjectArg2Linking[]
{
	binaryRel[];
	SententialSubject[];
	Iobject[];
	activeVerbMorphology[]
}

% Qu'il neige prouve qu'il fait froid
class s0Vcs1[]
import
	SententialSubjectArg1Linking[]
	SententialCObjectArg2Linking[]
{
	binaryRel[];
	SententialSubject[];
	SententialCObject[];
	activeVerbMorphology[]
}

%%% NBAR, ADJECTIVES
% % avoir
% class n0Vnbar1[]
% import
% 	SubjectArg1Linking[]
% 	InterrogativeArg2Linking[]
% 	IobjectArg3Linking[]
% {
% 	binaryRel[];
% 	Subject[];activeVerbMorphology[]
% }

% class n0Vn1Adj2[]
% import
% 	ObjAttributeArg2Linking[]
% {
% 	n0Vn1[];
% 	ObjAttributeCan[]
% }

% Jean croit Marie stupide
class n0Vn1Adj2[]
import
	 scopalBinaryRel[]
	 SubjectArg1Linking[]
	 AdjectiveHandleArg2Linking[]
	 NounPredicateAgreement[]
{
	Subject[];
	Object[];
	ObjAttributeCan[];
	activeVerbMorphology[]	
}
% Jean nomme Marie présidente
class n0Vn1n2[]
import
	 scopalBinaryRel[]
	 SubjectArg1Linking[]
	 AdjectiveHandleArg2Linking[]
	 NounPredicateAgreement[]
{
	Subject[];
	Object[];
	NPAttributeCan[];
	activeVerbMorphology[]	
}
