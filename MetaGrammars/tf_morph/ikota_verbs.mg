%% -*- coding: utf-8 -*-

%% TYPES
type CLASS  = {g1,g2,g3}
type VOICE  = {active,passive}
type TENSE  = {past,present,future}
type NUMBER = {sg,pl}
type PROXI  = {none,imminent,day,near,far}
type NCLASS = {C1,C1A,C2,C3,C3A,C4,C5,C5A,C6,C7,C8,C9,C14}
type PERSON = [1..3]
type CHAMPS = [|f_sujet : string, f_temps : string, f_racine : string, f_voix : string, f_aspect : string, f_theme : string, f_eloignement : string|]
type TRAITS = [|vclass : CLASS, voice : VOICE, tense : TENSE, n : NUMBER, proxi : PROXI, nc : NCLASS, p : PERSON, neg : bool, prog : bool, active : bool|]

use dimtype with (CHAMPS, TRAITS) dims (morph)


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

field f_sujet
field f_temps
field f_racine
field f_voix
field f_aspect
field f_theme
field f_eloignement

f_sujet >> f_temps
f_temps >> f_racine
f_racine >> f_voix
f_voix >> f_aspect
f_aspect >> f_theme
f_theme >> f_eloignement


class Subject_Clitic
{
<morph>{
  { p:1; n:sg ; f_sujet <- "m"}
  | 
  { p:2; n:sg ; f_sujet <- "ò" }
  | 
  { p:3; n:sg ; f_sujet <- "à" }
  |
  { p:1; n:pl ; f_sujet <- "mín"}
  | 
  { p:2; n:pl ; f_sujet <- "bíh" }
  | 
  { p:3; n:pl ; f_sujet <- "b" }
}
}

class Subject_Noun
{
<morph>{

  p:3;
  { 
   { n:sg; {nc:C1|nc:C9}}
   |
   { n:pl; nc:C2; f_sujet <- "b"}
   | 
   { n:sg; nc:C3; f_sujet <- "mw"}
   | 
   { n:pl; nc:C4; f_sujet <- "mj"}
   |
   { n:pl; nc:C6; f_sujet <-"m"}
   | 
   { n:sg; nc:C5; f_sujet <- "dʒ"}
   | 
   { n:sg; nc:C7; f_sujet <- "j"}
   | 
   { n:pl; nc:C8; f_sujet <- "bj"}
   | 
   { n:sg; nc:C14; f_sujet <- "bw"}
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

  neg : - ;
  { 
    {f_temps <- "é"  ; {{ tense:past; proxi:near }
                     | { tense:future }}}
  | 
    {f_temps <- "à"  ; {{ tense:present; n:sg; proxi:none }
                     | { tense:past; n:sg; {proxi:imminent|proxi:day|proxi:far} } } }
  |
    {f_temps <- "á"  ; {{ tense:present; n:pl; proxi:none }
                     | { tense:past; n:pl; {proxi:imminent|proxi:day|proxi:far} } } }
  |
    {f_temps <- "àmò"  ; {{ tense:past; n:sg; proxi:none }}}
  |
    {f_temps <- "ámò"  ; {{ tense:past; n:pl; proxi:none }}}
  | 
    {f_temps <- "ábí"; { tense:future; proxi:imminent } } }
  }
}

class TenseNeg
{
<morph>{

  neg : + ;
  {
    { tense:present ;
      f_temps <- "à"  }
  | 
    { tense:past ;
      f_temps <- "átʃà" }
  |
   { tense:future ;
      f_temps <- "ádʒí" } 
      
	}
      }
}

class Tense
{ 
  TensePos[] 
  %%| 
  %%TenseNeg[] 
  }

class Theme
{
<morph>{

  { 
      active : +;
      neg : +; 
      tense : present;
      f_theme <- "é" }
|     
    { 
      active : +; 
      { 
      	{	
		vclass:g1; 
		prog: + ; 
		{proxi:none|proxi:imminent|proxi:far|proxi:day};
		f_theme <- "á"
		}
      | 
      	{
		vclass:g1; 
		{prog: - | {prog: + ; proxi : near}};
		f_theme <- "à"
		}
      | 
      	{
		vclass:g2; 
		prog: + ; 
		{proxi:none|proxi:imminent|proxi:far|proxi:day};
		f_theme <- "ɛ́"
		}
      | 
      	{
		vclass:g2; 
		{prog: - | {prog: + ; proxi : near}};
		f_theme <- "ɛ̀"
		}
      | 
      	{
		vclass:g3; 
		prog: + ; 
		{proxi:none|proxi:imminent|proxi:far|proxi:day};
		f_theme <- "ɔ́"
		}
      | 
      	{
		vclass:g3; 
		{prog: - | {prog: + ; proxi : near}};
		f_theme <- "ɔ̀" 
		}
    }
  }
  | {	
    	active: -;
	f_theme <- "ɛ"
	}
   }
}

class Voix
{
   % <morph>{
   % 	active : - ; 
   % 	f_voix <- "ébw" 
   % 	} 
   % 	|
  <morph>{
  	active: +
  	}

		
}		


class Aspect
{
<morph>{
  { 
	{	
   		tense:future; 
   		prog : - 
  	}
		;
    	{ 
	  {
		active: +;	
	  	{
			{f_aspect <- "ák" ; vclass:g1}
    	  		| 
	  		{f_aspect <- "ɛ́tʃ"; vclass:g2}
    	  		| 
	  		{f_aspect <- "ɔ́k" ; vclass:g3}
		}
	  }
	  |
	  {
		active: -;
		f_aspect <- "ɛ́tʃ"
	  }
	}
	
  }
  
  | 
  
  {
	tense:past ;
	prog : + 
	}

  | 
  
  {
	tense:present ;
	prog : + 
	}



}
}

class Proximal
{
<morph>{
  {
    {
  active: +;
  { 
    {f_eloignement <- "ná"; proxi:day; vclass:g1}
  | 
    {f_eloignement <- "sá"; proxi:far; vclass:g1}
  | 
    {f_eloignement <- "nɛ́"; proxi:day; vclass:g2}
  | 
    {f_eloignement <- "sɛ́"; proxi:far; vclass:g2}
  | 
    {f_eloignement <- "nɔ́"; proxi:day; vclass:g3}
  | 
    {f_eloignement <- "sɔ́"; proxi:far; vclass:g3}
  |  
     { 
		{proxi:none|proxi:near} 
               | 
	       { proxi:imminent; tense:future }
   }
 }
 }
 | 
 {
	  active: - ;
 	   {
  {f_eloignement <- "nɛ́"; proxi:day}
| 
  {f_eloignement <- "sɛ́"; proxi:far}
| { 	   
	   {proxi:none|proxi:near} 
           | 
	   { proxi:imminent; tense:future} 
    }
  }
}
}		    


}
}

class Manger
{
<morph>{

  vclass:g1; f_racine <- "dʒ"
}
}

class Donner
{
<morph>{
  vclass:g2; f_racine <- "w"
}
}

class Choisir 
{
<morph>{
 vclass:g3; f_racine <- "bɔ́n"
}
}

class VR
{
  Manger[] | Donner[] | Choisir[]
}

class Verb
{
  Subject[]; Tense[]; VR[]; Aspect[]; Theme[]; Voix[]; Proximal[]
}

%% AXIOMS
value Verb
