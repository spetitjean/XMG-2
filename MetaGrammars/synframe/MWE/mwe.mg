type CAT={np,vp,s,n,v,det,john,kicked,the,bucket}
type MARK={lex,anchor,subst}
type LABEL!
type PERS=[1..3]

feature cat: CAT
feature e: LABEL
feature i: LABEL
feature pers: PERS
feature rel: LABEL

property mark: MARK

frame-types = {dying, kicking}
%frame-attributes = {actor,theme,goal,mover,path,cause,effect}
frame-constraints = { 
	dying -> patient : +,
	kicking -> patient : +,
	kicking -> actor : +,
	kicking dying -> -
}


class nx0Vnx1 
export ?S ?NP_Subj ?VP ?V ?NP_Obj
declare ?S ?NP_Subj ?VP ?V ?NP_Obj ?X0 ?X1 
{
  <syn>{
     node ?S [cat=s, e=?X0] {
       node ?NP_Subj (mark=subst) [cat=np, i=?X1]
       node ?VP [cat=vp, e=?X0] {
         node ?V [cat=v, e=?X0] 
         node ?NP_Obj [cat=np] }}
  }  
}

class propernoun
declare ?X1
{
<syn>{node [cat=np, i=?X1] {node (mark=anchor)[cat = n,i=?X1]} }
 
}

class commonnoun
{
<syn>{node [cat=np] {node (mark=lex)[cat=the] node (mark=anchor)[cat = n]} }
}


class kick
import nx0Vnx1[]
declare ?X0 ?X1 ?X2
{
<syn>{
node ?NP_Subj [i=?X1];
node ?V (mark=anchor) [i=?X0];
node ?NP_Obj (mark=subst)[i=?X2] 
}
;
<frame>{
    ?X0[kicking,
      actor:?X1,
      patient:?X2]
}
}

class kicked_the_bucket
import nx0Vnx1[]
declare ?X0 ?X1 !L 
{
  <syn>{
     node ?NP_Subj [i=?X1];
     node ?V [e=?X0] { node (mark=anchor) [cat=v] };
     node ?NP_Obj [] {
       node [cat=det] { node (mark=lex) [cat=the] }
       node [cat=n, e=?X0] { node (mark=lex) [cat=bucket] } }
  }  
  ;
  <frame>{
    ?X0[dying,
      patient:?X1]
  }
}



value kicked_the_bucket
value kick
value propernoun
value commonnoun
