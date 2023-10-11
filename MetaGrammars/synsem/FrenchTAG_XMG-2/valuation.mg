include header.mg
include PredArgs.mg
include verbes.mg
include adjectifs.mg
include noms.mg
include adverbes.mg
include misc.mg

 
% % VALUATION
% %%%%%%%%%%%%

% %Impersonal
% value ilV		%il pleut
% value ilVcs1		%il faut que Jean vienne/venir

% %Nominal
% value n0V 		%Jean dort
% value n0ClV		%Jean s'évanouit
% value n0Vn1		%Jean regarde Marie
% value n0ClVn1		%L'enfant s'appelle Marie
% value n0Van1		%Jean parle à Marie
% value n0Vden1		%Jean parle de ses vacances
% value n0ClVden1	 	%Jean se souvient de Marc
% value n0Vpn1		%Jean parle avec Marie
% value n0ClVpn1		%Jean se bat contre Paul
% value n0Vloc1		%Jean va à Paris
% value n0Vn1an2		%Jean donne un cadeau à Marie
% value n0Van1den2	%Jean parle de ses vacances à Marie
% value n0Vn1den2		%Jean reçoit un cadeau de Marie
% value n0Vden1pn2	%Jean parle de ce livre avec Marie
% value n0Vn1pn2		%
% value n0Vn1loc2		%Jean envoie la lettre à la poste

% %Sentential
% value s0V		%Qu'il neige en mai arrive parfois
% value s0Vn1		%Que Jean soit parti désole Marie
% value s0Van1		%Que Jean soit parti déplait à Marie
% value s0Vcs1		%Qu'il neige prouve qu'il fait froid
% value n0Vcs1		%Jean pense qu'il a raison
% value n0Vas1		%Jean tient à venir
% value n0Vdes1		%Jean rêve qu'il ira à Barcelone
% value n0Vs1int		%Jean sait si Paul viendra
% value n0Vs1intan2	%Jean demande à Marie si Paul viendra
% value n0Vn1sint2	%Jean 
% value n0Vcs1an2		%Jean dit à Marie qu'il a raison
% value n0Vn1des2		%Jean a convaincu Marie de partir
% value n0Vn1as2		%Jean force Marie à venir
% value n0Vn1cs2		%Jean voit Marie pleurer
% value n0Vcs1des2	%Jean déduit qu'il fait froid de ce qu'il neige ('de ce que' not handled) *FAMILY CORE BUGGED*
% value n0Vdes1den2	%Jean obtient de Marie de venir
% value s0Vn1as2		%Qu'il neige habitue Jean à se couvrir la tête
% value n0Vdes1pn2	%Jean convient avec marie de venir 
% value n0Van1des2	%Jean promet à Marie de venir /qu'il partira
% value n0Vn1Adj2		%Jean trouve Marie jolie

% %Compounds
% value n0Vnbar1		%La réunion a lieu

% % PREDICATIVE ADJECTIVES
% value n0vA		%Jean est heureux, un garçon heureux, un heureux événement
% value s0vA		%Que Marie parte était imprévu, Le départ imprévu
% value n0vAden1		%Le père est fier de sa fille, un père fier de sa fille
% value n0vAan1		%L'enfant est attentif à ce projet, L'enfant attentif à ce projet
% value n0vApn1		%Un enfant fort en maths, L'enfant est fort en maths
% %value n0vAan1pn2	%Un enfant supérieur à Luc en math, Cet enfant est supérieur à Luc en maths
% value n0vAan1den2	%Un ami redevable à Paul de ses conseils, Ce bonhomme est redevable à Paul de ses conseils
% value n0vAdes1		%Jean est capable de venir
% value n0vAdes1pn2	%C'est difficile pour l'entreprise de comprendre

% %NOUNS
% value n0vN		%Jean , La *France*, Jean est un *garçon*
% value n0vNan1		%L'invitation à la négociation
% value n0vNan1den2	%L'invitaton de l'ingénieur à la négociation  
% value n0vNden1		%Marie est la *femme* de Jean; La *femme* de Jean s'appelle Marie
% value n0vNdes1		%L'espoir que la femme vienne
% value n0vNden1des2	%La décision de l'ingénieur de venir
% value noun

% %NonVerbalVerbs (!)
% value AvoirAux		%Jean *a* mangé
% value EtreAux		%Jean *est* venu
% value SemiAux		%Jean *semble* partir
% value Copule		%Jean *est* aimé par Marie

% % TOUGH adjectives
% %(only subject to subject raising)
% value toughDe		%Il est susceptible de pleuvoir


% % Adverbs
% %value advArgMan	%Jean court vite / *Jean court
% value advLoc		%Les enfants viennent *ici*, *Où vont les enfants*
% value prepLoc		%Dans quelle ville vont les enfants, les enfants vont chez la mère grand
% value advSAnte          %Hier Jean est venu, *jean hier est venu, *jean est hier venu,...
% value advSPost		%Jean viendra demain *jean est demain venu...
% value advVPost		%Jean a vraiment vu un monstre !
% value advAdjAnte	%Jean est très petit
% value advAdvAnte	%Jean court très vite
% value TempNounSAnte	%Ce soir l'ingenieur travaille
% value TempNounSPost	%L'ingenieur travaille la nuit 
% value TempNounVPost	%L'ingenieur a cette nuit travaille


% % PPModifiers
% value s0Pcs1	 	%Jean veut qu'on se rencontre avant le match, que tu partes, de partir
% value s0Ps1		%Jean veut qu'on se rencontre après le match, que tu partes, après être partis
% value s0PLoc1		%Nous viendrons jusque chez vous
value s0Pn1		%Un livre avec une couverture bleue

% % Misc.
% value CliticT		%Tree for any clitic : Jean *le* donne
% value estceque		%Tree for the construction : est-ce que.
% value InvertedSubjClitic %Tree for inverted subject clitic in context of questions : Semble*-t-il* venir ? Viendra*-t-il* ?
% value PrepositionalPhrase %Tree for postnominal PP modifier
% value propername	%Marie
% value pronoun		%
% value n0Nmod		%monsieur *Machin*
% value stddeterminer	%*Le* lutin
% value DetAdj		%*trois* enfants, Les *trois* enfants
% value detQuantifier	% *Tous* les enfants
% value complexNDeDeterminer  %*Deux tonnes de* vin est bu chaque année
% value complexAdvDeDeterminer	%*Beaucoup de* gens viendront
% value whdeterminer	%*Quel* lutin
% value Coordination	%Any simple constituent coordination :Jean *et* Marie mangent
% value s0Cs1		%Complementizers : Jean court *parce_qu'* il est pressé ; s'il vient la réunion aura lieu
% value ExclamativeQue	%Tree for que in exclamative contexts such as : "Qu'il parte !"
% value sententialAdv	%non !


% %negation
% value negLeft		 %Jean ne vient pas
% value negPas		 %Jean ne mange pas, Jean ne mange guère...
% value negativeQuantifier %Personne ne mange
% value detNegQuantifier	 %Aucun enfant n'a mang'e

