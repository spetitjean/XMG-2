%%%%%%%%%%%%%%%%%%%%
%	PredArgs.mg
%%%%%%%%%%%%%%%%%%%%%%

class TopLevelClass
% %# dummy class that provides a single root to the inh. hierarchy
export
	xS 
declare
         ?xS 


class VerbalArgument
import 
	TopLevelClass[]
export
	xVN
declare
        ?xVN 
{
        <syn>{
                node xS(color=white)[cat = @{s,n}]{
                        node xVN(color=white)[cat = @{vp,adj,n}]
                }               
        }
}

class NonCanonicalObject 
%# This class sets up Past Participle agreement w/ auxiliary 'avoir'
export 
	xVNAgr xObjAgr
declare 
	?xObjAgr ?xVNAgr ?fX ?fY
{
	<syn>{
		node xVNAgr[cat=v,bot=[pp-gen=?fX,pp-num=?fY]];
		node xObjAgr[top=[num=?fY,gen=?fX]]
	}
}

class CanonicalArgument
import 
	VerbalArgument[]

%# dummy for now

class EmptySubject
import 
	VerbalArgument[]

%CG 12/3/7 added inv = - to block main sentences with inverted subject (aboie le chien?)
%CG: 11/2/12 remove cat=n option to only allow for full NP (pronoun allowed by InvertedSubjectClitic) 
% Quand viendra Paul ?
% Je me demande quand viendra Paul?
class InvertedSubject
import 
	VerbalArgument[]
	SubjectAgreement[]
export
	xArg
declare
	?xArg {

		<syn>{
			node xS[bot = [inv = + ]];
			node xVN [cat=vp,top=[mode=ind,inv= + ]];
			node xArg(color = red,mark=subst)[top = [ det = + ,func=suj]]
			};
		xSubjAgr = xArg;
		xVNAgr = xVN}

% Je me demande quand viendra Paul?
% Quand viendra Paul?
% ** Viendra Paul? 
class InvertedNominalSubject
import 
       InvertedSubject[]
declare ?xV
{	<syn>{ 	node xS[bot = [princ = - ]];
		node xArg[cat=n,top=[wh = - ,func=suj]];		
		node xV(mark=anchor,color=white,rank=7)[cat=@{v,adj,n,pp},top=[mode=ind], bot=[inv = + ]];
		xVN -> xV; xVN -> xArg;
		xVN >> xArg
}}

% ***Je me demande quand viendra-t'il?
% Quand viendra-t'il?
class InvertedCliticSubject
import 
       InvertedSubject[]
declare ?xV
{	<syn>{ node xS[bot = [princ = + ]];
	       node xVN{
	       	    node xV(mark=anchor,color=white,rank=7)[cat=@{v,adj,n,pp}]
    	       	    node xArg[cat=cl,top=[inv= + ,func=suj]]}}}


