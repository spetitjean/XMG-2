%-------
%Verbs
%-------

class  VerbalTop
export ?Sr ?VP ?V  
declare ?Sr ?VP ?V  ?fP ?fN ?fAC ?fACP ?fM ?fP1 ?fN1 ?fAC1 ?fACP1 ?fM1 ?fPass ?fTense ?fTense1 ?fPass1 ?fMV1
{<syn>{ 
	node ?Sr(color=black)[cat=@{s,np},bot=[inv= -, comp = no_comp, extracted = -,pass=?fPass,
	     			pers=?fP,num=?fN,mode=?fM,tense=?fTense,assign-case=?fAC,assign-comp=?fACP]]{
		node ?VP (color=black)[cat=@{vp,n},
		     top=[pass=?fPass,pers=?fP,num=?fN,mode=?fM,tense=?fTense,assign-case=?fAC,assign-comp=?fACP],
		     bot=[mainv=?fMV1,pers=?fP1,num=?fN1,mode=?fM1,tense=?fTense1,pass=?fPass1,assign-case=?fAC1,
			assign-comp=?fACP1,compar = -]]{
            	    node ?V(color=black)[cat=v,
		     top=[mainv=?fMV1,pers=?fP1,num=?fN1,mode=?fM1,tense=?fTense1,pass=?fPass1,assign-case=?fAC1,
		     assign-comp=?fACP1,punct-struct=nil]]
														}
													}
        }
}

class  VerbalNonInverted
import VerbalTop[]
{<syn> { 
       	 node ?V(mark=anchor)
        }
}

class  active
import VerbalNonInverted[]
{<syn> {
	node ?V[top=[pass = - ]]
	}
}

class  passive
import VerbalNonInverted[]
{<syn> { 
       node ?V[top =[mode = ppart, pass = +]]
        }       
}


class  VerbalInverted
import VerbalTop[]
declare ?Sq ?Vq  ?fM ?fC ?fP ?fN ?fT ?fM1 ?fTr
{<syn> {
	node ?Sq (color=black) [cat=s,bot=[inv= +, extracted = -, mode=?fM,comp=no_comp]];
	node ?Vq(color=red,mark=anchor)[cat=v,top=[assign-case=?fC,pers=?fP,num=?fN,tense=?fT,mode=?fM1,trace=?fTr]];
	node ?V [bot=[mode=?fM1,trace=?fTr,phon=e]] ;
	     ?Sq ->* ?Vq ; 
	     ?Sq ->* ?Sr ;
	     ?Vq >> ?Sr 
	 }
}

class  verbless
import VerbalTop[]
{<syn> { 
  	node ?V[phon=e]
	}
} 

class  particle
declare  ?xVP ?xV ?xPl
{ <syn> { 
  	  node ?xVP (color=white)[cat=@{vp,n}]{
	       node ?xV (color=white)[cat=v] 
	       ,,,node ?xPl(color=red,name=Particle,mark=coanchor)[cat=pl]
						}
	 } 
}

%----------
% Features
%----------

class  SubjectAgreement
export ?Subj ?xagr ?S ?fAC
declare ?Subj ?xagr ?S ?fP ?fN ?fP1 ?fN1 ?fAC ?fAC1 ?fWH1 
{<syn>{ 
	node ?S[bot=[assign-case=?fAC,pers=?fP,num=?fN,wh=?fWH1]];
	     node ?Subj (gf=subj)[top =[case=?fAC,pers=?fP,num=?fN,wh =?fWH1]];
	     node ?xagr [top =[assign-case=?fAC,pers=?fP,num=?fN],bot=[assign-case=?fAC1,pers=?fP1,num=?fN1]]			
	}
}

class  MovementAgreement
export ?Sr ?WH1 ?WhArg 
declare ?Sr ?WH1 ?WhArg ?fP ?fN ?fAC
{<syn> {
	node ?WH1 [top = [pers=?fP, num=?fN, case=?fAC]]
	     %% ;
	     %% Temporarily removed (no color)
	     %% node ?WhArg [top=[pers=?fP, num=?fN, case=?fAC]]
	}
}

class  PrepCaseAssigner
export ?PP ?P  ?NP
declare ?PP ?P ?fX ?NP	?fY
{<syn> {
	node ?PP [bot=[assign-case=?fX, wh = ?fY]]{
	    node ?P [top=[assign-case=?fX]]
	    node ?NP[top=[case=?fX, wh = ?fY]]
						}
	}; ?fX = acc
}

class  VerbCaseAssigner
export ?verbph ?verb ?NP2 ?NP1 
declare ?verbph ?verb ?NP2 ?NP1 ?fAC ?fAC1
{<syn> {
	node ?verbph [bot=[assign-case=?fAC1]]{
	    node ?verb[top=[assign-case=?fAC1]]
	    %% Temporarily removed (no color)
	    %%,,,node ?NP2[top=[case=acc]]
	    %%,,,node ?NP1[top=[case=acc]]
					}
	}
}

class  Inversion
export ?InvS
declare ?InvS ?fI
{<syn> { 
	node ?InvS [bot = [invlink = ?fI, inv = ?fI]]
	}
}

%-------------------
%PredicateArguments
%-------------------

class  VerbalArgument
export ?XP ?VP
declare ?XP ?VP     
{<syn> {
        node ?XP(color=white)[cat = @{s,np,n}]{
            node ?VP(color=white)[cat = @{vp,a,n}]
                                        }               
        }
}

%-------------------------------------------------

class  SubjectArgumentTop
import VerbalArgument[]
       SubjectAgreement[]
export  ?fCtrl ?fPrg ?fPerf ?fMV
declare ?fCtrl ?fPrg ?fPerf ?fMV
{<syn> {
	node ?XP[cat=s,bot=[control=?fCtrl,progress= ?fPrg,perf=?fPerf,mainv=?fMV]]{
	    node ?Subj [top=[control=?fCtrl]]
	    node ?VP [cat=vp,top=[progress= ?fPrg,perf=?fPerf,mainv=?fMV]]
	    	      }
	}; ?XP = ?S ; ?VP = ?xagr	 	 
}

class  SubjectArgument
import SubjectArgumentTop[]
{<syn> { 
       	 node ?Subj(color=red)[top=[wh = -]]
       }
}

class  CanSubject
import SubjectArgument[]
{<syn> { 
       	 node ?Subj(mark=subst)[cat=np]
	}; ?fAC = nom   
}

class  CanSententialSubject
import SubjectArgument[]
{<syn> {
	node ?Subj(mark=subst)[cat=s,top=[mode=@{inf,ind},comp=@{that,whether,for,no_comp},assign-comp=inf_nil]]
       }
}

class  ProSubject
import SubjectArgument[]
declare ?X 
{<syn> {
	node ?XP[bot=[assign-case=?fAC]]{
        	node ?Subj(mark=nadj)[cat=np,top=[case = none]]{
		     	node ?X(color=red,mark=nadj)[cat=Pro]}
        	node ?VP [top=[mode=@{inf,ger,ind}]]    %adding bot=[mod=base] blocks passive + ProSubj
		     	       	 		    
            	     	       	       }
        }
}

class  ImperativeSubject
import SubjectArgument[] 
declare ?X
{<syn> { 
       	 node ?XP [top=[inv = -], bot=[mode=imp]]{
	    node ?Subj(mark=nadj)[cat=np,top=[wh = -,pers=2,num=@{sing,plur}]]{
	 	node ?X(color=red,mark=flex)[phon=e]}
	    node ?VP[top=[tense=pres],top=[mode=imp]]}
	} ; ?fAC = nom
}

class  SubjectXCoanchorCan
import SubjectArgumentTop[]
export ?xcoanch
declare ?xcoanch 
{<syn> { 
       	 node ?Subj [cat=np]{
	     node ?xcoanch(color=red,mark=coanchor)
			   }   
	}; ?fAC = nom
}

class  SubjectNCoanchorCan
import SubjectXCoanchorCan[]
{<syn> { 
       	 node ?Subj (color=black){
	     node ?xcoanch(name=Noun,rank=3)[cat=n]
				}
        }
}

class  SubjectAdjCoanchorCan
import SubjectXCoanchorCan[]
{<syn> { 
       	 node ?Subj (color=white){
	     node ?xcoanch(name=Adjective,rank=2)[cat=a]
				}
        }
}

class  SubjectDetCoanchorCan
import SubjectXCoanchorCan[]
{<syn> { 
       	 node ?Subj (color=white){
	     node ?xcoanch(name=Determiner,rank=1)[cat=det]
				}
        }
}

class  SubjectOuterTop
import SubjectArgumentTop[]
       PrepCaseAssigner[]
export ?xverb ?xprepph ?xprep ?xe ?fT
declare ?xverb ?xprepph ?xprep ?xe ?fT
{<syn> { 
       	 node ?VP {
	    node ?xverb(color=white)[cat=v]
	    ,,,node ?xprepph(color=red,rank=6)[cat=pp]{
	    	    node ?xprep(color=red,mark=coanchor,name=Prep)[cat=prep]
		    node ?xe(color=red)[phon=e,cat=np,top=[trace=?fT]]
						}
		}
	};  ?xprepph = ?PP ; ?xprep = ?P ; ?xe = ?NP
}

class  SubjectOuterCan
import SubjectOuterTop[]
{<syn> {
	node ?Subj (color=red,mark=subst)[cat=np,top=[trace=?fT,wh = -]]
       }; ?fAC = nom
}

