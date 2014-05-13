type COLOR = {red,black,white}
property color : COLOR
%% use color with () dims (syn) %args (COLOR)

type SynProps = []
type SynFeats = [synNode: <syn:synnode>]
%%type SynFeats = []


use dimtype with (<syn:tree>[SynProps,SynFeats]) dims (syn)

type CAT = {v,n,s,cl}
%%type CAT = {t}

type GEN = {m,f}
type NUM = {sg,pl}

type AGR = [gen:GEN, num:NUM]
%%type AGR = [num:NUM]

type FS = [this : CAT, that : [these: AGR, those : NUM]]

type LABEL !

feature cat : CAT
feature agr : AGR
feature num : NUM
feature gen : GEN

feature extracted : bool
feature color : COLOR
feature arg1 : LABEL
feature arg2 : LABEL

%%feature cat : CAT

%type node_feats = [|cat:CAT]
%type node_props = [color:COLOR]

%%use syn:node with () dims (syn) args (node_props, node_feats)
%% use syn:node with (node_props, node_feats) dims (syn) 


class dummier
%%import dummy[]
declare ?T ?C ?A
{
	?C=dummy[];
	<syn>{
		node ?T (color=black) %[cat=whatever]
		}*=[arg2=?A]
		;
	?T=?C.X
	%%?C.X=?A
}

class dummy
export X Y Z 
declare ?X ?Y ?Z ?T ?L ?C
{
  % <syn>{
  % 	node ?X (color=black) [cat=@{s,n}];
  % 	node ?Y (color=black) [cat=n];
  % 	node ?Z (color=black) [cat=v];
  % 	?X -> ?Y;
  % 	?X -> ?Z;
  % 	?Y >> ?Z
  % }
  % |
  {<syn>{
	node ?X (color=black) [cat=s, extracted= +]{ ...+
	     node ?Y (color=black) [cat=@{n,cl}]
	     ,,, 
	     node ?Z (color=black) [cat=?C, agr=[gen=m,num=sg,cat=s]]{
	     	  node ?T (color=black) [cat=?L]
		  }
	     
	     	} 
	}
	% ;
	% dummier[]
 }
 ;
 <iface>{ 
 		[cat=v,arg1=?L]
 }
}



value dummy
value dummier