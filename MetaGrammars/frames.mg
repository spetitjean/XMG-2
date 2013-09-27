% Dreaming ...
% The frames are taken from Fig. 32 in  Kallmeyer,Osswald(to appear)
 
type VAR = [1..n]
type VALTYPE = {event,activity,motion,causation,motion-activity,locomotion,onset-causation,extended-causation,locomotion-activity,directed-motion,direct-motion-activity}
type EDGELABEL = {cause,effect,actor,theme,goal,path}

hierarchy VALTYPE = {(event,activity),(event,motion),(event,causation),
		       (activity,motion-activity),
		       (motion,motion-activity),(motion,locomotion),
		       (causation,onset-causation),(causation,extended-causation),
		         (motion-activity,locomotion-activity),
		    	 (locomotion,locomotion-activity),
		    	 (locomotion,directed-motion),
		           (locomotion-activity,direct-motion-activity),
		      	   (direct-motion,direct-motion-activity)} 

property var:VAR
property type:VALTYPE
property label:EDGELABEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class causation
export ?ROOT ?ROOTVAR ?CAUSE ?EFFECT
declare ?ROOT ?ROOTVAR ?CAUSE ?EFFECT
{ 
  <frame> {
	node (var=?ROOTVAR,type=causation) ?ROOT;
	node (type=event) ?CAUSE;
	node (type=event) ?EFFECT;

	edge (label=cause) ?ROOT ?CAUSE;
	edge (label=effect) ?ROOT ?EFFECT
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class directed-motion
export ?ROOTVAR ?ROOT ?GOAL ?GOALVAR ?PATH ?PATHVAR
declare ?ROOTVAR ?ROOT ?GOAL ?GOALVAR ?PATH ?PATHVAR
{
  <frame>{
	node (var=?ROOTVAR,type=directed-motion) ?ROOT;
	node (var=?GOALVAR) ?GOAL;
	node (var=?PATHVAR) ?PATH;

	edge (label=goal) ?ROOT ?GOAL;
	edge (label=path) ?ROOT ?GOAL
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class activity
export ?ROOT ?ROOTVAR ?ACTOR ?ACTORVAR
declare ?ROOT ?ROOTVAR ?ACTOR ?ACTORVAR
{
  <frame>{
	node (var=?ACTORVAR) ?ACTOR;
	node (var=?ROOTVAR,type=activity) ?ROOT;

	edge (label=actor) ?ROOT ?ACTOR
  }
}

class activity-alternative		% with bracket notation 
export ?ROOT ?ROOTVAR ?ACTORVAR
declare ?ROOT ?ROOTVAR ?ACTORVAR
{
  <frame>{
	node (var=?ROOTVAR,type=activity) ?ROOT {
	     node (var=?ACTORVAR)
	}(label=actor)
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class n0Vn1pp
import causation[]
export ?DIRMOTION ?THEME ?THEMEVAR ?GOAL ?GOALVAR ?ACTOR ?ACTORVAR ?ACTIVITY
declare ?DIRMOTION ?THEME ?THEMEVAR ?GOAL ?GOALVAR ?ACTOR ?ACTORVAR ?ACTIVITY
{
  ?DIRMOTION = directed-motion[];
  ?DIRMOTION.?GOALVAR = ?GOALVAR;
  ?DIRMOTION.?THEMEVAR = ?THEMEVAR;

  ?ACTIVITY = activity[];
  ?ACTIVITY.?ACTORVAR = ?ACTORVAR

  <frame> {
	node (type=activity) ?DIRMOTION.?ROOT;
	node (var=?GOALVAR) ?GOAL;
	node (var=?ACTORVAR) ?ACTOR;

	edge (label=goal) ?ROOT ?GOAL;
	edge (label=actor) ?ROOT ?ACTOR;
	edge (label=effect) ?ROOT ?DIRMOTION.?ROOT
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value n0Vn1pp