class TopLevelClass
%# dummy class that provides a single root to the inh. hierarchy


class VerbalArgument
import 
	TopLevelClass[]
export
        xS xVN
declare
        ?xS ?xVN     
{
        <syn>{
                node xS(color=white)[cat = @{s,n}]{
                        node xVN(color=white)[cat = @{vn,adj,n}]
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
		node xVNAgr[cat=vn,bot=[pp-gen=?fX,pp-num=?fY]];
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

class InvertedNominalSubject
import 
	VerbalArgument[]
	SubjectAgreement[]
export
	xSubj
declare
	?xSubj
{
		<syn>{
			node xS[bot = [wh = -,inv = n]]{
				node xVN [top = [inv = -]]
				,,,node xSubj(color = red,mark=subst)[cat = n,top = [det = +]]
			}			
		};
		xSubjAgr = xSubj;
		xVNAgr = xVN
}

class NonInvertedNominalSubject

declare
	?xS ?xVN ?fX ?VA
{
	<syn>{
		node xS[bot = [inv = ?fX]];
		node xVN[top = [inv = ?fX, mode = @{ind,subj}]]
	};
	VA = VerbalArgument[] ;
	xS = VA.xS ;
	xVN = VA.xVN
}

class InfinitiveSubject
import 
	EmptySubject[]
declare
	?fX ?fY ?fZ
{
	<syn>{	
		node xS[bot=[control-num=?fX,control-gen=?fY,control-pers=?fZ]]{			
                            node xVN[top=[num=?fX,gen=?fY,pers=?fZ,mode=inf]]
		}
	}
}
class ImperativeSubject
import 
	EmptySubject[]
{
	<syn>{
		node xVN[top=[mode=imp,pers=@{1,2}]]
	}
}

%Forces adjunction of an inverted clitic subject at V level

class InterrogInvSubject
import 
       EmptySubject[]
{
	<syn>{
		node xS[bot =[inv = +,mode = @{ind,subj}]]{
		     node xVN[top = [inv = +]]
		}
	}
}


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
	xSubj
declare
        ?xSubj ?fX ?fY ?fZ
{
	<syn>{
		node xS[bot=[wh = -]]{
			node xSubj(color=red)[top=[det = +]]
			node xVN(color=white)[cat = vn]
		};
		xSubj = xSubjAgr;
		xVN = xVNAgr
	}
}

class CanonicalSubject
import
        RealisedNonExtractedSubject[]
declare 
	?fG ?fK
{
        <syn>{
	     node xVN [top=[neg-nom = ?fG],bot=[neg-adv = ?fK]];
             node xSubj(mark=subst)[cat = n,top=[neg-nom = ?fG,neg-adv = ?fK, wh = -,func=suj]]
	 }
}

class CliticSubject
import
       	RealisedNonExtractedSubject[]
{
        <syn>{            
             node xSubj(color=red,mark=subst)[cat = cl,top=[func=suj]]
        }
}

class ImpersonalSubject
import
        RealisedNonExtractedSubject[]
declare 
	?xil
{
	<syn>{                
             node xSubj[cat = cl,top=[num = sg, pers=3,gen=m]]{
		   node xil(color=red,mark=flex)[cat=il] 
             }                                                    	
	}
}

class CanonicalSententialSubjectFinite
%#Que Jean aille à la montagne plait à Marie
import
	CanonicalArgument[]
declare
	?xSubj ?xTop ?xComp ?xQue
{
	<syn>{
		node xS{
			node xTop(color=red)[cat=s]{
				node xComp(color=red)[cat=c]{
					node xQue(color=red,mark=flex)[cat=que]
				}
				node xSubj(color=red,mark=subst)[cat=s,top=[mode = subj, inv = -, wh = -, princ = -]]
			}
			node xVN
		}
	}
}

class CanonicalSententialSubjectInFinitive 
%#Aller à la montagne plait à Marie
import 
	CanonicalArgument[]
declare
	?xSubj
{
	<syn>{
		node xS{
			node xSubj(color=red,mark=subst)[cat=s, top=[mode = inf, princ = -, inv = -, wh = -]]
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
                        ,,,node xtop(color=red) 
                }
        }
}

class CanonicalObject
import
        CanonicalnonSubjectArg[]
declare 
	?fK ?fG
{
        <syn>{
		node xVN[top=[neg-nom = ?fK],bot=[neg-adv = ?fG]];
                node xtop(mark=subst)[cat = n,top=[det = +,neg-adv = ?fG,neg-nom = ?fK,func=obj]]
        }
}

class CanonicalNBar
import
	CanonicalnonSubjectArg[]
declare
	?fX ?fY
{
	<syn>{
		node xtop(mark=subst)[cat = n, top=[det = -, func = obj]]
	}
}


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
                        node xArg(mark=subst,color=red)[cat = n, top = [det = +]]
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



class CanonicalCAgent
import 
	CanonicalPPnonOblique[]

{
	<syn>{
		node xPrep[cat = par];
		node xArg[top = [func = cagent]]	
	}	
}

class CanonicalGenitive
import 
	CanonicalPPnonOblique[]

{
	<syn>{
		node xPrep[cat = de];
		node xArg[top = [func = gen]]	
	}
}

class CanonicalIobject
import 
	CanonicalPPnonOblique[]

{
	<syn>{
		node xPrep[cat = à];
		node xArg[top = [func = iobj]]	
	}
}

class CanonicalOblique[]
import 
	CanonicalPP[]
declare 
	?X

{
	<syn>{
		node xX(color=red,mark=flex)[name = ?X];
		node xArg[top = [func = obl]]	
	}*=[prep = ?X]
}

class CanonicalLocative
import 
	 CanonicalnonSubjectArg[]
{
	<syn>{
		node xtop(mark=subst)[cat=pp,top=[loc = +]]
	}
}

class Infinitive
export
	xCtrollee
declare 
	?xCtrollee
{
	<syn>{
		node xCtrollee(color=red)[top = [mode = inf]]
	}
}

class Subject-Control
%# Implements subject-control
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
	?xX ?xComp ?xArg
{
	<syn>{
		node xtop(mark=nadj)[cat=s]{
			node xX (color = red)[cat=c]{
				node xComp(color=red,mark=flex)
			}
			node xArg(color = red)[cat = s,top=[wh = -,princ = -, inv = -]]
		}		
	}
}

class CanonicalSententialXObjectWithComplementizerNonBounding
import
	CanonicalSententialXObjectWithComplementizer[]
{
	<syn>{ 
		node xArg(xcomp)		
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

class CanonicalSententialObjectFinite
import
	CanonicalSententialXObjectWithComplementizerNonBounding[]
{
	<syn>{
		node xComp[cat=que];
		node xArg[top=[mode = @{ind,subj,inf}]]
	}
}

class CanonicalSententialXObjectwithoutComplementizer
import
	CanonicalnonSubjectArg[]
{
	<syn>{
		node xtop(color=red)[cat=s]
	}
}

class CanonicalSententialXObjectwithoutComplementizerBounding
import 
	CanonicalnonSubjectArg[]
{
	<syn>{
		node xtop(color=red,mark=subst)[cat=s]
	}
}

class CanonicalSententialXObjectwithoutComplementizerNonBounding
import 
	CanonicalnonSubjectArg[]

{
	<syn>{
		node xtop(color=red,xcomp)[cat=s]  
	}
}

class CanonicalSententialObjectInFinitive
import
	CanonicalSententialXObjectwithoutComplementizerNonBounding[]
	Subject-Control[]
declare
	?fX ?fY ?fZ
{
	<syn>{
		node xtop[top=[mode=inf, princ = -]];
		xCtrollee = xtop;
		xVNCtroller = xVN
	}
}

class CanonicalSententialObjInfWithComplementizer
import
	CanonicalSententialXObjectWithComplementizerNonBounding[]
	Subject-Control[]
{
	<syn>{
		node xArg[top=[mode=inf,wh= -, princ = -]];
		xCtrollee = xArg;
		xVNCtroller = xVN			
	}
}

class CanonicalSententialObjectInFinitiveDe
import
	CanonicalSententialObjInfWithComplementizer[]
	
{
	<syn>{
		node xComp[cat=de]	
	}
}

class CanonicalSententialObjectInFinitiveA
import
	CanonicalSententialObjInfWithComplementizer[]
{
	<syn>{
		node xComp[cat=à]				
	}
}

class CanonicalSententialObjectInterrogativeFinite 
import
	CanonicalSententialXObjectWithComplementizerBounding[]
{
	<syn>{
		node xComp(color=red)[cat=si]
	};
	<syn>{
		node xArg(color = red)[cat = s,top=[wh = -,inv = -,princ = -]]
	}
}

class CanonicalSententialObjectInterrogativeInFinitive
import  
	CanonicalSententialXObjectwithoutComplementizerBounding[]
	Infinitive[]
{
	<syn>{
		node xtop [top =[wh = +,mode = @{inf,ind},princ = -]];
		xtop = xCtrollee
	}
}

class Clitic
import 
	VerbalArgument[]
export 
	xCl xV
declare
	?xCl ?xV
{
	<syn>{
		node xVN{
			node xCl(color=red,mark=subst)[cat=cl]
			,,,node xV(color=white)[cat=v]
		}
	}
}

class nonReflexiveClitic
import 
	Clitic[]
{
	<syn>{
		node xCl[top=[refl = -]]
	}
}

class CliticObjectII
%# Clitic subject ? see above (near canonical subject)
%# me te le les la nous vous leur leurs
import 
	nonReflexiveClitic[]	
declare
	?NCO
{
	<syn>{
		node xCl(rank=2)[top=[func=obj,pers = @{1,2}]];
		NCO = NonCanonicalObject[];
		xCl = NCO.xObjAgr;
		xVN = NCO.xVNAgr
	}
}
class CliticIobjectII
import 
	nonReflexiveClitic[]
	
{
	<syn>{
		node xCl(rank=2)[top=[func=iobj, pers = @{1,2}]]
	}
}
class CliticObject3
import 
	nonReflexiveClitic[]	
declare
	?NCO

{
	<syn>{
		node xCl(rank=3)[top=[func= obj,pers=3]]
		
	};
	NCO = NonCanonicalObject[];
	xCl = NCO.xObjAgr;
	xVN = NCO.xVNAgr
}

class CliticIobject3
import 
	nonReflexiveClitic[]
{
	<syn>{
		node xCl(rank=4)[top=[func=iobj,pers=3]]
	}
}
class CliticGenitive
import 
	nonReflexiveClitic[]

{
	<syn>{
		node xCl(rank=5)[top=[func=gen]]
	}
}
class CliticLocative
import 
	nonReflexiveClitic[]
{
	<syn>{
		node xCl(rank=6)[top=[func=loc]]
	}
}

class reflexiveClitic
%# Special clitics : reflexive
%# me te se nous vous se 
import 
	Clitic[]
{
	<syn>{
		node xCl[top=[refl = +]]
	}
}


class reflexiveAccusative
import 
	reflexiveClitic[]
declare 
	?fX ?fY ?NCO
{
	<syn>{
		node xCl(mark=subst,rank=2)[top=[func=obj,num=?fX,pers = ?fY]];
		node xVN[top=[num=?fX,pers=?fY]]
	};
	NCO = NonCanonicalObject[];
	xCl = NCO.xObjAgr;
	xVN = NCO.xVNAgr
}

class reflexiveDative
import
	reflexiveClitic[]
{
	<syn>{
		node xCl(mark=subst,rank=2)[top=[func=iobj]]
	}
}

class UnboundedExtraction
import 
	VerbalArgument[]
export
	xSe xtop
declare
	?xSe ?xtop ?fX
{
	<syn>{
		node xSe(color=red,extracted)[cat = s]{
			node xtop(color=red)
			node xS[top=[wh = -,inv = @{+,n,-}]] %false -> ask yannick (should be + | n for questions, + | - | n for clefts and relatives (I can't say that)   
		}
	}
}

class UnboundedQuestion
import 
	UnboundedExtraction[]
declare 
	?fX
{
	<syn>{
		node xSe[top = [princ = +],bot=[wh = +,princ = ?fX, inv = ?fX]];
		node xS[top=[inv = ?fX]]
	}
}

class whObject
import
	UnboundedQuestion[]
declare
	?NCO
{
	<syn>{
		node xtop(mark=subst)[cat = n,top=[wh = +]];		
		NCO = NonCanonicalObject[];
		xVN = NCO.xVNAgr;
		xtop = NCO.xObjAgr
	}
}

class whLocative
import
	UnboundedQuestion[]
{
	<syn>{
		node xtop(mark=subst)[cat = pp, top=[loc = +,wh = +]]		
	}
}

class whPrep
import
	UnboundedQuestion[]
export 
	xArg  xX
declare
	?xArg  ?xX
{
	<syn>{
		node xtop[cat = pp]{
			node xX(color=red)[cat = p]
			node xArg(mark=subst,color=red)[cat = n,top=[wh = +, det = +]]
		}
	}
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


class whIobject
import
	 whPrepnonOblique[]
{
	<syn>{
		node xPrep[cat = à]
	}
}

class whGenitive
import
	 whPrepnonOblique[]
{
	<syn>{
		node xPrep[cat = de]
	}
}

class whCAgent
import
	 whPrepnonOblique[]
{
	<syn>{
		node xPrep[cat = par]
	}
}

class whOblique[]
import
	 whPrep[]
declare
	?X
{
	<syn>{
		node xX(color=red,mark=flex)[name  = ?X]
	}*=[prep = ?X]
}

class UnboundedRelative
import 
	UnboundedExtraction[]
declare
	?xRelf ?xReltop ?fX ?fT ?fY ?fZ ?fU ?fW
{
	<syn>{
		node xReltop(color=red)[cat = n,bot=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar = 3]]{
			node xRelf(mark=foot,color=red)[cat = n,top=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar=@{0,1,2,3}]]
			node xSe(mark=nadj)
		}
	}
}

class RelativeObject
import
	UnboundedRelative[]
declare
	?NCO  ?xQue
{
	<syn>{
		node xtop[cat = c]{
		     node xQue(color = red,mark = flex)[cat = que]
		}	
	};
	NCO = NonCanonicalObject[];
	xVN = NCO.xVNAgr;
	xtop = NCO.xObjAgr	
}


class RelativeLocative
import 
	UnboundedRelative[]
{
	<syn>{
		node xtop(mark=subst)[cat = pp,loc = +]
	}
}

class RelativePP
import
	UnboundedRelative[]
export 
	xArg xX	
declare
	?xArg ?xX
{
	<syn>{
		node xtop[cat = pp]{
			node xX(color=red)[cat = p]
			node xArg(color=red,mark = subst)[cat = n,top=[det = +, wh = +]]
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



class RelativeIobject
import 
	RelativePPnonOblique[]
{
	<syn>{
		node xPrep[cat = à]
	}
}

class RelativeGenitive
import 
	RelativePPnonOblique[]
{
	<syn>{
		node xPrep[cat = de]
	}
}

class RelativeCAgent
import 
	RelativePPnonOblique[]
{
	<syn>{
		node xPrep[cat = par]
	}
}

class RelativeOblique[]
import 
	RelativePP[]
declare
	?X
{
	<syn>{
		node xX(color=red,mark=flex)[name = ?X]
	}*=[prep = ?X]
}

class UnboundedCleft
import
	UnboundedExtraction[]
export 
	xClefttop
declare
	?xCleft ?xVNCleft ?xClCleft ?xAuxCleft ?xClefttop
{
	<syn>{
		node xCleft(color=red)[cat = s,bot=[wh = -]]{
			node xVNCleft(color=red)[cat=vn]{
				node xClCleft(color=red,mark=subst)[cat=cl,top=[case = suj,pers=3]]
				node xAuxCleft(color=red,mark=subst)[cat=v,top=[mode=@{ind,subj},pers=3]]
			}
			node xClefttop(color=red)
			node xSe(mark=nadj)	
		}		
	}
}

class NominalCleft
import
	UnboundedCleft[]
export 
	xComp
declare
	?xComp
{
	<syn>{
		node xClefttop(mark=subst)[cat = n,top=[det = +,wh = -, num = sg]];
		node xtop[cat = c]{
			node xComp(color=red,mark=flex)
		}	
	}
}

class CleftObject
import 
	NominalCleft[]	
declare
	?NCO
{
	<syn>{
		node xComp[cat = que]					
	};
	NCO=NonCanonicalObject[];
	xVN = NCO.xVNAgr;
	xClefttop = NCO.xObjAgr
}

class CleftDont
import 
	NominalCleft[]
{
	<syn>{
		node xComp[cat = dont]				
	}
}

class PrepCompCleft
import
	UnboundedCleft[]
export 
	 xX
declare 
	?xComp ?xX ?xArg
{
	<syn>{
		node xClefttop[cat = pp]{
			node xX(color=red)[cat=p]
			node xArg(color=red,mark=subst)[cat=n,top=[det = +,wh = -, num = sg]]		
		} 		
	};
	<syn>{
		node xtop[cat=c]{
			node xComp(color=red,mark=flex)[cat = que]
		}
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



class CleftIobjectOne
import 
	PrepCompCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = à]
	}	
}

class CleftGenitiveOne
import 
	PrepCompCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = de]
	}	
}

class CleftCAgentOne
import 
	PrepCompCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = par]
	}	
}

class CleftObliqueOne[]
import 
	PrepCompCleft[]
declare 
	?X
{
	<syn>{
		node xX(mark=flex,color=red)[name = ?X]
	}*=[prep = ?X]	
}

class NominalPrepCleft
import 
	UnboundedCleft[]
export
	 xArg xX
declare
	?xX ?xArg
{
	<syn>{
		node xClefttop(mark=subst)[cat = n] 
	};
	<syn>{
		node xtop[cat = pp]{
			node xX(color =red)[cat = p]
			node xArg(color=red,mark=subst)[cat = n]
		}
	}
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

class CleftIobjectTwo
import 
	NominalPrepCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = à]
	}	
}
class CleftGenitiveTwo
import 
	NominalPrepCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = de]
	}	
}

