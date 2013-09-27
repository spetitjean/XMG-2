% -------------------------------------------------------
% header.mg
% -------------------------------------------------------

%% Principes

use color with () dims (syn)
use rank with () dims (syn)
use unicity with (extracted) dims (syn)
use unicity with (rank=1) dims (syn)
use unicity with (rank=2) dims (syn)
use unicity with (rank=3) dims (syn)
use unicity with (rank=4) dims (syn)
use unicity with (rank=5) dims (syn)
use unicity with (rank=6) dims (syn)
use unicity with (rank=7) dims (syn)

%% Definitions

extern rel theta1 theta2 theta3 quantifierRel restrictionRel noun quant

%type declarations

type SEM={be,qeq,num,tu,and,exists,someone,predI,predL,def,dem,poss,question,noone,nil,vide,event,proper_q,named,def_explicit_q,implicit_conjunction,udef_q,poss,pronoun_q,pron,indiv,generic_entity,semtype,cleftindex,ques}
type LEMANCHOR={ce,�tre,que,qui,avoir,il,se,o�}
type CAT={n,np,v,vp,s,pp,c,p,cl,adj,adv,coord,d,�,a,de,par,que,qui,dont,si,il,est,se,des,avec,en,entre,sans,dans,gp,punct,ne,ce,pas}
type PERSON=[1..3]
type GENDER={m,f}
type NUMBER={sg,pl,mass}
type DEF={+,-}
type MODE={ind,inf,imp,subj,cdtional,gerund,ppart,ppst}
type ASPECT={indet,+,-}
type COLOR ={red,black,white}
type WH={rel,+,-}
type LABEL !
type FUNC={suj,obj,iobj,gen,loc,obl,cagent}
type CASE={nom,acc,acc3rd,dat3rd,dat,gen,locative,ce}
type NAME  = {subject,object,iobject,genitiveN,obliqueN,vsup,vppPrep,vppDet,obliquePrep,locativePrep,predPrep,det,prep,vNdet,sarg,modee,adverbFoot}
type SUBJECTTYPE = {active,passive,moyen}

type MARK  = {subst,anchor,coanchor,nadj,foot,lex,flex,none}
type RANK  = [1..7]
type AUX = {etre,avoir,-}
type TENSE = {pres,past,future}
type INVERSION = {+, n, -}
type BARV = [0..3]

type ATOMIC=[
        cleftmod : bool,
	passivable : bool,
	cleft : bool,
	cest : bool,
	case : CASE,
	nomPropre : bool,
	vsup : bool,
	mode : MODE,
	aspect : ASPECT,
 	num : NUMBER,
 	gen : GENDER,
 	pers : PERSON,
 	refl : bool,      
 	loc : bool,
 	wh : WH,
 	func : FUNC,	
	pp-num: NUMBER,
	pp-gen: GENDER,
	control-num : NUMBER,
	control-pers : PERSON,
	control-gen : GENDER,
	aux-pass : bool,
	tense: TENSE,
	argtense: TENSE,
	aux: AUX,
	det : bool,
	inv : INVERSION,
	cop : bool,
	loc : bool,
	bar : BARV,
	neg-adv: bool,
	neg-nom:bool
]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% IMPLICITS HFPs 
% NP : det,def,num,gen,pers,wh
      % Classes concern�es : EpithAnte,

% V : mode,num,gen,pers,pp-num,pp-gen,inv,aux,aux-pass
% VN : mode,num,gen,pers,inv
% Adj : num,gen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%property declarations
property name       : NAME
property color : COLOR
property mark       : MARK
property extracted  : bool { extraction = + }
property xcomp : bool 
property rank : RANK{
        i_   = 1 ,
        ii_  = 2 ,
        iii_ = 3 ,
        iv_  = 4 ,
        v_  = 5 ,
	vi_ = 6
}

