use unicity with (cat=v) dims (syn)

type CAT={adj,v,n}
type NUM={s,p}
type GEN={m,f}

type COLOR={red,black,white}

%% type F={F1,F2,F3}
%% F1 > F2 ?

%% Field(F,string)

property color : COLOR

feature cat : CAT
feature num : NUM
feature gen : GEN



field field1
field field2
field field3
field field4

class one
export X
declare X Y Z
{
      <morph>{
	cat = adj;
	X="é";
	field1 <- X;
	{ field2 <- "pique" | field2 <- "norme" }
	} ;
	
	<sem>{
		X:Y(Z)
		}
}

class three [P1,P2]
export T
declare T
{
	<morph>{
		gen=P1|
		gen=P2;
		T="able"
		}
}

class two 
import one[] as [X=R]
declare Y Z P1 P2
{
      Y=three[P1,P2];
      Y.T=Z;	
      <morph>{
	num=s;
	{  field3 <- "remarqu" |
	   field3 <- "consider" }
	   ; field4 <- Z  
	}
     ;
     <morph>{
       field3 <- "remarqu";
       P1 = m;
       P2 = f
       }
}	

class four
declare A B C D
{
	% <syn>{
	% 	node A [cat=s];
	% 	node B [cat=n];
	% 	node C ;
	% 	{ B -> A; A >>* C}
	% 	}
	<syn>{
		node A [cat= [cat =s]]{
		%node A [cat=s]{
		     ...+ node [cat=@{n,v}]{
		     	       node D
			}	  
		      ,,,
		     node C
		     } 
		}
}

class five
declare X A
{
	<pg>{
		X = [cat = v , gen = m];
		X : A !;
		X : -!- A;
		X : A < A;
		X : A => id;
		X : A <=!> id;
		X : A	
		}
}

value one
value two
value four
%value five