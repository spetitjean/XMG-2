frame-types = {region, spatial_region, location, temporal_region, state, ruined_state, broken, completed, loc_state, non_loc_state, posture_state, object, haus, change_of_state, person, hans, boiler, street, local_authority, upright, completion, accomplishment}

frame-relations = { part-of(region, region) }

frame-constraints = {
 %% overall syntax: constraint1, constraint2, constraint3, ..., constraint_n

 %% subtype relations:                   
 %% type1 -> type2 signifies that type1 is a subtype of type2
		     		     
		     location -> spatial_region,
		     spatial_region -> region,
		     temporal_region -> region,
		     state -> region,
		     ruined_state -> state,
		     broken -> state,
		     completed -> state,
		     loc_state -> state,
		     non_loc_state -> state,
		     posture_state -> state,
		     haus -> object,
		     street -> object,
		     local_authority -> object,
		     boiler -> object,
		     
                     
 %% frame type incompatibilities:                    
 %% type1 type2 -> - signifies that type1 and type2 are incompatible

		     object region -> -,
		     spatial_region state -> -,
		     temporal_region state -> -,
		     spatial_region temporal_region -> -,
		     change_of_state region -> -,
		     object change_of_state -> -,
		     loc_state non_loc_state -> -,
                     
 %% existence of frame attributes:
 %% type1 -> attr:type2 signifies that if something is of type type1, 
 %% then it necessarily has an attribute attr whose value is of type 2
 %% + is the most general type (T/true), which means just existence, type unspecified

                     state -> theme:+,
                     change_of_state -> theme:+,
                     change_of_state -> initial_state:state,
                     change_of_state -> result_state:state,
                     change_of_state -> prestate:+,
                     change_of_state -> preregion:+,
                     loc_state -> location:location,
                     
 %% reentrencies (identity of attribute values)
 %% type -> path1=path2 where a path is a sequence of attributes separated by "." 
 %% signifies that is something is of type type, then it has outgoing attribute 
 %% paths path1 and path2 that lead to the same node

                     change_of_state -> theme=initial_state.theme,
                     change_of_state -> result_state.theme=theme,
                     change_of_state -> prestate.theme=theme,
                     change_of_state -> prestate=preregion
}

type MARK = {subst, subst, nadj, foot, anchor, coanchor, flex}
type CAT  = {s,np,vp,v,pp,p,det,n, steht, vor, dem, der, Ruin, Explosion, Haus, Hans, Kessel}
type NUM  = {sg,pl}
type PERS = [1..3]
type CASE = {nom,acc}
type PHON = {e}
type AGR  !
type LABEL !
type NAME = {PPNode}

property mark : MARK

feature cat  : CAT
feature phon : PHON
feature pers : PERS
feature num  : NUM
feature agr  : AGR
feature case : CASE
feature i : LABEL
feature ipp : LABEL
feature inp : LABEL
feature e : LABEL
feature theme : LABEL
feature participant : LABEL
feature name : NAME