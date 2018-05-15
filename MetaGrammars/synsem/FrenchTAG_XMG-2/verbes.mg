% NON FULL PREDICATIVE UNITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%* <Auxiliaires>
%%%%%%%%%%%%%%%%%%%

class TenseAux
export 
	xTop xL xR
declare
	?xTop ?xL ?xR ?fM ?fP ?fN ?fO ?fG ?fK
{
	<syn>{
		node xTop(color=red,mark=nadj)[cat = v,bot=[mode=?fM,num=?fN,pers=?fP,aux-pass= +, inv = ?fO,neg-adv = ?fG, neg-nom = ?fK]]{
			node xL(mark=anchor,color=red)[cat = v, top=[mode=?fM, num=?fN, pers=?fP,inv = ?fO,neg-adv = ?fG,neg-nom = ?fK],bot = [inv = inv_no]]
			node xR(mark=foot,color=red)[cat = v,top=[mode = ppart]]
		}
	}
}

class AvoirAux
import
	TenseAux[]
declare
	?fN ?fG
{
	<syn>{
		node xTop[bot=[pp-num = ?fN, pp-gen = ?fG]]{
			node xR[top=[pp-num = ?fN, pp-gen = ?fG, aux = avoir]]
		}
	}
}

class EtreAux
import
	TenseAux[]
declare
	?fN ?fG
{
	<syn>{
		node xTop[bot=[num = ?fN, gen = ?fG]]{
			node xR[top=[pp-num = ?fN, pp-gen = ?fG, aux = etre]]
		}
	}
}


%* <Copule> 
%%%%%%%%%%%%%%%%%%%%%%%%
class Copule
declare 
	?xV
{
	<syn>{
		node xV(color=red,mark=anchor)[cat = v,bot=[cop = +,inv = inv_no]]
	}
}


% SEMI-AUXILIARIES (Subject Raising verbs)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Todo : extend the representation to handle negation
% e.g. Personne ne semble venir
% Personne ne semble ne pas venir 
class SemiAux

declare
	?xTop ?xL ?xR ?fM ?fP ?fN ?fM ?fK ?fO ?fG ?fH
{
	<syn>{
		node xTop(color=red)[cat = vn,bot=[mode=?fM,num=?fN,pers=?fP,inv = ?fO, gen = ?fK,neg-nom = ?fG, neg-adv = ?fH]]{
			node xL(mark=anchor,color=red)[cat = v, top=[mode=?fM, num=?fN, pers=?fP,inv = ?fO],bot=[inv = inv_no]]
			node xR(mark=foot,color=red)[cat = vn,top=[mode = inf, num = ?fN,gen = ?fK,neg-adv = ?fH,neg-nom = ?fG]]
		}
	}
}

% avoir l'air de
%%%%%%%%%%%%%%%%%%%%%%%

class SemiAuxNPde
declare
	?xTop ?xHead ?xP ?xDe ?xPP ?xN ?xR ?fM ?fP ?fN ?fM ?fK ?fO
{
	<syn>{
		node xTop(color=red)[cat = vn,bot=[mode=?fM,num=?fN,pers=?fP,inv = ?fO, gen = ?fK]]{
			node xHead(mark=anchor,color=red)[cat = v, top=[mode=?fM, num=?fN, pers=?fP,inv = ?fO]]
			node xN(mark=anchor,color=red)[cat = n]
			node xPP(color=red)[cat = pp]{
				node xP(color=red)[cat = p]{
					node xDe(color=red,mark=flex)[cat = de]
				}
				node xR(mark=foot,color=red)[cat = vn,top=[mode = inf, num = ?fN,gen = ?fK]]	
			}
		}
	}
}

% Venir de
%%%%%%%%%%%%%%%%%%%%%%
class SemiAuxDe
declare
	?xTop ?xHead ?xP ?xDe ?xPP ?xN ?xR ?fM ?fP ?fN ?fM ?fK ?fO
{
	<syn>{
		node xTop(color=red)[cat = vn,bot=[mode=?fM,num=?fN,pers=?fP,inv = ?fO, gen = ?fK]]{
			node xHead(mark=anchor,color=red)[cat = v, top=[mode=?fM, num=?fN, pers=?fP,inv = ?fO]]
			node xPP(color=red)[cat = pp]{
				node xP(color=red)[cat = p]{
					node xDe(color=red,mark=flex)[cat = de]
				}
				node xR(mark=foot,color=red)[cat = vn,top=[mode = inf, num = ?fN,gen = ?fK]]	
			}
		}
	}
}



%%%%%%%%%%%%%%%%%%%%%%%
%Verbal Predicate morphology
%%%%%%%%%%%%%%%%%%%%%%%


class VerbalMorphology
export
   xS xVN xV
declare
   ?xS ?xVN ?xV ?fU ?fV ?fW ?fX
{
        <syn>{
                node xS(color=black)[cat = s,bot=[mode=?fX]]{
                        node xVN(color=black)[cat = vn,top=[mode=?fX,neg-adv = -],bot=[neg-nom = -]]{
                                node xV(mark=anchor,color=black)[cat = v]
                        }
                }
        }       
}

