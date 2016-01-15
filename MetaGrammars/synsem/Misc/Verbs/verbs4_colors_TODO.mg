use color with () dims (syn)

type MARK = {subst, subst, nadj, foot, anchor, coanchor, flex}
type CAT = {np,n,v,vp,s,pp,p,by}
type PHON = {e}
type COLOR = {red,black,white}

property mark : MARK
property color : COLOR

feature cat : CAT
feature phon : PHON

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREE FRAGMENTS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class Subject
export ?SubjMark ?SubjNP
declare ?S ?VP ?SubjNP ?SubjMark
{ <syn> {
	node ?S [cat=s] {
		node ?SubjNP (mark=SubjMark) [cat=np]
		node ?VP [cat=vp]
	}
  }
}


class VerbProjection
declare ?VP ?V
{ <syn> {
	node ?VP [cat=vp] {
		node ?V (mark=anchor) [cat=v]
	}
  }
}

class Object
export ?ObjMark ?ObjNP
declare ?VP ?V ?ObjNP ?ObjMark
{ <syn> {
	node ?VP [cat=vp] {	
		node ?V [cat=v]
		node ?ObjNP (mark=ObjMark) [cat=np]
	}
  }
}

class ExtractedNP
declare ?Sr ?NP ?S
{
	<syn> {
	node ?Sr [cat=s] {	
		node ?NP (mark=subst) [cat=np]
		node ?S [cat=s]
	}
  }
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREE TEMPLATES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


class alphanx0V
import Subject[] VerbProjection[]
{
  ?SubjMark=subst
}


class alphaW0nx0V
import Subject[] VerbProjection[] ExtractedNP[]
declare ?XP
{
  ?SubjMark=nadj;
    <syn> {
		node ?XP (mark=flex)[phon = e];
		?SubjNP -> ?XP
	}
}

class alphanx0Vnx1_mark
import Subject[] VerbProjection[] Object[]

class alphanx0Vnx1
import alphanx0Vnx1_mark[]
{
	?SubjMark=subst;
	?ObjMark=subst
}


class alphaW1nx0Vnx1
import alphanx0Vnx1_mark[] ExtractedNP[]
declare ?XP
{
  ?SubjMark=subst;
  ?ObjMark=nadj;
  <syn> {
		node ?XP (mark=flex)[phon = e];
		?ObjNP -> ?XP
	}

}

class alphaW0nx0Vnx1
import alphanx0Vnx1_mark[] ExtractedNP[]
declare ?XP
{
  ?SubjMark=nadj;
  ?ObjMark=subst;
  <syn> {
		node ?XP (mark=flex)[phon = e];
		?SubjNP -> ?XP
	}

}


class propernoun
declare ?NP ?N
{
  <syn>{
    node ?NP [cat=np];
    node ?N (mark=anchor) [cat=n];
    ?NP -> ?N
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREE FAMILIES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class n0V
{
  alphanx0V[]
  |
  alphaW0nx0V[]
}

class n0Vn1
{
  alphanx0Vnx1[]
  |
  alphaW1nx0Vnx1[]
  |
  alphaW0nx0Vnx1[]
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EVALUATION:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value n0V
value n0Vn1
value propernoun