% expletive inverted "il" (neige-t'il?)
% Rmved:  node xIl(mark=subst,color=red)[cat=cl,
class ** InvertedIlSubject
import 
	VerbalArgument[]
	SubjectAgreement[]
declare
	?xSubj ?I ?L ?E ?xIl
{
		<syn>{
			node xS[bot = [wh = -,inv = n]]{
				node xVN [top = [inv = -]]
				,,,node xSubj(color = red,mark=subst)[cat = cl,top=[inv = + ],bot=[lemanchor=il]]}};
		xSubjAgr = xSubj;
		xVNAgr = xVN
}




% Quand viendra Paul?
% Je demande quand viendra Paul?
% ** Quand verra Paul sa mère ?
class NonInvertedNominalSubject
declare
	?xS ?xVN ?fX ?VA
{
	<syn>{
		node xS[bot = [inv = ?fX]];
		node xVN[cat=vp, top = [inv = ?fX, mode = @{ind,subj}]]
	};
	VA = VerbalArgument[] ;
	xS = VA.xS ;
	xVN = VA.xVN
}
%% 12/10/05 added mode = inf on xS (s) node : 
% the infinitival subject constraints the sentence mode 
% added zeroObjectI to reflect the possibility of an ellided object to be controlled (eg le livre est difficile a comprendre ??) 

class ** InfinitiveSubject
import 
	EmptySubject[]
declare
	?fX ?fY ?fZ
{
	<syn>{	
		node xS[bot=[control-num=?fX,control-gen=?fY,control-pers=?fZ,mode=inf]]{			
                            node xVN[top=[num=?fX,gen=?fY,pers=?fZ]]
		}
	}
}
%CG 11/3/7 added tuSubjectI=tu to block instantiation of the empty imperative subject
class ** ImperativeSubject
import 
	EmptySubject[]
declare ?xV
{
	<syn>{
		node xVN[top=[mode=imp,pro-idx = tu, pers=@{1,2}]];
                node xV(mark=anchor,color=white,rank=1)[cat=v];
		xVN -> xV
	}
}

% Forces adjunction of an inverted clitic subject at V level
% Verra t'il sa mère ? 	 	  on n0V-InterrogInvSubject
% ** Je demande quand verra t'il sa mère (princ = +)
class ** InterrogInvSubject
import 
       EmptySubject[]
declare
	?xV
{
	<syn>{
		node xS[bot =[inv = +,mode = ind,princ = + ]]{
		     node xVN[top = [inv = + ]]{
		     	node xV(color=white)[cat = v,bot=[mode=ind]]}
		}
}}

class NounPredicateAgreement
declare ?xS ?xN ?xPred ?fN ?fG
{
<syn>{
	node xS(color=white)[cat=s]{
       	     node xN(color=white)[cat=n,top=[num = ?fN, gen = ?fG]]
	     node xPred(color=white)[cat=@{adj,n},top=[num = ?fN, gen = ?fG]]}}}


class SubjectAgreement
%# Accord Sujet -- Verbe
export
	xSubjAgr xVNAgr
declare 
	?xSubjAgr ?xVNAgr ?fX ?fY ?fZ
{
	<syn>{
		node xSubjAgr[top=[num = ?fX, gen = ?fY, pers = ?fZ]];
		node xVNAgr[top=[num = ?fX, gen = ?fY, pers = ?fZ]]
	}
}

class RealisedNonExtractedSubject 
import 
	CanonicalArgument[]
	SubjectAgreement[]
	NonInvertedNominalSubject[]
export
	xArg
declare
        ?xArg ?fX ?fY ?fZ
{
	<syn>{
		node xS{
			node xArg(color=black)[top=[det = +, wh = - ,func=suj]]
			node xVN(color=white)[cat = vp]
		};
		xArg = xSubjAgr;
		xVN = xVNAgr
	}
}

class ** CanonicalSubject
import
        RealisedNonExtractedSubject[]
%	EpithOrCanSubj[]
declare 
	?fG ?fK  ?xV
{
        <syn>{
	     node xVN [top=[neg-nom = ?fG],bot=[neg-adv = ?fK]];
             node xArg(mark=subst)[cat = n,top=[neg-nom = ?fG,neg-adv = ?fK]];		
	     node xV(mark=anchor,color=white,rank=7)[cat=@{v,adj,n,pp}];
	     xVN -> xV}}

class ** DoubleInterrogSubject
import 
       CanonicalSubject[]
declare
	?xV
{
	<syn>{
		node xS[bot =[inv = +,mode = ind,princ = + ]]{
		     node xVN[top = [inv = + ]]{
		     	node xV(color=white,rank=7)[cat = @{v,adj,n,pp},bot=[inv = - ]]}
		}}}

class ** CliticSubject
import
       	RealisedNonExtractedSubject[]
declare ?xV
{
        <syn>{
	     node xVN[top = [inv = - ]];       
             node xArg(color=black,mark=subst)[cat = cl,top=[case=nom,inv= - ]];		
	     node xV(mark=anchor,color=white,rank=7)[cat=@{v,adj,n,pp}];
	     xVN -> xV}}

class ** ImpersonalSubject
import
        RealisedNonExtractedSubject[]
declare 
	?L
{
	<syn>{                
             node xArg(mark=subst)[cat=cl,bot=[lemanchor=il,inv = - ],top=[num = sg,pers=3,gen=m]]}
}
%		   node xil(color=red,mark=flex)[cat=@{il,ce}] %		   node xil(


class ** CanonicalSententialSubjectFinite
%#Que Jean aille à la montagne plait à Marie
import
	CanonicalArgument[]
export
	xArg
declare
	?xArg ?xTop ?xComp ?xQue ?E ?L
{
	<syn>{
		node xS{
			node xTop(color=red)[cat=s]{
				node xComp(color=red)[cat=c]{
					node xQue(color=red,mark=flex)[cat=que]
				}
				node xArg(color=red,mark=subst)[cat=s,top=[mode = subj, inv = -, wh = -, princ = -,func=suj]]
			}
			node xVN
		}
	}
}

class ** CanonicalSententialSubjectInFinitive 
%#Aller à la montagne plait à Marie
import 
	CanonicalArgument[]
export
	xArg
declare
	?xArg 
{
	<syn>{
		node xS{
			node xArg(color=red,mark=subst)[cat=s, top=[ mode = inf, princ = -, inv = -, wh = -,func=suj]]
			node xVN
		}
	}
}

class CanonicalnonSubjectArg 
%# = postverbal arg
import
        CanonicalArgument[]
export
        xtop
declare
        ?xtop
{
        <syn>{
                node xS{
                        node xVN
                        ,,,node xtop(color=black) 
                }
        }

}
class ** CanonicalObject
import
        CanonicalnonSubjectArg[]
export xArg
declare 
	?fK ?fG ?I ?xArg ?xV
{
<syn>{
	node xVN[top=[neg-nom = ?fK],bot=[neg-adv = ?fG]]
		     {node xV(color=white)[cat=v,bot=[pp-num=sg,pp-gen=m]]};
        node xtop(mark=subst)[cat = n,top=[det = +,neg-adv = ?fG,neg-nom = ?fK,func=obj,wh= - ]];
	xS -> xVN; xS -> xtop; xVN >> xtop;
	xtop = xArg
}}

class ** CanonicalNBar[X,L]
import
	CanonicalnonSubjectArg[]
export xArg
declare
	?fX ?fY ?xArg
{
	<syn>{
		node xtop(mark=subst)[cat = n, top=[det = -, func = obj]]
	};
	xtop=xArg
}

%% pp(p([prep]) !n)
class CanonicalPP
import
        CanonicalnonSubjectArg[]
export
        xArg xX
declare
        ?xArg ?xX ?fG ?fK
{
        <syn>{
                node xtop[cat = pp]{
                        node xX (color=red)[cat = p]
                        node xArg(mark=subst,color=red)[cat = n, top = [wh= - , det = + ]]
                }
        };
	<syn>{
		node xArg[top = [neg-adv = ?fG,neg-nom = ?fK]];
		node xVN [top = [neg-nom = ?fK],bot = [neg-adv = ?fG]]
	}
}

class CanonicalPPnonOblique
import 
	CanonicalPP[]
export 
	xPrep
declare
	?xPrep
{
	<syn>{
		node xX{
			node xPrep(color=red,mark=flex)
		}
	}
}



class ** CanonicalCAgent
import 
	CanonicalPPnonOblique[]
{
	<syn>{
		node xPrep[cat = par];
		node xArg(name=genitiveN)[top = [func = obl]]	
	}
}

class **  CanonicalGenitive
import 
	CanonicalPPnonOblique[]
{
	<syn>{
		node xPrep[cat = de];
		node xArg(name=genitiveN)[top = [func = gen]]	
	}
}

class ** CanonicalIobject
import 
	CanonicalPPnonOblique[]
{
	<syn>{
		node xPrep[cat = à];
		node xArg[top = [func = iobj]]	
	}
}

class ** CanonicalOblique[]
import
	CanonicalPP[]
declare 
	?xLex
{
	<syn>{
		node xX(color=red){
			node xLex(color=red,mark=coanchor,name=obliquePrep)
				};
		node xArg(name=obliqueN)[top = [func = obl]]	
	}
}

class ** CanonicalLocative
import 
	CanonicalnonSubjectArg[]
export
	?xArg
declare 
	?xX ?xLex ?xArg
{
	<syn>{
		node xtop(color=red){
		        node xX(color=red)[cat=p]{
				node xLex(color=red,mark=flex,name=locativePrep)[cat=en]}
			node xArg(color=red,mark=subst)[cat=n,top=[wh = - ,func=obl]]
				}
	}
}

class Infinitive
export
	xCtrollee
declare 
	?xCtrollee  
{
	<syn>{
		node xCtrollee(color=black)[top = [mode = inf]]
	}
}

class Subject-Control
%# Implements subject-control
% the interface will be inherited by all infinitival objects (a, de, nothing)
import 
	Infinitive[]
export 
	xVNCtroller
declare 
	?xVNCtroller ?fX ?fY ?fZ
{
	<syn>{
		node xCtrollee[top=[control-num = ?fX, control-gen = ?fY, control-pers = ?fZ]];
		node xVNCtroller(color=white)[top=[num = ?fX, gen = ?fY, pers = ?fZ]]
	}
}

class CanonicalSententialXObjectWithComplementizer
import
	CanonicalnonSubjectArg[]
export 
	xComp xArg
declare
	?xX ?xComp ?xArg ?fT
{
	<syn>{
		node xtop(mark=nadj)[cat=s,bot=[argtense=?fT]]{
			node xX (color = red)[cat=c]{
				node xComp(color=red,mark=flex)
			}
			node xArg(color = black)[cat = s,top=[argtense=?fT,tense=?fT,wh = -,princ = -, inv = -,func=obj]]
		};
		node xS[bot=[tense=?fT]]	
}	
}

class CanonicalSententialXObjectWithComplementizerNonBounding
import
	CanonicalSententialXObjectWithComplementizer[]
{
	<syn>{ 
		node xArg(xcomp = +)		
	}
}

class CanonicalSententialXObjectWithComplementizerBounding
import
	CanonicalSententialXObjectWithComplementizer[]
{
	<syn>{
		node xArg(mark=subst)
	}
}
%% CG added foot mark on xArg -- now removed
% CG 12/3/7 remove finite mode on xArg
% t50
class ** CanonicalSententialObjectFinite
import
	CanonicalSententialXObjectWithComplementizerNonBounding[]
{
	<syn>{
		node xComp[cat=que];
		node xArg(name=sarg)[top=[mode = @{ind,subj},func=obj], bot = [cleft = - , wh = - ]]
	}
}

class CanonicalSententialXObjectwithoutComplementizer
import
	CanonicalnonSubjectArg[]
export
	?xArg
declare
	?xArg
{
	<syn>{
		node xtop(color=red)[cat=s];
		xtop = xArg
	}
}

class CanonicalSententialXObjectwithoutComplementizerBounding
import 
	CanonicalnonSubjectArg[]
export
	xArg
declare
	?xArg
{
	<syn>{
		node xtop(color=red,mark=subst)[cat=s];
		xtop = xArg
	}
}

class CanonicalSententialXObjectwithoutComplementizerNonBounding
import	CanonicalnonSubjectArg[]
export
	xArg
declare
	?xArg
{
	<syn>{
		node xtop(color=black,xcomp= +)[cat=s] ;
		xtop = xArg
	}
}
%CG 12/3/7 added bot=[mode=inf] to block combination of jean dit que avec paul partir
class ** CanonicalSententialObjectInFinitive
import
	CanonicalSententialXObjectwithoutComplementizerNonBounding[]
	Subject-Control[]
	ControlleeSem[]
%	SubjectControlLinking[]
%export
%	xArg
declare
	?fX ?fY ?fZ % ?xArg
{
	<syn>{
		node xtop[top=[mode=inf, princ = - ,func=obj], bot=[mode=inf]];
		xCtrollee = xtop;
		xVNCtroller = xVN;
		xtop = xArg;
		xArg = xSententialArg
	}
}

class CanonicalSententialObjInfWithComplementizer
import
	CanonicalSententialXObjectWithComplementizerNonBounding[]
	Subject-Control[]
	ControlleeSem[]
%	SubjectControlLinking[]
{
	<syn>{
		node xArg[top=[mode=inf,wh= -, princ = -,func=obj]];
		xCtrollee = xArg;
		xVNCtroller = xVN			
	};
	xArg = xSententialArg
}

class ** CanonicalSententialObjectInFinitiveDe
import
	CanonicalSententialObjInfWithComplementizer[]
{
	<syn>{
		node xComp[cat=de]
	}
}

class ** CanonicalSententialObjectInFinitiveA
import
	CanonicalSententialObjInfWithComplementizer[]
declare
	?O
{
	<syn>{
		node xComp[cat=à]
	}
}
%jean se demande qui part
class ** CanonicalSententialObjectInterrogativeFiniteWithoutComplementizer
import
	CanonicalSententialXObjectwithoutComplementizerNonBounding[]
{
	<syn>{
		node xtop[top=[mode=@{ind,inf},wh = + ,inv= - , princ = - ,cleft = - ]]
	}
}
%jean se demande si Jean part
class ** CanonicalSententialObjectInterrogativeFiniteWithComplementizer
import
	CanonicalSententialXObjectWithComplementizerBounding[]
{
	<syn>{
		node xComp(color=red)[cat=si]
	};
	<syn>{
		node xArg(color = black)[cat = s,top=[wh = -,inv = -,princ = -,func=obj]]
	}
}

class ** CanonicalSententialObjectInterrogativeInFinitive
import  
	CanonicalSententialXObjectwithoutComplementizerBounding[]
	Infinitive[]
{
	<syn>{
		node xtop [top =[wh = +,mode = inf,princ = -]];
		xtop = xCtrollee
	}
}

class Clitic
import 
	VerbalArgument[]
export 
	xArg xV
declare
	?xArg ?xV
{
	<syn>{
		node xArg(color=red,mark=subst)[cat=cl];
		node xV(color=white)[cat=v];
		xVN -> xArg; xVN -> xV
		}}

class nonReflexiveClitic
import 
	Clitic[]
%declare
	%?xArg
{
	<syn>{
		node xArg[top=[refl = -]]
	}
}

class ** CliticObjectII
%# Clitic subject ? see above (near canonical subject)
%# me te le les la nous vous leur leurs
import 
	nonReflexiveClitic[]	
declare
	?NCO
{
		NCO = NonCanonicalObject[];
		xArg= NCO.xObjAgr;
		xVN = NCO.xVNAgr;	
	<syn>{
		node xArg(rank=2)[top=[case=acc,func=obj,pers = @{1,2}]]
	
	}
}

class ** CliticIobjectII
import 
	nonReflexiveClitic[]
{
	<syn>{
		node xArg(rank=2)[top=[case=dat,func=iobj, pers = @{1,2}]]
	}
}
class ** CliticObject3
import 
	nonReflexiveClitic[]
declare
	?NCO 
{
	<syn>{
		node xArg(rank=3)[top=[func= obj,pers=3]]
		
	};
	NCO = NonCanonicalObject[];
	xArg = NCO.xObjAgr;
	xV = NCO.xVNAgr
}

class ** CliticIobject3
import 
	nonReflexiveClitic[]
{
	<syn>{
		node xArg(rank=4)[top=[case=dat3rd,func=iobj,pers=3]]
	}
}
class ** CliticGenitive
import 
	nonReflexiveClitic[]
{
	<syn>{
		node xArg(rank=5)[top=[func=gen]]
	}
}
class ** CliticLocative
import 
	nonReflexiveClitic[]
{
	<syn>{
		node xArg(rank=6)[top=[func=loc]]
	}
}

class reflexiveClitic
%# Special clitics : reflexive
%# me te se nous vous se 
import 
	Clitic[]
declare ?I
{
	<syn>{
		node xArg[top=[refl = + ,idx = I]]
	}*=[iobjectI = I,arg1=I]
}


class ** reflexiveAccusative
import 
	reflexiveClitic[]
declare 
	?fX ?fY ?NCO
{
	<syn>{
		node xArg(mark=subst,rank=2)[top=[case=acc,func=obj,num=?fX,pers = ?fY]];
		node xVN[top=[num=?fX,pers=?fY]]
	};
	NCO = NonCanonicalObject[];
	xArg = NCO.xObjAgr;
	xVN = NCO.xVNAgr
}


class ** reflexiveDative
import
	reflexiveClitic[]
{
	<syn>{
		node xArg(mark=subst,rank=2)[top=[func=iobj,case=dat]]
	}
}
%% CG 01/06: removed nadj on xS to allow adjunction of estceque
%% a qui est ce que jean parle
class UnboundedExtraction
import 
	VerbalArgument[]
	xSProj1[]
export
	xSe xtop
declare
	?xSe ?xtop ?fX ?M ?P
{
	<syn>{
		node xSe(color=black,extracted)[cat = s,bot=[mode=M,princ=?P]]{
			node xtop(color=black)
			node xS[top=[inv = @{+,n,-},mode=M,princ= - ]] 
		};
	xS = xXS
	}
}

class UnboundedQuestion
import 
	UnboundedExtraction[]
declare 
	?fX ?fInv
{
	<syn>{
		node xSe[bot=[act=ques,wh = + , princ = + , inv = ?fInv]];
		node xS[top=[inv = ?fInv],bot=[princ = - ]]
	}
}

class ** whObject
import
	UnboundedQuestion[]
export 
	xArg
declare
	?NCO ?xArg ?E ?VL ?xV
{
	xtop = xArg;
	NCO = NonCanonicalObject[];
	xV = NCO.xVNAgr;
	xtop = NCO.xObjAgr;
	<syn>{
		node xtop(mark=subst)[cat = n,top=[wh = + , func = obj,vbI=E,vbL=VL]];		
		node xV(color=white)[cat=v];
		xVN -> xV
	
	}*=[vbI=E,vbL=VL]
}

class ** whLocative
import
	UnboundedQuestion[]
	LocativeSem[]
export
	xArg
declare ?xArg ?E ?VL
{
	<syn>{
		node xtop(mark=subst)[cat = pp, top=[loc = +,wh = +,vbI=E,vbL=VL,func=obl]]		
	}*=[vbI=E,vbL=VL];
	xtop=xArg
}

class whPrep
import
	UnboundedQuestion[]
export 
	xArg  xX
declare
	?xArg  ?xX ?I ?L ?VL ?E
{
	<syn>{
		node xtop[cat = pp]{
			node xX(color=red)[cat = p]
			node xArg(mark=subst,color=black)[cat = n,top=[wh = +, det = +,vbI=E,vbL=VL]]
		}
	}*=[vbI=E,vbL=VL]
}

class whPrepnonOblique
import 
	whPrep[]
export 
	xPrep
declare
	?xPrep
{
<syn>{
		node xX{
			node xPrep(color=red,mark=flex)
		}
	}
}


class**  whIobject	
import
	whPrepnonOblique[]
{
	<syn>{
		node xPrep[cat = à]
	}
}

class ** whGenitive
import
	whPrepnonOblique[]
{
	<syn>{
		node xPrep[cat = de]
	}
}

class ** whCAgent
import
	 whPrepnonOblique[]
{
	<syn>{
		node xPrep[cat = par]
	}
}

class ** whOblique[]
import
	whPrep[]
declare
	?X ?xLexPrep
{
	<syn>{
		node xX(color=red)
		  {node xLexPrep(color=black,mark=flex,name=obliquePrep)}
	}
}

class UnboundedRelative
import 
	UnboundedExtraction[]
	footProj1[]
export 
       	?xArg  ?xReltop
declare
	?xArg ?xReltop ?fT ?fY ?fZ ?fU ?fW ?X ?L ?X1 ?L1
{
	<syn>{
		node xReltop(color=black)[cat = n,bot=[det = - , def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar = 3,idx=X1,label=L1],top=[idx=X,label=L]]{
			node xArg(mark=foot,color=black)[cat = n,top=[det = - , def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = - ,bar=@{0,1,2,3},idx=X1,label=L1]]
			node xSe(mark=nadj)[top=[mode = ind ]]
		};
		xArg = xSemFoot
	}
}

class ** RelativeObject
import
	UnboundedRelative[]
declare
	?NCO  ?xQue ?I ?L ?xV
{
	<syn>{
		node xtop[cat = c]{
		     node xQue(color = red,mark = flex)[cat = que,top=[wh = + ]]
		};
		node xV(color=white)[cat = v];
		xVN -> xV
	};
	NCO = NonCanonicalObject[];
	xV = NCO.xVNAgr;
	xArg = NCO.xObjAgr
}

class ** RelativeGenitive
import
	UnboundedRelative[]
declare
	?NCO  ?xQue ?xV
{
	<syn>{
		node xtop[cat = c]{
		     node xQue(color = red,mark = flex)[cat = dont,top=[wh = + ]]
		};
		node xV(color=white)[cat = v];
		xVN -> xV
	};
	NCO = NonCanonicalObject[];
	xV = NCO.xVNAgr;
	xArg = NCO.xObjAgr
}


class ** RelativeLocative
import 
	UnboundedRelative[]
{
	<syn>{
		node xtop(mark=subst)[cat = pp,top=[wh = + ,loc = +],bot=[lemanchor=où]]
	}
}

class RelativePP
import
	UnboundedRelative[]
export 
	xArgWh xX	
declare
	?xArgWh ?xX
{
	<syn>{
		node xtop[cat = pp]{
			node xX(color=red)[cat = p]
			node xArgWh(color=red,mark = subst)[cat = n,bot=[lemanchor=qui],top=[det = +, wh = +]]
		}
	}
}

class RelativePPnonOblique
import
	 RelativePP[]
export
	xPrep
declare
	?xPrep	
{
	<syn>{
		node xX{
			node xPrep(mark=flex,color=red)
		}	
	}
}

class ** RelativeIobject
import 
	RelativePPnonOblique[]	
declare ?I
{
	<syn>{
		node xPrep[cat = à];
		node xArg[top=[idx = I,func=iobj]];
		node xReltop[bot=[idx = I]]
	}
}

class ** RelativeCAgent
import 
	RelativePPnonOblique[]
declare ?I
{
	<syn>{
		node xPrep[cat = par];
		node xArg[top=[idx = I,func=cagent]];
		node xReltop[bot=[idx = I]]
	}}


class ** RelativeOblique[]
import 
	RelativePP[]
declare
	?I ?xLexPrep
{
	<syn>{
		node xX(color=red)
		  {node xLexPrep(color=black,mark=flex,name=obliquePrep)}
	}
}
%F7-12-03-07 added mode = ind on top S node to block combination with verbs taking infinitival complements
%F12-15-03-07 added cest = + on VP node xVNCleft to block adjunction of raising verbs eg "devoir c'est jean qui part"

class UnboundedCleft
import
	UnboundedExtraction[]
export 
	xClefttop fNum xV
declare
	?xCleft ?xVNCleft ?xClCleft ?xAuxCleft ?xClefttop ?xVP ?xV ?E ?fNum
{
	<syn>{
		node xCleft(color=black)[cat = s,bot=[wh = -,mode = ind]]{
			node xVNCleft(color=red)[cat=vp,bot=[cest= + ]]{
				node xClCleft(color=red,mark=subst)[cat=cl,top=[case = suj,pers=3],bot=[lemanchor=ce ]]
				node xAuxCleft(color=red,mark=subst)[cat=v,top=[mode=ind,pers=3,num=?fNum,tense=pres],bot=[lemanchor=etre,cleftmod= + ,aux= - ]]
			}
			node xClefttop(color=black)
			node xSe(mark=nadj)[top=[mode = ind, princ = - ], bot=[mode = ind,idx=?E, wh = + ]]	
		};
		node xS[bot=[cleft = + ]];
		node xVN[cat = vp];
        	node xV(color=white)[cat = v,bot=[cleft = + ]];
		xVN -> xV}}

class NominalCleft
import
	UnboundedCleft[] 
export 
	xComp xArg
declare
	?xComp  ?xArg
{
	<syn>{
		node xClefttop(mark=subst)[cat = n,top=[det = +,wh = -, num = fNum]];
		node xS[bot = [cleft = +]];
		node xtop[cat = c]{
			node xComp(color=red,mark=flex)
		}
	};
	xClefttop=xArg
}

%F10-13-03-07 added cleft = + on S node to block verb taking s arg to adjoin there
class ** CleftObject
import 
	NominalCleft[]
declare 
	?NCO
{
	<syn>{
		node xComp[cat = que];
		node xArg[top=[func=obl]]
	};
	NCO=NonCanonicalObject[];
	xV = NCO.xVNAgr;
	xArg = NCO.xObjAgr
}

class ** CleftDont
import 
	NominalCleft[]
declare ?I
{
	<syn>{
		node xComp[cat = dont]
	}
}

class PrepCompCleft
import
	UnboundedCleft[]
export 
	 xX xArg
declare 
	?xComp ?xX ?xArg
{
	<syn>{
		node xClefttop[cat = pp]{
			node xX(color=red)[cat=p]
			node xArg(color=red,mark=subst)[cat=n,top=[det = +,wh = -, num = fNum, func = obl]]		
		} 		
	};
	<syn>{
		node xtop[cat=c]{
			node xComp(color=red,mark=flex)[cat = que]
		};
		node xS[bot = [cleft = +]]
	}
}

class PrepCompCleftnonOblique[]
import
	PrepCompCleft[]
export
	xPrep
declare
	?xPrep
{
	<syn>{
		node xX{
			node xPrep(mark=flex,color=red)
		}
	}
}



class ** CleftIobjectOne
import 
	PrepCompCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = à]
	}
}

