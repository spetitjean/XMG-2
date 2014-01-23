%% a metagrammar example inspired by the "Syntax-Driven Semantic Frame Composition in Lexicalized Tree Adjoining Grammars" article, by Laura Kallmeyer and Rainer Osswald

ftype event
ftype activity
ftype motion
ftype causation
ftype translocation
ftype onset-causation
ftype extended-causation
ftype locomotion
ftype bounded-translocation
ftype bounded-locomotion
ftype walking
ftype path
ftype person
ftype john

%% event is the only root
fconstraint activity -> event 
fconstraint motion -> event 
fconstraint causation -> event

%% causation is incompatible with motion and activity
fconstraint motion, causation -> false
fconstraint causation, activity -> false

%% left part of the hierarchy
fconstraint translocation -> motion
fconstraint locomotion <-> activity, translocation
fconstraint bounded-translocation -> translocation
fconstraint bounded-locomotion <-> locomotion, bounded-translocation
fconstraint walking -> bounded-locomotion

%% right part of the hierarchy
fconstraint onset-causation -> causation
fconstraint extended-causation -> causation
fconstraint onset-causation, extended-causation -> false

%% attribute and path constraints

%% left side
fconstraint activity -> actor : true
fconstraint motion -> mover : true
fconstraint activity, motion -> actor = mover
fconstraint bounded-translocation -> goal = true

%% right side
fconstraint causation -> cause : true
fconstraint causation -> effect : true
fconstraint onset-causation -> cause : true %% cause should be of type punctual-event

fconstraint path, event -> false
fconstraint person, path -> false
fconstraint person, event -> false

fconstraint john -> person

class Test
declare ?F1 ?F2 ?F3 ?X1 ?X2 ?V
{
	<frame>{
		?F1 (locomotion 
		    	   actor:?X1 
		    	   mover:?X2 
			   path: ( path )
				
			   manner: ( walking )
					
				 
			);
		?F2 (translocation
			   path:(
				path
					region: ?V
				)
			);
		?F3 (person
			name:(
				john
				)
			)
		
	}
	;
	?F1=?F2;
	?X1=?F3
}

value Test