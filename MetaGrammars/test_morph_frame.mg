type CAT = {vp,v,np,s,pp}
type MARK = {anchor}
type PREP = {to}
type VAR = [1..9]  
type VALTYPE = {event,activity,motion,causation,motion-activity,locomotion,onset-causation,extended-causation,locomotion-activity,directed-motion,direct-motion-activity}

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

class test
declare ?S1 ?S2 ?S3 ?S4 ?ROOT ?RECIPIENT ?RECIPIENTVAR ?RECIPIENT2 ?ROOTVAR ?TEST
{
<morph>{
	morpheme ?S3;
	morpheme ?S1;
	morpheme ?S4;
	morpheme ?S2;

	?S2 <- "ground";
	?S4 <- "ly";
	?S1 <- "under";
	?S3 <- "ing";
	
	?S1 >> ?S2;
	?S3 >> ?S4;
	?S2 >> ?S3
}	;
<frame>{
	node ?TEST (ftype=direct-motion-activity);
	node ?ROOT (ftype=activity,var=?ROOTVAR){
	     	(label=theme)   node ?RECIPIENT (var=?RECIPIENTVAR)
		(label=motion)   node ?RECIPIENT2
		}		

	     
	}
	;
	?TEST=?ROOT
}

value test