class  SubjectOuterPro
import SubjectOuterTop[]
declare ?X
{<syn> {
	node ?Subj(color=red,mark=nadj)[cat=np,top=[case = none,trace=?fT]]{
		 node ?X(color=red,mark=nadj)[cat=Pro]
							}
        }
}


%-------------------------------------------------

class  CanComplement
import VerbalArgument[]
export ?V ?compl
declare ?V ?compl
{<syn> {
  	node ?VP[cat=vp]{
                node ?V(color=white)[cat=v]
                ,,,node ?compl[top=[wh = -]]
                }
        }
}

class  CanObject
import CanComplement[]
       VerbCaseAssigner[] 
{<syn> {
	node ?compl(color=red,mark=subst,gf=obj,rank=2)[cat=np]
        }; ?VP = ?verbph ; ?V = ?verb ; ?compl = ?NP1
}

class  CanIObject
import CanComplement[]
       VerbCaseAssigner[] 
{<syn> {
        node ?compl(color=red,mark=subst,gf=iobj,rank=1)[cat=np]
        }; ?V = ?verb; ?VP = ?verbph ; ?compl = ?NP2 
}

class  CanLocative
import CanComplement[]
       VerbCaseAssigner[] 
declare ?xNP ?xAdv ?fWh
{<syn> {
  	node ?compl(color=red,gf=obj,rank=2)[cat=advp,bot=[wh=?fWh]]{
	     node ?xNP (color=red,mark=subst)[cat=np,top=[wh=?fWh]]
	     node ?xAdv (color=red,mark=anchor)[cat=adv]}
        }; ?VP = ?verbph ; ?V = ?verb ; ?compl = ?NP1
}

class  CanBEComplement
import CanComplement[]
declare ?Ve ?xNP
{<syn> { 
       	 node ?compl (color=red)[cat=vp,bot=[compar= -]]{
       	      node ?Ve(color=red)[cat=v,phon=e]
	      node ?xNP(color=red,mark=subst)[cat=np,gerund= -, case=@{nom,acc}]
	      	   					  }
	}
}

class  ComplementCoanchorCan
import CanComplement[]
       VerbCaseAssigner[] 
export ?xcoanch 
declare ?xcoanch
{ <syn> { 
  	  node ?compl(gf=obj)[cat=np]{
	     node ?xcoanch(color=red,mark=coanchor)
						}
        };?compl = ?NP1 ; ?V = ?verb ; ?VP = ?verbph
}

class  ObjectNCoanchorCan
import ComplementCoanchorCan[]
declare ?fC ?fP ?fN ?fWH ?fDef ?fPron ?fCmp
{ <syn>{
	node ?compl(color=black,rank=2)[bot=[case=?fC,pers=?fP,num=?fN,wh=?fWH,definite=?fDef,pron=?fPron,compar=?fCmp]]{
	     node ?xcoanch(rank=3,name=Noun)[cat=n,top=[case=?fC,pers=?fP,num=?fN,wh=?fWH,definite=?fDef,pron=?fPron,compar=?fCmp],bot=[compar= -]]
									}
        }
}

class  AdjCoanchorCan
import ComplementCoanchorCan[]
declare ?A ?fCmp ?fWH 
{<syn> {
	node ?compl (color=white)[bot=[compar=?fCmp,wh=?fWH]]{
       	     node ?xcoanch(rank=2,name=Adjective)[cat=a,bot=[compar=?fCmp,wh=?fWH]]
								}
	}
}

class  DetCoanchorCan
import ComplementCoanchorCan[]
declare ?fDef
{<syn>{
	node ?compl(color=white)[bot=[definite=?fDef]]{
	     node ?xcoanch(rank=1,name=Determiner)[cat=det,top=[definite=?fDef]]
							}
        }
}

class  CanXAnchor
import CanComplement[]
export ?xanch  ?fWH
declare ?xanch  ?fWH 
{<syn> { 
  	node ?compl(color=black)[bot=[wh=?fWH]]{
	     node ?xanch(color=red,mark=anchor)[top=[wh=?fWH]]
						};   
	?V >> ?compl 
        }
}

class  CanObjectAnchor
import CanXAnchor[]
       VerbCaseAssigner[]
declare ?N ?fAC ?fP ?fN ?fG ?fWH ?fDef ?fPron ?fCmp
{<syn>{
	node ?compl[cat=np,bot=[case=?fAC,pers=?fP,num=?fN,definite=?fDef,compar=?fCmp,pron=?fPron]]{
	     node ?xanch(rank=2)[cat=n,top=[case=?fAC,pers=?fP,num=?fN,definite=?fDef,compar=?fCmp,pron=?fPron]]
									}
	};?compl = ?NP1 ; ?V = ?verb ; ?VP = ?verbph
}

class  CanAdjAnchor
import CanXAnchor[]
declare ?A ?fCmp 
{<syn>{ 
	node ?compl [cat=ap,bot=[compar=?fCmp]]{
       	     	  node ?xanch(rank=2)[cat=a,top=[compar=?fCmp]]
						}
	} 
}

class  CanPPIObject-VPE
import CanComplement[]
export ?VE ?prepph ?xprep
declare ?VE ?prepph ?xprep
{<syn>{ 
  	 node ?compl(color=red,rank=4)[cat=vp,bot = [mainv = -, compar = -, assign-comp = no_comp,mode=base]]{
                    node ?VE(color=red,mark=nadj)[cat=v,phon=e]
                    node ?prepph(color=red)[cat=pp]{
                        node ?xprep(color=red)[cat=prep]             
						}
                                               }
	}
}

class  CanPPCoanchorExhaustive 
import CanPPIObject-VPE[]
{<syn>{ 
	node ?xprep(mark=coanchor,name=Prep)
	}
} 

class  CanPPCoanchor
import CanPPCoanchorExhaustive[]
       PrepCaseAssigner[]
{ <syn> { 
  	node ?NP(color=red,mark=subst) [cat=np]
	}; ?prepph = ?PP ; ?xprep  = ?P
}

class  CanPPSubstExhaustive
import CanPPIObject-VPE[]
{ <syn>{ 
  	 node ?xprep(mark=subst)
	}
}

class  CanPPSubst
import CanPPSubstExhaustive[]
       PrepCaseAssigner[]
{<syn> { 
  	node ?NP(color=red,mark=subst) [cat=np]
	} ; ?prepph = ?PP ; ?xprep  = ?P
}


class  CanPPTop
import CanComplement[]
       PrepCaseAssigner[]
{<syn>{
	node ?compl(color=red)[cat=pp]{    
          	node ?P(color=red)
                node ?NP(color=red,mark=subst)[cat=np]          
					}
        }; ?compl = ?PP
}

class  CanByAgent
import CanPPTop[]
{<syn>{
	node ?compl (rank=7);
	      node ?P (mark=flex)[cat=by]
	}
}

class  CanToObject
import CanPPTop[]
{<syn>{
	node ?compl(rank=4);
	      node ?P(mark=flex)[cat=cat_to]
	}
}

class  CanPPIObject
import CanPPTop[]
{<syn>{
	node ?compl(rank=5);
	     node ?P(mark=coanchor,name=Prep)[cat=prep]
	}
}

class  CanAdjComplement
import 
       CanComplement[]
{ <syn>{
        node ?compl(color=red,rank=3,mark=subst)[cat=ap]
        }
}

class  AdjCoanchorCanR
import CanComplement[]
declare ?A ?fCmp ?fWH
{<syn> {
	 node ?compl (color=red,rank=3)[cat=ap,bot=[compar=?fCmp,wh=?fWH]]{
      	     node ?A(color=red,mark=coanchor,name=Adjective)[cat=a,bot=[compar=?fCmp,wh=?fWH]]}
	}
}

class  CanSentComplement
import CanComplement[]
{ <syn>{ 
  	 node ?compl (color=red,rank=6)[cat=s,top=[assign-comp=@{inf_nil,ind_nil},inv= - ]]
        }
}

class  CanSentComplementFoot
import CanSentComplement[]
{ <syn>{ 
  	 node ?compl (mark=foot)
        }
}

class  CanSentComplementFootECM
import CanSentComplementFoot[]
{<syn> { 
       	 node ?compl [top=[inv = -, extracted = -,comp=no_comp,
       	      	      assign-comp=@{ecm,for},assign-case=acc]]
       }	
}

class  CanSentComplementSubst
import CanSentComplement[]
{ <syn>{ 
  	 node ?compl (mark=subst) 
                  
        }
}

class  CanSentComplementSubstECM
import CanSentComplementSubst[]
{<syn> { 
       	 node ?compl [top=[inv = -, extracted = -,comp=no_comp],
       	      	      bot=[assign-comp=@{inf_nil,ind_nil,ecm},assign-case=acc]]
       }	
}


class  CanSentComplement2
import CanComplement[]
declare ?xS ?fCtrl
{ <syn>{ 
  	 node ?XP [bot=[control=?fCtrl]];
  	 node ?compl (color=white)[cat=@{ap,np}] {
	      node ?xS (color=red,rank=6,mark=subst)[cat=s,top=[assign-comp=@{inf_nil,ind_nil},control=?fCtrl,inv= -]]
					}
        }
}

%-------------------------------------------------

class  ExtractedArgument
import VerbalArgument[]
       MovementAgreement[]
