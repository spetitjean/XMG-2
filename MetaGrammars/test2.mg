feature cat

field field1
field field2

class something
export X
declare X Y Z
{
      <morph>{
	cat = adj;
	X="é";
	field1 <- X;
	{ field2 <- "pique" | field2 <- "norme" }
	} 
}

class something_else 
import something
{
      <morph>{
	cat=adj;
	{  field1 <- "remarqu" |
	   field1 <- "consider" } ;
	field2 <- "able"  
	}
     ;
     <morph>{
       cat=adj;
       field1 <- "remarqu"
       }
}	

value something
value something_else