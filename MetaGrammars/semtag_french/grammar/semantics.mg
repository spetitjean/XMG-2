% Logon semantics
% sources = allegro/semantics.mg



% -------------------------------------------------------
% One semantic per function (subjectSem, objectSem)
% labels the arg node of the corresponding class (Subject, Object)
% subjectSem exports a node variable (xSubj)
% each tree fragment in a class exports a node variable (xArg)
% the two variables are unified when enumerating the class
% A=CanonicalSubject[];xSubj = A.xArg
% -------------------------------------------------------

% -------------------------------------------------------
% Argument node semantics
% node xFunction [top=[idx=I,label = L]]
% *=[functionI = I, functionL = L]
% -------------------------------------------------------

class PROSem
      export xSubject
      declare ?xSubject ?I 
      { <syn>{ node xSubject[top=[pro-idx=I]]}*=[subjectI = I]}

class ControlleeSem
      export xSententialArg
      declare ?xSententialArg ?I 
      { <syn>{ node xSententialArg[top=[pro-idx=I]]}*=[controlleeI = I]}

class VerbSem
      export xVerbSem
      declare ?xVerbSem ?I ?L
      { <syn>{ node xVerbSem[bot=[idx=I,label = L]]}*=[vbI = I, topL = L]}

% non verbal predicates (relational nouns)
class predicateSem
      export xPred
      declare ?xPred ?E ?L
      {	<syn>{ node xPred[top=[idx=E,label=L]]}*=[predI=E,topL=L]}

% the semantic label of a verb semrepre provides the scope label of
%  argument nodes (which will provide the scope label of derminers)
% 01.12 CG: remove scope label as it conflicted with other classes and is not used in mrs
class ArgumentNodeSemantics
      export x I L
      declare ?x ?I ?L ?S
      { <syn>{ node x[top=[idx=I,label = L,scopeL=S]]}}

class modifieeSem
      import ArgumentNodeSemantics[]
      export xModifiee
      declare ?xModifiee
      { <syn>{ node xModifiee}*=[modifieeI = I, modifieeL = L]; 
      	       	    xModifiee = x}

class modifierSem
      import ArgumentNodeSemantics[]
      export xModifier
      declare ?xModifier
      { <syn>{ node xModifier}*=[modifierI = I, modifierL = L]; 
      	       	    xModifier = x}
class dummySem
      import ArgumentNodeSemantics[]
      export xDummy
      declare ?xDummy
      { <syn>{ node xDummy}*=[dummyI = I, dummyL = L]; 
      	       	    xDummy = x}

class SubjectSem
      import ArgumentNodeSemantics[]
      export xSubject
      declare ?xSubject ?fT
      { <syn>{ node xSubject(name=arg1)}*=[subjectI = I, subjectL = L,semtype=fT]; 
      	       	    xSubject = x}

class PassiveSubjectSem
      import ArgumentNodeSemantics[]
      export xSubject
      declare ?xSubject ?fT
      { <syn>{ node xSubject(name=arg2)}*=[subjectI = I, subjectL = L,semtype=fT]; 
      	       	    xSubject = x}


class ObjAttributeSem
      import ArgumentNodeSemantics[]
      export xObjAttribute
      declare ?xObjAttribute
      { <syn>{ node xObjAttribute}*=[objattributeI = I, objattributeL = L]; 
      	       	    xObjAttribute = x}
class ObjectSem
      import ArgumentNodeSemantics[]
      export xObject
      declare ?xObject
      { <syn>{ node xObject(name=arg2)}*=[objectI = I, objectL = L]; 
      	       	    xObject = x}
class IobjectSem
      import ArgumentNodeSemantics[]
      export xIobject
      declare ?xIobject
      { <syn>{ node xIobject}*=[iobjectI = I, iobjectL = L]; 
      	       	    xIobject = x}
class CAgentSem
      import ArgumentNodeSemantics[]
      export xCAgent
      declare ?xCAgent
      { <syn>{ node xCAgent}*=[cagentI = I, cagentL = L]; 
      	       	    xCAgent = x}
