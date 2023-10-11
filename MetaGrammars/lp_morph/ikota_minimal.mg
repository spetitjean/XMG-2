%% -*- coding: utf-8 -*-

%% TYPES
type CLASS  = {g1,g2,g3}
type VOICE  = {active,passive}
type TENSE  = {past,present,future}
type NUMBER = {sg,pl}
type PROXI  = {none,imminent,day,near,far}
type NCLASS = {C1,C1A,C2,C3,C3A,C4,C5,C5A,C6,C7,C8,C9,C14}
type PERSON = [1..3]

feature vclass : CLASS
feature voice : VOICE
feature tense : TENSE
feature n : NUMBER
feature proxi : PROXI
feature nclass : NCLASS
feature p : PERSON
feature nc : NCLASS
feature neg : bool
feature prog : bool
feature active : bool



class Init
{
<morph>{
	field f_subj;
	field f_tense;
	field f_root;
	field f_aspect;
	field f_active;
	field f_prox;

	f_subj >> f_tense;
	f_tense >> f_root;
	f_root >> f_aspect;
	f_aspect >> f_active;
	f_active >> f_prox
  }
}

class Subject_Clitic
{
{<morph>{f_subj <- "m"};<iface>{[p=1, n=sg]}}
}


class Subject
{ 
  Subject_Clitic[] 
  }

class TensePos
{
    {<morph>{f_tense <- "é"}  ; { <iface>{[tense=past, proxi=near] } | <iface>{[tense=future, proxi=@{day,far,near}] } } }
  | 
    {<morph>{f_tense <- "à"}  ; {<iface>{[tense=present, n=sg, proxi=none]} | <iface>{[tense=past, n=sg, proxi=@{imminent,day,far}]} } }
  | 
    {<morph>{f_tense <- "ábí"} ; <iface>{[tense=future, proxi=imminent] } }
   
}


class Tense
{ 
  TensePos[] 
  }

class Theme
{ 
  {	
    <iface>{[prog= +, proxi=@{none,imminent,far,day}]};
    <morph>{f_active <- "a´"}
  }
| 
  {
    {<iface>{[prog= -]} | <iface>{[prog= + , proxi = near]}};
    <morph>{f_active <- "à"}
  }        
}
  

class Voice		


class Aspect
{ 
  { <iface>{[tense=future,prog = -]} ; <morph>{f_aspect <- "ák"} }
  | 
  <iface>{[tense=past, prog= +]}
  |   
  <iface>{[tense=present, prog= +]}
}


class Proximal
{
  {<morph>{f_prox <- "ná"}; <iface>{[proxi=day]}}
  | 
  {<morph>{f_prox <- "sá"}; <iface>{[proxi=far]}}
  |  
  <iface>{[proxi=none]}
  |
  <iface>{[proxi=near]}
  |
  <iface>{[proxi=imminent, tense=future] }   
}		    


class Eat
{
<morph>{f_root <- "dʒ"}
}

class VR
{
  Eat[] 
}

class Verb
{
  Init[]; Subject[]; Tense[]; VR[]; Aspect[]; Theme[]; Voice[]; Proximal[]
}

%% AXIOMS
value Verb