export ?S0 ?WH  ?Trace ?fT ?fWH ?X ?fPass ?fM ?fI ?fTense ?fN
declare ?S0 ?WH  ?Trace ?fT ?fWH ?X ?fPass ?fM ?fI ?fTense ?fN
{<syn> {
        node ?S0(color=red)[cat=s,bot = [wh=?fWH,mode=?fM,tense=?fTense,pass=?fPass,num=?fN]]{
            node ?WH(color=red)[top = [trace = ?fT, wh = ?fWH,num=?fN]]
            node ?XP [cat=s,top=[mode=?fM,tense=?fTense,pass=?fPass,inv = ?fI]]
	    	     							  };
		%% Temporarily removed (no color)
		%% node ?Trace [top=[trace= ?fT, wh = ?fWH],bot=[phon=e]];
		node ?VP    [cat=vp]
	} ; ?WH = ?WH1 ; ?Trace = ?WhArg
}

class  WhExtraction
import ExtractedArgument[]
{<syn>{
	node ?S0[bot = [inv = ?fI,extracted = +, comp=no_comp]];
       	     node ?XP[top=[conj = no_conj,comp=no_comp, inv = ?fI],bot=[inv= -,comp=no_comp]]
	}
}
    
class  WhSubjectArgument
import WhExtraction[]
       SubjectAgreement[]
{<syn> { 
       	 node ?S0 {
              node ?WH (mark=subst)[cat=np,top = [wh = +]]
              node ?XP [bot=[assign-comp=@{inf_nil,ind_nil,ecm}]] {
	      	       node ?Trace (color=red,mark=nadj)
		       node ?VP    
						} 
	      	   }
	} ; ?fI = - ; ?fAC = nom ;
	    ?XP = ?S; ?Trace = ?Subj ; ?VP = ?xagr 
}

class  WhSubject
import WhSubjectArgument[]
{<syn>{
	node ?Trace [cat=np]
	}
}

class  WhSententialSubject
import WhSubjectArgument[]
{<syn>{
	node ?Trace [cat=s]
	} 
}

class  WhComplementTop
import WhExtraction[]
       MovementAgreement[]
       Inversion[]
export ?V
declare ?V
{<syn> {
	node ?WH [top=[wh= + ]] ;
	node ?V (color=white)[cat=v] ;
	node ?Trace (color=red,mark=nadj) ;
	?VP -> ?V
	}; ?fI = + ; ?WH = ?WH1 ; ?Trace = ?WhArg ; ?S0 = ?InvS  
}

class  WhComplement
import WhComplementTop[]
       VerbCaseAssigner[]
{<syn> {
	?V >>* ?Trace ;
	%% Added the following constraint for XMG-2 compatibility
	?VP ->+ ?Trace ;
	?Trace = ?NP1 ; ?VP = ?verbph ; ?V = ?verb
	}
}

class  WhObject
import WhComplement[]
{ <syn>{
	node ?WH (mark=subst,gf=obj)[cat=np];
	node ?Trace(gf=obj,rank=2)[cat=np]
        }
}         
             
class  WhIObject
import WhComplement[]
{<syn>{
	node ?WH (mark=subst,gf=iobj)[cat=np] ;
	node ?Trace(gf=iobj,rank=1)[cat=np] 
      }
}
 
class  WhPPIObjectVPE
import WhComplementTop[]
export ?VPe ?Ve
declare ?VPe ?Ve
{<syn>{
	node ?WH[cat=pp] ;
	node ?VP {	 
	     node ?VPe(color=red,rank=4)[cat=vp,bot = [mainv = -, compar = -, assign-comp = no_comp,mode=base]]{
                    node ?Ve(color=red,mark=nadj)[cat=v,phon=e]
                    node ?Trace[cat=pp] 
						}
       		} ; ?V >>+ ?Trace
	}
}

class  WhPPIObject
import WhComplementTop[]
{<syn>{
	node ?WH[cat=pp] ;
	node ?VP {	 
	     node ?V
	     ,,, node ?Trace[cat=pp]
	     	 }
	}
}


class  WhPPExhaustive
import WhPPIObjectVPE[]
{<syn> {
	node ?WH (mark=subst)
	}
}

class  WhPPTopVPE
import WhPPIObjectVPE[]
       PrepCaseAssigner[]
{<syn> {
	node ?WH{
	     node ?P(color=red)
	     node ?NP(color=red,mark=subst)[cat=np]
		}
	}; ?WH = ?PP 
}

class  WhPPTop
import WhPPIObject[]
       PrepCaseAssigner[]
{<syn> {
	node ?WH{
	     node ?P(color=red)
	     node ?NP(color=red,mark=subst)[cat=np]
		}
	}; ?WH = ?PP 
}


class  WhPPSubst
import WhPPTopVPE[]
{<syn> {
       	node ?P(mark=subst)[cat=prep]
	%node ?Trace(rank=4)
	}
}

class  WhPPCoanchor
import WhPPTopVPE[]
{<syn> {
	node ?P(name=Prep,mark=coanchor)[cat=prep] 
	%node ?Trace(rank=4)
	}
}

class  WhByAgent
import WhPPTop[]
{<syn> { 
       	 node ?P(mark=flex)[cat=by] ;
	 node ?Trace(rank=7)
          }
 }

class  WhToObject
import WhPPTop[]
{<syn> { 
       	 node ?P(mark=flex)[cat=cat_to] ;
	 node ?Trace (rank=7)
	 }
}

class  WhPObjectVPE
import WhComplementTop[]
       PrepCaseAssigner[]
export ?VPe ?Ve
declare ?VPe ?Ve
{<syn> {
	node ?WH(gf=obj,mark=subst)[cat=np] ;
	node?VP{
             node ?VPe (color=red,rank=4)[cat=vp,bot = [mainv = -, compar = -, assign-comp = no_comp,mode=base]]{
	     	  node ?Ve (color=red,mark=nadj)[cat=v,phon=e]
                  ,,,node ?PP(color=red)[cat=pp] {
                         node ?P(color=red)
                         node ?Trace [cat=np]
						}
						}
                      }; ?V >>* ?VPe ; ?Trace = ?NP 
	}
}

class  WhPObjectSubst
import WhPObjectVPE[]
{<syn>{ 
	node ?PP(rank=5);
	node ?P(mark=subst)[cat=prep]
	}
}

class  WhPObjectCoanchor
import WhPObjectVPE[]
{<syn>{ 
	node ?PP (rank=5);
	node ?P(name=Prep, mark=coanchor)[cat=prep]
	}
}

class  WhPObject
import WhComplementTop[]
       PrepCaseAssigner[]
{<syn> {
	node ?WH(gf=obj,mark=subst)[cat=np] ;
	node?VP{
             node ?V 
	     ,,,node ?PP(color=red)[cat=pp] {
	     	     node ?P(color=red)
                     node ?Trace [cat=np]
						}
		}; ?Trace = ?NP 
	}
}


class  WhAgentBy
import WhPObject[]
{<syn>{ 
	node ?PP(rank=7);
	node ?P (mark=flex)[cat=by]
	}

}

class  WhObjectTo
import WhPObject[]
{<syn>{ 
	node ?PP (rank=5);
	node ?P(mark=flex)[cat=cat_to]
	}
}

class  WhLocative1
import WhComplement[]
       MovementAgreement[]
declare ?xNP ?xAdv ?fWh
{<syn>{
	node ?WH [cat=advp,bot=[wh=?fWh]]{
	     node ?xNP (color=red,mark=subst)[cat=np,top=[wh=?fWh]]
	     node ?xAdv (color=red,mark=anchor)[cat=adv]
							};
			node ?Trace[cat=advp]
	}
}

class  WhLocative2
import WhComplementTop[]
declare ?xNP ?xAdv ?WhAdv ?fWh
{<syn>{
	node ?WH (mark=subst)[cat=np,top=[wh= ?fWh]] ;
	       node ?VP {
		     node ?V
		     node ?WhAdv(color=red)[cat=advp,bot=[wh=?fWh]]{
		      	   node ?Trace [cat=np]
		 	   node ?xAdv (color=red,mark=anchor)[cat=adv]
								}
		      	   }
	}
}

class  WhAdjectiveTop
import WhComplement[]
{ <syn>{
	node ?WH (gf=compl)[cat=ap] ;
	node ?Trace(rank=3,gf=compl)[cat=ap]
	}
}

class  WhAdjective
import WhAdjectiveTop[]
{ <syn>{ 
	node ?WH (mark=subst)
	}
}

class  WhAdjCoanchorR
import WhAdjectiveTop[]
declare ?A ?fCmp 
{<syn> {
	node ?WH [bot=[compar=?fCmp,wh=?fWH]]{
	     node ?A(color=red,mark=coanchor,name=Adjective)[cat=a,bot=[compar=?fCmp,wh=?fWH]]
						}
	}
}	  

class  WhSentComplement
import WhComplement[]
{ <syn>{
        node ?WH (mark=subst,gf=obj)[cat=np] ;
	node ?Trace(gf=obj,rank=6)[cat=s,top=[assign-comp=@{inf_nil,ind_nil},inv= - ]]
	}
}

%-------------------------------------------------
%Wh-small clauses

class  WhAnchorTop
import WhComplement[]
export  ?wharg
declare ?wharg ?fWH
{<syn> { 
       	 node ?WH [bot=[wh=?fWH]] {
	    	 node ?wharg (color=red,mark=anchor)[top=[wh=?fWH]]
				};
            node ?Trace(rank=3,gf=compl)
         }
}

