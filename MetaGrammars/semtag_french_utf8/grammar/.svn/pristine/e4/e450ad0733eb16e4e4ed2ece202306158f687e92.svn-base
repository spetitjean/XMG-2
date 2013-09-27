basicProperty
	L0:Rel(E) 
	[label0 = L0, rel =Rel,arg0=E]
ternaryState
	L0:Rel(X,Y,Z)
	[label0 = L0, rel =Rel,arg0=X,arg1=Y,arg2=Z]
unaryRel
	L0:Rel(E) L0:Theta1(E,X)
	[label0 = L0, rel =Rel,arg0=E,theta1 =Theta1,arg1=X] 



[subjectI = I,arg1 = I]	

%impersonal

class ilV
declare
	?L  ?E
{
	basicProperty[]*=[arg0=E];
	{ImpersonalSubject[] | InvertedIlSubject[]};
	activeVerbMorphology[]*=[vbI=E]
}
[vbI = I,arg0 = I]	

% il faut un ingénieur
% l0:exists(x lr ls) lr:ingenieur(x) ls:necessaire(x)

class ilVn1
declare
	?L  ?E
{
	ImpersonalSubject[];
	activeVerbMorphology[]*=[vbI = E];
	Object[E,L];
	basicProperty[]*=[label0 = L, arg0 = E]
}
[objectI = I,arg0 = I]
% il faut que jean parte; il faut partir
% faut(l) l:partir(e) agent(e x)

class ilVcs1
declare
	?E ?X
{	basicProperty[]*=[arg0 = E];
	ImpersonalSubject[];
	activeVerbMorphology[]*=[vbI = E];
   	SententialCObject[X,E]
}
[vbI = I,arg0 = I]	
%% UNARY VERBS
class n0V
declare
	?X  ?E ?L
{
	unaryRel[]*=[label0=L,arg0=E,arg1=X] ;
	{
	dian0Vactive[L,E,X]
	|dian0Vimpersonal[L,E,X]}
}
%class dian0Vactive[L,E,X]
%{
%	Subject[X,L] ; 
%	activeVerbMorphology[]*=[vbI=E,vbL=L]
%}
[vbI = arg0, subjectI = arg1]
class dian0Vimpersonal[L,E,X]
{
	ImpersonalSubject[] ; 
	activeVerbMorphology[]*=[vbI=E,vbL=L];
	Object[X,L]
}
[vbI = arg0, objectI = arg1]
%% REFLEXIVE VERBS
%% Marie se lave (reflechi autonome)
class n0ClV[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=X] ;
	Subject[X,L]; 
	reflexiveVerbMorphology[]*=[vbI=E,vbL=L,reflI=X] 
}
[vbI = arg0, subjectI = arg1,reflI=arg2]

