 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	adverbs.mg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% This file describes mostly sentential and verbal modifiers that play the status of adverbs, that is :
% * Adverbs
% * Prepositional phrases
% * Nouns being temporal modifiers

% with semantics

%ABSTRACT CLASSE
% This class should be subclassed by any modifier of this file

class AbstractSModifier
import
	basicProperty[]
	modifieeSem[]
	modifieeArg0Linking[]
	footProj1[]
export 
	xHead xFoot % xR
declare
	?xHead ?xFoot ?fX ?fY ?fZ ?fU ?fV ?fW ?X %?L ?xR
{
	<syn>{
		node xR{
			node xHead(color=red,mark=anchor)
		};
		node xR(color=black)[cat = s, bot = [wh = ?fX, inv = ?fY, mode = ?fZ, ctrl-gen = ?fU, ctrl-num = ?fV, ctrl-pers = ?fW]]{
			node xFoot(color=black,mark=foot,name=adverbFoot) [cat = s, top=[wh = ?fX, inv = ?fY, mode = ?fZ, ctrl-gen = ?fU, ctrl-num = ?fV, ctrl-pers = ?fW]]
		};
		xModifiee=xFoot;
		xSemFoot = xFoot
	}
}
class AbstractVModifier
import
	adjectiveProperty[]
	modifieeSem[]
	modifieeArg0Linking[]
	footProj1[]
export 
	xHead  xFoot
