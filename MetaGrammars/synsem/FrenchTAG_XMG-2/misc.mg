%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%* <MISC>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


class propername
declare
	?xN
{
	<syn>{
		node xN(color=red,mark=anchor)[cat = n,bot=[pers = 3, wh = wh_no]]
	}
}
class pronoun
declare
	?xN
{
	<syn>{
	       node xN(color=red,mark=anchor)[cat = n,bot=[det = +]]
	}
}

class n0Nmod
declare 
	?xR ?xFoot ?xHead ?fX ?fT ?fY ?fZ ?fU ?fW ?fG ?fK
{
	<syn>{
		node xR(color=red)[cat = n,bot=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG,neg-nom = ?fK]]{
			node xFoot(color=red,mark=foot)[cat = n,top=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG, neg-nom = ?fK]]
			node xHead(color=red,mark=nadj,mark=anchor)[cat = n]
		}
	}
}




class determiner
export
	xR xFoot xAnc 
declare
	?xR ?xFoot ?xAnc ?fX ?fY ?fZ ?fT ?fU ?fW ?fG ?fK
{
	<syn>{
		node xR(color=red)[cat = n, bot = [def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU,neg-adv = ?fG, neg-nom = ?fK]]{
			node xAnc(color=red,mark=anchor)[cat = d,bot=[num = ?fY,gen = ?fZ]]
			node xFoot(color=red,mark=foot)[cat = n,top=[def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, neg-adv = ?fG,neg-nom = ?fK]]
		}
	}
}	

class complexDeterminer
export
 ?xR ?xAnc ?xPP ?xP ?xDe ?xFoot
declare
 ?xR ?xAnc ?xPP ?xP ?xDe ?xFoot ?fX ?fW ?fT ?fY ?fZ ?fU ?fG ?fK
{
	<syn>{
		node xR(color=red)[cat = n,bot = [det = +, wh = wh_no, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU,neg-adv = ?fK,neg-nom = ?fG]]{
			node xAnc(color=red,mark=anchor)
			node xPP(color=red)[cat = pp]{
				node xP(color=red)[cat = p]{
					node xDe(color=red,mark = flex)
				}
				node xFoot(color=red,mark=foot)[cat = n,top=[det = -, wh = wh_no, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU,neg-adv = ?fK, neg-nom = ?fG]]
			}
		}
	}
}




class complexAdvDeDeterminer
import 
	complexDeterminer[]
{
	<syn>{
			node xAnc[cat = adv];
			node xDe[cat = de]
	}
}

class complexNDeDeterminersg
import 
	complexDeterminer[]
declare 
	?xDet
{
	<syn>{
		node xAnc[cat = n,top=[det = +],bot=[det = -]];
		node xDe [cat = de]		
	}
}	


class complexNDeDeterminerpl
import 
	complexDeterminer[]
declare 
	?xDet
{
	<syn>{
		node xAnc[cat = n,top=[det = +],bot=[det = -]];
		node xDe[cat = des]		
	}
}	


class complexNDeDeterminer
{
	complexNDeDeterminersg[]|complexNDeDeterminerpl[]
}


class pureDeterminer
import 
	determiner[]
{
	<syn>{
		node xR[bot = [det = +]];
		node xFoot[top = [det = -]]
	}
}

class DetAdj
import 
	determiner[]
declare 
	?fR
{
	<syn>{
		node xFoot[top = [det = -, wh = ?fR]];
		node xR[bot = [wh = ?fR]]
	}
}


class stddeterminer
import 
	pureDeterminer[]
declare 
	?fR
{
	<syn>{
		node xR[bot = [wh = wh_no]];
		node xFoot
	}
}


class whdeterminer
import
	pureDeterminer[]
{
	<syn>{
		node xR[bot = [wh = wh_yes]];
		node xFoot[top = [wh = wh_no]]
	}
}


% *Tous* les enfants
class detQuantifier
import
	determiner[]
{
	<syn>{
		node xR[bot = [det = +, wh = wh_no]];
		node xFoot[top = [det = @{+,-}]]
	}
}	

% *Aucun* enfant
class detNegQuantifier
import 
	pureDeterminer[]
{
	<syn>{
		node xR[bot=[neg-adv = -, neg-nom = +,wh = wh_no]]
	}
}

class PrepositionalPhrase
% as postnominal modifier
declare
	?xroot ?xfoot ?xprepph ?xprep ?xnoun ?fX ?fT ?fY ?fZ ?fU ?fW ?fG ?fK
{
	<syn>{
		node xroot(color=red)[cat = n,bot=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG, neg-nom = ?fK]]{
			node xfoot(color=red,mark=foot)[cat = n,top=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG,neg-nom = ?fK]]
			node xprepph(color=red)[cat = pp]{
				node xprep (color=red,mark=anchor)[cat = p]
				node xnoun (color=red,mark=subst)[cat = n]
			}
		}
	}	
}

class CliticT
declare
	?xCl
{
	<syn>{
		node xCl(color=red,mark=anchor)[cat = cl]
	}
}

%propag du mode avec valeur disj @?fX{ind,subj} 

