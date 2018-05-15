%% A minimal example for a TAG grammar with frame semantics 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HEADERS: declaration of all types used in the metagrammar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Type declarations
%% For types CAT and MARK, we enumerate the values (syntactic categories and types of nodes in TAG)
type CAT = {s,vp,np,v}
type MARK = {subst, anchor, foot}
%% LABEL is a type for which we don't specify the possible values (values will be feature structures)
type LABEL !

%% Feature declarations
%% They will be attached to nodes (square brackets)
%% The feature cat, of type CAT, is the syntactic category of a node
%% The features e (event) and i (individual), of type LABEL, contain semantic information specific to the node
feature cat : CAT
feature e : LABEL
feature i : LABEL

%% Properties declarations
%% They will be attached to nodes (parentheses)
%% The property mark, of type MARK, is the type of a node (substitution, etc)
property mark : MARK

%% Type declarations and type constraints

%% Type declarations: 3 atomic types
frame-types = {event, activity, sleep}

%% Type constraints: 2 subsumption constraints (all frames of type
%% activity are also of type event, all frames of type sleep are also
%% of type activity)
frame-constraints = {activity -> event, sleep -> activity}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLASSES: description of the structures (trees + frames)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% A simple class for the intransitive verb sleep (with canonical subject)
class sleep
declare ?X0 ?X1
{
  <syn>{
    node[cat=s, e=?X0]{
      node (mark=subst) [cat=np, i=?X1]
      node [cat=vp, e=?X0]{
      	   node (mark=anchor) [cat=v, e=?X0]
	   }
      }
  };
  <frame>{
    ?X0[sleep,
        actor:?X1]
  }
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VALUATIONS: the axioms of the metagrammar
%%   -> classes for which we compute the models
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value sleep