% This is a version that can be parsed by the XMG extension. It will get better (hopefully)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% What can not be done (yet) is : 

% * defining a range type with a variable in it

% * Using type as an identifier (reserved keyword)

% * using '?' in feature structures. In fact, the use of '?' inside the classes is quite useless, except if you have a variable and a constant in the scope sharing the same name (which looks dangerous anyway)

% * up to now, the code of the <frame> dimension is only parsed, the rest of the compiling steps are coming as fast as they can
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%type VAR = [1..n]
type VAR = [1..9]

type VALTYPE = {event,activity,motion,causation,motion-activity,locomotion,onset-causation,extended-causation,locomotion-activity,directed-motion,direct-motion-activity}
type EDGELABEL = {cause,effect,actor,theme,goal,path}

% hierarchy VALTYPE = {(event,activity),(event,motion),(event,causation),
% 		       (activity,motion-activity),
% 		       (motion,motion-activity),(motion,locomotion),
% 		       (causation,onset-causation),(causation,extended-causation),
% 		         (motion-activity,locomotion-activity),
% 		    	 (locomotion,locomotion-activity),
% 		    	 (locomotion,directed-motion),
% 		           (locomotion-activity,direct-motion-activity),
% 		      	   (direct-motion,direct-motion-activity)} 

property var:VAR
property ptype:VALTYPE
property label:EDGELABEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class causation
export ?ROOT ?ROOTVAR ?CAUSE ?EFFECT
declare ?ROOT ?ROOTVAR ?CAUSE ?EFFECT
{ 
  <frame> {
	node ?ROOT (var=ROOTVAR,ptype=causation);
	node ?CAUSE (ptype=event);
	node ?EFFECT (ptype=event);

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
	node ?ROOT (var=ROOTVAR,ptype=directed-motion);
	node ?GOAL (var=GOALVAR);
	node ?PATH (var=PATHVAR);

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
	node ?ACTOR (var=ACTORVAR);
	node ?ROOT (var=ROOTVAR,ptype=activity);

	edge (label=actor) ?ROOT ?ACTOR
  }
}

% class activity-alternative		% with bracket notation 
% export ?ROOT ?ROOTVAR ?ACTORVAR
% declare ?ROOT ?ROOTVAR ?ACTORVAR
% {
%   <frame>{
% 	node (var=?ROOTVAR,ptype=activity) ?ROOT {
% 	     node (var=?ACTORVAR)
% 	}(label=actor)
%   }
% }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class n0Vn1pp
import causation[]
export ?DIRMOTION ?THEME ?THEMEVAR ?GOAL ?GOALVAR ?ACTOR ?ACTORVAR ?ACTIVITY
declare ?DIRMOTION ?THEME ?THEMEVAR ?DIRROOT ?GOAL ?GOALVAR ?ACTOR ?ACTORVAR ?ACTIVITY
{
  ?DIRMOTION = directed-motion[];
  ?DIRMOTION.?GOALVAR = ?GOALVAR;
  ?DIRMOTION.?PATHVAR = ?THEMEVAR;

  ?ACTIVITY = activity[];
  ?ACTIVITY.?ACTORVAR = ?ACTORVAR;

  ?DIRMOTION.?ROOT = ?DIRROOT;

  <frame> {
	node ?DIRROOT (ptype=activity);
	node ?GOAL (var=GOALVAR);
	node ?ACTOR (var=ACTORVAR);

	edge (label=goal) ?ROOT ?GOAL;
	edge (label=actor) ?ROOT ?ACTOR;
	edge (label=effect) ?ROOT ?DIRROOT
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value causation
value directed-motion
value activity
value n0Vn1pp