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



class Init
{
<morph>{
	field f_sujet;
	field f_temps;
	field f_racine;
	field f_voix;
	field f_aspect;
	field f_theme;
	field f_eloignement;

	f_sujet >> f_temps;
	f_temps >> f_racine;
	f_racine >> f_voix;
	f_voix >> f_aspect;
	f_aspect >> f_theme;
	f_theme >> f_eloignement
  }
}

class Subject_Clitic
{
{<morph>{f_sujet <- "m"};<iface>{[p=1, n=sg]}}
%   | 
% {<morph>{f_sujet <- "ò" };<iface>{[p=2, n=sg]}}
%   |
% {<morph>{f_sujet <- "à" };<iface>{[p=3, n=sg]}}
%   |
% {<morph>{f_sujet <- "mín"};<iface>{[p=1, n=pl]}}
%   |
% {<morph>{f_sujet <- "bíh" };<iface>{[p=2, n=pl]}}
%   | 
% {<morph>{f_sujet <- "b" };<iface>{[p=3, n=pl]}}
}

class Subject_Noun
{
<iface>{[p=3]};
  { 
   {<iface>{[n=sg]}; {<iface>{[nc=C1]} | <iface>{[nc=C9]}}}
   |
   {<morph>{f_sujet <- "b"};<iface>{ [n=pl, nc=C2] }}
   | 
   {<morph>{f_sujet <- "mw"};<iface>{[ n=sg, nc=C3 ]}}
   | 
   {<morph>{f_sujet <- "mj"};<iface>{[n=pl, nc=C4]}}
   |
   {<morph>{f_sujet <-"m"};<iface>{[n=pl, nc=C6]}}
   | 
   {<morph>{f_sujet <- "dʒ"};<iface>{[n=sg, nc=C5]}}
   | 
   {<morph>{f_sujet <- "j"};<iface>{[n=sg, nc=C7]}}
   | 
   {<morph>{f_sujet <- "bj"};<iface>{[n=pl, nc=C8]}}
   | 
   {<morph>{f_sujet <- "bw"};<iface>{[n=sg, nc=C14]}}
  
  } 
}

class Subject
{ 
  Subject_Clitic[] 
  % | 
  % Subject_Noun[] 
  }

class TensePos
{
<iface>{[neg= -]} ;
  { 
  {<morph>{f_temps <- "é"}  ; { <iface>{[tense=past, proxi=near] } | <iface>{[tense=future, proxi=@{day,far,near}] } } }
  | 
   {<morph>{f_temps <- "à"}  ; {<iface>{[tense=present, n=sg, proxi=none]} | <iface>{[tense=past, n=sg, proxi=@{imminent,day,far}]} } } 
  |
   {<morph>{f_temps <- "á"}  ; {<iface>{[tense=present, n=pl, proxi=none]} | <iface>{[tense=past, n=pl, proxi=@{imminent,day,far}]} } }
  |
   {<morph>{f_temps <- "àmò"}  ; <iface>{[tense=past, n=sg, proxi=none] } }
  |
   {<morph>{f_temps <- "ámò"}  ; <iface>{[tense=past, n=pl, proxi=none] } }
  | 
    {<morph>{f_temps <- "ábí"} ; <iface>{[tense=future, proxi=imminent] } }
   }
}

class TenseNeg
{
<iface>{[neg = +]} ;
  {
    {<iface>{[tense=present]};<morph>{f_temps <- "à"}  }
  | 
    {<iface>{[tense=past]};<morph>{f_temps <- "átʃà"}}
  |
    {<iface>{[tense=future]};<morph>{f_temps <- "ádʒí"}}
   }					     
}

class Tense
{ 
  TensePos[] 
  % | 
  % TenseNeg[] 
  }

