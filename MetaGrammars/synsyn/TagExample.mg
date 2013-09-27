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

class test
declare ?X1 ?X2 ?X3 ?X4 ?X5
{
<syn1>{node ?X1(color=red); node ?X2(color=red); ?X1 -> ?X2}
;
<syn2>{node ?X3(color=red); node ?X4(color=red); ?X3 -> ?X4}
}

%Simple transitive
value test
