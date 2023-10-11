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

%% standard uses of dots:
%% * access variable in export vector
%% * access value of (existing) attribute in FS 
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

%% non standard uses of dots:
%% * access non existing variable in export vector
%% * access value of non existing attribute in FS 
class C
declare ?V ?Feats ?OtherFeats ?Cat ?Cot
{
  ?V=A[];
  ?V.?Feats = ?Feats;
  %% this raises a type error: good
  %% ?V.?OtherFeats = ?OtherFeats;
  
  ?Feats.cat = ?Cat;
  ?Feats.cot = ?Cat;
  <syn>{
    %%node  [cat = ?Cat]
    node feats ?Feats
  }
}



value B
value C