class ObliqueSem
      import ArgumentNodeSemantics[]
      export xOblique
      declare ?xOblique
      { <syn>{ node xOblique}*=[obliqueI = I, obliqueL = L]; 
      	       	    xOblique = x}
class LocativeSem
      import ArgumentNodeSemantics[]
      export xLocative
      declare ?xLocative
      { <syn>{ node xLocative}*=[locativeI = I, locativeL = L]; 
      	       	    xLocative = x}
class GenitiveSem
      import ArgumentNodeSemantics[]
      export xGenitive
      declare ?xGenitive
      { <syn>{ node xGenitive}*=[genitiveI = I, genitiveL = L]; 
      	       	    xGenitive = x}

class SententialSubjectSem
      import ArgumentNodeSemantics[]
      export xSententialSubject
      declare ?xSententialSubject
      { <syn>{ node xSententialSubject}*=[ssubjectI = I, ssubjectL = L]; 
      	       	    xSententialSubject = x}
class SententialCObjectSem
      import ArgumentNodeSemantics[]
      export xSententialCObject
      declare ?xSententialCObject
      { <syn>{ node xSententialCObject}*=[sobjectI = I, sobjectL = L]; 
      	       	    xSententialCObject = x}
class SententialDeObjectSem
      import ArgumentNodeSemantics[]
      export xSententialDeObject
      declare ?xSententialDeObject
      { <syn>{ node xSententialDeObject}*=[sdeobjectI = I, sdeobjectL = L]; 
      	       	    xSententialDeObject = x}
class SententialAObjectSem
      import ArgumentNodeSemantics[]
      export xSententialAObject
      declare ?xSententialAObject
      { <syn>{ node xSententialAObject}*=[saobjectI = I, saobjectL = L]; 
      	       	    xSententialAObject = x}
class SententialInterrogativeSem
      import ArgumentNodeSemantics[]
      export xSententialInterrogative
      declare ?xSententialInterrogative
      { <syn>{ node xSententialInterrogative}*=[sinterrogativeI = I,sinterrogativeL = L]; 
      	       	    xSententialInterrogative = x}

% ObjAttribute


% -------------------------------------------------------
% Percolation
% -------------------------------------------------------

class footProj1[]
export xP1 xSemFoot
declare ?xP1 ?xSemFoot ?X ?Y ?LX ?LY
{        <syn>{
                node xP1(color=white) [bot=[idx = X, label = LX],top=[idx = Y, label = LY]]
                        { node xSemFoot [top=[idx = X, label = LX]]}
        }
}

class footProj2[]
import footProj1[]
export xP2
declare ?xP2 ?X ?Y ?LX ?LY
{        <syn>{
                node xP2(color=white) [bot=[idx = X, label = LX],top=[idx = Y, label = LY]]
                        { node xP1 [top=[idx = X, label = LX]]}
        }
}

class anchorProj1[]
export xN xAnchor
declare ?xN ?xAnchor ?X ?Y ?LX ?LY
{        <syn>{
                node xN(color=white) [bot=[idx = X, label = LX],top=[idx = Y, label = LY]]
                        { node xAnchor [top=[idx = X, label = LX]]}
        }*=[vbL = LX]
}

class anchorProj2[]
import anchorProj1[]
export xNbar
declare ?xNbar ?X ?Y ?LX ?LY
{        <syn>{
                node xNbar(color=white)[bot=[idx = X, label = LX],top=[idx = Y, label = LY]]
                        { node xN(color=white) [top=[idx = X, label = LX]]}
        }
}

class anchorProj3[]
import anchorProj2[]
declare ?xNbarbar ?X ?Y ?LX ?LY
{        <syn>{
                node xNbarbar(color=white) [bot=[idx = X, label = LX],top=[idx = Y, label = LY]]
                        { node xNbar(color=white)[top=[idx = X, label = LX]]}
        }
}

class xSProj1[]
export xXS xN
declare ?xN ?xXS ?X ?Y ?LX ?LY
{        <syn>{
                node xN(color=white) [bot=[idx = X, label = LX],top=[idx = Y, label = LY]]
                        { node xXS [top=[idx = X, label = LX]]}
        }
}

