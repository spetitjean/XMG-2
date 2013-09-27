%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% misc.mg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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




class nPreposition
% as postnominal modifier
declare
	?xroot ?xfoot ?xprepph ?xprep ?xnoun ?fX ?fT ?fY ?fZ ?fU ?fW ?fG ?fK ?L ?LX ?RX ?PX ?fM
{
	<syn>{
		node xroot(color=red)[cat = n,bot=[mass=?fM,det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG, neg-nom = ?fK]]{
			node xfoot(color=red,mark=foot)[cat = n,top=[cest = - ,idx=LX,label=L,det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG,neg-nom = ?fK,mass=?fM],bot=[det= -]]
			node xprepph(color=red)[cat = pp]{
				node xprep (color=red,mark=anchor)[cat = p,top=[idx=PX]]
				node xnoun (color=red,mark=subst)[cat = n,top=[idx=RX]]
			}
		}
	};
	prepSem[]*=[label=L,arg0=PX,arg1=LX,arg2=RX]	
}

class npPreposition
% as postnominal modifier
declare
	?xroot ?xfoot ?xprepph ?xprep ?xnoun ?fX ?fT ?fY ?fZ ?fU ?fW ?fG ?fK ?L ?LX ?RX ?PX ?fM
{
	<syn>{
		node xroot(color=red)[cat = n,bot=[mass=?fM,det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG, neg-nom = ?fK]]{
			node xfoot(color=red,mark=foot)[cat = n,top=[cest = - ,idx=LX,label=L,det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG,neg-nom = ?fK,mass=?fM],bot=[det= +]]
			node xprepph(color=red)[cat = pp]{
				node xprep (color=red,mark=anchor)[cat = p,top=[idx=PX]]
				node xnoun (color=red,mark=subst)[cat = n,top=[idx=RX]]
			}
		}
	};
	prepSem[]*=[label=L,arg0=PX,arg1=LX,arg2=RX]	
}

% Preposition for a PP modifying a VP

class vpPreposition
declare
	?xroot ?xfoot ?xprepph ?xprep ?xnoun ?fX ?fT ?fY ?fZ ?fU ?fW ?fG ?fK ?L ?LX ?RX ?PX ?fMo ?fM
{
	<syn>{
		node xroot(color=red)[cat = vp,bot=[mode = ?fMo, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG, neg-nom = ?fK]]{
			node xfoot(color=red,mark=foot,name=modee)[cat = vp,top=[mode = ?fMo,idx=LX,label=L,num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG,neg-nom = ?fK,mass=?fM,cest = - ]]
			node xprepph(color=red)[cat = pp]{
				node xprep (color=red,mark=anchor)[cat = p,top=[idx=PX]]
				node xnoun (color=red,mark=subst)[cat = n,top=[idx=RX,det = + ]]
			}
		}
	};
	prepSem[]*=[label=L,arg0=PX,arg1=LX,arg2=RX]	
}

%
class s0Cs1middle %Jean vient parce que la réunion aura lieu
declare
	?xR ?xF ?xSbar ?xHead ?xArg ?X ?Y ?LX ?LY
{
	<syn>{
		node xR(color=red)[cat = s]{
			node xF(color=red,mark=foot)[cat = s]
			node xSbar(color=red,mark=nadj)[cat = s,top=[idx=X,label=LX]]{
				node xHead(color=red,mark=anchor)[cat = c]
				node xArg(color=red,mark = subst)[cat = s, top=[inv = -, princ = -, wh = -, mode = @{subj,ind},idx=Y,label=LY]]
			}
		}
	};	
	binaryState[]*=[arg0=X,arg1=Y]
}