%% Marie s'évanouit (reflechi intrinseque)
class n0seV[L,E,X]{
	unaryRel[]*=[label0=L,arg0=E,arg1=X] ;
	Subject[X,L]; reflexiveVerbMorphology[]*=[vbI=E,vbL=L,reflI=noone] 
}
[vbI = arg0, subjectI = arg1]
% Jean s'offre un CD
class n0ClVn1[L,E,X,Y]{
	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=X,arg3=Y] ;
	Subject[X,L]; Object[Y,L]; reflexiveVerbMorphology[]*=[vbI=E,vbL=L,reflI=X] 
}
[vbI = arg0, subjectI = arg1,reflI=arg2,objectI=arg3]
% cet enfant s'appelle Marie
class n0seVn1[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	Subject[X,L]; Object[Y,L]; 
	reflexiveVerbMorphology[]*=[vbI=E,vbL=L,reflI=noone] 
}
[vbI = arg0, subjectI = arg1,objectI=arg2]
% Jean se bat contre Paul (reflechi autonome; agent1 theme agent2)
class n0ClVpn1[L,E,X,Y]{
	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=X,arg3=Y] ;
	Subject[X,L]; Oblique[Y,L]; reflexiveVerbMorphology[]*=[vbI=E,vbL=L,reflI=X]   	
}
[vbI = arg0, subjectI = arg1,objectI=arg2]
% Jean se plaint de Marc (agent,recipient,theme)
class n0ClVden1[L,E,X,Y]{
	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=X,arg3=Y] ;
	Subject[X,L]; Genitive[Y,L]; reflexiveVerbMorphology[]*=[vbI=E,vbL=L,reflI=X]  
}
% Jean se souvient de Marc (agent,theme)
class n0seVden1[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	Subject[X,L]; Genitive[Y,L]; reflexiveVerbMorphology[]*=[vbI=E,vbL=L,reflI=noone]  
}
% Qu'il neige en Aout arrive parfois
class s0V[L,E,X,Y]
declare ?Y
{
	unaryRel[]*=[label0=L,arg0=E,arg1=X] ;
	SententialSubject[Y,X,L]; 
	activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
%% BINARY VERBS
% Jean regarde Marie
class n0Vn1[L,E,X,Y]
{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
        { dian0Vn1Active[L,E,X,Y]
	| dian0Vn1Passive[L,E,X,Y]
	| dian0Vn1dePassive[L,E,X,Y]
	| dian0Vn1ShortPassive[L,E,X,Y]
	| dian0Vn1ImpersonalPassive[L,E,X,Y]
	%| dian0Vn1middle[E,X,Y]
	| dian0Vn1Reflexive[L,E,X,Y]
	}
}
class dian0Vn1Active[L,E,X,Y]
{
                Subject[X,L] ; 
		Object[Y,L];
		activeVerbMorphology[]*=[vbI=E,vbL = L]         
}
class dian0Vn1Passive[L,E,X,Y]
{
                Subject[Y,L] ; 
		CAgent[X,L]  ; 
		passiveVerbMorphology[]*=[vbI=E,vbL = L]        
}
class dian0Vn1dePassive[L,E,X,Y]
{
                Subject[Y,L] ; 
		Genitive[X,L]  ;
                passiveVerbMorphology[]*=[vbI=E,vbL = L]        
}
class dian0Vn1ShortPassive[L,E,X,Y]
{
                Subject[Y,L] ; 
		passiveVerbMorphology[]*=[vbI=E,vbL = L]        
} 
class dian0Vn1ImpersonalPassive[L,E,X,Y]
{
                ImpersonalSubject[] ; 
		Object[X,L];
		passiveVerbMorphology[]*=[vbI=E]        
}
class dian0Vn1middle[L,E,X,Y]
{
                Subject[Y,L] ; 
		middleVerbMorphology[]*=[vbI=E,vbL = L]       
}
%% X must be different from Y in the parameters -- why?
class dian0Vn1Reflexive[L,E,X,Y]
{
	Subject[X,L]; 
	AccReflexiveMorphology[]*=[vbI=E,vbL = L] 
} 
class n0Van1[L,E,X,Y]
{	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
        {dian0Van1Active[L,E,X,Y]
	|dian0Van1Reflexive[L,E,X,Y]}
}
class dian0Van1Active[L,E,X,Y]
{
	Subject[X,L] ; Iobject[Y,L] ; activeVerbMorphology[]*=[vbI=E,vbL=L]
}
class dian0Van1Reflexive[L,E,X,Y]
{
	Subject[X,L] ; DatReflexiveMorphology[]*=[vbI=E,vbL=L,reflI=Y]       
}
class n0Vden1[L,E,X,Y]
{	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	dian0Vden1[L,E,X,Y]
}
class dian0Vden1[L,E,X,Y]
{
	Subject[X,L] ; Genitive[Y,L] ; activeVerbMorphology[]*=[vbI=E,vbL=L]    }

class n0Vpn1[L,E,X,Y]
{
  {	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	Subject[X,L];Oblique[Y,L];activeVerbMorphology[]*=[vbI=E,vbL=L] 
  }
}
class n0Vloc1[L,E,X,Y]
{	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	Subject[X,L];Locative[Y,L];activeVerbMorphology[]*=[vbI=E,vbL=L] 
}	
%% TERNARY -- WITH NOMINAL ARGUMENTS
% not in valuation
% Qu'il neige habitue Jean a se couvrir
% Courir habitue Jean a se couvrir
% object control
class s0Vn1acs2[L,E,X,Y,Z]{
	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	SententialSubject[Y,X,L]; Object[Y,L]; SententialAObject[Y,Z]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
% Jean parle de linguistique à Marie
class n0Van1den2[L,E,X,Y,Z]
{	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y,arg3=Z] ;
	n0Van1[L,E,X,Y];Genitive[Z,L]
}
% not in valuation
% Jean parle de ce livre avec Marie
class n0Vden1pn2[L,E,X,Y,Z]
{	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y,arg3=Z] ;
   	Subject[X,L];Oblique[Y,L];Genitive[Z,L];
	activeVerbMorphology[]*=[vbI=E,vbL=L]
}
% 
class n0Vn1pn2[L,E,X,Y,Z]
{	ternaryRel[]*=[arg3=Z] ;
	n0Vn1[L,E,X,Y];Oblique[Z,L]
}
%not in the valuation
class n0Vn1loc2[L,E,X,Y,Z]
{	ternaryRel[]*=[arg3=Z] ;
	n0Vn1[L,E,X,Y];Locative[Z,L]
}