class xSProj2[]
import xSProj1[]
declare ?xNbar ?X ?Y ?LX ?LY
{        <syn>{
                node xNbar(color=white)[bot=[idx = X, label = LX],top=[idx = Y, label = LY]]
                        { node xN(color=white) [top=[idx = X, label = LX]]}
        }
}
% -------------------------------------------------------
% Linking constraints
% -------------------------------------------------------

class dummyArg0Linking[]
export xR
declare ?I ?xR ?L
% {	<syn>{
%                 node xR
% 	}*=[dummyI = I,arg1 = I, dummyL = L, label0 = L]
% }
class modifierArg0Linking[]
export xR
declare ?I ?xR
% {	<syn>{
%                 node xR
% 	}*=[modifierI = I,arg0 = I]
% }

class AdjectiveHandleArg2Linking[]
export xR
declare ?I ?xR
% {	<syn>{
%                 node xR
% 	}*=[objattributeL = I,arg2 = I]
% }

class VerbHandleArg2Linking[]
export xR
declare ?L ?xR
% {	<syn>{
%                 node xR
% 	}*=[saobjectL=L,arg2=L]
% }
class modifieeArg1Linking[]
export xR
declare ?I ?xR
% {	<syn>{
%                 node xR
% 	}*=[modifieeI = I,arg1 = I]
% }
class modifierArg1Linking[]
export xR
declare ?I ?xR
% {	<syn>{
%                 node xR
% 	}*=[modifierI = I,arg1 = I]
% }
class modifieeArg0Linking[]
export xR
declare ?I ?xR
% {	<syn>{
%                 node xR
% 	}*=[modifieeI = I,arg0 = I]
% }

% class TopLevelClass
% export ?xS
% declare ?xS
% {	<syn>{node xS}}
	
% Controller/Controllee 

class SubjectControlLinking[]
import 
	TopLevelClass[]
declare ?I  
% {	<syn>{
%                 node xS
% 	}*=[subjectI = I,controlleeI = I]
% }
class ObjectControlLinking[]
import 
	TopLevelClass[]
declare ?I  
% {	<syn>{
%                 node xS
% 	}*=[objectI = I,controlleeI = I]
% }
class IobjectControlLinking[]
import 
	TopLevelClass[]
declare ?I  
% {	<syn>{
%                 node xS
% 	}*=[iobjectI = I,controlleeI = I]
% }

% Syntax/Semantic linking

class VerbArg0Linking[]
import 
	TopLevelClass[]
declare ?E
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E]
% }
class PredArg0Linking[]
import 
	TopLevelClass[]
declare ?E
% {	<syn>{
%                 node xS
% 	}*=[predI = E,arg0 = E]
% }

class ObjAttributeArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E, objattributeL = I,arg2 = I]
% }
class SubjectArg0Linking[]
import 
	TopLevelClass[]
declare ?I  ?E
% {	<syn>{
%                 node xS
% 	}*=[subjectI = I,arg0 = I, vbI = I]
% }
class SubjectArg1Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,subjectI = I,arg1 = I,subjectL=L,arg1L=L]
% }
class SubjectArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,subjectI = I,arg2 = I,subjectL=L,arg2L=L]
% }
class SubjectArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,subjectI = I,arg3 = I,subjectL=L,arg3L=L]
% }
class ObjectArg0Linking[]
import 
	TopLevelClass[]
declare ?I  
% {	<syn>{
%                 node xS
% 	}*=[objectI = I,arg0 = I]
% }
class ObjectArg1Linking[]
import 
	TopLevelClass[]
declare ?I  ?L
% {	<syn>{
%                 node xS
% 	}*=[objectI = I,arg1 = I,objectL=L,arg1L=L]
% }
class ObjectArg2Linking[]
import 
	TopLevelClass[]
declare ?I ?L  
% {	<syn>{
%                 node xS
% 	}*=[objectI = I,arg2 = I,objectL=L,arg2L=L]
% }

class CAgentArg1Linking[]
import 
	TopLevelClass[]
