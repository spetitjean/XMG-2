%%
%% MG: frame constraints for selected event types
%% Author: Laura Kallmeyer
%% 
%% The following is a definition of the frames from Kallmeyer & Osswald 2013.
%% Only general frame constraints are used.
%% For instance the fact that an activity is an event and has an actor 
%% attribute is formulated as frame constraints 
%%
%%    activity -> event,
%%    activity -> agent: +,
%%
%% and not as a frame description of a specific XMG class.
%%
%% XMG classes are defined only for checking, i.e., a class activityFrame
%% is defined as having a frame of type activity. Its valuation checks 
%% whether the constraints work the way they are supposed to work


frame-types = {causation, activity, event, punctual_event, onset_causation,extended_causation, motion, caused_motion, locomotion, translocation, change_of_state, change_of_possession, possession, 
               entity, state, john, house, walking, path}

frame-constraints = {

%% Type hierarchy (partial)

%% Subtypes of events and their attributes:

    activity -> event,
    activity -> agent: +,

    causation -> event,
    causation -> cause:event,
    causation -> effect:event,

    motion -> event,
    motion -> mover:+,

    change_of_state -> event,
    change_of_state -> result:state,
    change_of_state -> patient=result.patient,

    change_of_possession -> event,
    change_of_possession -> theme:+,
    change_of_possession -> recipient:+,
    change_of_possession -> result:possession,
    change_of_possession -> recipient=result.possessor,
    change_of_possession -> theme=result.possessed,

    % explicit compatibility of subtypes 
    activity motion <-> locomotion,
    locomotion -> agent=mover,    

    % incompatibilities between these subtypes:
    activity causation -> -,
    motion causation -> -,

%% Subtypes of causation and their attributes:
    caused_motion -> causation,
    caused_motion -> effect:motion,

    onset_causation -> causation,
    onset_causation -> cause:punctual_event,

    extended_causation -> causation,

%% Subtypes of motion
    translocation -> motion,
    translocation -> path:path,

    path -> region:+,

%% Subtypes of state
    possession -> state,
    possession -> possessor:+,
    possession -> possessed:+,

%% relations between attributes:
    % an agent is always an effector
    agent: + -> agent=effector,
    % constraints for lifting semantic roles:
    cause.effector:+ -> cause.effector=effector,
    effect.patient:+ -> effect.patient=patient,

%% some non-event types:
    john -> entity,
    house -> entity,
    entity event -> -

    }

% the following classes are for testing:

class causationFrame
{
<frame>{[causation]
	}
}

class activityFrame
{
<frame>{[activity]
	}
}

class motionFrame
{
<frame>{[motion]
	}
}

class caused_motionFrame
{
<frame>{[caused_motion]
	}
}

class locomotionFrame
{
<frame>{[locomotion]
	}
}

class change_of_stateFrame
{
<frame>{[change_of_state]
	}
}

class change_of_possessionFrame
{
<frame>{[change_of_possession]
	}
}

class translocationFrame
{
<frame>{[translocation]
	}
}

class onset_causationFrame
{
<frame>{[onset_causation]
	}
}

value caused_motionFrame
value onset_causationFrame
value translocationFrame
value locomotionFrame
value change_of_stateFrame
value change_of_possessionFrame
value causationFrame
value activityFrame
value motionFrame