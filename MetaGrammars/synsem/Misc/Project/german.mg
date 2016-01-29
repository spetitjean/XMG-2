type MARK = {subst, nadj, foot, anchor, coanchor, flex}
type CAT = {np,n,v,vp,s,pp,p}
type PHON = {e}
type LABEL!

property mark : MARK

feature cat : CAT
feature phon : PHON
feature top: LABEL
feature bot: LABEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREE FRAGMENTS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREE TEMPLATES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREE FAMILIES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EVALUATION:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% value UnaryNoun
% value ProperNoun
% value NounPred
% value Noun
% value DetQuantifier
% value DetDef
% value Vnp1
% value V-inf
% value Vnp2
% value Vnp1-inf
% value Vnp3
% value Vnp2-inf
% value Vnp1s1
% value Vnp2s1
% ...