%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defectiveVerbs.mg
%%%%%%%%%%%%%%%%%%%
%% not in lemmas.syn (not a terminal class) 
class TenseAux
import
	basicProperty[]
	VerbArg0Linking[]
	VerbSem[]
	footProj1[]
export 
	xFoot xL xRoot
declare
	?xFoot ?xL ?xRoot ?fM ?fP ?fN ?fO ?fG ?fK ?fT ?fS ?fGen
{
	<syn>{
		node xRoot(color=black,mark=nadj)[cat = v,top=[gen=?fGen,num=?fN,pers=?fP,mode=fM,tense=?fT,aspect=?fS,aux-pass= +, inv = ?fO,neg-adv = ?fG, neg-nom = ?fK]]{
		 node xL(mark=anchor,color=red)[cat = v, top=[gen=?fGen,inv = ?fO,neg-adv = ?fG,neg-nom = ?fK],bot = [mode=fM,tense=?fT, mode=?fM,aspect=?fS,num=?fN, pers=?fP,inv = - ]]
		 node xFoot(mark=foot,color=black)[cat = v,bot=[gen=?fGen,tense=?fT, mode = ppart,aspect=?fS,num=?fN, pers=?fP]]
		};
		xVerbSem = xFoot;		
		xSemFoot = xFoot
	}
}
% should have no semantics; should be triggered by morphological generation
% use semantics : past(e)
class AvoirAux
import
	TenseAux[]
declare
	?fN ?fG ?A
{
	<syn>{
		node xRoot[bot=[pp-num = ?fN, pp-gen = ?fG]]{
			node xFoot[top=[pp-num = ?fN, pp-gen = ?fG, aux = avoir]]
		}
	}
}
% no semantics; triggered by morphology
class EtreAux
import
	TenseAux[]
declare
	?fN ?fG 
{
	<syn>{
		node xRoot[bot=[num = ?fN, gen = ?fG]]{
			node xFoot[top=[pp-num = ?fN, pp-gen = ?fG, aux = etre]]
		}
	}
}

%* <Copule> 
%%%%%%%%%%%%%%%%%%%%%%%%

% copula be 
% Tammy est une amÃ©ricaine
% C'est une amie

class ** copulaBe
{
	copulaRel[]; dian0Vn1Active[]
}

class Copule
declare 
	?xV
{
	<syn>{
		node xV(color=red,mark=anchor)[cat = v,bot=[cop = +,inv = - , lemanchor = etre]]
		}
}


% SEMI-AUXILIARIES (Subject Raising verbs)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Todo : extend the representation to handle negation
% e.g. Personne ne semble venir
% Personne ne semble ne pas venir 
%CG:15/03/07 added cest = - on foot node to block adjunction on cleft "c'est"-VP
class SemiAux
import
	raisingSem[]
	VerbArg0Linking[]
	anchorProj1[]
declare
	?xRoot ?xL ?xFoot ?fM ?fP ?fN ?fM ?fK ?fO ?fG ?fH ?fL
{
	<syn>{
		node xRoot(color=black)[cat = vp,bot=[mode=?fM,num=?fN,pers=?fP,inv = ?fO, gen = ?fK,neg-nom = ?fG, neg-adv = ?fH]]{
			node xL(mark=anchor,color=black)[cat = v, top=[mode=?fM, num=?fN, pers=?fP,inv = ?fO],bot=[inv = -]]
			node xFoot(mark=foot,color=black)[cat = vp,top=[mode = inf, num = ?fN,gen = ?fK,neg-adv = ?fH,neg-nom = ?fG,label=?fL],bot=[cest= - ]]
		}
	}*=[argLabel=?fL,scopeLabel=?fL];
		xAnchor = xL}
% avoir l'air de
%%%%%%%%%%%%%%%%%%%%%%%

class SemiAuxNPde
import
	basicProperty[]
	VerbArg0Linking[]
	VerbSem[]
	footProj2[]
declare
	?xRoot ?xHead ?xP ?xDe ?xPP ?xN ?xFoot ?fM ?fP ?fN ?fM ?fK ?fO
{
	<syn>{
		node xRoot(color=black)[cat = vp,bot=[mode=?fM,num=?fN,pers=?fP,inv = ?fO, gen = ?fK]]{
			node xHead(mark=anchor,color=red)[cat = v, top=[mode=?fM, num=?fN, pers=?fP,inv = ?fO]]
			node xN(mark=anchor,color=black)[cat = n]
			node xPP(color=black)[cat = pp]{
				node xP(color=red)[cat = p]{
					node xDe(color=red,mark=flex)[cat = de]
				}
				node xFoot(mark=foot,color=black)[cat = vp,top=[mode = inf, num = ?fN,gen = ?fK]]	
			}
		}
	};
		xVerbSem = xFoot;
		xSemFoot = xFoot
}

% Venir de
%%%%%%%%%%%%%%%%%%%%%%
class SemiAuxDe
import
	basicProperty[]
	VerbArg0Linking[]
	VerbSem[]
	footProj2[]
declare
	?xRoot ?xHead ?xP ?xDe ?xPP ?xN ?xFoot ?fM ?fP ?fN ?fM ?fK ?fO
{
	<syn>{
		node xRoot(color=black)[cat = vp,bot=[mode=?fM,num=?fN,pers=?fP,inv = ?fO, gen = ?fK]]{
			node xHead(mark=anchor,color=red)[cat = v, top=[mode=?fM, num=?fN, pers=?fP,inv = ?fO]]
			node xPP(color=black)[cat = pp]{
				node xP(color=red)[cat = p]{
					node xDe(color=red,mark=flex)[cat = de]
				}
				node xFoot(mark=foot,color=black)[cat = vp,top=[mode = inf, num = ?fN,gen = ?fK]]	
			}
		}
	};
		xVerbSem = xFoot;		
		xSemFoot = xFoot
}


