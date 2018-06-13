%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              XMG-based XTAG

%   Core Tree-Adjoining MetaGrammar for English 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% author = Katya Saint-Amand
% date = 2008
%
% last edition = Simon Petitjean
% date = May 2018
% comments = making the metagrammar fully
%            compatible with XMG-2 (types mostly)

use unicity with (gf = subj) dims(syn)
use unicity with (gf = obj) dims(syn)
use color with () dims(syn)
use rank with () dims (syn)
use unicity with (rank=1) dims (syn)
use unicity with (rank=2) dims (syn)
use unicity with (rank=3) dims (syn)
use unicity with (rank=4) dims (syn)
use unicity with (rank=5) dims (syn)
use unicity with (rank=6) dims (syn)
use unicity with (rank=7) dims (syn)
use unicity with (rank=8) dims (syn)

%% Added because not assumed by XMG-2 (L-TAG specific)
use unicity with (mark=anchor) dims (syn)

type MARK = {subst,anchor,coanchor,nadj,foot,lex,flex}
type NAME = {SubjNode,IObjNode,Anchor,SentCompl,ComplNode,Prep,Particle,Noun,CleftIt,Conjunction,Anchor,
     	    Anchor2,NCoanchor,Adjective,Determiner}
type CAT = {s,np,vp,v,n,prep,pp,pl,ap,a,adv,advp,by,c,det,of,Pro,poss,cat_to,cat_for,comp,conj}
%% values of GF moved to FUNC
%%type GF = {subj,obj,compl,iobj,ppiobj}
type PERSON = [1..3]
type NUMBER = {sing,plur}
type MODE={ind,inf,sbjnct,ger,base,ppart,m_nom,m_prep,imp}
%%type RMODE={ind,inf,sbjnct,ger,base,ppart,nom,rm_prep,imp}
type TRACE!
type CONTROL!
type PHON = {e}
type CASE = {nom,acc,gen,none}
type COLOR = {red,white,black}
type RANK  = [1..8]
type FUNC={subj,obj,iobj,loc,obl,byagent,compl,ppiobj}
type TRUTH = {yes,no}
type TENSE = {pres,past}
type AUX = {do,have}
type PUNCT-STRUCT = {comma,dash,colon,scolon,nil}
%%type ASSIGN-CASE = {nom,acc,none}
type COMP = {that,whether,if,for,ecm,inf_nil,ind_nil,ppart_nil,no_comp}
type AGR = {agr-3rdsing,agr-pers,agr-num,agr-gen}	
type GENDER = {masc,fem,neut}
%%type NOCOMP-MODE = {inf,ger, ppart}
%%type COMP = {that,if,whether,for,inf_nil,ind_nil,nil}
%%type MAINV = {base,ger,ind,inf,imp,nom,ppart,mv_prep,sbjunt}
type CONJ = {and,or,but,conj_comma,conj_scolon,to,disc,no_conj}
type PASS !
type COMPAR !
type INVLINK !
type PROGRESS !
type PERF !
type GERUND !
type DEFINITE !
type EQUIV !
type REL-CLAUSE !
type REFL !
type CONST !
type QUAN !
type CARD !
type DECREASE !
type COND !
type PASSIVE !
type VMODE !

type ATOMIC=[
	num : NUMBER,
 	pers : PERSON,
 	refl : bool,      
 	loc : bool,
 	control-num : NUMBER,
	control-pers : PERSON,
	compar : bool,
	equiv : bool,
	pass : bool,
	progress : bool,
	perf : bool,
	tense: TENSE,
	aux: AUX,
	det : bool,
	gerund : bool,
	loc : bool,
	inv : bool,
	extracted : bool,
	agr-3rdsing : bool,
	rel-clause : bool,
	agr-num : NUMBER,
	agr-pers : PERSON,
	agr-gen : GENDER,
	const : bool,
	quan : bool,
	card : bool,
	decrease : bool,
	pron : bool,
	refl : bool,
	definite : bool

]


property rank : RANK
property name : NAME
property mark : MARK
property gf : FUNC
property color : COLOR

feature phon : PHON
feature cat : CAT
feature trace : TRACE
feature case : CASE
feature wh : bool
feature mode : MODE
feature rmode : MODE
feature punct-struct : PUNCT-STRUCT
feature asign-case : CASE
feature assign-comp : COMP
feature agr : AGR
feature nocomp-mode : MODE
feature comp : COMP
feature conj : CONJ
feature mainv : bool
feature top : ATOMIC
feature bot : ATOMIC
feature control : CONTROL
feature punct-struct : PUNCT-STRUCT

feature inv : bool
feature extracted : bool
feature pass : PASS
feature pers : PERSON
feature num : NUMBER
feature tense : TENSE
feature assign-case : CASE
feature compar : COMPAR
feature invlink : INVLINK
feature progress : PROGRESS
feature perf : PERF
feature gerund : GERUND
feature definite : DEFINITE
feature pron : bool
feature equiv : EQUIV
feature rel-clause : REL-CLAUSE
feature refl : REFL
feature const : CONST
feature quan : QUAN
feature card : CARD
feature decrease : DECREASE
feature cond : COND
feature passive : PASSIVE
feature vmode : VMODE

%-------------------
% MUTUAL EXCLUSIONS 
%-------------------

mutex EXTR-IMPERATIVE1
mutex EXTR-IMPERATIVE1 += WhExtraction
mutex EXTR-IMPERATIVE1 += ImperativeSubject
mutex EXTR-IMPERATIVE1 += ProSubject


