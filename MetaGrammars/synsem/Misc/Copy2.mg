type CAT={s,a,b,c,v}
type MARK={foot,flex,subst,nadj}
type PHON={e}

feature cat: CAT
feature phon: PHON

property mark: MARK

class alpha
declare ?S ?V ?C
{
  <syn>{
  node ?S [cat=s];
  node ?V [cat=v];
  %% this is a lexical node for the empty word
  node ?C (mark=flex)[phon=e];
  ?S -> ?V;
  ?V -> ?C
  }
}

class beta_x[X]
declare ?S0 ?A0 ?S1 ?A1 ?S2 ?V1 ?V2
{
  <syn>{
	node ?S0 (mark=nadj)[cat=s];
	node ?S1 [cat=s];
	node ?V1 [cat=v];
	node ?V2 [cat=v];
	node ?A0 (mark=flex)[cat=?X];
	node ?A1 (mark=flex)[cat=?X];
	node ?S2 (mark=foot)[cat=s];
	?S0 -> ?V1;
	?S0 -> ?S1;
	?S1 -> ?V2;
	?S1 -> ?S2;
	?V1 >> ?S1;
	?S2 >> ?V2;
	?V1 -> ?A0;
	?V2 -> ?A1
  }
}

class beta
{
  beta_x[a]|beta_x[b]
}


value alpha

value beta