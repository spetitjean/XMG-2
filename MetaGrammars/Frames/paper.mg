%% a metagrammar example inspired by the "Syntax-Driven Semantic Frame Composition in Lexicalized Tree Adjoining Grammars" article, by Laura Kallmeyer and Rainer Osswald

type COLOR={red,black,white}
type CAT={s,vp,pp,p,np}

feature color:COLOR
feature cat:CAT

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
%% ?
%% fconstraint causation, activity -> false

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
fconstraint translocation -> path : true
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

class Along
declare 
	%% ?VP ?VPs ?PP ?P ?NP
	?F1 ?F2 ?F3 ?X1 ?X2 ?V
{

	% <syn>{
	% 	node ?VP (color=red)[cat=vp];
	% 	node ?VPs (color=red)[cat=vp];
	% 	node ?PP (color=red)[cat=pp];
	% 	node ?P (color=red)[cat=p];
	% 	node ?NP (color=red)[cat=np];
	% 	?VP -> ?VPs;
	% 	?VP -> ?PP;
	% 	?VPs >> ?PP;
	% 	?PP -> ?P;
	% 	?PP -> ?NP;
	% 	?P >> ?NP

	% };
	<frame>{
		?F1 (locomotion 
		    	   actor:?X1 
		    	   mover:?X1 
			   path: ( path )
				
			   manner: ( walking )
				%% walking should be a subtype of manner, incompatible with event	
				 
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

% class Walked
% declare
% 	?S ?NP ?VP ?V
% 	?F1 ?X1 ?X2
% {
% <syn>{
% 	node ?S (color=red) [cat=s];
% 	node ?NP (color=red) [cat=np];
% 	node ?VP (color=red) [cat=vp];
% 	node ?V (color=red) [cat=v];
% 	?S -> ?NP;
% 	?S -> ?VP;
% 	?NP >> ?VP;
% 	?VP -> ?V
% 	}
% ;
% <frame>{
% 	?F1 (locomotion 
% 		    	   actor:?X1 
% 		    	   mover:?X2 
% 			   path: ( path )
				
% 			   manner: ( walking )
					
				 
% 			)
% 	}
% }

value Along
%%value Walked
%%value WalkedAlong