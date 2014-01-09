include frames-n0Vn1.mg		% ok? -> would be ok without the values at the end of frames-n0Vn1.mg.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class IndirObj 
export ?V ?ROOT ?ROOTVAR ?RECIPIENT ?RECIPIENTVAR
declare ?V ?ROOT ?ROOTVAR ?RECIPIENT ?RECIPIENTVAR ?N1 ?N2 ?N3
{ <syn>{
	node ?N1 [cat=vp] {
	     node ?V (mark=anchor) [cat=v]
	     node ?N3 [cat=np,i=?RECIPIENTVAR] 
	}
  };
  <frame>{
	node ?ROOT (ftype=change-of-poss,var=?ROOTVAR) ;
	node ?RECIPIENT (var=?RECIPIENTVAR) ;

	edge (label=recipient) ?ROOT ?RECIPIENT
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class DirPrepObj-to
export ?V ?ROOT ?ROOTVAR ?GOAL ?GOALVAR ?PATH ?PATHVAR
declare ?V ?ROOT ?ROOTVAR ?GOAL ?GOALVAR ?PATH ?PATHVAR ?N1 ?N2 ?N3
{ <syn>{
  	node ?N1 [cat=s] {
  	     node ?N2 [cat=vp,path=?PATHVAR] {
  	     	  node ?V (mark=anchor) [cat=v]
  	     }
  	     ,,, node ?N3 [cat=pp,i=?GOALVAR,e=?ROOTVAR,prep=to]
  	}
  };
  <frame>{
	node ?ROOT (ftype=directed-motion,var=?ROOTVAR) ;
	node ?GOAL (car=?GOALVAR) ;
	node ?PATH (var=?PATHVAR) ;

	edge (label=goal) ?ROOT ?GOAL;
	edge (label=path) ?ROOT ?PATH
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class DOPOConstr
import n0Vn1[]
declare ?THEME ?THEMEVAR ?GOAL ?GOALVAR ?CAUSE ?EFFECT ?EFFECTVAR ?INDIR ?PP ?CAUSEACTOR ?EFFECTTHEME
{
 {	
  {
	?INDIR = IndirObj[];
   	?INDIR.?V = ?V;
   	?INDIR.?ROOT = ?EFFECT;
   	?INDIR.?RECIPIENTVAR = ?GOALVAR
  }
  |
  {
	?PP = DirPrepObj-to[];
  	?PP.?V = ?V;
  	?PP.?ROOT = ?EFFECT
	%%;
  	%%?PP.?GOALVAR = ?GOALVAR
  }
 }
  ;
  <frame> {
  	  node ?ROOT  (ftype=causation,var=?ROOTVAR);
	  node ?THEME (var=?THEMEVAR);
	  node ?GOAL (var=?GOALVAR);
	  node ?CAUSE (ftype=activity);
	  node ?EFFECT (var=?EFFECTVAR);
	  node ?CAUSEACTOR (var=?ACTORVAR);	% ?ACTORVAR is inherited from n0Vn1
	  node ?EFFECTTHEME (var=?THEMEVAR);
	  
	  edge (label=theme) ?ROOT ?THEME;
	  edge (label=goal) ?ROOT ?GOAL;
	  edge (label=cause) ?ROOT ?CAUSE;
	  edge (label=effect) ?ROOT ?EFFECT;
	  
	  edge (label=actor) ?CAUSE ?CAUSEACTOR;
	  edge (label=theme) ?EFFECT ?EFFECTTHEME
  }	
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value DOPOConstr