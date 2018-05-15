% -------------------------------------------------------
% A FRENCH METAGRAMMAR
% -------------------------------------------------------
% author = Benoit Crabbe
% date = May - December 2004
% comments = mostly follows (Abeillé02)
%
% last edition = Simon Petitjean
% date = May 2018
% comments = making the metagrammar fully
%            compatible with XMG-2 (types mostly)
%
% ASSOCIATED FILES (azim's parser): 
% 	Benoit4.lex : syntactic database
%	Benoit4.mph : morphological database
%			
% Semantics is not specified yet !
%
% Summary of the things covered so far :
%     Constructions :
%        * Nominal args : cleft, clitic, canonical, whquestions, relatives
% 	 * Sentential args : canonical, infinitives, completives
%        		     indirect questions	 
%     Diathesis :
%	 * Active, passive, middle, reflexive
%     Functions :
%        * Subject, Object, Iobject, Genitive, Locative, Obliques
%     Complementation :
%	 * Families of (Abeille 02)
%     Agreement :		
%        * Subject-Verb
%	 * Subject-Past Participle (avoir -- être), check w/ middle and reflexives
%     Tense auxiliaries
%	 * avoir -- être 
%     Raising vs Equi-Deletion
% 	 *Subject Control 
%	 *Subject Raising
%     Subject ellipsis (imperative,infinitives,etc.)
%     Subject inversion (nominal, clitic, complex)
%		Long inversion in ExtrContext is badly handled (TAG failure): Jean demande à qui veut parler Paul	
%     Predicative adjectives (nominal dependants)
%	complementation
%     Tough adjectives (a simple example that should be extended)
%
%   STUFF IMPLEMENTED TO MAKE THE GRAMMAR WORK
%   (what follows should be seriously revised)
%     Basic NP syntax (determiners etc.)
%     Negation (badly handled, overgenerates, etc. should be completely revised)
%     Coordination (constituent only)
%	n n
%	adj adj
%	adv adv
%	s s
%     Adverbs
%        s-adverbs and v-adverbs
%     PP-Modifiers
%	 s-modifiers v-modifiers
%     CP-Modifiers (parce_que, etc...)
%     Noun noun modifiers (Monsieur Leber)	
%
% TODO
% Semantics
% Cleft locative
% Causative (beuark...)
% Sentential Subject : check for passive
% 
% * functional unicity
% * Subject inversion : le sujet nominal ne peut etre inversé si l'objet nominal est en position canonique.


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


%type declarations

type CAT={n,np,v,vn,s,pp,c,p,cl,adj,adv,coord,d,à,de,par,que,qui,dont,si,il,se,des,avec,en,entre,sans,dans}
type PERSON=[1..3]
type GENDER={m,f}
type NUMBER={sg,pl}
type MODE={ind,inf,subj,imp,ppart}
type COLOR ={red,black,white}
%% type WH={rel,+,-}
type WH={rel,wh_yes,wh_no}
type LABEL !
type FUNC={suj,obj,iobj,gen,loc,obl,cagent}

type MARK  = {subst,nadj,foot,anchor,flex,none}
type RANK  = [1..7]
%% type AUX = {etre,avoir,-}
type AUX = {etre,avoir,aux_no}
type TENSE = {present,past}
%% type INVERSION = {+, n, -}
type INVERSION = {inv_yes, inv_n, inv_no}
type BARV = [0..3]

type PP-GEN !
type PP-NUM !
type CONTROL-NUM !
type CONTROL-GEN !
type GEN !
type DET !
type PRINC !
type NAME !
type PREP !
type LOC !
type REFL !
type DEF !
type CASE !

type ATOMIC=[
	mode : MODE,
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
      % Classes concernées : EpithAnte,

% V : mode,num,gen,pers,pp-num,pp-gen,inv,aux,aux-pass
% VN : mode,num,gen,pers,inv
% Adj : num,gen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%property declarations

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
feature idx : LABEL
feature top : ATOMIC
feature bot : ATOMIC

feature cat : CAT
feature pp-gen : PP-GEN
feature pp-num : PP-NUM
feature control-num : NUMBER
feature control-gen : GENDER
feature control-pers : PERSON
feature num : NUMBER
feature gen : GEN
feature pers : PERSON
feature inv : INVERSION
feature mode : MODE
feature wh : WH
feature det : DET
feature neg-nom : bool
feature neg-adv : bool
feature func : FUNC
feature princ : INVERSION
feature name : NAME
feature prep : PREP
feature prep1 : PREP
feature prep2 : PREP
feature loc : LOC
feature refl : REFL
feature def : DEF
feature bar : BARV
feature case : CASE
feature aux-pass : bool
feature aux-refl : bool
feature aux : AUX
feature cop : bool
feature tense : TENSE
feature ctrl-gen : GEN
feature ctrl-num : NUMBER
feature ctrl-pers : PERSON

%feature mode : LABEL
%feature num : NUMBER
%feature pers : PERSON
%feature wh : WH
%feature loc : bool
%feature refl : bool
%feature case : CASE

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