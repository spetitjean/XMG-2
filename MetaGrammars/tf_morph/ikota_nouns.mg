%% -*- coding: utf-8 -*-

%% -> atomic disjunctions 

%% TYPES
type NUMBER = {sg,pl}
type NCLASS = {C1,C1A,C2,C3,C3A,C4,C5,C5A,C6,C7,C8,C9,C14}

feature n : NUMBER
feature nc : NCLASS

field prefix
field NR

prefix >> NR

class Prefix
{
	<morph>{
  	{ 
   	{ n=sg; nc=@{C1,C3,C9}}
   	|
   	{ n=pl; nc=C2; prefix <- "ba"}
   	| 
   	{ n=sg; nc=@{C1,C3}; prefix <- "mo"} %% ou "n" pour la C3
   	| 
   	{ n=pl; nc=C4; prefix <- "me"}
   	| 
   	{ n=pl; nc=C6; prefix <- "ma"}
   	| 
   	{ n=sg; nc=C5; prefix <- "dʒ"} %% ou "i"
   	| 
   	{ n=sg; nc=C7; prefix <- "e"}
   	| 
   	{ n=pl; nc=C8; prefix <- "be"}
   	| 
   	{ n=sg; nc=C14; prefix <- "bo"} %% ou "o"
  	}
    }
}


class C9
{
<morph>{
  	{
	{n=sg; nc=@{C9}}
	|
	{n=pl; nc=C6}
	}
}
}

class C14
{
<morph>{
	{
	{n=sg; nc=C14}
	|
	{n=pl; nc=C6}
	}
}
}


class Aiguille
{
	C9[]
	;
<morph>{
	NR <- "lɛngwɛ"
	}
}


class Village
{
	C14[]
	;
<morph>{
	NR <- "mb`oka"
	}
}


class NR
{
  Village[] | Aiguille[]
}

class Noun
{
  Prefix[] ; NR[]
}

%% AXIOMS
value Noun
