type MARK = {subst, subst, nadj, foot, anchor, coanchor, flex}
type CAT = {np,n,v,vp,s,pp,p,by}
type PHON = {e}

property mark : MARK

feature cat : CAT
feature phon : PHON

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREE FRAGMENTS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class Subject
export ?VP ?S ?SubjNP ?SubjMark
declare ?S ?VP ?SubjNP ?SubjMark
{ <syn> {
	node ?S [cat=s] {
		node ?SubjNP (mark=SubjMark) [cat=np]
		node ?VP [cat=vp]
	}
  }
}


class VerbProjection
export ?VP ?V
declare ?VP ?V
{ <syn> {
	node ?VP [cat=vp] {
		node ?V (mark=anchor) [cat=v]
	}
  }
}

class Object
export ?VP ?V ?ObjNP ?ObjMark
declare ?VP ?V ?ObjNP ?ObjMark
{ <syn> {
	node ?VP [cat=vp] {	
		node ?V [cat=v]
		node ?ObjNP (mark=ObjMark) [cat=np]
	}
  }
}

class ExtractedNP
export ?S
declare ?Sr ?NP ?S
{
	<syn> {
	node ?Sr [cat=s] {	
		node ?NP (mark=subst) [cat=np]
		node ?S [cat=s]
	}
  }
}

class byPP
declare ?PP ?P ?By ?NP
{
  <syn>{
    node ?PP [cat=pp];
    node ?P [cat=p];
    node ?By (mark=flex) [cat=by];
    node ?NP (mark=subst) [cat=np];
    ?PP -> ?P;
    ?PP -> ?NP;
    ?P >> ?NP;
    ?P -> ?By
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
	%% TODO
}


class alphaW1nx0Vnx1
import alphanx0Vnx1_mark[] ExtractedNP[]
declare ?XP
{
	%% TODO
}

class alphaW0nx0Vnx1
import alphanx0Vnx1_mark[] ExtractedNP[]
declare ?XP
{
	%% TODO
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
  %% TODO
}

class n0Vn1
{
  %% TODO
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EVALUATION:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value n0V
value n0Vn1
value propernoun