declare ?I ?L  
% {	<syn>{
%                node xS
% 	       }*=[cagentI = I,arg1 = I,cagentL=L,arg1L=L]
% }
class GenitiveArg1Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,genitiveI = I,arg1 = I,genitiveL=L,arg1L=L]
% }
class GenitiveArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,genitiveI = I,arg2 = I,genitiveL=L,arg2L=L]
% }
class GenitiveArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,genitiveI = I,arg3 = I,genitiveL=L,arg3L=L]
% }
class  IobjectArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,iobjectI = I,arg2 = I,iobjectL=L,arg2L=L]
% }
class  IobjectArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,iobjectI = I,arg3 = I,iobjectL=L,arg3L=L]
% }
class  ObliqueArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,obliqueI = I,arg2 = I,obliqueL=L,arg2L=L]
% }
class  ObliqueArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,obliqueI = I,arg3 = I,obliqueL=L,arg3L=L]
% }

class  LocativeArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,locativeI = I,arg2 = I,locativeL=L,arg2L=L]
% }
class  LocativeArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,locativeI = I,arg3 = I,locativeL=L,arg3L=L]
% }
class  SententialSubjectArg1Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,ssubjectI = I,arg1 = I,ssubjectL=L,arg1L=L]
% }
class  SententialSubjectArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,ssubjectI = I,arg2 = I,ssubjectL=L,arg2L=L]
% }
class  SententialCObjectArg0Linking[]
import 
	TopLevelClass[]
declare ?I ?L
% {	<syn>{
%                 node xS
% 	}*=[arg0 = I,sobjectI = I,sobjectL=L,arg0L=L]
% }

class  SententialCObjectArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,sobjectI = I,arg2 = I,sobjectL=L,arg2L=L]
% }
class  SententialCObjectArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,sobjectI = I,arg3 = I,sobjectL=L,arg3L=L]
% }
class  SententialDeObjectArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,sdeobjectI = I,arg2 = I,sdeobjectL=L,arg2L=L]
% }
class  SententialDeObjectArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,sdeobjectI = I,arg3 = I,sdeobjectL=L,arg3L=L]
% }
class  SententialAObjectArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,saobjectI = I,arg2 = I,saobjectL=L,arg2L=L]
% }
class  SententialAObjectArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,saobjectI = I,arg3 = I,saobjectL=L,arg3L=L]
% }
class  InterrogativeArg2Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,arg2 = L,sinterrogativeL=L]
% }
class  InterrogativeArg3Linking[]
import 
	TopLevelClass[]
declare ?I  ?E ?L
% {	<syn>{
%                 node xS
% 	}*=[vbI = E,arg0 = E,sinterrogative = I,arg3 = I,sinterrogativeL=L,arg3L=L]
% }

% -------------------------------------------------------
% Semantic schemas
% -------------------------------------------------------

%% Semantic classes
class eventSem
export E L0 Rel
declare ?Rel ?E ?L0 ?fTse ?fMode ?fSecant
      {
	<sem>{
		L0:event(E,fTse,fSecant,fMode)
	      }*=[label0 = L0,tense=fTse,mode=fMode,aspect=fSecant]
	  }

class state
export E L0 Rel
declare ?Rel ?E ?L0 ?fTse ?fMode ?fSecant
      {
	<sem>{
		L0:Rel(E); L0:event(E,fTse,fSecant,fMode)
	      }*=[label0 = L0, rel =Rel,arg0=E,vbI=E,vbL=L0,tense=fTse,mode=fMode,aspect=fSecant]
	  }

class basicProperty
export E L0 Rel
declare ?Rel ?E ?L0
      {
	<sem>{
		L0:Rel(E)
	      }*=[label0 = L0, rel =Rel,arg0=E,vbI=E,vbL=L0]
	  }

class modalRel
export E L0 Rel
declare ?Rel ?E ?L0 ?H ?LV
      {
	<sem>{
		L0:Rel(E,H); qeq(H,LV)
	      }*=[sobjectL=LV,label0 = L0, rel =Rel,arg0=E,vbI=E,vbL=L0]
	  }