mutex PASS-IMPERATIVE
mutex PASS-IMPERATIVE += passive
mutex PASS-IMPERATIVE += ImperativeSubject

mutex EXTR-IMPERATIVE2
mutex EXTR-IMPERATIVE2 += RelativeClause  
mutex EXTR-IMPERATIVE2 += ImperativeSubject
mutex EXTR-IMPERATIVE2 += ProSubject

mutex EXTR-SENTCOMPL
mutex EXTR-SENTCOMPL += RelativeByAgent
mutex EXTR-SENTCOMPL += dian0Vn1s2passive
mutex EXTR-SENTCOMPL += n0Vpln1
mutex EXTR-SENTCOMPL += n0VN1
mutex EXTR-SENTCOMPL += n0VAN1
mutex EXTR-SENTCOMPL += n0VDAN1
mutex EXTR-SENTCOMPL += n0VDN1

mutex DETERMINERGERUND-PASSIVE
mutex DETERMINERGERUND-PASSIVE += DeterminerGerund
mutex DETERMINERGERUND-PASSIVE += passive

mutex SENTCOMPFOOT-EXTR
mutex SENTCOMPFOOT-EXTR += CanSentComplementFoot 
mutex SENTCOMPFOOT-EXTR += WhSubject
mutex SENTCOMPFOOT-EXTR += WhObject
mutex SENTCOMPFOOT-EXTR += WhByAgent
mutex SENTCOMPFOOT-EXTR += WhAgentBy
mutex SENTCOMPFOOT-EXTR += RelativeClause

mutex SENTCOMPFOOT-GERUND
mutex SENTCOMPFOOT-GERUND += CanSentComplementFoot
mutex SENTCOMPFOOT-GERUND += GerundArgument

mutex SENTCOMPSUBST-SUBJ
mutex SENTCOMPSUBST-SUBJ += CanSentComplementSubst
mutex SENTCOMPSUBST-SUBJ += SubjectArgument 

mutex ECM-NPGERUND
mutex ECM-NPGERUND += Xn0Vs1
mutex ECM-NPGERUND += NPGerundSubjectPro

mutex SMALLCLAUSE-WHPP
mutex SMALLCLAUSE-WHPP += s0Pn1
mutex SMALLCLAUSE-WHPP += WhPPAnchor
mutex SMALLCLAUSE-WHPP += WhPObjectAnchor

mutex SMALLCLAUSE-ADJ-GERUND
mutex SMALLCLAUSE-ADJ-GERUND += GerundArgument
mutex SMALLCLAUSE-ADJ-GERUND += ImperativeSubject  
mutex SMALLCLAUSE-ADJ-GERUND += PPAnchorArgumentAdj

mutex SMALLCLAUSE-N-GERUND
mutex SMALLCLAUSE-N-GERUND += GerundArgument
mutex SMALLCLAUSE-N-GERUND += ImperativeSubject  
mutex SMALLCLAUSE-N-GERUND += PPAnchorArgumentN


mutex SENTSUBJ-PIEDPIPING
mutex SENTSUBJ-PIEDPIPING += WhAnchorPPArgument
mutex SENTSUBJ-PIEDPIPING += WhAnchorPArgument
mutex SENTSUBJ-PIEDPIPING += RelativeOvertPPAnchorPied-Piping-N
mutex SENTSUBJ-PIEDPIPING += SententialSubject

mutex PRO-WHBYAGENT
mutex PRO-WHBYAGENT += SubjectOuterPro
mutex PRO-WHBYAGENT += WhByAgent
mutex PRO-WHBYAGENT += WhAgentBy

mutex SUBJECTCAN-WHAGENT
mutex SUBJECTCAN-WHAGENT += SubjectOuterCan
mutex SUBJECTCAN-WHAGENT += WhAgentBy

mutex RELAGENT-IDIOM
mutex RELAGENT-IDIOM += RelativeOvertByAgent
mutex RELAGENT-IDIOM += RelativeCovertByAgent
mutex RELAGENT-IDIOM += RelativeByAgent
mutex RELAGENT-IDIOM += n0VDAN1Pn2
mutex RELAGENT-IDIOM += n0VAN1Pn2
mutex RELAGENT-IDIOM += n0VN1Pn2
mutex RELAGENT-IDIOM += n0VDN1Pn2

mutex PROSUBJ-RESULT
mutex PROSUBJ-RESULT += ProSubject
mutex PROSUBJ-RESULT += NPGerundSubjectPro
mutex PROSUBJ-RESULT += Rn0Vn1A2
mutex PROSUBJ-RESULT += Rn0Vn1Pn2
mutex PROSUBJ-RESULT += REn1VA2
mutex PROSUBJ-RESULT += REn1VPn2

mutex WHSENTCOMP-PASSIVE
mutex WHSENTCOMP-PASSIVE += passive
mutex WHSENTCOMP-PASSIVE += WhSentComplement

mutex AnchorPP-SMALLCLAUSE
mutex AnchorPP-SMALLCLAUSE += s0Pn1
mutex AnchorPP-SMALLCLAUSE += WhAnchorPP
mutex AnchorPP-SMALLCLAUSE += WhAnchorP

mutex ExtractedAnchorPP-SMALLCLAUSE
mutex ExtractedAnchorPP-SMALLCLAUSE += SententialSubject
mutex ExtractedAnchorPP-SMALLCLAUSE += WhAnchorPPArgumentXP
mutex ExtractedAnchorPP-SMALLCLAUSE += RelativeOvertPPAnchorPied-PipingTop 