class  WhAnchorAdjective
import WhAnchorTop[]
declare ?fE ?fCmp
{<syn> {
	node ?WH    [cat=ap,bot=[equiv=?fE,compar=?fCmp]] ; 
        node ?wharg [cat=a, top=[equiv=?fE,compar=?fCmp]] ; 
	node ?Trace [cat=ap]
        }
}

class  WhObjectAnchor
import WhAnchorTop[]
declare ?WHn ?fC ?fN ?fDef ?fP
{<syn> {
	node ?WH    [cat=np,bot=[case=?fC,pers=?fP,num=?fN,definite=?fDef]] ;
        node ?wharg [cat=n, top=[case=?fC,pers=?fP,num=?fN,definite=?fDef]] ;
	node ?Trace [cat=np] 
	}  
}

class  WhAnchorPPExhaustive
import WhAnchorTop[]
{<syn> {
	node ?WH    [cat=pp] ;
        node ?wharg [cat=prep] ;
	node ?Trace [cat=pp]
	}
}

class  WhAnchorPArgument
import WhPObject[]
export ?xArg ?xprep2
declare ?xArg ?xprep2
{<syn>{ 
	node ?P [cat=prep]{
	     node ?xArg (color=red,mark=coanchor,name=Anchor)
	     node ?xprep2 (color=red,mark=anchor)[cat=prep]
	       }
	}
}

class  WhAnchorPPAdv %final
import WhAnchorPArgument[]
{<syn> {
	node ?xArg [cat=adv]
       }
}

class  WhAnchorPPAdj %final
import WhAnchorPArgument[]
{<syn> {
	node ?xArg [cat=a]
       }
}

class  WhAnchorPPN %final
import WhAnchorPArgument[]
{<syn> {
	node ?xArg [cat=n]
       }
}


class  WhAnchorPPP %final
import WhAnchorPArgument[]
{<syn> {
	node ?xArg [cat=prep]
       }
}

class  WhAnchorPNP
import WhAnchorPPN[]
declare ?xprep1
{<syn> {
	node ?P {
       	    node ?xprep1 (color=red,mark=coanchor,name=Anchor2)[cat=prep]
	    node ?xArg
	    node ?xprep2
	    	 }
	}
}

class  WhAnchorP %final
import WhPObject[]
{<syn>{ 
	node ?P(mark=anchor)[cat=prep]
	}
}

class  WhAnchorPP
import WhPPTop[]
{<syn> { 
       	 node ?P (mark=anchor)[cat=prep]
	}
}

class  WhAnchorPPArgumentXP
import WhPPTop[]
export ?xArg ?xprep2
declare ?xArg ?xprep2
{<syn> {
	node ?P (color=red)[cat=prep] {
       	     node ?xArg (color=red,mark=coanchor,name=Anchor)
	     node ?xprep2 (color=red,mark=anchor)[cat=prep]
					}
	}
}

class  WhAnchorPPArgumentAdv %final
import WhAnchorPPArgumentXP[]
{<syn> {
	node ?xArg [cat=adv]
	}
}


class  WhAnchorPPArgumentN  %final
import WhAnchorPPArgumentXP[]
{<syn> {
	node ?xArg [cat=n]
	}
}


class  WhAnchorPPArgumentP  %final
import WhAnchorPPArgumentXP[]
{<syn> {
	node ?xArg [cat=prep]
	}
}

class  WhAnchorPPArgumentPNP
import WhAnchorPPArgumentN[]
declare ?xprep1
{<syn> {
       node ?P {
       	    node ?xprep1 (color=red,mark=coanchor,name=Anchor2)[cat=prep]
	    node ?xArg
	    node ?xprep2
	    	 }
	}
}

%-------------------------------------------------

class  RelativeClause
import ExtractedArgument[]
export ?RelClause ?Foot?fP ?fN ?fG ?fC ?fPron ?fCmp
declare ?RelClause ?Foot ?fP ?fN ?fG ?fC ?fPron ?fCmp
{<syn> {
	node ?RelClause (color=red)[cat=np,bot = [rel-clause = +,num=?fN,pers=?fP,case=?fC,pron=?fPron,compar=?fCmp]]{
             node ?Foot(color=red,mark=foot)[cat=np,top=[num=?fN,pers=?fP,case=?fC,pron=?fPron,compar=?fCmp],
			bot=[refl = -, rel-clause= -,case=@{nom,acc}]]
             node ?S0(mark=nadj){
               	  node ?WH 
               	  node ?XP [top = [inv = -,conj = no_conj]] }
		}       
	 }
}

class  RelativeOvertExtractedWH
import RelativeClause[]
{<syn> { 
       	 node ?WH [top = [wh = +,rmode=ind]] ;
	 node ?XP [top=[mode=ind,comp=no_comp],bot=[comp=no_comp]] 
%in XTAG XP.top mode = ind,inf. If the inf is kept, there is parse tree for *'the man who to sleep'
	 }
}

class  RelativeOvertSubject
import RelativeOvertExtractedWH[]
       SubjectAgreement[]
{<syn> {
	node ?WH (mark=subst)[cat=np];
	node ?XP {
	     node ?Trace(color=red)[cat=np,bot=[rel-clause = -]]
	     node ?VP %   [top=[mode=ind]]          
                    			    }; 
	?XP = ?S ; ?Trace = ?Subj ; ?VP = ?xagr
         } 
}
%the rmode=ind is to prevent 'Bill whose mother liked by Lisa' There is no
%agreement between the foot node and the wh-np (for that purpose, I used
%subject-verb agreement).  The agreement doesn't always hold, e.g.: the women
%who sleep vs. the women whose man sleeps

class  RelativeOvertSubjectOuter
import RelativeOvertSubject[]
declare ?xverb ?xprepph ?xprep ?xe ?fT
{<syn> {
	node ?Trace [top=[trace=?fT]];
	node ?VP {
       	     node ?xverb(color=white)[cat=v]
	     ,,,node ?xprepph(color=red,rank=6)[cat=pp]{
			node ?xprep(color=red,mark=coanchor,name=Prep)[cat=prep]
                        node ?xe (color=red)[cat=np,phon=e,top=[trace=?fT]]
							}
		}
	}	
}


class  RelativeOvertComplement
import RelativeOvertExtractedWH[]
export ?V
declare ?V
{<syn>{
	node ?WH (mark=subst)[cat=np] ;
	node ?VP {
	     node ?V (color=white)
	     ,,,node ?Trace (color=red)[cat=np]
	     	  }
	} 
}


class  RelativeOvertObject
import RelativeOvertComplement[]
       VerbCaseAssigner[] 
{<syn> { 
       	 node ?Trace(rank=2,gf=obj)
       } ; ?VP = ?verbph; ?V = ?verb ; ?Trace = ?NP1
}

class  RelativeOvertIObject
import RelativeOvertComplement[]
       VerbCaseAssigner[]
{<syn> { 
       	 node ?Trace(rank=1,gf=iobj)
       } ; ?VP = ?verbph; ?V = ?verb ; ?Trace = ?NP2
}

class  RelativePied-Piping
import RelativeOvertExtractedWH[]
       PrepCaseAssigner[]
{<syn>{	
	node ?WH[cat=pp,top = [wh = + ]]{
	     node ?P(color=red)
	     node ?NP(color=red,mark=subst)[cat=np]
					} 
	}; ?WH = ?PP
}

class  RelativePPIObject-VPE
import RelativePied-Piping[]
       PrepCaseAssigner[]
export ?VPe ?Ve ?V
declare ?VPe ?Ve ?V
{<syn>{
	node ?VP {
	     node ?V(color=white)
	     ,,,node ?VPe(color=red,rank=4)[cat=vp]{
	     	  node ?Ve(color=red,mark=nadj)[cat=v,bot=[phon=e]]
	     	  node ?Trace(color=red)[cat=pp]
					       }
		}
	} 
} 

class  RelativePPSubst
import RelativePPIObject-VPE[]
{<syn>{
	node ?P(mark=subst)[cat=prep]
	}
}

class  RelativePPAnchor
import RelativePPIObject-VPE[]
{<syn>{
	node ?P(name=Prep, mark=coanchor)[cat=prep]
	}
}

class  RelativePPObjectTop
import RelativePied-Piping[]
export ?V
declare ?V
{<syn>{
	node ?VP {
	     node ?V (color=white)[cat=v]	
	     ,,,node ?Trace(color=red,rank=6)[cat=pp]
	     	}
	}
}

class  RelativeByAgent
import RelativePPObjectTop[]
{<syn> { 
       	 node ?P (mark=flex)[cat=by]
       }
}

class  RelativeToObject
import RelativePPObjectTop[]
{<syn> {
	node ?P(mark=flex)[cat=cat_to]
       }
}

class  RelativePPObject
import RelativePPObjectTop[]
{<syn> {
	node ?P(mark=coanchor,name=Prep)[cat=prep]
       }
}

class  RelativeAdjunctPied-Piping
import RelativeOvertExtractedWH[]
{<syn>{
	node ?WH(mark=subst)[cat=pp]
	}
}

class  RelativeOvertPPObject-VPE
import RelativeOvertExtractedWH[]
       PrepCaseAssigner[]
export ?V ?RelPObj ?VPe ?Ve
declare ?V ?RelPObj ?VPe ?Ve
{<syn>{
	node ?WH (mark=subst) [cat=np] ;
	     node ?VP{
	     	  node ?V(color=white)[cat=v]
		  ,,,node ?VPe(color=red,rank=4)[cat=vp]{
		  	  node ?Ve(color=red,mark=nadj)[cat=v,phon=e]
			  node ?RelPObj(color=red)[cat=pp]{
			       node ?P(color=red)[cat=prep]
			       node ?Trace(color=red)[cat=np]
							}
						}
			}
	} ; ?RelPObj = ?PP ; ?Trace = ?NP
}