class CleftCAgentTwo
import 
	NominalPrepCleftnonOblique[]
{
	<syn>{
		node xPrep[cat = par]
	}	
}

class CleftObliqueTwo[]
import 
	NominalPrepCleft[]
declare
	?X
{
	<syn>{
		node xX(color=red,mark = flex)[name = ?X]
	}*=[prep = ?X]	
}

class BoundedExtraction
import 
	VerbalArgument[]
	SubjectAgreement[]
	NonInvertedNominalSubject[]
export 
	xArg
declare 
	?xSubj ?xArg
{
	<syn>{
		xArg = xSubj
	};
	xSubj = xSubjAgr;
	xVN = xVNAgr
}

%# extraction du sujet est bornée : 
%# La fille qui voit Jean ?
%# *La fille qui tu crois que voit Jean ?
%# Dummy class for now

class whSubject
import 
	BoundedExtraction[]
{
	<syn>{
		node xS[bot=[wh = +,inv = -]]{ 
			node xArg(color=red,extracted,mark=subst)[cat=n,top=[wh = +]]
			node xVN [top = [mode = @{subj,ind}]]
		}		
	}
}

class RelativeSubject
import 
	BoundedExtraction[]
declare
	?xfoot ?xRel ?fT ?fU ?fW ?fX ?fY ?fZ ?xQui
{
	<syn>{
		node xRel(color=red)[cat = n,bot=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW, bar = 3]]{
			node xfoot(color=red,mark=foot)[cat=n,top=[det = ?fX, def = ?fT, num = ?fY,gen = ?fZ,pers = ?fU, wh = ?fW,bar = @{0,1,2,3}]]
			node xS(mark=nadj)[bot=[mode=ind,wh = -]]{
				node xArg(color=red,extracted)[cat=c]{
					node xQui(color=red,mark=flex)[cat=qui]
				}
				node xVN[top = [mode = @{ind,subj}]]
			}
		}
	}
}

