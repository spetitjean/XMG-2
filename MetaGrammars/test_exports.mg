%feature cat CAT

%field field1
%field field2

class something
export X
declare X Y Z
{
      <morph>{
	cat = adj
	} 
}

class c
import something_else
export V T
declare V
{
      <morph>{
	cat=adj
       }
}

class d
import c
{
      <morph>{
	cat=adj
       }
}

class something_else 
import something
{
      <morph>{
	cat=adj
       }
}	

value d