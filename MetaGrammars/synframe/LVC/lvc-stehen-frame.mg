include types.mg

class Explosion
declare ?X1 ?X3
{
  <frame>{
    ?X1[change_of_state,
	result_state:[broken],
	theme:?X3
	]
  };
  <iface>{[i=?X1, theme=?X3]}
}

class Haus
declare ?X1 ?X2 ?X3 ?X4
{
  <frame>{
    ?X1[haus,
	inregion: ?X2,
	atregion: ?X3,
	preregion:?X4
	]
  };
  <iface>{[i=?X1]}
}

class Kessel
declare ?X1 
{
  <frame>{
    ?X1[boiler]
  };
  <iface>{[i=?X1]}
}

class vor
declare ?X1 ?X2 ?X3 ?X4 ?X5
{
  <frame>{
    ?X2[preregion:?X3];
    ?X5[ground:?X2]
    ;
    part-of(?X1,?X3)
  };
  <iface>{[i=?X1, inp=?X2, theme=?X4, e=?X5]}
}

class stehen
declare ?X0 ?X1 
{
  <frame>{
    ?X0[non_loc_state,
	theme:?X1]
    |
    ?X0[loc_state,
	theme:?X1]
    |
    ?X0[loc_state & posture_state,
        theme:?X1, posture:upright]
  };
  <iface>{[i=?X1, e=?X0]}  
}

class Hans
declare ?X1
{
  <frame>{
    ?X1[person,
	name: hans
	]
  };
  <iface>{[i=?X1]}
}

class der

class Fertigstellung
declare ?X1 ?X3 ?X4 ?X5
{
  <frame>{
    ?X1[completion,
	result_state:[completed,
	              theme:?X3],
	theme:?X3,
	actor:?X4
	]
  }
  ;
  <iface>{[i=?X1, theme=?X5]}
}

class Umgehungsstraße
declare ?X1 
{
  <frame>{
    ?X1[street]
  };
  <iface>{[i=?X1]}
}

class Gemeinde
declare ?X1 
{
  <frame>{
    ?X1[local_authority]
  };
  <iface>{[i=?X1]}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EVALUATION:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value Explosion
value Haus
value vor
value stehen
value Hans
value der
value Kessel
value Fertigstellung
value Gemeinde
value Umgehungsstraße
