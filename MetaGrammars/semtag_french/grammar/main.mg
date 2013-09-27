include header.mg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Semantic classes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include semantics.mg
%%%%%%%%%%%%%%%%%%%%%
%%  Syntactic classes
%%%%%%%%%%%%%%%%%%%%%
include PredArgs.mg
include predicativeForms.mg
include verbs.mg
include adjectives.mg
include dummies.mg 

include nominals.mg
include nominalPredicates.mg
include defectiveVerbs.mg

include adverbs.mg
include determiners.mg
include misc.mg

include punctuation.mg
%include predicatives.mg
%%%%%%%%%%%%%%%%%%%%%%%%
%% Leaf class valuations
%%%%%%%%%%%%%%%%%%%%%%%%%
%include mrs-test-valuations.mg
%include adjectivevaluations.mg
%include nominalvaluation.mg
%include nominalpredicatevaluations.mg
%include defectiveverbvaluations.mg
%include adverbvaluations.mg

%include determinervaluations.mg
%include miscvaluations.mg
%%%%%%%%%%%%%%%%%%%%%
%%  Dummy classes
%%%%%%%%%%%%%%%%%%%%%
%include selectionClasses.mg

%% Semantics (test)

%value unaryRel

%% Dummies

value dummyClitic
value dummyAdv
value dummyAdjective
value dummyNoun
value dummyBe

%% Nominals
value CliticT
value propername
value noun
value pronoun
value nounPredicate
value indefQuantifier
value n0vNPredicative

%% Determiners
value detQuantifier
value pureDeterminer
value DetAdj
value detNegQuantifier
value complexNDeDeterminersg
value complexAdvDeDeterminer
value complexDeterminer
value stddeterminer
value possDeterminer

%% Auxiliaries
value AvoirAux
value EtreAux
value SemiAux
value copulaBe

%% Adjectives
value EpithAnte
value EpithPost
value n0vAPredicative
value n0vParticipialPredicative
value adjective

%% Coordination
value NominalCoord

%% Prepositions
value nPreposition
value npPreposition
value vpPreposition

%% Adverbs
value advAdjAnte
value advVPost
value advVPPost

%% Verbs
%value ilV
value n0V
% value n0ClV
% value n0ClVn1
value n0ClVan1
% value n0ClVden1
% value n0ClVpn1
value n0Vn1
value n0Van1
value n0Vden1
value n0Vpn1
% value n0Vloc1
% value ilVcs1
value n0Vcs1
% value n0Vas1
% value n0Vdes1
% value n0Vn1Adj2
% value s0Vn1
value n0Vs1int
% value n0Vn1n2
 value n0Vn1an2
% value ilvAcs1
% value n0vAcs1

%Question words
value estceque
value estcequeVP
value InvertedSubjClitic
value whdeterminer
value whSubjectPronoun
value whNonSubjectPronoun
value whSubjectClitic
value nestcepas

%Punctuation
value questionmark