class s0Cs1Fronted %Si il vient la réunion aura lieu
declare
	?xR ?xF ?xSbar ?xHead ?xArg ?X ?Y ?LX ?LY
{
	<syn>{
		node xR(color=red)[cat = s]{		
			node xSbar(color=red,mark=nadj)[cat = s]{
				node xHead(color=red,mark=anchor)[cat = c]
				node xArg(color=red,mark = subst)[cat = s, top=[inv = -, princ = -, wh = -, mode = @{subj,ind},idx=X,label=LX]]
			}
			node xF(color=red,mark=foot)[cat = s,top=[idx=Y,label=LY]]
		}
	};	
	binaryState[]*=[arg0=LX,arg1=LY]

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
		node xR(color=black)[cat = vp,top=[neg-adv = -],bot=[neg-nom = @{+,-},mode = ?fX, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT]]{
			node xHead(color=black,mark=anchor)[cat = cl]	
			node xFoot(color=black,mark=foot)[cat = vp,top=[neg-adv = @{+,-},neg-nom = -,mode = ?fX, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT]]
		} 
	}%;
%       	negationSem[]
}

%use it for : plus, jamais, etc as well (specificities of jamais etc should be taken into account (Abeille-Godard 97)

class negPasFinitePost
import modifierSem[]
export 
	xHead xR xFoot
declare
	?xHead ?xR ?xFoot ?fX ?fY ?fZ ?fU ?fV ?fW ?fT ?fR ?fS ?fG ? fK
{
	<syn>{
		node xR(color=black)[cat = v,bot=[mode = @{ind,subj,imp}, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = +,neg-nom = -]] {
			node xFoot(color=black,mark=foot)[cat=v,top=[mode = @{ind,subj,imp}, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = -]] 
			node xHead(color=red,mark=anchor)[cat = adv]
		}
	}
}

class negPasInfAnte
import modifierSem[]
export 
	xHead xR xFoot
declare
	?xHead ?xR ?xFoot ?fX ?fY ?fZ ?fU ?fV ?fW ?fT ?fR ?fS ?fG ? fK
{
	<syn>{
		node xR(color=black)[cat = vp,bot=[mode = inf, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = +,neg-nom = -]] {
			node xHead(color=red,mark=anchor)[cat = adv]
			node xFoot(color=black,mark=foot)[cat=vp,top=[mode =  inf, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = -]] 		
		}
	}
}

class negPas
{
     negPasFinitePost[]
   | negPasInfAnte[]
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For anchoring *que* in exclamative sentences such as
% qu'elle sorte !
% qu'il parte !

class ExclamativeQue
declare
	?xR ?xHead ?xFoot
{
	<syn>{
		node xR(color=red)[cat = s,bot = [princ = +] ]{
			node xHead(color=red,mark=anchor)[cat = c]
			node xFoot(color=red,mark=foot)[cat = s, top = [inv = -, mode = subj, wh = -]]
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
	?xCoordtop ?xCoordFoot ?xCoord ?xCoordSubst ?X ?LX ?RX ?LX ?LLX ?RLX 
{
	<syn>{
	node xCoordtop(color=red)[bot=[num=pl]]{
		node xCoordFoot(color=red,mark=foot)[top=[idx=LX,label=LLX]]			node xCoord(color=red,mark=anchor)[cat = coord,bot=[idx=X]]			node xCoordSubst(color=red)[top=[idx=RX,label=RLX]]
		}
	};
	coordSem[]*=[nIndex=X,arg1=LX,lIndex=LX,arg2=RX,rIndex=RX]
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
		node xCoordtop[cat = n, bot = [wh = -, det = +]];
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
		node xCoordtop[cat = pp, bot = [wh = -, det = +]];
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

class Coordination
{
	NominalCoord[]
	|SententialCoord[]
	|AdjCoord[]
	|PrepCoordsHacked[]
	|AdvCoord[]
}

% xtop was marked as anchor; i removed the mark (cg, 07/12/05)
class sententialAdv
import modifierSem[]
declare
	?xtop ?xanc
{
   <syn>{
		node xtop(color = red)[cat = s, bot = [wh = -, inv = -, princ = -]]{
			node xanc(color = red, mark = anchor)[cat = adv]}  
	 };
	xModifier = xtop
}