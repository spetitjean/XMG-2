%------------------
%  Testing dots to access values of attributes of AVMs
%        or variables in export vectors   
%------------------
 
%type declarations:

type CAT={n,np,v,vn,s,vs,p}
type NUMBER={sg,pl}

%feature declarations

feature cat : CAT
feature num  : NUMBER


%class definitions:

class A
export ?Feats
declare ?Feats
{
  ?Feats=[cat=v, num=pl]
}

class B
declare ?V ?Feats ?Cat 
{
  ?V=A[];
  ?V.?Feats.cat = ?Cat;
  %% ?V.?Feats = ?Feats;
  %% ?Feats.cat = ?Cat;
  <syn>{
    node  [cat = ?Cat]
  }
}

value B


