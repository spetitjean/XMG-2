% Dreaming ...
% The frames are taken from Fig. 32 in  Kallmeyer,Osswald(to appear)
 
type CAT = {vp,v,np,s,pp}
type MARK = {anchor}
type PREP = {to}
type VAR = [1..9]  
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
property ftype:VALTYPE
property label:EDGELABEL
property mark:MARK

feature cat:CAT
feature i:VAR
feature e:VAR
feature prep:PREP
feature path:VAR



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class Subj
export ?ROOT ?ROOTVAR ?ACTOR ?ACTORVAR ?V
declare ?ROOT ?ROOTVAR ?ACTOR ?ACTORVAR ?V ?N1 ?N2 ?N3
{ 
  <syn> {
  	node ?N1 [cat=s] {
	     node ?N2 [cat=np,i=?ACTORVAR]
	     node ?N3 [cat=vp] {
	     	  ...node ?V (mark=anchor) [cat=v,e=?ROOTVAR]
	     }
	}
  };
  <frame> {
	node ?ROOT (var=?ROOTVAR,ftype=event);  %% is it ok with the name before the properties, as in <syn> ?
	node ?ACTOR (var=?ACTORVAR);

	edge (label=actor) ?ROOT ?ACTOR
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class VSpine
export ?V
declare ?V ?N1
{
  <syn> {
  	node ?N1 [cat=vp] {
	     node ?V (mark=anchor) [cat=v]
	}
  }
  % <frame>{  
  % }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class DirObj
export ?ROOT ?ROOTVAR ?GOALTHEME ?GOALTHEMEVAR ?V
declare ?ROOT ?ROOTVAR ?GOALTHEME ?GOALTHEMEVAR ?V ?N1 ?N2
{
  <syn>{
	node ?N1 [cat=vp] {
	     node ?V (mark=anchor) [cat=v,e=?GOALTHEMEVAR]
	     ,,, node ?N2 [cat=np,i=?GOALTHEMEVAR] %% surprisingly, large precedence is written ,,, and not ,,,*
	}
  };
  <frame>{
	node ?ROOT (var=?ROOTVAR,ftype=event);
	node ?GOALTHEME (var=?GOALTHEMEVAR);

	%%edge (label=@{goal, theme}) ?ROOT ?GOALTHEME
	       {
	       edge (label=goal) ?ROOT ?GOALTHEME 
	       |
	       edge (label=theme) ?ROOT ?GOALTHEME
	       }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class n0V
import Subj[] VSpine[]
export ?V ?ROOT ?ROOTVAR ?ACTOR ?ACTORVAR 
%{
 % ... can I write it like this? 
 % I think so, you might even omit the brackets
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class n0Vn1
import n0V[]
export ?V ?ROOT ?ROOTVAR ?ACTOR ?ACTORVAR 
declare ?DO
{
  ?DO = DirObj[];	
  ?DO.?V = ?V;
  ?DO.?ROOT = ?ROOT	% redundant, should already follow from the identification of ?V-nodes!
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%value n0Vn1
%value n0V