declare
	?xHead  ?xFoot ?fX ?fY ?fZ ?fU ?fV ?fW ?fT ?fR ?fS ?fG ? fK ?fA ?fTse ?fMde % ?L
{
	<syn>{
		node xR{
			node xHead(color=red,mark=anchor)
		};
		node xR(color=black)[cat = @{v,vp},bot=[aspect=?fA,tense=?fTse,mode=?fMde, num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = + ,neg-nom = ?fK]]{
			node xFoot(color=black,mark=foot,name=adverbFoot)[cat= @{v,vp},top=[num = ?fY, gen = ?fZ, pers = ?fU, pp-num = ?fV,pp-gen = ?fW, inv = ?fR, aux = ?fS, aux-pass = ?fT,neg-adv = ?fG, neg-nom = ?fK,aspect=?fA,tense=?fTse,mode=?fMde]] 
		};
		xModifiee=xFoot;
		xSemFoot = xFoot
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
	node xR[cat=v]{
		node xFoot[cat=v]
		node xHead 
		}
	}
}
class AbstractVPModifierPost
import 
	AbstractVModifier[]
{
	<syn>{
	node xR[cat=vp]{
		node xFoot[cat=vp]
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
class advVPPost
import
	AbstractVPModifierPost[]
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

class ** advSPost
import
	AbstractSModifierPost[]
{
	<syn>{
		node xHead[cat = adv]
	}

}
class ** TempNounSPost
import
	AbstractSModifierPost[]
{
	<syn>{
		node xHead[cat = n, top=[det = +],bot=[det = -]]
	}
}

class ** advSAnte
import
	AbstractSModifierAnte[]
{
	<syn>{
		node xHead[cat = adv]
	}	
}


class ** TempNounSAnte
import
	AbstractSModifierAnte[]
{
	<syn>{
		node xHead[cat = n,top=[det = +],bot=[det = -]]
	}
}

class ** advAdjAnte
import
	adjectiveProperty[]
	modifieeSem[]
	modifieeArg0Linking[]
	footProj1[]
declare 
	 ?xHead ?fX ?fY ?xFoot ?A ?fST
{
	<syn>{
		node xR(color=black)[cat = adj, bot=[num = ?fX, gen = ?fY,semtype=?fST]]{
			node xHead(color=black,mark=anchor)[cat = adv]
			node xFoot(color=black,mark=foot)[cat = adj,top=[semtype=?fST,num = ?fX,gen = ?fY]]			}
	};
	xSemFoot = xFoot;
	xModifiee = xFoot
}
% tres (souvent)
class advAdvAnte
import
	basicProperty[]
	modifieeSem[]
	modifieeArg0Linking[]
	footProj1[]
declare 
	 ?xHead ?xFoot
{
	<syn>{
		node xR(color=black)[cat = adv]{
			node xHead(color=black,mark=anchor)[cat = adv]
			node xFoot(color=black,mark=foot)[cat = adv]	
		}
	};
	xSemFoot = xFoot;
	xModifiee = xFoot
}
% tres (intelligent)
class advNAnte
import
	basicProperty[]
	modifieeSem[]
	modifieeArg0Linking[]
	footProj1[]
declare 
	?xHead ?xFoot ?X ?Y
{
	<syn>{
		node xR(color=black)[cat = n, bot = [det = + ,label = L0, index = X ]]{
			node xHead(color=black,mark=anchor)[cat = adv]
			node xFoot(color=black,mark=foot)[cat = n, top = [det = + , index = Y]]	
		}
	};
	xSemFoot = xFoot;
	xModifiee = xFoot
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PP MODIFIERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%should be merged with the above abstract classes, I lack of time :-(

class abstractModifier
import
	unaryState[]
	modifieeSem[]
	modifierArg1Linking[]
	modifieeArg0Linking[]
	footProj1[]
export
	xFoot xBarBar xBar xComp % xR		
declare
	?xR2 ?xFoot ?xBarBar ?xBar ?xComp % ?xR
{
	<syn>{
		node xR(color=black){
			node xFoot(color=black,mark=foot)
		}
	};
	xModifiee = xFoot;
	xSemFoot = xFoot;
	<syn>{
		node xR2(color=white){
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
class ** s0Pn1post
import 
	ppSModifierPost[]	
       modifierSem[]
{
	<syn>{
		node xComp(mark=subst)[cat = n]
	};
	xModifier = xComp
}

class ** s0Pn1ante
import 
	ppSModifierAnte[]
       modifierSem[]
{
	<syn>{
		node xComp(mark=subst)[cat = n]
	};
	xComp = xModifier
}
%% 
class ** s0Pv1post
import 
	ppVModifier[]
       modifierSem[]
{
	<syn>{
		node xComp(mark=subst)[cat = n]
	};
	xModifier = xComp
}
% aller ** jusque ** chez vous
class ** s0PLoc1
import 
	ppSModifierPost[]
       modifierSem[]
{
	<syn>{
		node xComp(mark=subst)[cat = pp,top=[loc = +]]
	};
	xModifier = xComp
}
% un livre ** avec ** une couverture bleue
class ** n0Pn1
import 
	ppNModifier[]
       modifierSem[]
{
	<syn>{
		node xComp[cat = n]
	};
	xModifier = xComp
}


% Complementeur qui introduit une infinitive (ex. [...] pour venir)
class s0PNullCOmplementizer
import 
	ppSModifierPost[]
       modifierSem[]
{
	<syn>{
		node xComp(mark = subst)[cat = s, top=[mode = inf]]
	};
	xModifier = xComp
}

class s0PComplementizer
import 
       ppSModifierPost[]
       modifierSem[]
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
	};
	xModifier = xS
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

	
class s0Pques1
import 
	s0PComplementizer[]
{
	<syn>{
		node xCLex[cat = que,top=[mode= @{ind,subj}]]
	}
}
% marie chante ** avant *** la reunion
% intersective
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
%	|whPPMod[]
%	|RelPPMod[]
%	|cleftPPModOne[]
%	|cleftPPModTwo[]
}

%%% Semantics not added from here on (dunno what these classes are for)

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


class abstractCleftPPMod
export 
	?xTop ?xVN ?xV ?xCl ?xArg ?xS ?xPied ?xFoot
declare
	?xTop ?xVN ?xV ?xCl ?xArg ?xS ?xPied ?xFoot
{
	<syn>{
		node xTop(color=red)[cat = s, bot = [wh = -]]{
			node xVN(color=red)[cat = vp]{
				node xV(color=red,mark=subst)[cat = v, top = [pers = 3,mode = @{ind,subj}]]
				node xCl(color=red,mark=subst)[cat = cl,top=[func = suj]]
			}
			node xArg(color=red)
			node xS(color=red,mark=nadj)[cat = s]{
				node xPied(color=red)
				node xFoot(color=red,mark=foot)[cat = s,top=[wh = -]]
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
			node xN(color=red,mark = subst)[cat = n, top=[wh = +]]
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
		node xE(color=red)[cat = s,bot=[wh = +]]{
			node xPP(color=red)[cat = pp]{
				node xP(color=red,mark=anchor)[cat = p]
				node xN(color=red,mark=subst)[cat = n,top=[det = +,wh = +]]
			}
			node xS(color=red)[cat = s,top = [wh = -]]
		}
	}
}

class whPPMod
import 
	 ExtractedPPMod[]
{
	<syn>{
		node xS[top = [inv = +,wh = +]]
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
			node xE(color=red,mark=nadj)[cat = s,bot = [wh = +]]
		}
	}
}
