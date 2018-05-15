% This file describes mostly sentential and verbal modifiers that play the status of adverbs, that is :
% * Adverbs
% * Prepositional phrases
% * Nouns being temporal modifiers


%ABSTRACT CLASSES

% This class should be subclassed by any modifier of this file

class AbstractSModifier
export 
	xHead xR xFoot
declare
	?xHead ?xR ?xFoot ?fX ?fY ?fZ ?fU ?fV ?fW
{
	<syn>{
		node xR{
			node xHead(color=red,mark=anchor)
		};
		node xR(color=red)[cat = s, bot = [wh = ?fX, inv = ?fY, mode = ?fZ, ctrl-gen = ?fU, ctrl-num = ?fV, ctrl-pers = ?fW]]{
			node xFoot(color=red,mark=foot) [cat = s, top=[wh = ?fX, inv = ?fY, mode = ?fZ, ctrl-gen = ?fU, ctrl-num = ?fV, ctrl-pers = ?fW]]
		}	
	}
}

class AbstractVModifier
export 
	xHead xR xFoot
declare
	?xHead ?xR ?xFoot ?fX ?fY ?fZ ?fU ?fV ?fW ?fT ?fR ?fS ?fG ? fK
{
	<syn>{
		node xR{
			node xHead(color=red,mark=anchor)
		};
		node xR(color=red)[cat = v,bot=[mode = ?fX, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = ?fG,neg-nom = ?fK]]{
			node xFoot(color=red,mark=foot)[cat=v,top=[mode = ?fX, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = ?fG, neg-nom = ?fK]] 
		}	
	}
}

class AbstractSModifierAnte
import 
	AbstractSModifier[]

{
	<syn>{
		node xR{
			node xHead 
			node xFoot
		}				
	}	
}

class AbstractSModifierPost
import 
	AbstractSModifier[]
{
	<syn>{
		node xR{		
			node xFoot	
			node xHead 		
		}				
	}	
}


%Should be subclassed by any verbal modifier
%Propagates v features

class AbstractVModifierPost
import 
	AbstractVModifier[]
{
	<syn>{
	node xR{
		node xFoot
		node xHead 
		}
	}
}