class activeVerbMorphology
import
	VerbalMorphology[]
declare 
	?fX ?fY ?fZ ?fW ?fS ?fT ?fO ?fP ?fK ?fG
{
	<syn>{
		node xVN[top=[neg-nom = ?fG],bot=[mode=?fX, num = ?fY,gen = ?fZ,pers=?fW,pp-gen = ?fS,pp-num=?fT,inv = ?fO,neg-adv = ?fK]]{
			node xV[top=[mode=?fX,num = ?fY,gen = ?fZ,pers=?fW,inv = ?fO,pp-gen= ?fS, pp-num = ?fT,neg-adv = ?fK,neg-nom = ?fG],bot=[inv = inv_no, aux-refl= -]]
		}			
	}
}

class passiveVerbMorphology
import
   VerbalMorphology[]
export
   xInfl
declare
   ?xInfl ?fS ?fT ?fU ?fV ?fX ?fY ?fZ ?fW ?f0 ?fK ?fG
{
        <syn>{
		     node xVN[top=[neg-nom = ?fG],bot=[num = ?fX, gen = ?fY, pers = ?fZ, mode = ?fW,inv = ?f0,neg-adv = ?fK]]{
                     	node xInfl(color=black,mark=subst)[cat = v,top=[num = ?fX, gen = ?fY, pers = ?fZ, mode = ?fW,cop = +,inv = ?f0,neg-adv = ?fK,neg-nom = ?fG]]
                     	node xV(color=black)[cat = v,top=[mode = ppart,pp-gen=?fY,pp-num=?fX,aux-pass= -],bot=[aux-refl = -]]
		     }		              
        }       
}

%I put the middle and intrinsic reflexives here (and not w/ clitics) because auxiliary 
class affixalVerbMorphology
import
   VerbalMorphology[]
export
   xClitic
declare
   ?xClitic ?fX ?fY ?fZ ?fW ?fU ?fK ?fG
{
        <syn>{
	    node xVN[top=[neg-nom = ?fK],bot=[num = ?fX, pers = ?fY, gen=?fZ, mode = ?fW,inv = ?fU,neg-adv = ?fG]]{
               	node xClitic(color=red,rank=2)[cat = cl]
               	,,,node xV(color=black)[cat = v,top=[num = ?fX, pers = ?fY, gen=?fZ,mode=?fW,inv = ?fU,neg-nom = ?fK,neg-adv = ?fG],bot=[aux = etre,aux-refl = +,inv = inv_no]]
	    }		              
        }       
}

class middleVerbMorphology
import
   affixalVerbMorphology[]
declare
   ?xSe
{
        <syn>{	    
		node xVN[bot=[pers=3,tense=present]]{
               		node xClitic{	
				node xSe(mark=flex,color=red)[cat=se]		
			}
		}
        }       
}

class reflexiveVerbMorphology
import
   affixalVerbMorphology[]
declare
   ?fX ?fY
{
	<syn>{
		node xVN[top=[num=?fX,pers=?fY]]{
			node xClitic(mark=subst)[top=[num=?fX,pers=?fY,refl = +]]
		}
	}
}

class AccReflexiveMorphology
import
	 reflexiveVerbMorphology[]
{
	<syn>{
		node xClitic[top=[func = obj]]
	}
}
class DatReflexiveMorphology
import
	 reflexiveVerbMorphology[]
{
	<syn>{
		node xClitic[top=[func = iobj]]
	}
}


%* <Alternances de diathèse>
%%%%%%%%%%%%%%%%%%%%%%%%%%

class dian0Vactive
{
	Subject[] ; activeVerbMorphology[]
}

class dian0Vimpersonal
{
	ImpersonalSubject[] ; Object[]; activeVerbMorphology[]
}

class dian0Vn1Active{
                Subject[] ; Object[] ; activeVerbMorphology[]          
}
class dian0Vn1Passive{
                Subject[] ; CAgent[] ; passiveVerbMorphology[]        
}
class dian0Vn1dePassive{
                Subject[] ; Genitive[] ; passiveVerbMorphology[]        
}
class dian0Vn1ShortPassive{
                Subject[] ; passiveVerbMorphology[]        
}
class dian0Vn1ImpersonalPassive{
                ImpersonalSubject[] ; Object[]; passiveVerbMorphology[]        
}
class dian0Vn1middle{
                Subject[] ; middleVerbMorphology[]        
}
class dian0Vn1Reflexive{
	Subject[]; AccReflexiveMorphology[]
} 
class dian0Van1Active{
		Subject[] ; Iobject[] ; activeVerbMorphology[]       
}
class dian0Van1Reflexive{
		Subject[] ; DatReflexiveMorphology[]       
}
class dian0Vden1{
		Subject[] ; Genitive[] ; activeVerbMorphology[]       
}

%sentential arguments (sketched -> the full stuff would oversize the grammar)
class dian0Vcs1Passive{
	SententialSubject[];passiveVerbMorphology[];CAgent[]
}
class dian0Vcs1shortPassive{
	SententialSubject[];passiveVerbMorphology[]
}
class dian0Vdes1ImpersonalPassive{
                ImpersonalSubject[];SententialDeObject[];passiveVerbMorphology[]        
}

