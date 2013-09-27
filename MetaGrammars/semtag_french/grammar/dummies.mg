% Dummy rules for GenSem to handle lemanchor nodes
class dummy
export xDummy
declare ?xDummy 
{<syn>{
	node xDummy(color=black,mark=anchor)}}


% Jeanne est petite -- petite:n0vAPredicative, est: dummy

class dummyBe
import dummy[]
       eventSem[]
declare 
%?L0 
%?E 
?fTse ?fMode ?fSecant
{
<syn>{
	node xDummy[cat=v,top=[tense=?fTse,mode=?fMode,aspect=?fSecant]]}*=[tense=fTse,mode=fMode,aspect=fSecant] 
}

class ** dummyAdjective
import dummy[]
{
	<syn>{
		node xDummy[cat = adj]	
	}
}

class ** dummyNoun
import dummy[]
{
	<syn>{
		node xDummy[cat = n]	
	}
}

class ** dummyVerb
import dummy[]
{
	<syn>{
		node xDummy[cat = v]	
	}
}

class ** dummyClitic
import dummy[]
{
	<syn>{
		node xDummy[cat = cl]	
	}
}

class ** dummyAdv
import dummy[]
{
	<syn>{
		node xDummy[cat = adv]	
	}
}