class n0Vn1an2[L,E,X,Y,Z]
{
 	ternaryRel[]*=[arg3=Z] ;
	n0Vn1[L,E,X,Y];Iobject[Z,L]
}
class n0Vn1den2[L,E,X,Y,Z]
{
 	ternaryRel[]*=[arg3=Z] ;
	n0Vn1[L,E,X,Y];Genitive[Z,L]
}

%%% SUBJECT CONTROL 

%Subject control
% Jean pense avoir raison
% SubjectControl
class n0Vcs1[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	Subject[X,L]; SententialCObject[X,Y]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
%Jean tient à venir
class n0Vas1[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	Subject[X,L]; SententialAObject[X,Y]
; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
% Jean demande où aller
%Subject control
class n0Vs1int[L,E,X,Y]{
 binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
 Subject[X,L]; 
 SententialInterrogative[X,Y]; 
 activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
% Jean se demande où aller (reflechi autonome; agent recipient theme)
class n0ClVs1int[L,E,X,Y,Z]{
 ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=X,arg3=Y] ;
 Subject[X,L]; 
 SententialInterrogative[X,Y]; 
 reflexiveVerbMorphology[]*=[vbI=E,vbL=L,reflI=X] 
}

%% SUBJ/OBJ CONTROL 
% default = subject control

class n0Vdes1[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	{dian0Vcs1Passive[L,E,X,Y]*=[zeroSubjectI=X]
	|dian0Vdes1ImpersonalPassive[L,E,X,Y]*=[zeroSubjectI=X]
	|dian0Vdes1Active[L,E,X,Y]*=[zeroSubjectI=X]
	|dian0Vcs1shortPassive[L,E,X,Y]*=[zeroSubjectI=X]}
}

class n0Vdes1ControleObjet[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	{dian0Vcs1Passive[L,E,X,Y]*=[zeroSubjectI=Y]
	|dian0Vdes1ImpersonalPassive[L,E,X,Y]*=[zeroSubjectI=Y]
	|dian0Vdes1Active[L,E,X,Y]*=[zeroSubjectI=Y]
	|dian0Vcs1shortPassive[L,E,X,Y]*=[zeroSubjectI=Y]}
}
% Jean reve de partir/qu'il ira a Bilbao
%?? partir est rêvé par Jean
class dian0Vcs1Passive[L,E,X,Y]
declare ?Z
{
 SententialSubject[Z,Y,L];
 passiveVerbMorphology[]*=[vbI=E,vbL=L];
 CAgent[X,L]}
%?? partir est rêvé 
class dian0Vcs1shortPassive[L,E,X,Y]
declare ?Z
{
 SententialSubject[Z,Y,L];passiveVerbMorphology[]*=[vbI=E,vbL=L]
}
%?? il est rêvé de partir
class dian0Vdes1ImpersonalPassive[L,E,X,Y]
declare ?Z
{
 ImpersonalSubject[];SententialDeObject[Z,Y];passiveVerbMorphology[]*=[vbI=E,vbL=L]        
}
%Jean rêve de partir
%Subject control
class dian0Vdes1Active[L,E,X,Y]
declare ?Z
{
 Subject[X,L]; SententialDeObject[Z,Y]; activeVerbMorphology[]*=[vbI=E,vbL=L] 	
}

%% TERNARY WITH SENTENTIAL ARGUMENTS
% Jean avertira Marie si Pierre part 
% ?? Jean avertira Marie de partir
class n0Vn1sint2[L,E,X,Y,Z]{
	ternaryRel[]*=[arg3=Z] ;
	n0Vn1[L,E,X,Y];SententialInterrogative[Y,Z]
}
% Jean demande à Marie si l'ingenieur vient
% ?? Jean demande à Marie si partir
% Jean demande à Marie où aller
% subject control
class n0Vs1intan2[L,E,X,Y,Z]{
 ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y,arg3=Z] ;
 Subject[X,L]; SententialInterrogative[X,Y]; activeVerbMorphology[]*=[vbI=E,vbL=L]; Iobject[Z,L]
}


% Jean force Marie à venir
% Object control
class n0Vn1acs2[L,E,X,Y,Z]{
	ternaryRel[]*=[arg3=Z] ;
	n0Vn1[L,E,X,Y]; SententialAObject[Y,Z]
}
% Jean voit Marie partir
% Object control
class n0Vn1cs2ControleObjet[L,E,X,Y,Z]{
	ternaryRel[]*=[arg3=Z];
	n0Vn1[L,E,X,Y]; SententialCObject[Y,Z]
}
% Subject Control
class n0Vn1cs2[L,E,X,Y,Z]{
	ternaryRel[]*=[arg3=Z];
	n0Vn1[L,E,X,Y]; SententialCObject[X,Z]
}
%% not in lexicon
class n0Vcs1decs2[L,E,X,Y,Z]{
	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y,arg3=Z] ;
	Subject[X,L]; SententialCObject[X,Y]; SententialDeObject[Z,L]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
% Jean requiert de Marie qu'elle parte
class n0Vcs1den2[L,E,X,Y,Z]{
	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y,arg3=Z] ;
	Subject[X,L]; SententialCObject[Y,Z]; Genitive[Y,L]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
% Jean persuade marie de partir
% Subject control
class n0Van1decs2[L,E,X,Y,Z]{
	ternaryRel[]*=[arg3=Y] ;
	n0Vdes1[L,E,X,Z]; Iobject[X,L]
}
% Jean promet a Marie de partir
% Object control
class n0Van1decs2ControleObjet[L,E,X,Y,Z]{
	ternaryRel[]*=[arg3=Z] ;
	n0Vdes1ControleObjet[L,E,X,Z]; Iobject[Y,L]
}
% Jean convainc Marie de partir
% Object control
class n0Vn1decs2ControleObjet[L,E,X,Y,Z]{
	ternaryRel[]*=[arg3=Y] ;
	n0Vdes1ControleObjet[L,E,X,Z]; Iobject[Y,L]
}
class n0Vdes1pn2[L,E,X,Y,Z]
declare
	?Prep
{
	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y,arg3=Z] ;
   {
	Subject[X,L]; Oblique[Y,L]*=[prep = ?Prep]; SententialDeObject[Z,L]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
   }*=[prep2 = ?Prep]
}
% Jean dit à l'entreprise avoir raison
class n0Vcs1an2[L,E,X,Y,Z]{
	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y,arg3=Z] ;
	Subject[X,L];  Iobject[Y,L]; 
	SententialCObject[X,Z]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
%% BINARY -- SENTENTIAL SUBJECT
% Que jean parte désole Marie
class s0Vn1[L,E,X,Y,Z]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	SententialSubject[Y,X,L]; Object[Y,L]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}
% Que jean parte déplait à Marie
class s0Van1[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	SententialSubject[Y,X,L]; Iobject[Y,L]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}

% Qu'il neige prouve qu'il fait froid
class s0Vcs1[L,E,X,Y]
declare ?Z1 ?Z2
{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	SententialSubject[Z1,X,L]; SententialCObject[Z2,Y]; activeVerbMorphology[]*=[vbI=E,vbL=L]  
}

%%% NBAR, ADJECTIVES
% avoir
class n0Vnbar1[L,E,X,Y]{
	binaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y] ;
	Subject[X,L];activeVerbMorphology[]*=[vbI=E,vbL=L];CanonicalNBar[Y,L]
}
% Jean croit Marie stupide
class n0Vn1Adj2[L,E,X,Y]
{
	n0Vn1[L,E,X,Y];ObjAttribute[Y,L]
}