%Actual classes  
%(I don't have time to include PPs in the abstract schema above; should be done)

class advVPost
import
	AbstractVModifierPost[]
{
	<syn>{
		node xHead[cat = adv]
	}

}

class TempNounVPost
import
	AbstractVModifierPost[]
{
	<syn>{
		node xHead[cat = n, top=[det = +],bot=[det = -]]
	}
}

class advSPost
import
	AbstractSModifierPost[]
{
	<syn>{
		node xHead[cat = adv]
	}

}
class TempNounSPost
import
	AbstractSModifierPost[]
{
	<syn>{
		node xHead[cat = n, top=[det = +],bot=[det = -]]
	}
}

class advSAnte
import
	AbstractSModifierAnte[]
{
	<syn>{
		node xHead[cat = adv]
	}

}


class TempNounSAnte
import
	AbstractSModifierAnte[]
{
	<syn>{
		node xHead[cat = n,top=[det = +],bot=[det = -]]
	}
}

class advAdjAnte
declare 
	?xR ?xHead ?xFoot ?fX ?fY
{
	<syn>{
		node xR(color=red)[cat = adj, bot=[num = ?fX, gen = ?fY]]{
			node xHead(color=red,mark=anchor)[cat = adv]
			node xFoot(color=red,mark=foot)[cat = adj,top=[num = ?fX,gen = ?fY]]	
		}
	}
}

class advAdvAnte
declare 
	?xR ?xHead ?xFoot
{
	<syn>{
		node xR(color=red)[cat = adv]{
			node xHead(color=red,mark=anchor)[cat = adv]
			node xFoot(color=red,mark=foot)[cat = adv]	
		}
	}
}

class advLoc
declare
	?xR ?xHead ?fX
{
	<syn>{
		node xR(color=red)[cat = pp,bot=[loc = +,wh=?fX]]{
			node xHead(color=red,mark=anchor)[cat = adv,top=[wh=?fX]]
		}
	}
}
class prepLoc
declare
	?xHead ?xArg ?xP ?fX
{
	<syn>{
		node xHead(color=red)[cat = pp,bot=[loc = +,wh=?fX]]{
			node xP(color=red,mark=anchor)[cat = p]
			node xArg(color=red,mark=subst)[cat = n,top=[wh = ?fX]]
		}
	}
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PP MODIFIERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%should be merged with the above abstract classes, I lack of time :-(


class abstractModifier
export
	xR xFoot xBarBar xBar xComp		
declare
	?xR ?xFoot ?xBarBar ?xBar ?xComp
{
	<syn>{
		node xR(color=red){
			node xFoot(color=red,mark=foot)
		}
	};
	<syn>{
		node xR(color=red){
			node xBarBar(color=red){
				node xBar(color=red,mark=anchor)
				node xComp(color=red)
			}
		}
	}
}

class GenericPPModifierPost
import 
	abstractModifier[]
{
	<syn>{
		node xBarBar[cat = pp];
		node xBar[cat = p]
	};
	<syn>{
		node xR{
			node xFoot
			node xBarBar
		}		
	}

} 

class GenericPPModifierAnte
import 
	abstractModifier[]
{
	<syn>{
		node xBarBar[cat = pp];
		node xBar[cat = p]
	};
	<syn>{
		node xR{
			node xBarBar
			node xFoot
		}		
	}
} 


class ppSModifierPost
import 
	GenericPPModifierPost[]
declare
	?fX ?fY ?fZ ?fU ?fV ?fW
{
	<syn>{
		node xR[cat=s,bot=[wh = ?fX, inv = ?fY, mode = ?fZ, ctrl-gen = ?fU, ctrl-num = ?fV, ctrl-pers = ?fW]];
		node xFoot[cat=s,top=[wh = ?fX, inv = ?fY, mode = ?fZ, ctrl-gen = ?fU, ctrl-num = ?fV, ctrl-pers = ?fW]]
	}
}

class ppSModifierAnte
import 
	GenericPPModifierAnte[]
declare
	?fX ?fY ?fZ ?fU ?fV ?fW
{
	<syn>{
		node xR[cat=s,bot=[wh = ?fX, inv = ?fY, mode = ?fZ, ctrl-gen = ?fU, ctrl-num = ?fV, ctrl-pers = ?fW]];
		node xFoot[cat=s,top=[wh = ?fX, inv = ?fY, mode = ?fZ, ctrl-gen = ?fU, ctrl-num = ?fV, ctrl-pers = ?fW]]
	}
}

class ppVModifier
import 
	GenericPPModifierPost[]
declare
	?fX ?fY ?fZ ?fU ?fV ?fW ?fR ?fS ?fT ?fG ?fK
{
	<syn>{
		node xR[cat = v,bot=[mode = ?fX, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = ?fG,neg-nom = ?fK]];
		node xFoot[cat = v,top=[mode = ?fX, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = ?fG,neg-nom = ?fK]]
	}
}

class ppNModifier
import 
	GenericPPModifierPost[]
declare
	?fX ?fT ?fY ?fZ ?fU ?fW ?fG ?fK
{
	<syn>{
		node xR[cat=n,bot=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-nom = ?fK, neg-adv = ?fG, bar=2]];
		node xFoot[cat=n,top=[neg-adv = ?fG,neg-nom = ?fK,det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar=@{0,1,2}]];
		node xComp(mark=subst)
	}
}
class s0Pn1post
import 
	ppSModifierPost[]
{
	<syn>{
		node xComp(mark=subst)[cat = n]
	}
}

class s0Pn1ante
import 
	ppSModifierAnte[]
{
	<syn>{
		node xComp(mark=subst)[cat = n]
	}
}

class s0Pv1post
import 
	ppVModifier[]
{
	<syn>{
		node xComp(mark=subst)[cat = n]
	}
}
class s0PLoc1
import 
	ppSModifierPost[]
{
	<syn>{
		node xComp(mark=subst)[cat = pp,top=[loc = +]]
	}
}

class n0Pn1
import 
	ppNModifier[]
{
	<syn>{
		node xComp[cat = n]
	}
}


% Complmenteur qui introduit une infinitive (ex. [...] pour venir)
class s0PNullCOmplementizer
import 
	ppSModifierPost[]
{
	<syn>{
		node xComp(mark = subst)[cat = s, top=[mode = inf]]
	}
}


class s0PComplementizer
import 
	ppSModifierPost[]
export 
	xC xCLex xS
declare
	?xC ?xCLex ?xS
{
	<syn>{
		node xComp[cat = s]{
			node xC(color = red)[cat = c]{
				node xCLex(color = red,mark=flex)
			}
			node xS(color=red,mark=subst)[cat = s]
		}
	}	
}
class s0Pdes1
import 
	s0PComplementizer[]
{
	<syn>{
		node xCLex[cat = de];
		node xS[top=[mode = inf]]
	}
}

class abstractCleftPPMod
export 
	?xTop ?xVN ?xV ?xCl ?xArg ?xS ?xPied ?xFoot
declare
	?xTop ?xVN ?xV ?xCl ?xArg ?xS ?xPied ?xFoot
{
	<syn>{
		node xTop(color=red)[cat = s, bot = [wh = wh_no]]{
			node xVN(color=red)[cat = vn]{
				node xV(color=red,mark=subst)[cat = v, top = [pers = 3,mode = @{ind,subj}]]
				node xCl(color=red,mark=subst)[cat = cl,top=[func = suj]]
			}
			node xArg(color=red)
			node xS(color=red,mark=nadj)[cat = s]{
				node xPied(color=red)
				node xFoot(color=red,mark=foot)[cat = s,top=[wh = wh_no]]
			}
		}
	}
}

class cleftPPModOne
import 
	abstractCleftPPMod[]
declare
	?xQue ?xP ?xN
{
	<syn>{
		node xArg(color=red)[cat=pp]{
			node xP(color=red,mark=anchor)[cat = p]
			node xN(color=red,mark=subst)[cat = n, top=[det = +]]
		};
		node xPied(color=red)[cat = c]{
			node xQue(color=red,mark=flex)[cat = que]
		}
	}
}

class cleftPPModTwo
import 
	abstractCleftPPMod[]
declare
	?xP ?xN
{
	<syn>{
		node xArg(color=red,mark=subst)[cat = n, top=[det = +, def = +]];
		node xPied(color=red)[cat = pp]{
			node xP(color=red,mark=anchor)[cat = p]
			node xN(color=red,mark = subst)[cat = n, top=[wh = wh_yes]]
		}	
	}
}	

class ExtractedPPMod
export
	xE xPP xP xN xS
declare
	?xE ?xPP ?xP ?xN ?xS
{
	<syn>{
		node xE(color=red)[cat = s,bot=[wh = wh_yes]]{
			node xPP(color=red)[cat = pp]{
				node xP(color=red,mark=anchor)[cat = p]
				node xN(color=red,mark=subst)[cat = n,top=[det = +,wh = wh_yes]]
			}
			node xS(color=red)[cat = s,top = [wh = wh_no]]
		}
	}
}

class whPPMod
import 
	 ExtractedPPMod[]
{
	<syn>{
		node xS[top = [inv = inv_yes,wh = wh_yes]]
	}
}
class  RelPPMod
import 
	ExtractedPPMod[]
declare
	?xTop ?xFoot ?fX ?fY ?fZ ?fU ?fW
{
	<syn>{
		node xTop(color=red)[cat = n,bot = [det = ?fX, def = ?fY, num = ?fZ, gen = ?fU, pers= ?fW]]{
			node xFoot(color=red,mark=foot)[cat = n,top=[det = ?fX, def = ?fY, num =  ?fZ, gen = ?fU, pers= ?fW]]
			node xE(color=red,mark=nadj)[cat = s,bot = [wh = wh_yes]]
		}
	}
}
	
class s0Pques1
import 
	s0PComplementizer[]
{
	<syn>{
		node xCLex[cat = que,top=[mode= @{ind,subj}]]
	}
}
class s0Ps1
{
	n0Pn1[]|s0PNullCOmplementizer[]|s0Pques1[]
}
class s0Pcs1
{
	n0Pn1[]|s0PNullCOmplementizer[]|s0Pdes1[]
}
class s0Pn1
{
	s0Pn1post[]
	|s0Pn1ante[]
	|s0Pv1post[]
	|whPPMod[]
	|RelPPMod[]
	|cleftPPModOne[]
	|cleftPPModTwo[]
}
