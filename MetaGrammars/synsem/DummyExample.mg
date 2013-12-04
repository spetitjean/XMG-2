class dummier
%%import dummy[]
declare ?T ?C
{
	?C=dummy[];
	<syn>{
		node ?T (color=blue) %%[cat=whatever]
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