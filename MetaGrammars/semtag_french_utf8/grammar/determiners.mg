%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determiners.mg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%CG 12/3/7
% modified index percolation (idx was not percolated to root)

class topdeterminer
export
	xR xFoot 
declare
	?xR ?xFoot ?X ?H
{
	<syn>{
		node xR(color=black)[cat = n,bot=[idx=X]]{
			node xFoot(color=black,mark=foot)[cat = n,top=[idx=X,handle=H]]}
			}
}	

class determiner
import
	topdeterminer[]
export
	xAnc 
declare
	?xAnc ?fX ?fY ?fZ ?fT ?fW ?fG ?fK ?I ?LN ?LV ?I1 ?fWH ?fM ?D ?fST
{
	<syn>{
		node xR[ bot = [det = + ,semtype=?fST,def = ?fT, num = ?fY,gen = ?fZ,pers = 3,neg-adv = ?fG, neg-nom = ?fK,idx=I1, wh = ?fWH, mass = ?fM, def = ?D]]{
			node xAnc(color=black,mark=anchor)[cat = d,top=[num = ?fY,gen = ?fZ, wh = ?fWH, mass = ?fM, def = ?D]]
			node xFoot[top=[semtype=?fST,def = ?fT, num = ?fY,gen = ?fZ,idx= I1, neg-adv = ?fG,neg-nom = ?fK],bot=[idx=I, det = - ,mass = ?fM]]
		}
	}
}	
class complexDeterminer
import
	topdeterminer[]
export
  ?xPP ?xP ?xDe ?xAnc
declare
  ?xPP ?xP ?xDe ?fX ?fW ?fT ?fY ?fZ ?fU ?fG ?fK ?xAnc
{
	<syn>{
		node xR[bot = [det = +, wh = -, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU,neg-adv = ?fK,neg-nom = ?fG]]{
			node xAnc(color=black,mark=anchor)
			node xPP(color=black)[cat = pp]{
				node xP(color=black)[cat = p]{
					node xDe(color=black,mark = flex)
				}}
			node xFoot[top=[det = -, wh = -, def = ?fT, num = ?fY,gen = ?fZ,neg-adv = ?fK, neg-nom = ?fG]]
		}
	}
}

class complexAdvDeDeterminer
import 
	complexDeterminer[]
declare ?X ?LN ?LV
{
	<syn>{
			node xAnc[cat = adv];
			node xDe[cat = de]
	}
}
% un (litre de lait)
% litre :: basicProperty
class complexNDeDeterminersg
import 
	complexDeterminer[]
declare 
	?xDet ?X ?LN
{
	<syn>{
		node xAnc[cat = n,top=[det = +,idx=X,label=LN],bot=[det = -]];
		node xDe [cat = de]		
	}
}	


class complexNDeDeterminerpl
import 
	complexDeterminer[]
declare 
	?xDet ?X ?LN
{
	<syn>{
		node xAnc[cat = n,top=[det = +,idx=X,label=LN],bot=[det = -]];
		node xDe[cat = des]		
	}
}	


class complexNDeDeterminer
{
	complexNDeDeterminersg[]|complexNDeDeterminerpl[]
}

%Non quantifying determiners (semantics indicates number and definiteness)
class pureDeterminer
import 
	determiner[]
declare
	?N ?D
{
	<syn>{
		node xR[bot = [det = + , num = N, def = D]];
		node xFoot[bot = [det = - , num = N, def = D]]
	}*=[num=N, def = D]
}

class DetAdj
import 
	determiner[]
declare 
	?fR ?X ?LN ?LV
{
	<syn>{
		node xFoot[top = [det = -, wh = ?fR]];
		node xR[bot = [wh = ?fR]]
	}
}


class stddeterminer
import 
	pureDeterminer[]
	quantifierDetSem[]
{
	<syn>{
		node xR[bot = [wh = -]]
	}
}
class possDeterminer
import 
	pureDeterminer[]
	possessiveDetSem[]
{
	<syn>{
		node xR[bot = [wh = -]]
	}
}
class whdeterminer
import
	determiner[]
	quantifierDetSem[]
declare
	 ?X ?LN ?LV
{
	<syn>{
		node xR[bot = [wh = +]];
		node xFoot[top = [wh = - , det = - ]]
	}; xFoot = xNounSem
}


% *Tous* les enfants
class detQuantifier
import
	determiner[]
	quantifierDetSem[]
declare
	 ?X ?LN ?LV
{
	<syn>{
		node xR[bot = [det = +, wh = -]];
		node xFoot[top = [det = - ]]
	}; xFoot = xNounSem
}	

% *Aucun* enfant
class detNegQuantifier
import 
	pureDeterminer[]
declare
	 ?X ?LN ?LV
{
	<syn>{
		node xR[bot=[neg-adv = -, neg-nom = +,wh = -]]
	}
}