class dian0Vdes1Active{
	Subject[]; SententialDeObject[]; activeVerbMorphology[]	
}


%* <Familles>
%%%%%%%%%%%%%%%%%%%%%%%%%%

class ilV{
	ImpersonalSubject[];activeVerbMorphology[]
}
class ilVcs1{
	ImpersonalSubject[];activeVerbMorphology[];SententialCObject[]
}
class n0V{
	dian0Vactive[]
	|dian0Vimpersonal[]
}

class n0Vn1{
                dian0Vn1Active[]
		| dian0Vn1Passive[]
		| dian0Vn1dePassive[]
		| dian0Vn1ShortPassive[]
		| dian0Vn1ImpersonalPassive[]
		%| dian0Vn1middle[]
		| dian0Vn1Reflexive[]		
}



class n0Vn1an2{
		n0Vn1[];Iobject[]
}
class n0Vn1Adj2
{
	n0Vn1[];ObjAttributeCan[]
}

class n0Vn1den2{
		n0Vn1[];Genitive[]
}
class n0Van1{
                dian0Van1Active[]
		|dian0Van1Reflexive[]
}
class n0Vden1{
		dian0Vden1[]
}
class n0Vpn1
declare 
	?X
{
  {
	Subject[];Oblique[]*=[prep = ?X];activeVerbMorphology[]
  }*=[prep1 = ?X]
}

class n0Vloc1{
	Subject[];Locative[];activeVerbMorphology[]
}	
class n0Van1den2{
		n0Van1[];Genitive[]
}
class n0Vden1pn2
declare 
	?X
{
   {
		Subject[];Oblique[]*=[prep = ?X];Genitive[];activeVerbMorphology[]
   }*=[prep2 = ?X]
}
class n0Vn1pn2
declare
        ?X
{
   {
                n0Vn1[];Oblique[]*=[prep = ?X]
   }*=[prep2 = ?X]
}

class n0Vn1loc2{
		n0Vn1[];Locative[]
}
class n0Vcs1{
		Subject[]; SententialCObject[]; activeVerbMorphology[]   
}
class n0Vas1{
		Subject[]; SententialAObject[]; activeVerbMorphology[]   
}
class n0Vdes1{
	dian0Vcs1Passive[]
	|dian0Vdes1ImpersonalPassive[]
	|dian0Vdes1Active[]
	|dian0Vcs1shortPassive[]
}

class n0Vcs1an2{
		Subject[]; SententialCObject[]; Iobject[]; activeVerbMorphology[]   
}
class n0Vs1int{
	Subject[]; SententialInterrogative[]; activeVerbMorphology[]
}
class n0Vn1sint2{
	n0Vn1[];SententialInterrogative[]
}

class n0Vs1intan2{
	{
		Subject[]; SententialInterrogative[]; activeVerbMorphology[];Iobject[]
	}
	|
	{
		Subject[]; SententialInterrogative[]; DatReflexiveMorphology[]
	}  
}
class n0Vn1des2{
	n0Vn1[]; SententialDeObject[]
}
class n0Vn1as2{
	n0Vn1[]; SententialAObject[]
}
class n0Vn1cs2{
	n0Vn1[]; SententialCObject[]
}
class n0Vs1des2{
	Subject[]; SententialCObject[]; SententialDeObject[]; activeVerbMorphology[]   
}
class n0Vcs1des2{
	Subject[]; SententialCObject[]; SententialDeObject[]; activeVerbMorphology[]
}
class n0Vdes1den2{
	Subject[]; SententialDeObject[]; Genitive[]; activeVerbMorphology[]   
}
class n0Van1des2{
	n0Vdes1[]; Iobject[]
}
class s0V{
	SententialSubject[]; activeVerbMorphology[]
}
class s0Vn1{
	SententialSubject[]; Object[]; activeVerbMorphology[]
}
class s0Van1{
	SententialSubject[]; Iobject[]; activeVerbMorphology[]
}
class s0Vcs1{
	SententialSubject[]; SententialCObject[]; activeVerbMorphology[]
}
class s0Vn1as2{
	SententialSubject[]; Object[]; SententialAObject[]; activeVerbMorphology[]
}
class n0Vdes1pn2
declare
	?X
{
   {
	Subject[]; Oblique[]*=[prep = ?X]; SententialDeObject[]; activeVerbMorphology[]
   }*=[prep2 = ?X]
}
class n0ClV{
	Subject[]; reflexiveVerbMorphology[]  
}
class n0ClVn1{
	Subject[]; Object[]; reflexiveVerbMorphology[]  
}
class n0ClVpn1
declare 
	?X
{
   {
	Subject[]; Oblique[]*=[prep = ?X]; reflexiveVerbMorphology[]  	
   }*=[prep1 = ?X]
}
class n0ClVden1{
	Subject[]; Genitive[]; reflexiveVerbMorphology[] 
}

class n0Vnbar1
{
	Subject[];activeVerbMorphology[];CanonicalNBar[]
}