class  RelativeOvertPPSubst
import RelativeOvertPPObject-VPE[]
{<syn>{
	node ?P(mark=subst)
	}
}

class  RelativeOvertPPAnchor
import RelativeOvertPPObject-VPE[]
{<syn>{
	node ?P(name=Prep, mark=coanchor)
	}
}

class  RelativeOvertPPTop
import RelativeOvertExtractedWH[]
       PrepCaseAssigner[]
export ?xverb ?xprepph ?xprep 
declare ?xverb ?xprepph ?xprep
{<syn>{
	node ?WH (mark=subst)[cat=np] ;
	node ?VP[top=[mode=ind]]{
	     node ?xverb(color=white)[cat=v]
	     ,,,node ?xprepph(color=red,rank=6)[cat=pp] {
	     	     	node ?xprep(color=red)
                        node ?Trace(color=red)[cat=np]
							}
		}					
	}; ?xprepph = ?PP ; ?Trace = ?NP ; ?xprep = ?P
}
	 

class  RelativeOvertByAgent
import RelativeOvertPPTop[]
{<syn> { 
       	 node ?xprep(mark=flex)[cat=by]
       }
}

class  RelativeOvertToObject
import RelativeOvertPPTop[]
{<syn> {
	node ?xprep(mark=flex)[cat=cat_to]
	}
}

class  RelativeOvertPObject
import RelativeOvertPPTop[]
{<syn> {
	node ?xprep(mark=coanchor,name=Prep)[cat=prep]
	}
}

%--------------------------------------------------

class  RelativeOvertPPAnchorArgumentNP
import RelativeOvertExtractedWH[]
export ?xV ?RelPP
declare ?xV ?RelPP
{<syn> {
	node ?VP{
	     node ?xV(color=white)[cat=v]
	     ,,,node ?RelPP(color=red)[cat=pp]		
		  } 
	}
}

class  RelativeOvertPPAnchorPied-PipingTop 
import RelativeOvertPPAnchorArgumentNP[]
       PrepCaseAssigner[]
export  ?xPrep ?xArg
declare ?xPrep ?xArg
{<syn>{	
	node ?WH [cat=pp] {
 	   node ?xPrep(color=red)[cat=prep]
 	   node ?xArg (color=red,mark=subst)[cat=np]
			}
 	} ; ?RelPP = ?Trace ; ?WH = ?PP ; ?xPrep = ?P ; ?xArg = ?NP
}

class  RelativeOvertPPAnchorPied-Piping %final
import RelativeOvertPPAnchorPied-PipingTop[]
{<syn> { 
       	 node ?xPrep (mark=anchor)
       }
}

class  RelativeOvertPPAnchorPied-Piping-P %final
import RelativeOvertPPAnchorPied-PipingTop[]
declare ?xprep1 ?xprep2
{<syn> { 
       	 node ?xPrep {
       	      node ?xprep1(color=red,mark=coanchor,name=Anchor)[cat=prep]
	      node ?xprep2(color=red,mark=anchor)[cat=prep]
	      	   }
	}
}

class  RelativeOvertPPAnchorPied-Piping-N %final
import RelativeOvertPPAnchorPied-PipingTop[]
export  ?xarg ?xprep2
declare ?xarg ?xprep2
{<syn> { 
       	 node ?xPrep {
       	      node ?xarg(color=red,mark=coanchor,name=Anchor)[cat=n]
	      node ?xprep2(color=red,mark=anchor)[cat=prep]
	      	   }
	}
}

class  RelativeOvertPPAnchorPied-Piping-PNP %final
import RelativeOvertPPAnchorPied-Piping-N[]
declare ?xprep1
{<syn> { 
       	 node ?xPrep {
       	      node ?xprep1 (color=red,mark=coanchor,name=Anchor2)[cat=prep]
       	      node ?xarg   
	      node ?xprep2
	      	   }
	}
}

class  RelativeOvertPPAnchor-PPArg
import RelativeOvertPPAnchorArgumentNP[]
       PrepCaseAssigner[]
declare ?xNP 
{<syn>{
	node ?WH (mark=subst) [cat=np] ;
	    node ?RelPP{
		 node ?P(color=red)[cat=prep]
		 node ?xNP(color=red)[cat=np]
			}
	} ;  ?xNP = ?Trace ; ?RelPP = ?PP ; ?xNP = ?NP
}

class  RelativeOvertPPAnchor-P %final
import RelativeOvertPPAnchor-PPArg[]
{<syn> {
	node ?P (mark=anchor)
       }
}

class  RelativeOvertPPAnchorArgumentXP
import RelativeOvertPPAnchor-PPArg[]
export  ?xprep2 ?xArg
declare ?xprep2 ?xArg
{<syn> {
	node ?P {
       	     node ?xArg (color=red,mark=coanchor,name=Anchor)
	     node ?xprep2 (color=red,mark=anchor)[cat=prep]
	     	      }
	}
}

class  RelativeOvertPPAnchorArgumentAdv %final
import RelativeOvertPPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=adv]
       } 
}

class  RelativeOvertPPAnchorArgumentAdj %final
import RelativeOvertPPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=a]
       } 
}

class  RelativeOvertPPAnchorArgumentN %final
import RelativeOvertPPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=n]
       } 
}


class  RelativeOvertPPAnchorArgumentP %final
import RelativeOvertPPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=prep]
       } 
}

class  RelativeOvertPPAnchorArgumentPNP %final
import RelativeOvertPPAnchorArgumentN[]
declare ?xprep1
{<syn> {
	node ?P {
       	    node ?xprep1 (color=red,mark=coanchor,name=Anchor2)[cat=prep]
	    node ?xArg
	    node ?xprep2
	    	 }
	}
}

%---------------------------------------------------

class  RelativeCovertExtractedWH
import RelativeClause[]
export  ?fComp ?fM
declare ?fComp ?fM
{<syn> { 
       	 node ?WH (mark=nadj)[cat=np,top=[wh= -],bot=[phon=e]] ;
	     node ?XP [top=[mode=@{inf,ind}],bot=[comp=no_comp,assign-comp=?fComp]] 
		      	{
	     	      node?VP[top=[assign-comp=?fComp]]
		      	}
	} ; ?fComp = @{that,ind_nil,inf_nil,for,ecm} 
	 
}

class  RelativeCovertSubject
%in XTAG the XP top mode & nocomp-mode features differ in active & pass. I have one class feat for both.
import RelativeCovertExtractedWH[]
       SubjectAgreement[]
{<syn> { 
       	 node ?XP {
	      node ?Trace(color=red)[cat=np]
	      node?VP
		}
	};?XP = ?S ; ?Trace = ?Subj ; ?VP = ?xagr ; ?fComp =  @{that,ind_nil,inf_nil,ecm,for}
}

class  RelativeCovertSubjectOuter
import RelativeCovertSubject[]
declare ?xverb ?xprepph ?xprep ?xe ?fT
{<syn> {
	node ?Trace [top=[trace=?fT]];
	node ?VP {
       	     node ?xverb(color=white)[cat=v]
	     ,,,node ?xprepph(color=red,rank=6)[cat=pp]{
			node ?xprep(color=red,mark=coanchor,name=Prep)[cat=prep]
                        node ?xe (color=red)[cat=np,phon=e,top=[trace=?fT]]
							}
		}
	}	
}

class  RelativeCovertComplementTop
import RelativeCovertExtractedWH[]
export ?V
declare ?V
{<syn> { 
       	 node ?XP [top=[mode=@{inf,ind},nocomp-mode=ind]] ;
       	 node ?VP{
		node ?V(color=white)
               	,,,node ?Trace(color=red,mark=nadj)[cat=np]
                  }                    
	} ; ?fComp = @{that,for,ind_nil}
}

class  RelativeCovertObject
import RelativeCovertComplementTop[]
       VerbCaseAssigner[] 
{<syn> { 
       	 node ?Trace(rank=2,gf=obj)
        }; ?VP = ?verbph; ?V = ?verb ; ?Trace = ?NP1
}

class  RelativeCovertIObject
import RelativeCovertComplementTop[]
       VerbCaseAssigner[] 
{<syn>{
	node ?Trace(rank=1,gf=iobj)
	}; ?VP = ?verbph; ?V = ?verb ; ?Trace = ?NP2
}

class  RelativeCovertPPObject-VPE
import RelativeCovertExtractedWH[]
       PrepCaseAssigner[]
export ?RelPObj ?V ?VPe ?Ve
declare ?RelPObj ?V ?VPe ?Ve
{<syn>{ 
	node ?VP{
	     node ?V(color=white)[cat=v]
	     ,,,node ?VPe(color=red,rank=4)[cat=vp,
	     	     bot=[compar = -, mainv = -,assign-comp = no_comp]]{
		     node ?Ve(color=red,mark=nadj)[cat=v,phon=e]
		     node ?RelPObj(color=red)[cat=pp]{
		     	  node ?P(color=red)[cat=prep]
			  node ?Trace(color=red)[cat=np]
						}
					}
		}	
	}; ?RelPObj = ?PP ; ?Trace = ?NP
}

class  RelativeCovertPPSubst
import RelativeCovertPPObject-VPE[]
{<syn>{
	node ?P(mark=subst)
	}
}