class InvertedSubjClitic
declare
	?xR ?xfoot ?xCl	?fX ?fY ?fZ ?fU ?fV ?fW ?fG ?fK
{
	<syn>{
		node xR(color=red)[cat = v,bot = [inv = @{inv_yes,inv_no},mode = @{ind,subj}, num = ?fY, pers= ?fZ, gen = ?fU,aux = ?fV ,aux-pass = ?fW,neg-adv = ?fG, neg-nom = ?fK]]{
			node xfoot(color=red,mark=foot)[cat =v,top=[inv = inv_no, mode = @{ind,subj}, num = ?fY, pers = ?fZ, gen = ?fU, aux = ?fV, aux-pass=?fW,neg-adv = ?fG,neg-nom = ?fK]]
			node xCl(color=red,mark=anchor)[cat = cl]
		}
	}
}

class s0Cs1middle %Jean vient parce que la réunion aura lieu
declare
	?xR ?xF ?xSbar ?xHead ?xArg
{
	<syn>{
		node xR(color=red)[cat = s]{
			node xF(color=red,mark=foot)[cat = s]
			node xSbar(color=red,mark=nadj)[cat = s]{
				node xHead(color=red,mark=anchor)[cat = c]
				node xArg(color=red,mark = subst)[cat = s, top=[inv = inv_no, princ = inv_no, wh = wh_no, mode = @{subj,ind}]]
			}
		}
	}
}

class s0Cs1Fronted %Si il vient la réunion aura lieu
declare
	?xR ?xF ?xSbar ?xHead ?xArg
{
	<syn>{
		node xR(color=red)[cat = s]{		
			node xSbar(color=red,mark=nadj)[cat = s]{
				node xHead(color=red,mark=anchor)[cat = c]
				node xArg(color=red,mark = subst)[cat = s, top=[inv = inv_no, princ = inv_no, wh = wh_no, mode = @{subj,ind}]]
			}
			node xF(color=red,mark=foot)[cat = s]
		}
	}
}

