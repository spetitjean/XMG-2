%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%* Nominals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%  TERMINAL CLASSES %%%%%%%%%%%%
% Jean 
% L:jean(X)
class propername
declare ?xN ?N ?G ?L ?I
{
	<syn>{
		node xN(color=black,mark=anchor)[cat = n,bot=[pers = 3, det = + ,nomPropre = + ,num=N,gen=G,label=L,index=I]]}*=[arg0=I,label=L,num=N, gen=G];
	properNounQuantifierSem[]
}

% Noun used as predicate 
% Tex nomme Tammy presidente

class nounPredicate
declare ?xN ?N ?G ?L ?I
{
	<syn>{
		node xN(color=black,mark=anchor)[cat = n,bot=[pers = 3, det = - ,nomPropre = - ,num=N,gen=G,label=L,index=I]]}*=[arg0=I,label=L,num=N, gen=G];
	adjectiveProperty[]
}
class pronoun
declare ?xN ?N ?G ?P
{
	<syn>{
	       node xN(color=black,mark=anchor)[cat = n,top=[det = +,num=N,gen=G,pers=P,wh = - ]]
		}*=[num=N, gen=G,pers=P];
	pronounQuantifierSem[]
}
class whPronoun
export ?xN
declare ?xN ?N ?G ?E ?L
{
	<syn>{
	       node xN(color=black,mark=anchor)[cat = n,top=[det = +,wh= + ]]
		}
}
%Qui chante?
class whSubjectPronoun
import whPronoun[]
{
	<syn>{
	       node xN[top=[func = suj]]};
	whSubjectPronounQuantifierSem[]
}
%Qui Jean aime t'il?
class whNonSubjectPronoun
import whPronoun[]
declare ?fF
{
	<syn>{ node xN[top=[func = fF]] };
	whNonSubjectPronounQuantifierSem[]
}
%Chante t'il?
class whSubjectClitic
import questionCliticSem[]
declare ?xN ?N ?G ?E ?L
{
	<syn>{
	       node xN(color=black,mark=anchor)[cat =cl,top=[det = +,num=N,gen=G,inv= + ,vbI=E,vbL=L]]
		}*=[num=N, gen=G,vbI=E,vbL=L]}

%Jean demande **si** Pierre vient
class complementiser 
declare ?xN
{
	<syn>{
	       node xN(color=black,mark=anchor)[cat = n,bot=[det = +,wh= + ]]
		};
	nounSem[]
}
% je, tu,le, me, se (constant semantics eg je, tu, me, le, se)
class CliticT
declare ?xN ?N ?G
{
	<syn>{
	       node xN(color=black,mark=anchor)[cat =cl,bot=[det = +,num=N,gen=G,inv= - ]]
		}*=[num=N, gen=G];
	pronounQuantifierSem[]
}
% il (null semantics)
class expletive
declare
	?xCl ?xN ?L
{
	<syn>{
		node xN(color=black,mark=anchor)[cat = cl,bot=[lemanchor=L]]}
}
% personne, aucun, etc... used as pronouns
class indefQuantifier
import
		quantifierSem[]
declare
	?xH ?N ?D ?G
	{<syn>{
		node xH(color=red,mark=anchor)[cat = n, bot = [det = +,wh = -,neg-nom = - ,neg-adv = -,num=N,def=D,gen=G]]
	}*=[num=N, def=D,gen=G];
	xH = xNounSem}


% NOUNS
%%%%%%%

class possessiveNoun
declare
	?xN ?N ?G ?fM ?L ?I ?P
{
	<syn>{
 		node xN(color=black,mark=anchor)[cat = n,bot=[det = -,pers = P,wh = -,bar = 0,num=N,gen=G,mass =?fM,label=L,index=I]]
	}*=[num=N,gen=G,person=P,idx=I,label=L];
	possessiveQuantifierSem[]
}
class noun
declare
	?xN ?N ?G ?fM ?L
{
	<syn>{
 		node xN(color=black,mark=anchor)[cat = n,bot=[det = -,pers = 3,wh = -,bar = 0,num=N,gen=G,mass =?fM,label=L]]
	}*=[num=N,gen=G];
	nounSem[]
}

%% NOMS QUESTION
%% Mots introduisant une semantique du type "question(e)" ou e est la
%% variable évenementielle