class CleftSubject
import 
	BoundedExtraction[]
declare
	?xSe ?xVNCleft ?xCl ?xVcleft ?xComp ?xCompl

{
	<syn>{
		node xSe(color=red)[cat = s, bot=[wh = -]]{
			node xVNCleft(color=red)[cat=vn]{
				node xCl(color=red,mark=subst)[cat=cl,top=[func = suj, pers = 3]]
				node xVcleft(color=red,mark=subst)[cat=v,top=[pers = 3,mode=ind]]
			}
			node xArg(color=red,mark=subst,extracted)[cat=n]
			node xS[bot=[wh = -, mode = ind]]{
				node xComp(color=red)[cat=c]{
					node xCompl(color=red,mark=flex)[cat=qui]
				}
				node xVN[top = [mode = @{ind,subj}]]
			}
		}
	}
}

class ObjAttributeCan
import 
	 CanonicalnonSubjectArg[]
{
	<syn>{
		node xtop(mark = subst)[cat = adj]
	}
}


%%%%%%%%%%%%%%%%%%%
% LEXICAL CLASSES %
%%%%%%%%%%%%%%%%%%%


%* <Fonctions>
%%%%%%%%%%%%%%

class Subject
{
	CanonicalSubject[]
	|CliticSubject[]
	|whSubject[]
	|RelativeSubject[]
	|CleftSubject[]
	|InfinitiveSubject[]
 	|ImperativeSubject[]
 	|InvertedNominalSubject[]
	|InterrogInvSubject[]
}