class Theme
{
  {<morph>{f_theme <- "é"};  <iface>{[active = +,neg = +, tense = present]}}
|     
  { 
    <iface>{[active = +]}; 
      { 
      	{	
      		<iface>{[vclass=g1, 
      		         prog= +, 
      		        proxi=@{none,imminent,far,day}
      			]};
      		<morph>{f_theme <- "á"}
      		}
      | 
      	{
  		<iface>{[vclass=g1]}; 
  		{<iface>{[prog= -]}| <iface>{[prog= + , proxi = near]}
				};
  		<morph>{f_theme <- "à"}
  		}
      | 
      	{
  		<iface>{[vclass=g2, 
  		         prog= +, 
  		         proxi=@{none,imminent,far,day}]};
  		<morph>{f_theme <- "ɛ́"}
  		}
      | 
      	{
  		<iface>{[vclass=g2]}; 
  		{<iface>{[prog= -]} | <iface>{[prog= +, proxi= near]}};
  		<morph>{f_theme <- "ɛ̀"}
  		}
      | 
      	{
  		<iface>{[vclass=g3,
  		         prog= +, 
  		         proxi=@{none,imminent,far,day}]};
  		<morph>{f_theme <- "ɔ́"}
  		}
      | 
      	{
  		<iface>{[vclass=g3]}; 
  		{<iface>{[prog= -]} | <iface>{[prog= + , proxi= near]}};
  		<morph>{f_theme <- "ɔ̀"} 
  	}
    
  }
  | {	
    	<iface>{[active= -]};
  	<morph>{f_theme <- "ɛ"}
   	}
    }
}

class Voix
{
   % {<morph>{f_voix <- "ébw" };
   %  <iface>{[active = -]} 
   	
   % 	}
   % 	|
  <iface>{[active= +]}

		
}		


class Aspect
{ 

  {
   	<iface>{[tense=future,prog = -]} 
  	
		;
    	{ 
	  {
		<iface>{[active= +]};	
	  	{
			{<morph>{f_aspect <- "ák"} ; <iface>{[vclass=g1]}}
    	  		| 
	  		{<morph>{f_aspect <- "ɛ́tʃ"} ; <iface>{[vclass=g2]}}
    	  		| 
	  		{<morph>{f_aspect <- "ɔ́k"} ; <iface>{[vclass=g3]}}
		}
	  }
	  |
	  {
	  	<iface>{[active= -]};
	  	<morph>{f_aspect <- "ɛ́tʃ"}
	  }
	}
	
  }
  
  | 
  
  {
  	<iface>{[tense=past, prog= +]} 
  	}

  | 
  
  {
  	<iface>{[tense=present, prog= +]} 
  	}

}

class Proximal
{
  {
  <iface>{[active= +]};
  { 
    {<morph>{f_eloignement <- "ná"}; <iface>{[proxi=day, vclass=g1]}}
  | 
    {<morph>{f_eloignement <- "sá"}; <iface>{[proxi=far, vclass=g1]}}
  | 
    {<morph>{f_eloignement <- "nɛ́"}; <iface>{[proxi=day, vclass=g2]}}
  | 
    {<morph>{f_eloignement <- "sɛ́"}; <iface>{[proxi=far, vclass=g2]}}
  | 
    {<morph>{f_eloignement <- "nɔ́"}; <iface>{[proxi=day, vclass=g3]}}
  | 
    {<morph>{f_eloignement <- "sɔ́"}; <iface>{[proxi=far, vclass=g3]}}
  |  
     { 
  		{<iface>{[proxi=none]}|<iface>{[proxi=near]}} 
               | 
	       { <iface>{[proxi=imminent, tense=future] }}
   }
 }
 }
 | 
 {
	<iface>{[active= -]} ;
 	   {
  {<morph>{f_eloignement <- "nɛ́"}; <iface>{[proxi=day]}}
| 
  {<morph>{f_eloignement <- "sɛ́"}; <iface>{[proxi=far]}}
| { 	   
	   {<iface>{[proxi=none]}|<iface>{[proxi=near]}}
           | 
	   <iface>{[proxi=imminent, tense=future]} 
    }
  }
}
}		    





class Manger
{
<morph>{
f_racine <- "dʒ"
}
;<iface>{[vclass=g1]}
}

class Donner
{
<morph>{f_racine <- "w"};
<iface>{[vclass=g2]}
}

class Choisir 
{
<morph>{f_racine <- "bɔ́n"};
<iface>{[vclass=g3]}
}

class VR
{
  Manger[] %| Donner[] | Choisir[]
}

class Verb
{
  Init[]; Subject[];
  Tense[];
  VR[]; Aspect[]; Theme[]; Voix[]; Proximal[]
}

%% AXIOMS
value Verb