class tensedModalRel
export E L0 Rel
declare ?Rel ?E ?L0 ?H ?LV  ?fTse ?fMode ?fSecant
      {
	<sem>{
		L0:Rel(E,H); qeq(H,LV); L0:event(E,fTse,fSecant,fMode)
	      }*=[sobjectL=LV,label0 = L0, rel =Rel,arg0=E,vbI=E,vbL=L0,tense=fTse,mode=fMode,aspect=fSecant]
	  }
class adjectiveProperty
export X L0 Rel
declare ?Rel ?X ?S ?L0
      {
	<sem>{
		L0:Rel(S,X)
	      }*=[label0 = L0, rel =Rel,arg0=X]
	  }
class nounProperty
export E L0 Rel
declare ?Rel ?E ?L0 ?N ?G
      {
	<sem>{
		L0:Rel(E); L0:indiv(E,G,N)
	      }*=[label0 = L0, rel =Rel,arg0=E,vbI=E,vbL=L0,num=N,gen=G]
	  }


class indivSem
export E L0
declare ?E ?L0 ?N ?G
      {
	<sem>{
		L0:indiv(E,G,N)
	      }
	      *=[rlabel=L0,arg0=E,num=N,gen=G]
	  }
% binary relation with state variable
class questionSem
declare ?E ?L
      {
	<sem>{
		L:question(E)
	      }
	      *=[label0=L,topL=L,arg0=E,vbI=E]
	  }
% binary relation with state variable
class unaryState
declare ?Rel ?S ?X ?L0
      {
	<sem>{
		L0:Rel(S,X)
	      }
	      *=[label0 = L0, rel =Rel,arg0=S,arg1=X]
	  }
class binaryState
export L0 Rel S X Y
declare ?Rel ?S ?X ?L0  ?Y 
      {
	<sem>{
		L0:Rel(S,X,Y)
	      }
	      *=[label0 = L0, rel =Rel,arg0=S,arg1=X,arg2=Y]
	  }
class ternaryState
export L0 Rel S X Y
declare ?Rel ?S ?X ?L0  ?Y ?Z 
      {
	<sem>{
		L0:Rel(S,X,Y,Z)
	      }
	      *=[label0 = L0, rel =Rel,arg0=S,arg1=X,arg2=Y,arg3=Z]
	  }
% unary relation with event variable
class unaryRel
declare ?L0 ?Rel ?E ?X  ?fTse ?fMode ?fSecant
      {
	<sem>{
		L0:Rel(E,X); L0:event(E,fTse,fSecant,fMode)
	      }
	      *=[label0 = L0, rel =Rel,arg0=E,arg1=X,vbI=E,vbL=L0,tense=fTse,mode=fMode,aspect=fSecant] 
	  }

% unary relation with event variable
class unaryRelBase
declare ?L0 ?Rel ?E ?X 
      {
	<sem>{
		L0:Rel(E,X)
	      }
	      *=[label0 = L0, rel =Rel,arg0=E,arg1=X] 
	  }

% binary relation with event variable
class copulaRel
declare  ?L0 ?E ?X ?Y ?fTse ?fMode ?fSecant
      {
	<sem>{
		 L0:be(E,X,Y); L0:event(E,fTse,fSecant,fMode)
	      }
	      *=[label0=L0,arg0=E,arg1=X,arg2=Y,vbI=E,vbL=L0,tense=fTse,mode=fMode,aspect=fSecant] 
	  }
% binary relation with scopal relation "Jean trouve Marie jolie/que Marie est jolie"b
class scopalBinaryRel
declare  ?L0 ?Rel ?E ?X ?Y ?fTse ?fMode ?fSecant ?AH
      {
	<sem>{
		 L0:Rel(E,X,Y); L0:event(E,fTse,fSecant,fMode); qeq(Y,AH)
	      }
	      *=[label0=L0, rel=Rel,arg0=E,arg1=X,arg2=AH,vbI=E,vbL=L0,tense=fTse,mode=fMode,aspect=fSecant] 
	  }
class scopalQuestionRel
declare  ?L0 ?Rel ?E ?X ?Y ?fTse ?fMode ?fSecant ?AH ?AI
      {
	<sem>{
		 L0:Rel(E,X,Y); L0:event(E,fTse,fSecant,fMode); qeq(Y,AH); AH:ques(AI)
	      }
	      *=[label0=L0, rel=Rel,arg0=E,arg1=X,arg2=AH,vbI=E,vbL=L0,tense=fTse,mode=fMode,aspect=fSecant,sinterrogativeI=AI] 
	  }
