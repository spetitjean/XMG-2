% TOUGH ADJECTIVES (Subject raising adjectives)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% experimental (further constraints on these adjectives ?)
% other prepositions than specifically de ? sure ! which ones ?
class toughDe
declare
	?xR ?xCop ?xHead ?xPP ?xP ?xde ?xFoot ?fM ?fN ?fP ?fO ?fK
{
	<syn>{
		node xR(color=red)[cat = vn, bot = [mode=@{subj,ind},num=?fN,pers=?fP,inv = ?fO, gen = ?fK]]{
			node xCop(color=red,mark=subst)[cat = v,top=[cop = +, num = ?fN, pers = ?fP]]
			node xHead(color=red,mark=anchor)[cat = adj,top=[gen = ?fK, num = ?fN]]
			node xPP(color=red)[cat = pp]{
				node xP(color=red,mark=anchor)[cat = p]{
					node xde(color=red,mark=flex)[cat = de]
				}
				node xFoot(color=red,mark=foot)[cat = vn, top= [mode=inf,num=?fN,pers=?fP,inv = ?fO, gen = ?fK]]
			}		
		}
	}
}
 



% factor it with verbalForm (undone actually)
class adjectiveForm
declare
	?xR ?xVN ?xCop ?xHead ?fX ?fY ?fZ ?fU ?fW

{
	<syn>{
		node xR(color=black)[cat = s,bot=[mode = ?fX]]{
			node xVN(color=black)[cat = vn,top=[mode = ?fX],bot=[mode = ?fY,gen = ?fU,num = ?fZ,pers=?fW]]{
				node xCop(color=black,mark=subst)[cat = v,top=[cop = +, mode= ?fY,gen = ?fU,pers=?fW,num=?fZ]]
				node xHead(color=black,mark=anchor)[cat = adj]
			}
		}
	}
}


%PredicativeAdj
class EpithAnte
declare
	?xR ?xHead ?xFoot ?fT ?fU ?fW ?fX ?fY ?fZ
	?vX ?fG ?fK
{
	<syn>{
		node xR(color=red)[cat = n,bot=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,neg-adv = ?fG, neg-nom = ?fK,bar= 1]]{
			node xHead(color=red,mark=anchor)[cat = adj,top=[num = ?fY,gen = ?fZ]]
			node xFoot(color=red,mark=foot)[cat = n,top=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW, bar = @{0,1},neg-adv = ?fG,neg-nom = ?fK]]
		};
		vX = [det = -];fX = vX.det
	}
}
class EpithPost
declare
	?xR ?xHead ?xFoot ?fT ?fU ?fW ?fX ?fY ?fZ ?fG ?fK
{
	<syn>{
		node xR(color=black)[cat = n,bot=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar = 1,neg-adv = ?fG,neg-nom = ?fK]]{
			node xFoot(color=red,mark=foot)[cat = n,top=[neg-adv = ?fG,neg-nom = ?fK,det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar = @{0,1}]]
			node xHead(color=black,mark=anchor)[cat = adj,top=[num = ?fY,gen = ?fZ]]
		}
	}
}


%class for working w/ Object Attribute Construction
% La construction à attribut de l'objet devrait être retravaillée
class dummyAdjective
declare
	?xHead
{
	<syn>{
		node xHead(color=red,mark=anchor)[cat = adj]	
	}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADJECTIVAL NOMINAL FAMILIES
% (epith. are missing due to a probable bug in the compiler)
% missing: adjectival diathesis
class n0vA
{
	{Subject[]; adjectiveForm[]}
	|EpithAnte[]			
	|EpithPost[]
	|dummyAdjective[]
}
class s0vA
{
	{SententialSubject[];adjectiveForm[]}
	|EpithAnte[]
	|EpithPost[]
	|dummyAdjective[]
}
class n0vAden1
{
	{
		{Subject[];adjectiveForm[];Genitive[]}
		|{EpithPost[];CanonicalGenitive[]}
		|dummyAdjective[]
	}
}
class n0vAan1
{
	{
		{Subject[];adjectiveForm[];Iobject[]}
		|{EpithPost[];CanonicalIobject[]}
		|dummyAdjective[]
	}
}
class n0vApn1
declare
	?X
{
	{
		{Subject[];adjectiveForm[];Oblique[]*=[prep = ?X]}
		|{EpithPost[];CanonicalOblique[]*=[prep = ?X]}
		|dummyAdjective[]
	}*=[prep1 = ?X]
}
class n0vAan1pn2
declare
       ?X
{
	{
		dummyAdjective[]
		|{Subject[];adjectiveForm[];Iobject[];Oblique[]*=[prep = ?X]}
		|{EpithPost[];CanonicalIobject[];CanonicalOblique[]*=[prep = ?X]}
	}*=[prep2 = ?X]
}
class n0vAan1den2
{
	{
		{Subject[];adjectiveForm[];Iobject[];Genitive[]}
		|{EpithPost[];CanonicalIobject[];CanonicalGenitive[]}
		|dummyAdjective[]
	}
}

class n0vAdes1
{
	{
		{Subject[];adjectiveForm[];SententialDeObject[]}
		|{EpithPost[];SententialDeObject[]}
		|dummyAdjective[]
	}
}

class n0vAdes1pn2
declare 
	?X
{
	{
		{Subject[];adjectiveForm[];SententialDeObject[];Oblique[]*=[prep = ?X]}
		|{EpithPost[];SententialDeObject[];CanonicalOblique[]*=[prep = ?X]}
		|dummyAdjective[]
	}*=[prep2 = ?X]
}





%ADJECTIVAL FAMILIES W/SENTENTIAL ARGS
%todo
