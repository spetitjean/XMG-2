%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	nominalPredicates.mg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%  NON TERMINAL CLASSES %%%%%%%%%%%%

class ** nounWithCompl
import
 	predicateSem[]
	anchorProj1[]
declare 
	?xR ?xHead
{
	<syn>{
		node xR(color=black)[cat = n,bot=[bar = 2]]{
			node xHead(color=black,mark=anchor)[cat = n,bot=[bar = 0]]
		}
	};
	xPred = xHead;
	xHead = xAnchor
}

class ** npWithCompl
import
 	predicateSem[]
	anchorProj1[]
declare 
	?xR ?xHead 
{
	<syn>{
		node xR(color=black)[cat = n,bot=[bar = 2]]{	
			node xHead(color=black,mark=anchor)[cat = n,bot=[bar = 1]]
		}
	};
	xPred = xHead;
	xHead = xAnchor
}
%%%%%%%%%%  TERMINAL CLASSES %%%%%%%%%%%%


% Jean est président (predicative);
class  n0vNPredicative[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
{
 	unaryRelBase[];
	Subject[];
        NominalPredicativeform[]
}


%??
class  n0vNLightVerbConstruction[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
{
 	unaryRel[];
	Subject[];
        NominalPredicativeform[]
}

%% passer pour un specialiste
class  n0vpN[]
{
        n0vpNPredicative[]
     	|n0vpNLightVerbConstruction[]
}

class  n0vpNPredicative[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
{
 	unaryState[];
	Subject[];
        PrepositionalPredicativeform[]
}
class  n0vpNLightVerbConstruction[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
{
 	unaryRel[];
	Subject[];
        PrepositionalPredicativeform[]
}

% etre le chef du departement; 
class  n0vNden1[]
{
        n0vNden1Predicative[]
     	|n0vNden1LightVerbConstruction[]
	|n0vNden1RelationalNounDeverbal[]
	|n0vNden1RelationalNounNonDeverbal[]
}

class  n0vNden1Predicative[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
      GenitiveArg2Linking[]
{
 	binaryState[];
	Subject[];
        PrepositionalPredicativeform[];
	Genitive[]
}
class  n0vNden1LightVerbConstruction[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
     GenitiveArg2Linking[]
{
 	binaryRel[];
	Subject[];
        PrepositionalPredicativeform[];
	Genitive[]
}
class  n0vNden1RelationalNounDeverbal[]
import
      PredArg0Linking[]
     GenitiveArg2Linking[]
{
 	binaryRel[]*=[arg1L=noone];
	nounWithCompl[];
	CanonicalGenitiveWithSem[]
}
class  n0vNden1RelationalNounNonDeverbal[]
import
      PredArg0Linking[]
     GenitiveArg2Linking[]
{
 	binaryState[]*=[arg1L=noone];
	nounWithCompl[];
	CanonicalGenitiveWithSem[]
}

%% modified from Benoit; not used in tsnlp
% x prend la decision de p; la decision de x de p
% n0vNden1
%class n0vNden1des2[L,E,X,Y,Z]

class  n0vNdes1[]
{
        n0vNdes1Predicative[]
     	|n0vNdes1LightVerbConstruction[]
	|n0vNdes1RelationalNounDeverbal[]
	|n0vNdes1RelationalNounNonDeverbal[]
}

class  n0vNdes1Predicative[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
      SententialDeObjectArg2Linking[]
{
 	binaryState[];
	Subject[];
        NominalPredicativeform[];
	SententialDeObject[]
}
class  n0vNdes1LightVerbConstruction[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
      SententialDeObjectArg2Linking[]
{
 	binaryRel[];
	Subject[];
        NominalPredicativeform[];
	SententialDeObject[]
}
class  n0vNdes1RelationalNounDeverbal[]
import
      PredArg0Linking[]
     SententialDeObjectArg2Linking[]
{
 	binaryRel[];
	nounWithCompl[];
	SententialDeObject[]
}
class  n0vNdes1RelationalNounNonDeverbal[]
import
      PredArg0Linking[]
     SententialDeObjectArg2Linking[]
{
 	binaryState[];
	nounWithCompl[]*=[arg1L=noone];
	SententialDeObject[]
}

% invitation à partir
class  n0vNas1[]
{
        n0vNas1Predicative[]
     	|n0vNas1LightVerbConstruction[]
	|n0vNas1RelationalNounDeverbal[]
	|n0vNas1RelationalNounNonDeverbal[]
}

class  n0vNas1Predicative[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
      SententialAObjectArg2Linking[]
{
 	binaryState[];
	Subject[];
        NominalPredicativeform[];
	SententialAObject[]
}
class  n0vNas1LightVerbConstruction[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
     SententialAObjectArg2Linking[]
{
 	binaryRel[];
	Subject[];
        NominalPredicativeform[];
	SententialAObject[]
}
class  n0vNas1RelationalNounDeverbal[]
import
      PredArg0Linking[]
     SententialAObjectArg2Linking[]
{
 	binaryRel[];
	nounWithCompl[]*=[arg1L=noone];
	SententialAObject[]
}
class  n0vNas1RelationalNounNonDeverbal[]
import
      PredArg0Linking[]
     SententialAObjectArg2Linking[]
{
 	binaryState[];
	nounWithCompl[]*=[arg1L=noone];
	SententialAObject[]
}

% Nom relationnel non déverbaux eg le chef du departement

%  faire un cadeau a marie
class  n0vNan1[]
{
        n0vNan1Predicative[]
     	|n0vNan1LightVerbConstruction[]
	|n0vNan1RelationalNounDeverbal[]
	|n0vNan1RelationalNounNonDeverbal[]
}

class  n0vNan1Predicative[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
      IobjectArg2Linking[]
{
 	binaryState[];
	Subject[];
        PrepositionalPredicativeform[];
	Iobject[]
}
class  n0vNan1LightVerbConstruction[]
import
      SubjectArg1Linking[]
      PredArg0Linking[]
     IobjectArg2Linking[]
{
 	binaryRel[];
	Subject[];
        PrepositionalPredicativeform[];
	Iobject[]
}
class  n0vNan1RelationalNounDeverbal[]
import
      PredArg0Linking[]
     IobjectArg2Linking[]
{
 	binaryRel[]*=[arg1L=vide];
	nounWithCompl[];
	CanonicalIobject[]
}

class  n0vNan1RelationalNounNonDeverbal[]
import
      PredArg0Linking[]
     IobjectArg2Linking[]
{
 	binaryState[]*=[arg1L=vide];
	nounWithCompl[];
	CanonicalIobject[]
}

% class n0vNan1den2[L,E,X,Y,Z]
% {
% 	ternaryRel[]*=[label0=L,arg0=E,arg1=X,arg2=Y,arg3=Z];
% 	{{Subject[X,L];NominalPredicativeform[]*=[predI=E,predL=L];Iobject[Y,L];Genitive[Z,L]}
% 	|{nounWithCompl[]*=[predI = E];CanonicalIobject[]*=[iobjectI=Y];
% 	  Canonical@Genitive[]*=[genitiveI=Z]}}}