class ** CleftGenitiveOne
import 
	PrepCompCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = de]
	}
}

class ** CleftCAgentOne
import 
	PrepCompCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = par]
	}
}

class ** CleftObliqueOne[]
import 
	PrepCompCleft[]
declare
	?xLex
{
	<syn>{
		node xX(color=red){
			node xLex(color=red,mark=flex,name=obliquePrep)
				}
	}
}
class ** CleftLocativeOne
import 
	PrepCompCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = en]
	}
}

class NominalPrepCleft
import 
	UnboundedCleft[]
export
	 xArgWh xArg xX
declare
	?xX ?xArgWh ?xArg
{
	<syn>{
		node xClefttop(mark=subst)[cat = n, top = [func= obl,num = fNum]] 
	};
	<syn>{
		node xtop[cat = pp]{
			node xX(color =red)[cat = p]
			node xArgWh(color=red,mark=subst)[cat = n, top = [ wh = + , det = + ]]
		}
	};
	xClefttop = xArg
}	
class ** CleftLocativeTwo
import 
	UnboundedCleft[]
export
	xArg
declare
	?xArg
{
	<syn>{
		node xClefttop(mark=subst)[cat = n, top=[func=loc]] 
	};
	<syn>{
		node xtop(mark=subst)[cat = pp, top = [loc = + ],bot = [lemanchor = où] ]
		};
	 xClefttop = xArg
}