class Object
{
	CanonicalObject[]
	|CliticObjectII[]
	|CliticObject3[]
	|CliticGenitive[] %L'ingénieur (présente des résultats | en présente)
	|reflexiveAccusative[]
	|whObject[]
	|RelativeObject[]
	|CleftObject[]
}




class SententialSubject{
	CanonicalSententialSubjectFinite[]
	|CanonicalSententialSubjectInFinitive[]
	|Subject[] %always true ? it seems...
}
class SententialCObject{
	CanonicalSententialObjectFinite[]
	|CanonicalSententialObjectInFinitive[]
}
class SententialDeObject{
	CanonicalSententialObjectFinite[]
	|CanonicalSententialObjectInFinitiveDe[]
}
class SententialAObject{
	CanonicalSententialObjectFinite[]
	|CanonicalSententialObjectInFinitiveA[]
}
class SententialInterrogative{
	CanonicalSententialObjectInterrogativeFinite[]
	|CanonicalSententialObjectInterrogativeInFinitive[]
}

class Iobject
{
	CanonicalIobject[]
	|whIobject[]
	|CliticIobjectII[]
	|CliticIobject3[]
	|CliticLocative[] %Jean pense à Marie / y pense (pas de distinction ici) 
	|reflexiveDative[]
	|RelativeIobject[]
	|CleftIobjectOne[]
	|CleftIobjectTwo[]
}

class CAgent
{
	CanonicalCAgent[]
	|whCAgent[]
	|RelativeCAgent[]
	|CleftCAgentOne[]
	|CleftCAgentTwo[]
}

class Oblique[]
{
	CanonicalOblique[]
	|whOblique[]
	|RelativeOblique[]
	|CleftObliqueOne[]
	|CleftObliqueTwo[]
}

class Locative
{
	CanonicalLocative[]
	|whLocative[]
	|RelativeLocative[]
	|CliticLocative[]
	%|CleftLocativeOne[]
	%|CleftLocativeTwo[]
}


class Genitive
{
	CanonicalGenitive[]
	|CliticGenitive[]
	|whGenitive[]
	|RelativeGenitive[]
	|CleftGenitiveOne[]
	|CleftGenitiveTwo[]
	|CleftDont[]
}

