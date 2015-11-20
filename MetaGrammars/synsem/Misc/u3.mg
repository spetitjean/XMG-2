%principle declarations:

%type declarations:
type MARK={subst,nadj,foot,flex,anchor}
type CAT={s,v,b,c,n,np,vp}
type CASE={nom,acc}

%property declarations:
property mark: MARK

%feature declarations:
feature cat: CAT
feature case: CASE

%class definitions:



class ex1
declare ?S ?VP ?V ?NP0 ?NP1
{
  <syn>{
	node S[cat=s];
  	node VP[cat=vp];
  	node V(mark=anchor)[cat=v];
	node NP0(mark=subst)[cat=np, case=nom];
	node NP1(mark=subst)[cat=np, case=acc];
	S -> NP0;
	S -> VP;
	NP0 >> VP;
	VP -> V;
	VP -> NP1
  }
}

class ex2
declare ?A ?B ?C ?D
{
  <syn>{
	node A[cat=s];
  	node B[cat=v];
  	node C[cat=s];
	node D[cat=n];
  	A ->  B;
  	A ->* C;
	A -> D;
	B >> D
  }
}

%valuations:
value ex1
value ex2