%feature declarations
feature lemanchor : LEMANCHOR
feature focus : LABEL
feature idx : LABEL
feature pro-idx : LABEL
feature controllee-idx : LABEL
feature label : LABEL
feature control-idx : LABEL
feature top : ATOMIC
feature bot : ATOMIC
feature prepL : LABEL
feature prepRel : LABEL
feature modifiedV : LABEL
feature complementV : LABEL
feature quantifierRel : LABEL
feature quantificationV : LABEL
feature restrictionL : LABEL
feature scopeL : LABEL
feature determinerI : LABEL
feature nounI : LABEL
feature verbL : LABEL
feature topL : LABEL
feature verbI : LABEL
feature nounL : LABEL
%feature scopeL : LABEL
feature subjectI : LABEL
feature modifieeI : LABEL
feature dummyI : LABEL
feature invertedCliticIdx : LABEL
feature predicateI : LABEL
feature zeroObjectIdx : LABEL
feature whIdx : LABEL
feature zeroObjectI : LABEL
feature objectI : LABEL
feature iobjectI : LABEL
feature cagentI : LABEL
feature genitiveI : LABEL
feature genitiveL : LABEL
feature obliqueI : LABEL
feature locativeI : LABEL
feature reflexiveI : LABEL
feature controlleeI : LABEL
feature ssubjectI : LABEL
feature sobjectI : LABEL
feature sdeobjectI : LABEL
feature saobjectI : LABEL
feature sinterrogativeI : LABEL
feature sobjectL : LABEL
feature ssubjectL : LABEL
%feature sobjectL : LABEL
feature sdeobjectL : LABEL
feature saobjectL : LABEL
feature sinterrogativeL : LABEL
feature phon : LABEL
feature copulaI : LABEL
feature vbI : LABEL
feature adjI : LABEL
feature evt : LABEL
feature label0 : LABEL
feature label1 : LABEL
feature label2 : LABEL
feature vbL : LABEL
feature adjL : LABEL
feature subjectL : LABEL
feature objectL : LABEL
feature iobjectL : LABEL
feature cagentL : LABEL
%feature genitiveL : LABEL
feature obliqueL : LABEL
feature locativeL : LABEL
feature reflexiveL : LABEL
feature arg1 : LABEL
feature arg2 : LABEL
feature arg3 : LABEL
feature rel3 : LABEL
feature rel2 : LABEL
feature rel1 : LABEL
feature theta1 : LABEL
feature theta2 : LABEL
feature theta3 : LABEL
feature exp : LABEL
feature cause : LABEL
feature agent : LABEL
feature theme : LABEL
feature beneficiary : LABEL
feature passiveImpersonal : LABEL
feature passiveShort : LABEL
feature passiveDe : LABEL
feature middle : LABEL
feature passivePar : LABEL
feature subjectType : SUBJECTTYPE

%%%%%%%%%%%%%%%%%%%%
% MUTUAL EXCLUSION %
%%%%%%%%%%%%%%%%%%%%

mutex EXTR-IMPERATIVE1
mutex EXTR-IMPERATIVE1 += UnboundedExtraction
mutex EXTR-IMPERATIVE1 += ImperativeSubject

mutex EXTR-IMPERATIVE2
mutex EXTR-IMPERATIVE2 += BoundedExtraction
mutex EXTR-IMPERATIVE2 += ImperativeSubject

mutex SUBJ-INV
mutex SUBJ-INV += CanonicalObject
mutex SUBJ-INV += InvertedNominalSubject

mutex SEN-SUBJ
mutex SEN-SUBJ += SententialSubject
mutex SEN-SUBJ += UnboundedExtraction

mutex COPULA-RELATIVE
mutex COPULA-RELATIVE += RelativeSubject
mutex COPULA-RELATIVE += copulaBe

mutex COPULA-RELATIVE2
mutex COPULA-RELATIVE2 += UnboundedRelative
mutex COPULA-RELATIVE2 += copulaBe

mutex RELATIVE-EMPTYSUBJECT
mutex RELATIVE-EMPTYSUBJECT += UnboundedRelative
mutex RELATIVE-EMPTYSUBJECT += EmptySubject

mutex INFINITIVE-SUBJECT1
mutex INFINITIVE-SUBJECT1 += RelativeObject
mutex INFINITIVE-SUBJECT1 += InfinitiveSubject

