



% factor it with verbalForm and adjectivalForm(undone actually)
class nominalForm
declare
	?xR ?xVN ?xCop ?xHead ?fX ?fY ?fZ ?fU ?fW

{
	<syn>{
		node xR(color=black)[cat = s,bot=[mode = ?fX]]{
			node xVN(color=black)[cat = vn,top=[mode = ?fX],bot=[mode = ?fY,gen = ?fU,num = ?fZ,pers=?fW]]{
				node xCop(color=black,mark=subst)[cat = v,top=[cop = +, mode= ?fY,pers=?fW,num=?fZ]]
				node xHead(color=black,mark=anchor)[cat = n]
			}
		}
	}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PREDICATIVE NOUNS (= basic support to make the grammar work, should be seriously extended)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class noun
declare
	?xN
{
	<syn>{
		node xN(color=red,mark=anchor)[cat = n,bot=[det = -,pers = 3,wh = -,bar = 0]]
	}
}

class nounWithCompl
declare 
	?xR ?xHead
{
	<syn>{
		node xR(color=black)[cat = n,bot=[bar = 2]]{
			node xHead(color=black,mark=anchor)[cat = n,bot=[bar = 0]]
		}
	}
}


class n0vN
{
	{Subject[];nominalForm[]}
	|noun[]
}

% TSNLP observed subcats
class n0vNden1
{
	{Subject[];nominalForm[];Genitive[]}
	|{nounWithCompl[];CanonicalGenitive[]}
}
class n0vNan1
{	{Subject[];nominalForm[];Iobject[]}
	|{nounWithCompl[];CanonicalIobject[]}
}

class n0vNan1den2
{
	{Subject[];nominalForm[];Iobject[];Genitive[]}
	|{nounWithCompl[];CanonicalIobject[];CanonicalGenitive[]}
}

class n0vNdes1
{	
	{Subject[];nominalForm[];SententialDeObject[]}
	|{nounWithCompl[];SententialDeObject[]}
}

class n0vNden1des2
{	
	{Subject[];nominalForm[];Genitive[];SententialDeObject[]}
	|{nounWithCompl[];SententialDeObject[];CanonicalGenitive[]}
}