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
	<syn>{
		node X [cat=one]
		}
}

class two
export X
declare X Y Z
{
	<syn>{
		node X [cat=two]
		}
}

class three
export X
declare X Y Z
{
	<syn>{
		node X[cat = three]
		}
}



class four
declare A B C D
{
	one[]
	|
	two[]
	|
	three[]
	
}



%value one
%value two
value four
%value five