class binaryRel
declare  ?L0 ?Rel ?E ?X ?Y ?fTse ?fMode ?fSecant
      {
	<sem>{
		 L0:Rel(E,X,Y); L0:event(E,fTse,fSecant,fMode)
	      }
	      *=[label0=L0, rel=Rel,arg0=E,arg1=X,arg2=Y,vbI=E,vbL=L0,tense=fTse,mode=fMode,aspect=fSecant,reflI=X] 
	  }
class binaryRelBase
declare  ?L0 ?Rel ?E ?X ?Y
      {
	<sem>{
		 L0:Rel(E,X,Y)
	      }
	      *=[label0=L0, rel=Rel,arg0=E,arg1=X,arg2=Y,vbI=E,vbL=L0] 
	  }
% ternary relation with event variable
class ternaryRel[]
declare  ?L0 ?Rel ?E ?X ?Y ?Z  ?fTse ?fMode ?fSecant
      {
	<sem>{
		 L0:Rel(E,X,Y,Z); L0:event(E,fTse,fSecant,fMode)
	      }
	      *=[label0 = L0, rel =Rel,arg0=E,arg1=X,arg2=Y,arg3=Z,vbI=E,vbL=L0,tense=fTse,mode=fMode,aspect=fSecant]
}
% ternary relation for coordination
class coordSem[]
declare  ?L0 ?RH ?SH ?NH ?Rel ?X ?LX ?RX
      {
	<sem>{
		 L0:udef_q(X,RH,SH); qeq(RH,NH); NH:Rel(X,LX,RX)
	      }
	      *=[rel=Rel,arg0=X,arg1=LX,arg2=RX]
}
class prepSem[]
declare  ?L0 ?Rel ?X ?LX ?RX
      {
	<sem>{
		 L0:Rel(X,LX,RX)
	      }
	      *=[label=L0,rel=Rel,arg0=X,arg1=LX,arg2=RX]
}
% Semantics of raising verbs (Jean semble dormir}

class raisingSem
export E L0 Rel
declare ?Rel ?E ?L0 ?H ?VH ?fTse ?fMode ?fSecant
      {
	<sem>{
		L0:Rel(E,H);  qeq(H,VH); L0:event(E,fTse,fSecant,fMode)
	      }
	      *=[label0 = L0, rel =Rel,arg0=E,scopeLabel=VH,tense=fTse,mode=fMode,aspect=fSecant]
	  }

%  quantifiers (every, a, some, etc.)
class quantifierDetSem
      export xNounSem
      declare ?xNounSem ?I ?NH ?L0 ?RH ?SH ?NH ?Quant
      { %<syn>{ node xNounSem[bot=[idx = I,label = NH]]};
      	<sem>{L0:Quant(I,RH,SH); qeq(RH,NH)}*=[arg0=I,argL=NH,quant=Quant]}

%  interrogative quantifiers (quel, quelle)
class quantifierWhDetSem
      export xNounSem
      declare ?xNounSem ?I ?NH ?L0 ?RH ?SH ?NH ?Quant ?VI ?VL
      { %<syn>{ node xNounSem[top=[vbI=VI,vbL=VL],bot=[idx = I,label = NH]]};
      	<sem>{L0:Quant(I,RH,SH); qeq(RH,NH);VL:ques(VI)}*=[arg0=I,argL=NH,quant=Quant]}

%  possessive (my, his, etc. "the N of me/him")
class possessiveDetSem
      export xNounSem
      declare ?xNounSem ?I ?NH ?L0 ?RH ?SH ?NH ?E ?X ?RHX ?SHX ?L2
      { %<syn>{ node xNounSem[top=[idx = I,label = NH]]};
      	<sem>{L0:def_explicit_q(I,RH,SH); NH:poss(E,I,X); qeq(RH,NH); pronoun_q(X,RHX,SHX); L2:pron(X); qeq(RHX,L2)}}

% lexical NP quantifiers (aucun, etc.)

