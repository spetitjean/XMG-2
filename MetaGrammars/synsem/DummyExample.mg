type COLOR = {red,black,white}
property color : COLOR
use color with () dims (syn) %args (COLOR)

type CAT = {v,n,s}
type CAT = {t}
%%feature cat : CAT

type node_feats = [|cat:CAT]
type node_props = [color:COLOR]

%%use syn:node with () dims (syn) args (node_props, node_feats)
use syn:node with (node_props, node_feats) dims (syn) 


class dummier
%%import dummy[]
declare ?T ?C
{
	?C=dummy[];
	<syn>{
		node ?T (color=black) %%[cat=whatever]
		}
		;
	?T=?C.?X
}

class dummy
export X Y Z 
declare ?X ?Y ?Z ?T
{
  % <syn>{
  % 	node ?X (color=black) [cat=@{s,n}];
  % 	node ?Y (color=black) [cat=n];
  % 	node ?Z (color=black) [cat=v];
  % 	?X -> ?Y;
  % 	?X -> ?Z;
  % 	?Y >> ?Z
  % }
  % |
  
  {<syn>{
	node ?X (color=black) [cat=s]{ ...+
	     node ?Y (color=black) [cat=n]
	     ,,, 
	     node ?Z (color=black) [cat=v]{
	     	  node ?T (color=black) [cat=v]
		  }
	     
	     	} 
	}
	% ;
	% dummier[]
 }
}



value dummy
value dummier