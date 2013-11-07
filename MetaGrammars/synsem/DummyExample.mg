class dummy
declare ?X ?Y ?Z
{
  <syn>{
	node ?X [cat=s];
	node ?Y [cat=n];
	node ?Z [cat=v];
	?X -> ?Y;
	?X -> ?Z
  }
  |
  
  {<syn>{
	node ?X [cat=s];
	node ?Y [cat=n];
	?X ->+ ?Y
	} 
	;
	dummier[]
 }
}

class dummier
declare ?T
{
	<syn>{
		node ?T (color=blue) [cat=whatever]
		}
}

value dummy