class  RelativeCovertPPAnchor
import RelativeCovertPPObject-VPE[]
{<syn>{
	node ?P(name=Prep, mark=coanchor)
	}
}

class  RelativeCovertPPTop
import RelativeCovertExtractedWH[]
       PrepCaseAssigner[]
export ?xverb ?xprepph ?xprep 
declare ?xverb ?xprepph ?xprep
{<syn>{
	node ?VP [top=[mode=ind]]{
	     node ?xverb(color=white) [cat=v]
	     ,,,node ?xprepph(color=red,rank=6)[cat=pp] {
	     	     node ?P(color=red)
		     node ?Trace (color=red)[cat=np]
						}
		}
	}; ?xprepph = ?PP ; ?Trace = ?NP	
}

class  RelativeCovertByAgent
import RelativeCovertPPTop[]
{<syn> {
	node ?P (mark=flex)[cat=by]
       }
}

class  RelativeCovertToObject
import RelativeCovertPPTop[]
{<syn> {
	node ?P (mark=flex)[cat=cat_to]
       }
}

class  RelativeCovertPObject
import RelativeCovertPPTop[]
{<syn> {
	node ?P (mark=coanchor,name=Prep)[cat=prep]
       }
}

%---------------------------------------------------

class  RelativeCovertPPAnchorArgumentNP
import RelativeCovertExtractedWH[]
export ?V ?WhPP
declare ?V ?WhPP 
{<syn>{
	node ?VP{
	    node ?V(color=white)[cat=v]
	    node ?WhPP(color=red)[cat=pp]		
		} ;
	node ?Trace(color=red)
	}
}  

class  RelativeCovertPPAnchor-PPArg
import RelativeCovertPPAnchorArgumentNP[]
       PrepCaseAssigner[]
declare ?xNP 
{<syn>{
	node ?WhPP{
	     node ?P(color=red)[cat=prep]
	     node ?xNP[cat=np]
			}
	} ;  ?xNP = ?Trace ; ?WhPP = ?PP ; ?xNP = ?NP
}

class  RelativeCovertPPAnchor-P %final
import RelativeCovertPPAnchor-PPArg[]
{<syn> { 
       	 node ?P(mark=anchor)
	}
}
	  
class  RelativeCovertPPAnchorArgumentXP
import RelativeCovertPPAnchor-PPArg[]
export  ?xprep2 ?xArg
declare ?xprep2 ?xArg
{<syn> {
	node ?P {
       	     node ?xArg (color=red,mark=coanchor,name=Anchor)
	     node ?xprep2 (color=red,mark=anchor)[cat=prep]
	     	      }
	}
}

class  RelativeCovertPPAnchorArgumentAdv %final
import RelativeCovertPPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=adv]
       } 
}

class  RelativeCovertPPAnchorArgumentAdj %final
import RelativeCovertPPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=a]
       } 
}


class  RelativeCovertPPAnchorArgumentN %final
import RelativeCovertPPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=n]
       } 
}


class  RelativeCovertPPAnchorArgumentP %final
import RelativeCovertPPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=prep]
       } 
}


class  RelativeCovertPPAnchorArgumentPNP
import RelativeCovertPPAnchorArgumentN[]
declare ?xprep1
{<syn> {
	node ?P {
       	    node ?xprep1 (color=red,mark=coanchor,name=Anchor2)[cat=prep]
	    node ?xArg
	    node ?xprep2
	    	 }
	}
}

class  RelativeAdjunctCovert
import RelativeCovertExtractedWH[]
{<syn> {
	 node ?XP [nocomp-mode=@{ind,inf}]
	 } 
}

%-------------------------------------------------

class  GerundArgument
import VerbalArgument[]
{<syn>{	
	node ?XP[cat=np,bot=[pers = 3,case=@{nom,acc}]]{
		node ?VP[cat=@{vp,n}]
				}
	}
}

class  DeterminerGerund
import GerundArgument[]
export ?V
declare ?V 
{<syn>{	
	node ?VP[cat=n]{
	     node ?V(color=white)[cat=v,bot=[mode=ger]]
			}
	}
}

class  DeterminerGerundSubject
import DeterminerGerund[]
declare ?Det ?fConst ?fDef ?fQu ?fCard ?fDecr ?fWH ?fCmp
{<syn>{
	node ?XP[bot =[const=?fConst,definite=?fDef,quan=?fQu,card=?fCard,decrease=?fDecr,wh=?fWH,compar=?fCmp]]{
	     node ?Det(color=red,mark=subst)[cat=det,
	        bot = [const=?fConst,definite=?fDef,quan=?fQu,card=?fCard,decrease=?fDecr,wh=?fWH]]
	     node ?VP [cat=n,top=[compar=?fCmp]]
	     	  }; ?fDef = + ; ?fCmp = -
	}
}

class  DeterminerGerundComplement
import DeterminerGerund[]
export ?gerundcompl 
declare ?gerundcompl 
{<syn>{
	node ?VP{
	     node ?V
	     ,,,node ?gerundcompl(color=red)
		}
	}
}

class  DeterminerGerundObject
import DeterminerGerundComplement[]
       PrepCaseAssigner[]
{<syn>{
	node ?gerundcompl(rank=2)[cat=pp]{
	     node ?P(color=red,mark=flex)[cat=of]
	     node ?NP(color=red,mark=subst)[cat=np]
				} ; 
	?gerundcompl=?PP
	}
}


class  DeterminerGerundObjectNCoanchor
import DeterminerGerundComplement[]
       PrepCaseAssigner[]
declare ?X ?N ?fAC ?fP ?fN ?fG ?fWH ?fConst ?fDef ?fQu ?fCard ?fDecr
{<syn>{ 
	node ?gerundcompl(rank=2)[cat=pp]{
	     node ?P(color=red,mark=flex)[cat=of]
	     node ?NP(color=red)[cat=np,bot=[case=?fAC,num=?fN,wh=?fWH,definite=?fDef]]{
	     	  node ?N(color=red,name=Noun,mark=coanchor)[cat=n,top=[case=?fAC,num=?fN,wh=?fWH,definite=?fDef]]
									}
					}
	}; ?gerundcompl = ?PP
}

class  DeterminerGerundToObject
import DeterminerGerundComplement[]
       PrepCaseAssigner[]
declare ?N
{<syn>{ 
	node ?gerundcompl(rank=3)[cat=pp]{
	     node ?P(color=red,mark=flex)[cat=cat_to]
	     node ?NP(color=red)[cat=np,mark=subst]
					}
	}; ?gerundcompl = ?PP
}

class  DeterminerSentComplement
import DeterminerGerundComplement[]
{<syn> {
	node ?gerundcompl(color=red,mark=subst,rank=6)[cat=s]
	}
}
	
class  DeterminerIObject
import DeterminerGerundComplement[]
       PrepCaseAssigner[]
{<syn>{
	node ?gerundcompl(rank=1)[cat=pp]{
	     node ?P(color=red,mark=flex)[cat=cat_for]
	     node ?NP(color=red,mark=subst)[cat=np]
					}
	}; ?gerundcompl = ?PP
}

class  DeterminerGerundPPIObject
import DeterminerGerundComplement[]
       PrepCaseAssigner[]
export ?Ve 
declare ?Ve
{ <syn>{
	node ?gerundcompl(rank=4)[cat=vp]{
	     node ?Ve(color=red)[cat=v,phon=e]
	     node ?PP(color=red)[cat=vp]{
	     	  node ?P(color=red)[cat=prep]
                  node ?NP(color=red,mark=subst) [cat=np]          
                                         }
                                       }
	}
}

class  DeterminerGerundPPSubst
import DeterminerGerundPPIObject[]
{<syn>{
	node ?P(mark=subst)
	}
}

class  DeterminerGerundPPAnchor
import DeterminerGerundPPIObject[]
{<syn>{
	node ?P(mark=coanchor,name=Prep)
	}
}