class  NominalPrepCleftnonOblique
import 
	NominalPrepCleft[]
export
	xPrep
declare
	?xPrep
{
	<syn>{
		node xX{
			node xPrep(mark=flex,color=red)
		}
	}
}

class ** CleftIobjectTwo
import 
	NominalPrepCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = à];
		node xArgWh[bot=[lemanchor = qui]]
	}
	}

class ** CleftGenitiveTwo
import 
	NominalPrepCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = de];
		node xArgWh(mark=nadj)[bot=[lemanchor = qui]]
	}
}
%CG:12/3/7 added nadj mark on xArg
class ** CleftCAgentTwo
import 
	NominalPrepCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = par];
		node xArgWh[bot=[lemanchor = qui]]
	}
}

class **  CleftObliqueTwo[]
import 
	NominalPrepCleft[]
{
	<syn>{
		node xX(color=red,mark = flex,name=obliquePrep)
	}
}
class BoundedExtraction
import 
	VerbalArgument[]
%	SubjectAgreement[]
	NonInvertedNominalSubject[]
export 
	xArg
declare 
	?xSubj ?xArg
{
	<syn>{
		xArg = xSubj
	}
% ;
% 	xSubj= xSubjAgr;
% 	xVN = xVNAgr
}

%# extraction du sujet est bornée : 
%# La fille qui voit Jean ?
%# *La fille qui tu crois que voit Jean ?
%# Dummy class for now

