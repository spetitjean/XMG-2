%------------------
%  Toy MetaGrammar   
%------------------

%principle declarations:

use color with () dims (syn)
use rank with () dims (syn)
use unicity with (extracted) dims (syn)
use unicity with (rank=1) dims (syn)
use unicity with (rank=2) dims (syn)
use unicity with (rank=3) dims (syn)
use unicity with (rank=4) dims (syn)
use unicity with (rank=5) dims (syn)

%type declarations:

type CAT={n,np,v,vn,s,vs,p}
type PERSON=[1..3] 
type GENDER={m,f}
type NUMBER={sg,pl}
type COLOR ={red,black,white} 
type AGR=[cat    : CAT,
	  person : PERSON,
	  test   : bool
]

type LABEL !
type PHON !

type LEXIQUE = {manger}

type MARK  = {subst,nadj,foot,none}
type RANK  = [1..5]


type WH={rel,+,-}



%property declarations:

property color : COLOR 
property mark       : MARK
property extracted  : bool { extraction = + }
property xcomp : bool
property rank       : RANK {
	i_   = 1 ,
	ii_  = 2 ,
	iii_ = 3 ,
	iv_  = 4 ,
	v_   = 5 }

%feature declarations
feature idx : LABEL
feature top : LABEL

feature phon : PHON
feature anch : PHON
feature suj : LABEL
feature obj : LABEL

feature mode : LABEL
feature num  : NUMBER
feature pers : PERSON

%class definitions:

class subjCan 
export S
declare ?W ?N ?M ?S ?NN ?NV
{ <syn>{
	node S (color=white)[cat = s]{
		node NN(color=red,mark=subst)[cat=n,top = [idx=?W,num = ?N, pers=?M]]
		node NV(color=white)[cat = v, top=[num=?N, pers=?M]]
	}
}*=[suj = ?W]
}

class objCan 
export S
declare ?W ?S ?S1 ?NN ?NV
{ <syn>{
	node S{
		node NV(color=white)[cat = v]
	     ,,,node NN(color=red,mark=subst)[cat = n,top=[idx=?W]]
	}
}*=[obj = ?W]
}

class activeMorph 
declare ?M ?N ?X ?NV ?NVV ?NPh
{ <syn>{
	node(color=black)[cat=s]{
		node NV(color=black)[cat=v, bot=[mode=?N]]{
			node NVV(color=black)[cat=v, top=[mode = ?N]]{
				node NPh(color=black)[phon=?X]
			}
		}
	}
}*=[anch=?X]
}

class transitifDirect 
declare 
	?X ?Y
{ 
	X = subjCan[] ; 
	Y = objCan[] ; 
	activeMorph[] ;
	X.S = Y.S
}

class BinaryRel[Pred]
declare !L !E ?X ?Y
{ <sem>{!L:Pred(!E,?X,?Y)}
*= [arg0 = ?X,arg1 = ?Y] }

class lexemeManger 
declare ?X ?Y
{ transitifDirect[]*=[suj=?X,obj=?Y,anch=manger] ; BinaryRel[manger]*=[arg0 =?X,arg1 = ?Y] }

%Simple transitive
value lexemeManger