class  NPGerund 
import GerundArgument[]
export ?GerundSubj ?fWH ?fCmp
declare ?GerundSubj ?fWH ?fCmp
{<syn>{ 
	node ?XP %[top=[definite= @{-,+}],
	     	  [bot = [gerund = +,wh = ?fWH, num=sing, compar=?fCmp]]{
	     node ?GerundSubj (color=red)[top = [wh=?fWH,compar=?fCmp]]
	     node ?VP [cat=vp,top =[mode=ger]]
	     	  }
	}
}

class  SubjectNCoanchorNPGerund
import NPGerund[]
declare ?N
{<syn>{
	node ?GerundSubj [cat=np,top=[wh= -]]{
	     node ?N(color=red,name=Noun,mark=coanchor)[cat=n]
					}
	}
}

class  NPGerundSubjectCan
import NPGerund[]
{<syn>{
	node ?XP [cat=np]{
	node ?GerundSubj(mark=subst)[cat=np,top=[definite= -, wh = -, case=@{acc,gen}]]
	     		}
	}
}

class  NPGerundSubjectPro
import NPGerund[]
declare ?X
{<syn> {
	node ?XP [top=[definite= - ]]{ %this feat is added to prevent [the [PRO melting]]
		node ?GerundSubj(mark=nadj)[cat=np,top = [definite= -,case = none,wh= -]]{
		     	node ?X(color=red,mark=nadj)[cat=Pro]
							}
        node ?VP
            }
        }
}

%-------------------------------------------------

class  CleftArgument
import
    VerbalArgument[]
export  ?NP0 ?N ?V0 ?VP1 ?V1 ?XP1 ?S
declare ?NP0 ?N ?V0 ?VP1 ?V1 ?XP1 ?S ?fC ?fC1 ?fAC2 ?fCond ?fAC3 ?fP2 ?fN2 ?fG2 ?fP3 ?fN3 ?fG3 ?fWH3 ?fM3?fM
{<syn>{
	node ?XP[cat=s,top=[assign-comp=@{inf_nil,ind_nil}],bot=[assign-case=?fC,inv= -,cond=?fCond]] {
	     	node ?NP0(color=red)[cat=np,top=[case=?fC],bot=[case=?fC1]]{
			node ?N(color=red,name=CleftIt,mark=coanchor)[cat=n,top=[case=?fC1],bot=[pers=3,num=sing]]
					}
        	node ?VP[cat=vp,top=[cond=?fCond],bot=[mode=?fM]]{
		     node ?V0 (color=white)[cat=v]
		     node ?VP1(color=red)[cat=vp,top=[mode=?fM],bot=[mode=?fM]]{
		     	  node ?V1(color=red,mark=nadj)[phon=e,cat=v]
			  node ?XP1 (color=red)
			  node ?S(color=red,mark=subst)[cat=s,
							bot=[extracted =  -,mode=ind,assign-comp=@{ind_nil,inf_nil},comp=@{that,no_comp}]]
                                				       }
                                		}
                                }
        }
}

class  CanonicalCleftArgument
import CleftArgument[]
{<syn>{
	node ?V0 (mark=anchor);
	node ?S[bot=[assign-comp=ind_nil]]
	}
}

class  CanonicalNominalCleft
import CanonicalCleftArgument[]
{<syn>{
	node ?XP1(mark=subst)[cat=np,top=[case=@{nom,acc}]]
	}
}


class  CanonicalPPCleft
import CanonicalCleftArgument[]
       PrepCaseAssigner[]
{<syn>{
	node ?XP1[cat=pp]{
	    node ?P(color=red,mark=subst)[cat=prep]
	    node ?NP(color=red,mark=subst)[cat=np]
			}
	}; ?XP1 = ?PP
}

class  CanonicalAdverbCleft
import CanonicalCleftArgument[]
{<syn>{
	node ?XP1(mark=subst)[cat=adv]
	}
}

class  WhCleftArgument
import CleftArgument[]
       MovementAgreement[] 
export ?Sq 
declare ?Sq ?fM ?fPass ?fWH ?fT
{<syn>{
	node ?Sq(color=red)[cat=s,bot=[comp=no_comp,inv= +,mode=?fM,pass= -,pass=?fPass,
	    			       wh=?fWH,assign-comp=@{inf_nil,ind_nil}]] ;
	node ?WH1(color=red)[top = [wh= +, wh = ?fWH,trace = ?fT]] ;
	node ?XP [top=[mode=ind,pass=?fPass]] ;
	node ?XP1 (mark=nadj) [top = [trace= ?fT, wh= ?fWH],bot=[phon=e]] ;
	   ?Sq -> ?WH1 ; ?WH1 >> ?XP ; ?Sq ->+ ?XP 
	   } ;  ?XP1 = ?WhArg 
}

class  WhNominalCleft
import WhCleftArgument[]
{<syn>{ 
	node ?WH1 (mark=subst)[cat=np];
	node ?WhArg[cat=np, top = [case=@{nom,acc}]]
	}
}

class  WhPPCleft
import WhCleftArgument[]
{<syn>{			  
	node ?WH1(mark=subst)[cat=pp] ; 
	node ?WhArg[cat=pp]
	}
}

class  WhPPCleftExhaustive
import WhCleftArgument[]
{<syn>{
	node ?WH1(mark=subst)[cat=pp]
	}
}

class  WhAdverbCleft
import WhCleftArgument[]
{<syn>{ 
	node ?WH1 (mark=subst)[cat=adv];
	node ?WhArg [cat=adv]
       } 
}

%-------------------------------------------------
%small clauses with PPs

class  PPAnchorTop
import CanComplement[]
export ?xprep
declare ?xprep
{<syn> {
	node ?compl(color=red) [cat=pp]{
       	     node ?xprep(color=red)[cat=prep]
					}
	}
} 

class  PPAnchorExhaustiveCan
import PPAnchorTop[]
{<syn> {
	node ?xprep (mark=anchor)
       }
}

class  PPAnchorArgument
import PPAnchorTop[]
       PrepCaseAssigner[]
export ?xNP
declare ?xNP
{<syn> {
	node ?xNP (mark=subst,color=red)[cat=np];
       	?xprep >> ?xNP ; 
	?compl = ?PP ; ?xprep = ?P ; ?xNP = ?NP
	}
}

class  PPAnchorArgumentNPCan %final
import PPAnchorArgument[]
{<syn> {
	node ?xprep (mark=anchor)
       }
}

class  PPAnchorArgumentXP
import PPAnchorArgument[]
export  ?xprep2 ?xArg
declare ?xprep2 ?xArg
{<syn> {
	node ?xprep {
       	     node ?xArg (color=red,mark=coanchor,name=Anchor)
	     node ?xprep2 (color=red,mark=anchor)[cat=prep]
	     	      }
	}
}

class  PPAnchorArgumentAdvCan  %final
import PPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=adv]
       } 
}

class  PPAnchorArgumentAdjCan  %final
import PPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=a]
       } 
}

class  PPAnchorArgumentNCan  %final
import PPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=n]
       } 
} 


class  PPAnchorArgumentPCan %final
import PPAnchorArgumentXP[]
{<syn> { 
       	 node ?xArg [cat=prep]
       } 
}

class  PPAnchorArgumentPNPCan
import PPAnchorArgumentNCan[]
declare ?xprep1
{<syn> {
	node ?xprep {
       	    node ?xprep1 (color=red,mark=coanchor,name=Anchor2)[cat=prep]
	    node ?xArg
	    node ?xprep2
	    	 }
	}
}

%-----------------
%Lexical classes:
%-----------------

class  noun 
declare ?NP ?N ?fWH ?fDef ?fC ?fN ?fP ?fG
{<syn>{
	node ?NP (color=red) [cat=np,bot=[definite= ?fDef,wh=?fWH,pers=?fP,num=?fN,case=?fC]] {
	     node ?N (color=red,mark=anchor)[cat=n,top=[wh=?fWH,definite=?fDef,pers=?fP,num=?fN]]
										 }
	}
}

class  betaXn
export ?Nr ?modifier ?Nf ?fC ?fP ?fN ?fWH ?fAC ?fDef
declare ?Nr ?modifier ?Nf ?fC ?fP ?fN ?fWH ?fAC ?fDef
{<syn>{
	node ?Nr(color=red)[cat=n,bot=[case=?fC,pers=?fP,num=?fN,wh=?fWH,assign-comp=?fAC,definite=?fDef]]{
	    node ?modifier(color=red,mark=anchor)[top=[wh=?fWH]]
	    node ?Nf(color=red,mark=foot)[cat=n,top=[case=?fC,pers=?fP,num=?fN,assign-comp=?fAC,definite=?fDef]]
												}
	}
}

class  betaNn
import betaXn[]
{<syn>{
	node ?modifier(color=red,mark=anchor)[cat=n]
	}
}

class  betaAn
import betaXn[]
{<syn>{
	node ?modifier(color=red,mark=anchor)[cat=a]
	}
}

class  adjective 
declare ?AP ?A ?fWH 
{<syn>{
	node ?AP (color=red) [cat=ap,bot=[wh=?fWH]] { 
  	     node ?A (color=red,mark=anchor)[cat=a,top=[wh=?fWH]] 
						}
 	}
}

class  adverb 
declare ?Adv 
{ <syn>{ 
  	 node ?Adv (color=red,mark=anchor)[cat=adv] 
	 }
}

class  betaARBa
declare ?Ar ?Ad ?Ax ?fWh ?fAC ?fCmp ?fEq ?fConj
{<syn> {
	 node ?Ar (color=red) [cat=a,bot=[wh=?fWh,assign-comp=?fAC,conj=?fConj,compar=?fCmp,equiv=?fEq]]{
	      node ?Ad (color=red,mark=anchor) [cat=adv,top=[wh=?fWh]]
	      node ?Ax (color=red,mark=foot)[cat=a,top=[wh= - ,assign-comp=?fAC,conj=?fConj,compar=?fCmp,equiv=?fEq]]
					}
	}
}

class  betaARB
export ?VP1 ?VP2 ?ADV
declare ?VP1 ?VP2 ?ADV ?fN ?fM ?fT ?fC ?fAC ?fPass
{<syn>{
	node ?VP1(color=red)[cat=vp,
	          bot=[num=?fN,mode=?fM,tense=?fT,assign-case=?fC,assign-comp=?fAC,passive=?fPass]];
 	node ?VP2(color=red,mark=foot)[cat=vp,
		  top=[num=?fN,mode=?fM,tense=?fT,assign-case=?fC,assign-comp=?fAC,passive=?fPass]];
  	node ?ADV(color=red,mark=anchor)[cat=adv]
       }
}

class  betavxARB
import betaARB[]
{<syn>{
	?VP1 -> ?VP2;
 	?VP1 -> ?ADV;
  	?VP2 >> ?ADV
       }
}

class  betaARBvx
import betaARB[]
{<syn>{
	?VP1 -> ?VP2;
  	?VP1 -> ?ADV;
  	?ADV >> ?VP2
       }
}