class ** whSubject
import 
	BoundedExtraction[]
	SubjectAgreement[]
declare ?xV ?E ?VL
{
	<syn>{
		node xS[bot=[inv = - ,wh = + ]]{ 
			node xArg(color=black,extracted,mark=subst)[cat=n,top=[wh = +, func = suj,vbI=?E,vbL=?VL]]
			node xVN [top = [mode = @{subj,ind}]]
		};
		node xV(mark=anchor,color=white,rank=7)[cat=@{v,adj,n,pp}];
		xVN -> xV;
		xSubjAgr = xArg;
		xVNAgr = xVN}*=[vbI=E,vbL=VL]}

class ** RelativeSubject
import 
	BoundedExtraction[]
	SubjectAgreement[]
	footProj1[]
declare
	?xRel ?fT ?fU  ?fX ?fY ?fZ ?xQui ?xArgWh ?fM ?xV
{
	<syn>{
		node xRel(color=black)[cat = n,bot=[mass = ?fM, det = - , def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh= - , bar = 3]]{
			node xArg(color=black,mark=foot)[cat=n,top=[func=suj,mass = ?fM, det = - , def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = - ,bar = @{0,1,2,3}]]
			node xS(mark=nadj)[bot=[mode=ind,wh = -]]{
				node xArgWh(color=red,extracted)[cat=c]{
					node xQui(color=red,mark=flex)[cat=qui,top=[wh= + ]]
				}
				node xVN[top = [mode = ind]]}};
	     	node xV(mark=anchor,color=white,rank=7)[cat=@{v,adj,n,pp}];
	        xVN -> xV;
		xArg = xSemFoot;
		xSubjAgr = xArg;
		xVNAgr = xVN}}