mutex INFINITIVE-WHOBJECT
mutex INFINITIVE-WHOBJECT += whObject
mutex INFINITIVE-WHOBJECT += InfinitiveSubject

mutex INFINITIVE-SUBJECT2
mutex INFINITIVE-SUBJECT2 +=  CleftObject
mutex INFINITIVE-SUBJECT2 += InfinitiveSubject

class imperativeSubjectMutex { whObject[] | RelativeObject[] |
      CleftObject[] | whCAgent[] | RelativeCAgent[] | CleftCAgentOne[]
      | CleftCAgentTwo[] | whGenitive[] | RelativeGenitive[] }
      

mutex IMPERATIVE-SUBJECT1
mutex IMPERATIVE-SUBJECT1 += whObject
mutex IMPERATIVE-SUBJECT1 += ImperativeSubject

mutex IMPERATIVE-SUBJECT2
mutex IMPERATIVE-SUBJECT2 += RelativeObject
mutex IMPERATIVE-SUBJECT2 += ImperativeSubject

mutex IMPERATIVE-SUBJECT3
mutex IMPERATIVE-SUBJECT3 += CleftObject
mutex IMPERATIVE-SUBJECT3 += ImperativeSubject

mutex IMPERATIVE-SUBJECT4
mutex IMPERATIVE-SUBJECT4 += whCAgent
mutex IMPERATIVE-SUBJECT4 += ImperativeSubject

mutex IMPERATIVE-SUBJECT5
mutex IMPERATIVE-SUBJECT5 += RelativeCAgent
mutex IMPERATIVE-SUBJECT5 += ImperativeSubject

mutex IMPERATIVE-SUBJECT6
mutex IMPERATIVE-SUBJECT6 += CleftCAgentOne
mutex IMPERATIVE-SUBJECT6 += ImperativeSubject

mutex IMPERATIVE-SUBJECT7
mutex IMPERATIVE-SUBJECT7 += CleftCAgentTwo
mutex IMPERATIVE-SUBJECT7 += ImperativeSubject

mutex IMPERATIVE-SUBJECT8
mutex IMPERATIVE-SUBJECT8 += whGenitive
mutex IMPERATIVE-SUBJECT8 += ImperativeSubject

mutex IMPERATIVE-SUBJECT9
mutex IMPERATIVE-SUBJECT9 += RelativeGenitive
mutex IMPERATIVE-SUBJECT9 += ImperativeSubject

mutex IMPERATIVE-SUBJECT10
mutex IMPERATIVE-SUBJECT10 += CleftGenitiveOne
mutex IMPERATIVE-SUBJECT10 += ImperativeSubject

mutex IMPERATIVE-SUBJECT11
mutex IMPERATIVE-SUBJECT11 += CleftDont
mutex IMPERATIVE-SUBJECT11 += ImperativeSubject

mutex IMPERATIVE-SUBJECT12
mutex IMPERATIVE-SUBJECT12 += CleftGenitiveTwo
mutex IMPERATIVE-SUBJECT12 += ImperativeSubject

% class invertedNominalSubjectMutex { CanonicalObject[] |
%       CliticObjectII[] | CliticObject3[] |  reflexiveAccusative[] |
%       CanonicalCAgent[] | CanonicalGenitive[] | CliticGenitive[] }

mutex INVERTEDNOMINAL-SUBJECT1
mutex INVERTEDNOMINAL-SUBJECT1 += CanonicalObject
mutex INVERTEDNOMINAL-SUBJECT1 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT2
mutex INVERTEDNOMINAL-SUBJECT2 += CliticObjectII
mutex INVERTEDNOMINAL-SUBJECT2 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT3
mutex INVERTEDNOMINAL-SUBJECT3 += CliticObject3
mutex INVERTEDNOMINAL-SUBJECT3 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT4
mutex INVERTEDNOMINAL-SUBJECT4 += reflexiveAccusative
mutex INVERTEDNOMINAL-SUBJECT4 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT5
mutex INVERTEDNOMINAL-SUBJECT5 += CanonicalCAgent
mutex INVERTEDNOMINAL-SUBJECT5 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT6
mutex INVERTEDNOMINAL-SUBJECT6 += CanonicalGenitive
mutex INVERTEDNOMINAL-SUBJECT6 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT7
mutex INVERTEDNOMINAL-SUBJECT7 += CliticGenitive
mutex INVERTEDNOMINAL-SUBJECT7 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT8
mutex INVERTEDNOMINAL-SUBJECT8 += n0vA
mutex INVERTEDNOMINAL-SUBJECT8 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT9
mutex INVERTEDNOMINAL-SUBJECT9 += NominalCleft
mutex INVERTEDNOMINAL-SUBJECT9 += InvertedNominalSubject

