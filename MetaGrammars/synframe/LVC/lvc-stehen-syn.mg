include types.mg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% subject-PP construction
class n0-pp
export ?V ?N0 ?PP ?X0
declare ?V ?N0 ?PP ?X0 ?X1 
{
  <syn>{
    node [cat=s, e=?X0]{
      node ?N0 (mark=subst) [cat=np, i=?X1]
      node [cat=vp, e=?X0]{
        node ?V (mark=anchor) [cat=v, e=?X0]
	node ?PP (mark=subst)[cat=pp, theme=?X1, e=?X0]
      }
    }
  };
  <iface>{[i=?X1, e=?X0]}
}

% subject-locative PP construction
% (1) er wohnt in Mannheim
% (2) sie liegt unter dem Tisch
% (3) er steht auf der Brücke
% ...
class n0-pp-loc
import n0-pp[]
declare ?X2 ?X3
{
  <syn>{
    node ?PP [i=?X2]
  }
  ;
  <frame>{?X0[loc_state, location:?X2]}
}

% light verb construction with subject and PP
% (1) der Kessel steht vor der Explosion
% (2) die Firma steht vor dem Ruin
% ...
class n0-pp-lvc
import n0-pp[]
{
  <syn>{
    node ?PP [i=?X0, e=?X0]
  }
  ;
  <frame>{?X0[non_loc_state]}
}


% Simple PP
% (1) vor der Explosion
% (2) vor dem Haus
% ...
class pp
export ?PP ?N1
declare ?PP ?N1 ?X1 ?X2 ?X3 ?X4 ?X5
{
  <syn>{
    node ?PP [cat=pp, i=?X1, theme=?X4, e=?X5]{
      node (mark=anchor)[cat=p]
      node ?N1 (mark=subst)[cat=np, i=?X2, theme=?X4]
    }
  };
  <iface>{[i=?X1, inp=?X2, theme=?X4, e=?X5]}
}

% simple NP
% (1) Hans
% (2) Haus
% ...
class np
export ?N1 ?N2 ?X1
declare ?N1 ?N2 ?X1 ?X3
{
  <syn>{
    node ?N1 [cat=np, i=?X1]{
      node ?N2 (mark=anchor)[cat=n]
    }
  }
  ;
  <iface>{[i=?X1]}
}


% NP describing an event
% (1) Explosion
% ...
class np-event
import np[]
export X3
declare ?X3
{
  <syn>{
	node ?N1 [theme=?X3]
	}
  ;
  <iface>{[theme=?X3]}
}

% NP with second NP in genitive
% (1) Fertigstellung der Umgehungsstraße
class np-np
import np[]
declare ?X4 ?N3 ?X6 ?X7
{
  <syn>{
	node ?N1 [theme=?X7];
	node ?N3 (mark=subst)[cat=np, i=?X4];
	?N2 >> ?N3
	}
  ;
  <frame>{
  ?X1[accomplishment,
      prestate:?X6[state, theme:?X7],
      preregion:?X6,
      theme:?X4,
      actor:?X7]
  };
  <iface>{[theme=?X7]}
}

% NP with PP
% (1) Fertigstellung durch der Gemeinde
class np-pp
import np[]
declare ?X4 ?X5 ?N3 ?X6 
{
  <syn>{
	node ?N1 [theme=?X5];
	node ?N3 (mark=subst)[cat=pp]{
	  node (mark=coanchor, name=PPNode) [cat=p]
	  node (mark=subst) [cat=np, i=?X4]};
	?N2 >> ?N3
	}
  ;
  <frame>{
    ?X1[accomplishment,
        prestate:?X6[state,theme:?X5],
	preregion:?X6,
	actor:?X4,
	theme:?X5]
  };
  <iface>{[theme=?X5]}
}

class np-accomplishment
{
  np-pp[] | np-np[]
}

% determiner
% (1) der Explosion
% (2) dem Haus
% ...
class det
{
  <syn>{
    node [cat=np]{
      node (mark=anchor) [cat=det]
      node (mark=foot) [cat=np]
    }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EVALUATION:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value n0-pp-loc
value n0-pp-lvc
value pp
value np
value np-event
value np-accomplishment
value det