%CG 20-05-05 added cleft info on root node 
%CG added null adjunction constraint on xS node to block "C'est Jean
% (Marie s'etonne que) qui parte" 
% added top = [cleft = + ] on root node to prevent substitution into
%subject completive ** Que c'est jean qui part etonne Marie
%CG 20-05-05 added top=[mode=ind] on root node to block use in
% infinitival context ** c'est Jean qui aime etonne marie

%CG:12/03/07 added index percolation between xSe and xS
%CG:12/03/07 added null adjunction constraint on s node to block "c'est jean [il faut que] qui part"
%F6-12-03-07 added mode = ind on top S node to block combination with verbs taking infinitival complement
%F12-15-03-07 added cest = + on VP node xVNCleft to block adjunction of raising verbs eg "devoir c'est jean qui part"
class ** CleftSubject
import 
	BoundedExtraction[]
	SubjectAgreement[]
	xSProj1[]
declare
	?xSe ?xVNCleft ?xCl ?xVcleft ?xComp ?xCompl ?I ?xV ?fN

{
	<syn>{
		node xSe(color=black)[cat = s, bot=[cleft = +,wh = -,idx=I,mode=ind],top = [cleft = + ,mode = ind]]{
			node xVNCleft(color=red)[cat=vp,bot = [cest= + ]]{
				node xCl(color=red,mark=subst)[cat=cl,top=[func = suj, pers = 3],bot=[lemanchor=ce]]
				node xVcleft(color=red,mark=subst)[cat=v,bot=[lemanchor=etre,mode=ind,tense=pres],top=[pers = 3,num=?fN,mode=ind,idx=cleftindex]]
			}
			node xArg(color=red,mark=subst,extracted)[cat=n,top=[det = + ,wh= - ,func=obl,num=?fN,cleftmod= + ]]
			node xS(mark=nadj)[top=[idx=I],bot=[wh = -, mode = ind]]{
		          	node xComp(color=red)[cat=c]{
					node xCompl(color=red,mark=flex)[cat=qui,top=[func=suj]]}
				node xVN[top = [mode = ind,inv = - ]]}};
		node xV(mark=anchor,color=white,rank=7)[cat=@{v,adj,n,pp},bot=[inv= - ,princ= - ,cleft= + ]];
		xVN -> xV;
		xS = xXS;
		xSubjAgr = xArg;
		xVNAgr = xVN}}



class ObjAttributeCan
import 
	CanonicalnonSubjectArg[]
	ObjAttributeSem[]
{
	<syn>{
		node xtop(mark = subst)[cat = adj]
	};
	xtop = xObjAttribute
}

class NPAttributeCan
import 
	CanonicalnonSubjectArg[]
	ObjAttributeSem[]
{
	<syn>{
		node xtop(mark = subst)[cat = n,top=[det= - ,wh= - ]]
	};
	xtop = xObjAttribute
}

%-------------------------------------------------------------------
%* <Fonctions>
%-------------------------------------------------------------------


class PassiveSubject[]
{     PassiveRealisedSubject[]
%      | NonRealisedSubject[]
}


class Subject[]
{      RealisedSubject[]
       | 
      NonRealisedSubject[]
}

class PassiveRealisedSubject[]
import PassiveSubjectSem[]
declare ?A
{ %<syn>
  { A=CanonicalSubject[]
	|A=CliticSubject[]
	|A=whSubject[]
 	|A=RelativeSubject[]
 	|A=CleftSubject[]
 	|A=InvertedNominalSubject[]
	};
	xSubject = A.xArg}

class RealisedSubject[]
import SubjectSem[]
declare ?A
{ %<syn>
  {      A=CanonicalSubject[]
 	|A=CliticSubject[]
 	|A=whSubject[]
 	|A=RelativeSubject[]
 	|A=CleftSubject[]
  	|A=InvertedNominalSubject[]
	|A=InvertedCliticSubject[]
	|A=DoubleInterrogSubject[]
	};
	xSubject = A.xArg}

class NonRealisedSubject[]
import PROSem[]
declare ?A
{ %<syn>
  { 
  	{A=InfinitiveSubject[]; xSubject = A.xS}
   	|
	{A=ImperativeSubject[]; xSubject = A.xVN}
  	|
	{A=InterrogInvSubject[]; xSubject = A.xVN}

}}

class Object[]
import ObjectSem[]
declare ?A
{%<syn>
	{ A=CanonicalObject[]
	 |A=CliticObjectII[]
	 |A=CliticObject3[]
  	 |A=CliticGenitive[]
	 |A=reflexiveAccusative[]
  	 |A=whObject[]
 	 |A=RelativeObject[]
	|A=CleftObject[]
};xObject = A.xArg
}

class Iobject[]
import IobjectSem[]
declare ?A
{%<syn>
	{
	A = CanonicalIobject[]
	|A = whIobject[]
 	|A = CliticIobjectII[]
 	|A = CliticIobject3[]
 	|A = CliticLocative[] %Jean pense à Marie /y pense (pas de distinction ici)
 	|A = reflexiveDative[]
	|A = RelativeIobject[]

% 	|A = CleftIobjectOne[]
% 	|A = CleftIobjectTwo[]
};xIobject = A.xArg
}

class CAgent[]
import CAgentSem[]
declare ?A
{%<syn>
	{
	A = CanonicalCAgent[]
	|A = whCAgent[]
	|A = RelativeCAgent[]
	|A = CleftCAgentOne[]
	|A = CleftCAgentTwo[]
};xCAgent = A.xArg
}

class Oblique[]
import ObliqueSem[]
declare ?A
{%<syn>
	{
	A = CanonicalOblique[]
	|A = whOblique[]
	|A = RelativeOblique[]
%	|A = CleftObliqueOne[]
%	|A = CleftObliqueTwo[]
};xOblique = A.xArg
}
class Locative[]
import LocativeSem[]
declare ?A
{%<syn>
	{
	A = CanonicalLocative[]
	|A = whLocative[]
	|A = RelativeLocative[]
	|A = CliticLocative[]
	|A = CleftLocativeOne[]
	|A = CleftLocativeTwo[]
};xLocative = A.xArg
}
class Genitive[]
{     CanonicalGenitiveWithSem[] | OtherGenitives[]
}
class CanonicalGenitiveWithSem[]
import GenitiveSem[]
declare ?A
{%<syn>
	{
	A = CanonicalGenitive[];
	xGenitive = A.xArg
}}
class OtherGenitives[]
import GenitiveSem[]
declare ?A
{%<syn>
	{
	A = CliticGenitive[]
	|A = whGenitive[]
	|A = RelativeGenitive[]
%	|A = CleftGenitiveOne[]
%	|A = CleftGenitiveTwo[]
%	|A = CleftDont[]
};xGenitive = A.xArg
}
% class ObjAttribute[]
% {	ObjAttributeCan[]*=[objattributecanI = I, objattributecanL = L]}

class SententialSubject[]
      {	SententialSubjects[]
      	|Subject[]}

class SententialSubjects[]
import
	SententialSubjectSem[]
declare ?A
{%<syn>
	{
	A = CanonicalSententialSubjectFinite[]
	|A = CanonicalSententialSubjectInFinitive[]
	};
	xSententialSubject = A.xArg
}
class SententialCObject[]
import
	SententialCObjectSem[]
declare ?A
{%<syn>
	{
	A =	CanonicalSententialObjectFinite[]
	|A = CanonicalSententialObjectInFinitive[]
	};
	xSententialCObject = A.xArg
}
class SententialDeObject[]
import
	SententialDeObjectSem[]
declare ?A
{%<syn>
	{
	A =	CanonicalSententialObjectFinite[]
	|A = CanonicalSententialObjectInFinitiveDe[]
	};
	xSententialDeObject = A.xArg
}
class SententialAObject[]
import
	SententialAObjectSem[]
declare ?A
{%<syn>
	{
	A =	CanonicalSententialObjectFinite[]
|	A = CanonicalSententialObjectInFinitiveA[]
	};
	xSententialAObject = A.xArg
}
class SententialAObjectInfinitive[]
import
	SententialAObjectSem[]
declare ?A
{%<syn>
	{
	A = CanonicalSententialObjectInFinitiveA[];
	xSententialAObject = A.xArg}}
% CG 11 mars 07
% 
class SententialInterrogative[]
import
	SententialInterrogativeSem[]
declare ?A
{%<syn>
	{ A = CanonicalSententialObjectInterrogativeFiniteWithComplementizer[]
	|A = CanonicalSententialObjectInterrogativeFiniteWithoutComplementizer[]
%  	|A =  CanonicalSententialObjectInterrogativeInFinitive[]
	};
	xSententialInterrogative = A.xArg
}

