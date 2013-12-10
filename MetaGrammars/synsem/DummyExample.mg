type COLOR = {red,black,white}
property color : COLOR
use color with () dims (syn) %args (COLOR)

type CAT = {v,n,s}
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
declare ?X ?Y ?Z
{
  <syn>{
	node ?X [cat=@{s,n}];
	node ?Y [cat=n];
	node ?Z [cat=v];
	?X -> ?Y;
	?X -> ?Z;
	?Y >> ?Z
  }
  |
  
  {<syn>{
	node ?X [cat=s];
	node ?Y [cat=n];
	?X ->+ ?Y
	} 
	% ;
	% dummier[]
 }
}



value dummy
value dummier