mutex INVERTEDNOMINAL-SUBJECT10
mutex INVERTEDNOMINAL-SUBJECT10 += SententialCObject
mutex INVERTEDNOMINAL-SUBJECT10 += InvertedSubject

mutex NOVN1-GENITIVEOBJECT
mutex NOVN1-GENITIVEOBJECT += CliticGenitive
mutex NOVN1-GENITIVEOBJECT += n0Vn1

mutex NOVN1AN2-CLITICLOCATIVE
mutex NOVN1AN2-CLITICLOCATIVE += CliticLocative
mutex NOVN1AN2-CLITICLOCATIVE += n0Vn1an2

mutex NOVAN2-CLITICLOCATIVE
mutex NOVAN2-CLITICLOCATIVE += CliticLocative
mutex NOVAN2-CLITICLOCATIVE += Iobject


% class impersonalSubjectMutex 
% declare ?L ?E ?X ?Y ?C ?I
% { CliticObjectII[] |CliticObject3[] |
% reflexiveAccusative[] | whObject[] | RelativeObject[] | CleftObject[] | SententialCObject[C,I] | n0Vn1[L,E,X,Y]
% }

% %F8-12-03-07: blocks transitive+impersonal subject
% class impersonalSubjMutex
% import impersonalSubjectMutex[]

mutex IMPERSONAL-SUBJECT
mutex IMPERSONAL-SUBJECT += ImpersonalSubject
mutex IMPERSONAL-SUBJECT += UnboundedCleft

% mutex IMPERSONAL-SUBJECT1
% mutex IMPERSONAL-SUBJECT1 += n0Vn1
% mutex IMPERSONAL-SUBJECT1 += ImpersonalSubject

mutex PASSIVE-INVERTEDNOMINALSUBJECT
mutex PASSIVE-INVERTEDNOMINALSUBJECT += InvertedNominalSubject
mutex PASSIVE-INVERTEDNOMINALSUBJECT += passiveVerbMorphology

mutex PASSIVE-ADJECTIVALPREDICATIVEFORM
mutex PASSIVE-ADJECTIVALPREDICATIVEFORM += InvertedNominalSubject
mutex PASSIVE-ADJECTIVALPREDICATIVEFORM += AdjectivalPredicativeform



% %% Classes

% %%%%%%%%%%%%%%%%%%%%%
% %% declaration des classes apparaissant dans la trace simplifi�e
% %%%%%%%%%%%%%

% % highlight CanonicalSubject CanonicalObject

% %%%%%%%%%%%%%%%%%
% % declaration des classes semantiques utilisees par le macro maker
% %%

semantics unaryRel binaryRel unaryRelBase binaryRelBase nounSem  basicProperty unaryState binaryState ternaryState unaryRel binaryRel ternaryRel raisingSem coordSem quantifierSem state properNounQuantifierSem quantifierDetSem indivSem possessiveDetSem pronounQuantifierSem prepSem possessiveQuantifierSem nounProperty adjectiveProperty copulaRel modalRel tensedModalRel scopalBinaryRel whSubjectPronounQuantifierSem whNonSubjectPronounQuantifierSem questionSem questionCliticSem dummyBe eventSem quantifierWhDetSem questionmarkSem qtilSem scopalQuestionRel properNounQuantifierSem

% %%%%%%%%%%%%%%%% 
% % declaration des parametres externes utilisee pour
% % specifier lexicalement la valeur de certains traits semantiques