class s0Cs1
{
	s0Cs1middle[]
	|s0Cs1Fronted[]
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Partial account for negation
% it should generally work for negation within a single clause finite/non-finite but the implementation is not that elegant

% Accounts for :
% Jean n'a pas dormi
% Personne ne dort
% Aucun individu ne dort
% Jean veut ne pas dormir
% Que jean ne vienne a 'etonn'e	
%...
%Rejects :
%*Personne ne dort pas
%*Jean ne veut faire confiance 'a personne (not handled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class negLeft
declare 
	?xR ?xFoot ?xHead ?fX ?fY ?fZ ?fU ?fV ?fW ?fR ?fS ?fT
{
	<syn>{
		node xR(color=red)[cat = vn,top=[neg-adv = -],bot=[neg-nom = @{+,-},mode = ?fX, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT]]{
			node xHead(color=red,mark=anchor)[cat = cl]	
			node xFoot(color=red,mark=foot)[cat = vn,top=[neg-adv = @{+,-},neg-nom = -,mode = ?fX, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT]]
		} 
	}
}

%use it for : plus, jamais, etc as well (specificities of jamais etc should be taken into account (Abeille-Godard 97)

class negPasFinitePost
export 
	xHead xR xFoot
declare
	?xHead ?xR ?xFoot ?fX ?fY ?fZ ?fU ?fV ?fW ?fT ?fR ?fS ?fG ? fK
{
	<syn>{
		node xR(color=red)[cat = v,bot=[mode = @{ind,subj,imp}, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = +,neg-nom = -]] {
			node xFoot(color=red,mark=foot)[cat=v,top=[mode = @{ind,subj,imp}, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = -]] 
			node xHead(color=red,mark=anchor)[cat = adv]
		}
	}
}

class negPasInfAnte
export 
	xHead xR xFoot
declare
	?xHead ?xR ?xFoot ?fX ?fY ?fZ ?fU ?fV ?fW ?fT ?fR ?fS ?fG ? fK
{
	<syn>{
		node xR(color=red)[cat = vn,bot=[mode = inf, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = +,neg-nom = -]] {
			node xHead(color=red,mark=anchor)[cat = adv]
			node xFoot(color=red,mark=foot)[cat=vn,top=[mode =  inf, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = -]] 		
		}
	}
}

class negPas
{
     negPasFinitePost[]
   | negPasInfAnte[]
}

%use it for personne, aucun, etc... used as pronouns
class negativeQuantifier
declare
	?xH
{
	<syn>{
		node xH(color=red,mark=anchor)[cat = n, bot = [det = +,wh = wh_no,neg-nom = +,neg-adv = -]]
	}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For anchoring *que* in excalamative sentences such as
% qu'elle sorte !
% qu'il parte !

class ExclamativeQue
declare
	?xR ?xHead ?xFoot
{
	<syn>{
		node xR(color=red)[cat = s,bot = [princ = inv_yes] ]{
			node xHead(color=red,mark=anchor)[cat = c]
			node xFoot(color=red,mark=foot)[cat = s, top = [inv = inv_no, mode = subj, wh = wh_no]]
		}
	}
}




	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Coordination (should be enhanced)
% Jean et marie mangent
% Jean ou marie mange
% Un professeur gentil et bienveillant
% Jean parle et Marie dort
% Eric parle de son pays et des ses voyages
% Jean parle lentement et avec assurance (not handled)
% Jean va soit à Paris soit à Minneapolis (not handled)

class GenericCoord
export
	xCoordtop xCoordFoot xCoord xCoordSubst
declare 
	?xCoordtop ?xCoordFoot ?xCoord ?xCoordSubst
{
	<syn>{
		node xCoordtop(color=red){
			node xCoordFoot(color=red,mark=foot)
			node xCoord(color=red,mark=anchor)[cat = coord]
			node xCoordSubst(color=red)
		}
	}
}

class ConstituentCoord
import 
	GenericCoord[]
{
	<syn>{
		node xCoordSubst(mark=subst)
	}
}




class NominalCoord
import
	ConstituentCoord[]
{
	<syn>{
		node xCoordtop[cat = n, bot = [wh = wh_no, det = +]];
		node xCoordFoot[cat = n,top=[det = +]];
		node xCoordSubst[cat = n, top=[det = +]]		
	}
}

class SententialCoord
import
	ConstituentCoord[]
{
	<syn>{
		node xCoordtop[cat = s];
                node xCoordFoot[cat = s];
                node xCoordSubst[cat = s]
	}
}

class PrepCoord
import
        GenericCoord[]
export 
	xPrep
declare 
	?xP ?xPrep ?xN
{
        <syn>{
                node xCoordtop[cat = pp];
                node xCoordFoot[cat = pp];
                node xCoordSubst[cat = pp]
        };
	<syn>{
		node xCoordSubst{
			node xP(color=red)[cat = p]{
				node xPrep(color=red,mark=flex)
			}	
			node xN(color=red,mark=subst)[cat = n]
		}		
	}
}	

class FakePrepCoord
import 
	ConstituentCoord[]
{
	<syn>{
		node xCoordtop[cat = pp, bot = [wh = wh_no, det = +]];
		node xCoordFoot(color=red,mark=foot)[cat = pp];
		node xCoord(color=red,mark=anchor)[cat = coord];
		node xCoordSubst(color=red,mark =subst)[cat = n, top = [det = +]]
	}
}

class PrepCoordA
import
	PrepCoord[]
{
	<syn>{
		node xPrep[cat = à]
	}
}
class PrepCoordDe
import
	PrepCoord[]
{
	<syn>{
		node xPrep[cat = de]
	}
}
class PrepCoordAvec
import
	PrepCoord[]
{
	<syn>{
		node xPrep[cat = avec]
	}
}
class PrepCoordDans
import
	PrepCoord[]
{
	<syn>{
		node xPrep[cat = dans]
	}
}
class PrepCoordSans
import
	PrepCoord[]
{
	<syn>{
		node xPrep[cat = sans]
	}
}
class PrepCoordEn
import
	PrepCoord[]
{
	<syn>{
		node xPrep[cat = en]
	}
}
class PrepCoordEntre
import
	PrepCoord[]
{
	<syn>{
		node xPrep[cat = entre]
	}
}

%ugh : awful isn't it ?
class PrepCoordsHacked
{
	FakePrepCoord[]|PrepCoordSans[]|PrepCoordEn[]|PrepCoordEntre[]|PrepCoordDe[]|PrepCoordAvec[]|PrepCoordDans[]|PrepCoordA[]
}

class AdjCoord
import
        ConstituentCoord[]
{
        <syn>{
                node xCoordtop[cat = adj];
                node xCoordFoot[cat = adj];
                node xCoordSubst[cat = adj]
        }
}
class AdvCoord
import
        ConstituentCoord[]
{
        <syn>{
                node xCoordtop[cat = adv];
                node xCoordFoot[cat = adv];
                node xCoordSubst[cat = adv]
        }
}

class estceque
declare
	?xR ?xVN ?xHead ?xCl ?xS ?xComp ?xQue ?xFoot
{
	<syn>{
		node xR(color=red)[cat = s,bot=[inv = @{inv_yes,inv_no},wh = wh_no]]{
			node xVN(color=red)[cat=vn]{
				node xHead(color=red,mark=anchor)[cat = v]
				node xCl(color=red,mark=subst)[cat = cl,top=[case = suj]]
			}
			node xS(color=red,mark=nadj)[cat = s]{
				node xComp(color=red)[cat=c]{
					node xQue(color=red,mark=flex)[cat = que]
				}
 				node xFoot(color=red,mark=foot)[cat = s,top=[inv = inv_no,wh = wh_no]]
			}
		}
		
	}
}

class Coordination
{
	NominalCoord[]
	|SententialCoord[]
	|AdjCoord[]
	|PrepCoordsHacked[]
	|AdvCoord[]
}

class sententialAdv
declare
	?xtop ?xanc
{
   <syn>{
		node xtop(color = red, mark = anchor)[cat = s, bot = [wh = wh_no, inv = inv_no, princ = inv_no]]{
			node xanc(color = red, mark = anchor)[cat = adv]
		}  
   }
}