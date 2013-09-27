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

field VR
field fsubject
field ftense
field faspect
field fproxi
field factive

fsubject >> ftense
ftense >> VR
VR >> faspect
faspect >> factive
factive >> fproxi


class Subject_Clitic
{
<morph>{
  { p=1; n=sg ; fsubject <- "m"}
  | 
  { p=2; n=sg ; fsubject <- "ò" }
}
}

class Subject_Noun
{
<morph>{

  p=3;
  { 
   { n=sg; nc=@{C1,C1A,C9}}
   |
   { n=pl; nc=C2; fsubject <- "b"}
   | 
   { n=sg; nc=@{C3,C3A}; fsubject <- "mw"}
   | 
   { n=pl; nc=@{C4,C6}; fsubject <- "my"}
   | 
   { n=sg; nc=@{C5,C5A}; fsubject <- "dʒ"}
   | 
   { n=sg; nc=C7; fsubject <- "y"}
   | 
   { n=pl; nc=C8; fsubject <- "by"}
   | 
   { n=sg; nc=C14; fsubject <- "bw"}
  }
}
}

class Subject
{ 
  Subject_Clitic[] 
  | 
  Subject_Noun[] 
  }

class TensePos
{
<morph>{

  neg = - ;
  { 
    {ftense <- "é"  ; {{ tense=past; proxi=near }
                     | { tense=future }}}
  | 
    {ftense <- "à"  ; {{ tense=present }
                     | { tense=past; proxi=@{none,imminent,day,far} } } }
  | 
    {ftense <- "ábí"; { tense=future; proxi=imminent } } }
  }
}

class TenseNeg
{
<morph>{

  neg = + ;
  {
    { tense=present ;
      ftense <- "à"  }
  | 
    { tense=past ;
      ftense <- "átʃà" }
  |
   { tense=future ;
      ftense <- "ádʒí" } 
      
	}
      }
}

class Tense
{ 
  TensePos[] 
  | 
  TenseNeg[] 
  }

class Active
{
<morph>{

  { 
      active = +;
      neg = +; 
      tense = present;
      factive <- "é" }
|     
    { 
      active = +; 
      { 
      	{	
		vclass=g1; 
		prog= + ; 
		factive <- "á"
		}
      | 
      	{
		vclass=g1; 
		prog= - ; 
		factive <- "à"
		}
      | 
      	{
		vclass=g2; 
		prog= + ; 
		factive <- "ɛ́"
		}
      | 
      	{
		vclass=g2; 
		prog= - ; 
		factive <- "ɛ̀"
		}
      | 
      	{
		vclass=g3; 
		prog= + ; 
		factive <- "ɔ́"
		}
      | 
      	{
		vclass=g3; 
		prog= - ; 
		factive <- "ɔ̀" 
		}
    | {
	active = - ; 
	faspect <- "ubwɛ̀" 
	} 
	}

}
}
}


class Aspect
{
<morph>{

  { 
	{	
	tense=future; 
    	prog = - 
	}
		;
    	{ 
	{faspect <- "ák" ; vclass=g1}
    	| 
	{faspect <- "ɛ́tʃ"; vclass=g2}
    	| 
	{faspect <- "ɔ́k" ; vclass=g3}
	}
  | 
  
  {
	tense=@{past,present} ;
	prog = + 
	}
}
}
}

class Proximal
{
<morph>{
  {
    {
  active= +;
  { 
    {fproxi <- "ná"; proxi=day; vclass=g1}
  | 
    {fproxi <- "sá"; proxi=far; vclass=g1}
  | 
    {fproxi <- "nɛ́"; proxi=day; vclass=g2}
  | 
    {fproxi <- "sɛ́"; proxi=far; vclass=g2}
  | 
    {fproxi <- "nɔ́"; proxi=day; vclass=g3}
  | 
    {fproxi <- "sɔ́"; proxi=far; vclass=g3}
  |  
     { 
		proxi=@{none,near} 
               | 
	       { proxi=imminent; tense=future }
   }
 }
 }
 |
 {
	  active= - ;
 	   {
  {fproxi <- "nɛ́"; proxi=day}
| 
  {fproxi <- "sɛ́"; proxi=far}
| { 	   
	   proxi=@{none,near} 
           | 
	   { proxi=imminent; tense=future} 
    }
  }
}
}		    


}
}

class Manger
{
<morph>{

  vclass=g1; VR <- "dʒ"
}
}

class Donner
{
<morph>{
  vclass=g2; VR <- "w"
}
}

class VR
{
  Manger[] | Donner[]
}

class Verb
{
  Subject[]; Tense[]; VR[]; Aspect[]; Active[]; Proximal[]
}

%% AXIOMS
value Verb
