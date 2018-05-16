frame-types = {eventuality, initial_eventuality, event, entity, lexeme, derived-lexeme, ment-lexeme, state, activity, experiencer, stimulus, initial_state, result_state, change_of_possession, change_of_state, animate, inanimate, animacy, causation}

frame-constraints = {
    event -> eventuality,
    state -> eventuality,
    state event -> -,
    eventuality entity -> -,

    % initial_eventuality -> eventuality,
    % initial_eventuality initial_state -> -,

    derived-lexeme -> lexeme,
    ment-lexeme -> derived-lexeme,
    lexeme eventuality -> -,
    eventuality entity -> -,
    causation -> event,
    activity -> event,	
    change_of_possession -> event,
    change_of_state -> event,
    causation activity -> -,
    causation change_of_possession -> -,
    causation change_of_state -> -,
    change_of_state change_of_possession -> -,
    experiencer -> entity,
    stimulus -> entity,
    experiencer stimulus -> -,
    initial_state result_state -> -,
    initial_state -> state,
    result_state -> state,
    animate inanimate -> -,
    animate -> animacy,
    inanimate -> animacy,
    animacy eventuality -> -,
    animacy entity -> -,
    entity -> animacy:animacy, 
    animacy lexeme -> -
    }



class rent
export ?X0 
declare ?X0 ?X1 ?X2 ?X3 ?X4 ?X5 ?X6 ?X7
{<frame>{
 ?X0[causation,
       agent: ?X1[entity, animacy:[animate]],
       theme: ?X2,
       recipient: ?X3[entity],
       cause: ?X4[activity,
                   agent:?X1,
		   theme:?X2,
                   recipient:?X3[entity, animacy:[animate]]
			],
       effect: ?X5[change_of_possession,
                  initial-state: ?X6[initial_state, theme:?X2[entity], possessor:?X1],
                  result-state:  ?X7[result_state, theme:?X2[entity], possessor:?X3] ] ]

		  }
	
}
%% Possible readings should be: X0, X7, X2
%% Never X1, X3, X4, X5, X6

%% Still to be ruled out: the cause and the effect readings (event is compatible with activity and change_of_possession)

class renew
export ?X0 
declare ?X0 ?X1 ?X2 ?X3 ?X4 ?X5 ?X6 ?X7
{<frame>{
 ?X0[causation,
       agent: ?X1[entity, animacy:[animate]],
       patient: ?X2,
       instrument: ?X3[entity],
       cause: ?X4[activity,
                   agent:?X1,
		   patient:?X2,
                   instrument:?X3[entity, animacy:[animate]]
			],
       effect: ?X5[change_of_state,
                  initial-state: ?X6[initial_state, patient:?X1],
                  result-state:  ?X7[result_state, patient:?X3] ] ]

		  }
	
}

class al
declare ?Ref ?Base ?X0
{
 {?Base=rent[] | ?Base=renew[]};
 ?X0=?Base.?X0;
 <frame>{
 
 [al-lexeme,
       m-base:[event,
	       sem:?X0]
       ref:?Ref
 ]
       ;
       %% Underspecified with constraints
        ?X0 >* ?Ref;
        {?Ref[result_state]  | ?Ref[causation]  | ?Ref[entity, animacy:[inanimate]]}
       %%{?Ref[initial_eventuality]       | ?Ref[entity, animacy:[inanimate]]}
       %% ---------EVENTUALITY---------  or ------INANIMATE-ENTITY------

       %% Underspecified with no constraint
       %% ?Root >* ?Ref;
       %% {?Ref[eventuality] | ?Ref[entity]  }
       
       %% Fully specified
       %%{?X0=?Ref | ?X2=?Ref | ?X7=?Ref}
  }
	
}

%%% Evaluation:
%value renew
value al