class  betaDn
export ?NPr ?NPf ?Det 
declare ?NPr ?NPf ?Det ?fDef ?fWH ?fC ?fP ?fN ?fDef1 ?fWH1
{<syn>{
	node ?NPr(color=red)[cat=np,bot=[definite=?fDef,wh=?fWH,case=?fC,pers=?fP,num=?fN]]{
	     node ?Det(color=red,mark=anchor)[cat=det,top=[definite=?fDef,wh=?fWH,num=?fN],bot=[definite=?fDef1,wh=?fWH1]]
      	     node ?NPf(color=red,mark=foot)[cat=np,top=[rel-clause = -,case=?fC,pers=?fP,num=?fN]]}
       } 
}

class  betaVv
declare ?VPr ?VPf ?V ?fC ?fM ?fTense ?fP ?fN ?fAC ?fRM ?fPass ?fPass1
{<syn>{
	node ?VPr(color=red)[cat=vp,bot=[assign-case=?fC,mode=?fM,tense=?fTense,pers=?fP,num=?fN,assign-comp=?fAC]]{
	     node ?V(color=red,mark=anchor)[cat=v,
			top=[assign-case=?fC,mode=?fM,tense=?fTense,pers=?fP,num=?fN,assign-comp=?fAC],bot=[rmode=?fRM]]
       	     node ?VPf(color=red,mark=foot)[cat=vp,bot=[mode=?fRM]]
									}
	}
}

class  betaVs
export ?Sr ?V ?Sf
declare ?Sr ?V ?Sf ?fP1 ?fN1 ?fG1 ?fTense ?fM ?fC ?fP ?fN ?fRM
{<syn>{
	node ?Sr(color=red)[cat=s,top=[inv = +],bot=[pers=?fP1,num=?fN1,tense=?fTense,mode=?fM,assign-case=?fC]]{
	    node ?V(color=red,mark=anchor)[cat=v,
			top=[pers=?fP1,num=?fN1,tense=?fTense,mode=?fM,assign-case=?fC],bot=[pers=?fP,num=?fN,rmode=?fRM]]
	    node ?Sf(color=red,mark=foot)[cat=s,top=[pers=?fP,num=?fN,assign-case=?fC,mode=?fRM],bot=[inv= -,comp=no_comp]]
									}
	}
}

class  betaCOMPs
export ?Sc ?Sr ?Comp
declare ?Sc ?Comp ?Sr ?fComp
{<syn>{
	node ?Sc(color=red)[cat=s,bot=[inv= - ,comp = ?fComp]]{
	    	node ?Comp(color=red,mark=anchor)[cat=comp,top=[comp=?fComp]]
		node ?Sr(color=red,mark=foot)[cat=s,top=[inv= -,assign-comp=?fComp],bot=[comp=no_comp]]
								}
	};?fComp=that
}

class  betaxPn
import PrepCaseAssigner[]
export ?xroot ?xfoot ?xprepph ?xprep ?xnoun 
declare ?xroot ?xfoot ?xprepph ?xprep ?xnoun 
{<syn>{ 
	node xroot(color=red) {
		node xfoot(color=red,mark=foot)
		node xprepph(color=red)[cat=pp]{
			node xprep (color=red,mark=anchor)[cat=prep]
			node xnoun (color=red,mark=subst)[cat=np]
						}
				} 
	}; xprepph = ?PP ; xprep = ?P ; xnoun = ?NP	
}

class  betavPn
import betaxPn[]
declare ?fP ?fN ?fM ?fTense ?fC ?fAC ?fPass
{ <syn>{ 
  	 node xroot[cat=vp,bot=[pers=?fP,num=?fN,mode=?fM,tense=?fTense,assign-case=?fC,assign-comp=?fAC,pass=?fPass]]{
		node xfoot[cat=vp,top=[pers=?fP,num=?fN,mode=?fM,tense=?fTense,assign-case=?fC,assign-comp=?fAC,pass=?fPass]]
		node xprepph
							}
	}; xprepph = ?PP ; xprep = ?P ; xnoun = ?NP	
}
 
class  betanPn
import betaxPn[]
declare ?fP ?fN ?fG ?fC ?fAC ?fDef ?fWH
{<syn>{ 
	node xroot[cat=np,bot=[pers=?fP,num=?fN,case=?fC,assign-comp=?fAC,wh=?fWH,definite=?fDef]]{
		node xfoot[cat=np,top=[pers=?fP,num=?fN,case=?fC,assign-comp=?fAC,wh=?fWH,definite=?fDef],
				  bot=[case=@{nom,acc}]]
		node xprepph(color=red)
								}
	}; xprepph = ?PP ; xprep = ?P ; xnoun = ?NP	
}

class  betanPns
import PrepCaseAssigner[]
declare ?xroot ?xfoot ?xprepph ?xprep ?xnoun
{<syn>{ 
	node xroot(color=red)[cat=s]{
	     node xprepph(color=red)[cat=pp]{
	     	  node xprep (color=red,mark=anchor)[cat=prep]
	   	  node xnoun (color=red,mark=subst)[cat=np]
					}
	     node xfoot(color=red,mark=foot)[cat=s]
					}
	}; xprepph = ?PP ; xprep = ?P ; xnoun = ?NP	
}

class  alphaPPn
import PrepCaseAssigner[]
declare ?xprepph ?xprep ?xnoun
{<syn> { 
       	 node xprepph (color=red)[cat=pp]{
       	      node xprep(color=red,mark=anchor)[cat=prep]
	      node xnoun (color=red,mark=subst)[cat=np]
					}
	}; xprepph = ?PP ; xprep = ?P ; xnoun = ?NP
}

class  alphaPP
declare ?xprepph ?xprep ?fWH
{<syn> {
	node xprepph(color=black)[cat=pp,bot=[wh=?fWH]]{
       	     node xprep(color=black,mark=anchor)[cat=prep,top=[wh=?fWH]]
						}
	 }
}


class  preposition 
declare ?xprep
{<syn>{
	node xprep (color=red,mark=anchor)[cat=prep]
	}    
}
 
class  determiner
declare ?Det ?fDef
{<syn>{
	node ?Det (color=red,mark=anchor)[cat=det,top=[definite=?fDef]]
 	}
}

class  betax1CONJx2
export ?Xr ?X1 ?X2 ?Conj
declare ?Xr ?X1 ?X2 ?Conj
{<syn>{ 
	node ?Xr(color=red){
	     node ?X1(color=red,mark=foot)
	     node ?Conj(color=red,mark=anchor)[cat=conj]
	     node ?X2(color=red,mark=subst)}
	}
}

class  betan1CONJn2
import betax1CONJx2[]
declare ?fC ?fWH ?fDef
{<syn>{
	node ?Xr[cat=np,bot=[case=?fC,wh=?fWH,definite=?fDef]];
	    node ?X1[cat=np,top=[case=?fC,wh=?fWH,definite=?fDef]];
	    node ?X2[cat=np,top=[case=?fC,wh=?fWH,definite=?fDef]]
	 }; ?fC = @{nom,acc}
}

class  betas1CONJs2
import betax1CONJx2[]
declare ?fM ?fWH
{<syn>{ 
	node ?Xr[cat=s,bot=[mode=?fM,wh=?fWH]];
	     node ?X1[cat=s,top=[mode=?fM,wh=?fWH]];
	     node ?X2 [cat=s,top=[mode=?fM,wh=?fWH]]
	}; ?fM = @{ind,inf,ger,imp}
}

class  betaCONJs1CONJs2
import betax1CONJx2[]
declare ?Conj1 ?Conj2
{<syn>{ 
	node ?Xr[cat=s]{
	     node ?Conj1(color=red,name=Conjunction,mark=coanchor)[cat=conj]
	     node ?X1[cat=s]
	     node ?Conj2
	     node ?X2[cat=s]}
	}; ?Conj2 = ?Conj
}

class  betaVn
%this is an alternative tree in n0V, En1V, n0Vn1 
declare ?xNr ?xVP ?xV ?xNf ?fC ?fP ?fN ?fWH ?fDef ?fM ?fCmp ?fPron ?fQu ?fCard ?fDecr ?fConst
{<syn> {
	node ?xNr (color=black)[cat=n,bot=[case=?fC,pers=?fP,pron=?fPron,num=?fN,wh=?fWH,
			definite=?fDef,compar=?fCmp,const=?fConst,quan=?fQu,card=?fCard,decrease=?fDecr]]{
	     node ?xVP (color=black)[cat=vp,bot=[mode=?fM]]{
	     	  node ?xV(color=black,mark=anchor)[cat=v,top=[mode=?fM,punct-struct=nil]]
					}
	     node ?xNf(color=red,mark=foot)[cat=n,top=[case=?fC,pers=?fP,pron=?fPron,num=?fN,wh=?fWH,
			definite=?fDef,compar=?fCmp,const=?fConst,quan=?fQu,card=?fCard,decrease=?fDecr]]
				    } 
	}*=[vmode = ?fM] ; ?fC = @{nom,acc} ; ?fCmp = -  

} 

class  alphaAV
declare ?xA ?xVP ?xV
{<syn> {
	node ?xA (color=red)[cat=a,bot=[wh= -]] {
	     node ?xVP (color=red) [cat=vp] {
	     	    node ?xV (color=red,mark=anchor) [cat=v,top=[mode=ppart,punct-struct=nil]]
		    	     			}
					}

	}
}