class quantifierSem
      export xNounSem
      declare ?x ?I ?RH ?SH ?NL ?xNounSem ?Noun ?L ?Quant ?N ?G 
      { %<syn>{ node xNounSem[top=[idx = I,label = L]]};
      	<sem>{L:Quant(I,RH,SH); NL:Noun(I); qeq(RH,NL); NL:indiv(I,G,N)}*=[arg0=I,label=L,quant=Quant,noun=Noun,rlabel=NL,num=N,gen=G]}

class whSubjectPronounQuantifierSem
      declare ?x ?I ?RH ?SH ?NL ?xN ?Noun ?QL ?Quant ?N ?G
      { <syn>{ node xN(color=white)[cat =n,top=[idx = I,label=QL]]};
      	<sem>{QL:Quant(I,RH,SH); NL:Noun(I); qeq(RH,NL)}*=[quant=Quant,noun=Noun,idx=I,label=QL]}

class whNonSubjectPronounQuantifierSem
      declare ?x ?I ?RH ?SH ?NL ?xN ?Noun ?QL ?Quant ?N ?G
      { <syn>{ node xN(color=white)[cat =@{n,cl}, top=[idx = I,label=QL]]};
      	<sem>{QL:Quant(I,RH,SH); NL:Noun(I); qeq(RH,NL)}*=[quant=Quant,noun=Noun]}

class properNounQuantifierSem
      declare ?xN ?I ?L ?xNounSem ?L0 ?I ?HR ?HS ?L1 ?Noun ?G ?N
      { <syn>{  node xN(color=white)[cat=n,bot=[idx=I]]};
      	<sem>{L0:proper_q(I,HR,HS); qeq(HR,L1); L1:named(I,Noun); L1:indiv(I,G,N)}*=[arg0=I,label0=L0,label1=L1,noun=Noun,num=N,gen=G]}

class possessiveQuantifierSem
      declare ?xN ?I ?L ?xNounSem ?L0 ?I ?HR ?HS ?L1 ?Noun ?G ?N ?J ?P ?PR ?PS ?L2 ?PP 
      { <syn>{  node xN(color=white)[cat=n,bot=[index=I,label=L]]};
      	<sem>{L:generic_entity(I); L:indiv(I,G,N); L:poss(J,I,P); L1:pronoun_q(P,PR,PS); qeq(PR,L2); L2:pron(P,PP)}*=[num=N,gen=G,person=PP,idx=I,label=L]}

%% Noun, Propernoun and pronoun semantics

class nounSem
declare
        ?xN ?I ?L
{
	<syn>{
                node xN(color=white)[cat=@{cl,n},bot=[idx=I,label = L]]
	};
	nounProperty[]*=[arg0=I,label0 = L]
}

class propernounSem
declare
        ?xN ?I
{
	<syn>{
                node xN(color=white)[cat=@{cl,n},bot=[idx=I]]
	};
	properNounQuantifierSem[]*=[arg0=I]
}

class pronounQuantifierSem
      declare ?xN ?I ?L0 ?I ?HR ?HS ?L1 ?N ?P ?G
      { <syn>{  node xN(color=white)[cat=@{n,cl},bot=[idx=I,num=N,pers=P,gen=G]]};
      	<sem>{L0:pronoun_q(I,HR,HS); L1:pron(I); L1:indiv(I,G,N,P);qeq(HR,L1)}*=[arg0=I,num=N,pers=P,gen=G]}

% chante-t'il?
class questionCliticSem
declare ?E ?L ?xN ?I ?L0 ?I ?HR ?HS ?L1 ?N ?P ?G
      { 
        <sem>{L:ques(E); L0:pronoun_q(I,HR,HS); L1:pron(I); L1:indiv(I,G,N);qeq(HR,L1)}*=[arg0=I,num=N,pers=P,gen=G,vbI=E,vbL=L]
	  }
% chante-t'il?
class qtilSem
declare ?E ?L 
      { 
        <sem>{L:ques(E)}*=[vbI=E,vbL=L]
	  }
% question mark semantics
class questionmarkSem[L,R]
declare ?E %?L
      { 
        <sem>{L:ques(E)}}
