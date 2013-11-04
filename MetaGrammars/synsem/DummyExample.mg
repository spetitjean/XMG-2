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
}

value dummy