% CG: t-il
%propag du mode avec valeur disj @?fX{ind,subj} 
class InvertedSubjClitic
import 
       footProj1[]
       qtilSem[]
declare
	?xR ?xfoot ?xCl ?fA ?fT ?fM ?fX ?fY ?fZ ?fU ?fV ?fW ?fG ?fK ?E ?L ?Q ?X ?fP
{
	<syn>{
		node xR(color=black)[cat = v,bot = [inv =  + , num = ?fY, pers= ?fZ, gen = ?fU,aux = ?fV ,aux-pass = ?fW,neg-nom = ?fK,tense=?fT,mode=?fM,aspect=?fA,princ=?fP]]{
			node xfoot(color=black,mark=foot)[cat =v,top=[tense=?fT,mode=?fM,aspect=?fA,idx=E,label=L,inv = -, num = ?fY, pers = ?fZ, gen = ?fU, aux = ?fV, aux-pass=?fW,neg-adv = - ,neg-nom = ?fK,invertedCliticIdx=Q,princ=?fP],bot=[invertedCliticIdx=X,inv= - ,mode = @{ind,subj},princ= + ,cleftmod = - ,cleft= - ]]
			node xCl(color=red,mark=anchor)[cat = cl,top=[num=?fY,pers=?fZ,gen = ?fU]]
		}
	}*=[vbL=L,vbI=E,num=?fY,pers=?fZ];
	xSemFoot = xfoot
}

%% est ce que (pour S)
%% changed inv = +|- to inv = +

class estceque
%import footProj2[]
declare
	?xR ?xVN ?xHead ?xCl  ?xCe ?xS ?xComp ?xQue ?xFoot ?E ?xV  ?L
{
	<syn>{
		node xR(color=black)[cat = s,bot=[inv = +,wh = -]]{
			node xVN(color=red)[cat=vp]{
                          	node xHead(color=red,mark=anchor)[cat = v,bot=[tense=pres,pers=3,num=sg,mode=ind]]
				node xCl(color=red,mark=nadj)[cat = cl,top=[case = suj]]{
					node xCe(color=red,mark=flex)[cat = ce]
				}
			}
			node xS(color=black,mark=nadj)[cat = s]{
				node xComp(color=red)[cat=c]{
					node xQue(color=red,mark=flex)[cat = que]
				}
 				node xFoot(color=black,mark=foot)[cat = s,top=[inv = - ,wh = - ,cleft= - ],bot=[idx=E,label=L]]
			}
		} 		
	};
	questionmarkSem[L,E]}
class nestcepas
%import footProj2[]
declare
	?xR ?xFoot ?xVN ?xNe ?xEtre ?xCe ?xPas ?E ?L
{
<syn>{
  node xR(color=red)[cat = s,bot=[inv = +,wh = -]]{
     node xFoot(color=red,mark=foot)[cat = s,top=[inv = - ,wh = - ,princ = + ,idx=E,label=L]]
     node xVN(color=red)[cat=vp]{
     	  node xNe(color=red,mark=subst)[cat = cl,bot=[lemanchor=ne]]
     	  node xEtre(color=red,mark=anchor)[cat = v,top=[tense=pres,pers=3,num=sg,mode=ind]]
	  node xCe(color=red,mark=flex)[cat = ce]
	  node xPas(color=red,mark=flex)[cat = pas]}}};
	questionmarkSem[L,E]}

%% est ce que (pour VP)
class estcequeVP
import
       footProj2[]
declare
	?xR ?xVN ?xHead ?xCl ?xS ?xComp ?xQue ?xFoot ?xCe ?E
{
	<syn>{
		node xR(color=black)[cat = vp,bot=[inv = @{+,-},wh = -]]{
			node xVN(color=red)[cat=vp]{
				node xHead(color=red,mark=anchor)[cat = v,top=[tense=pres,pers=3,num=sg,mode=ind]]
				node xCl(color=red)[cat = cl,top=[case = suj]]{
					node xCe(color=red,mark=flex)[cat = ce]
				}
			}
			node xS(color=black,mark=nadj)[cat = s]{
				node xComp(color=red)[cat=c]{
					node xQue(color=red,mark=flex)[cat = que]
				}
 				node xFoot(color=black,mark=foot)[cat = vp,top=[inv = -,wh = -],bot=[idx=E]]
			}
		}
		
	};
	xSemFoot = xFoot;
	basicProperty[]*=[arg0=E]
}
