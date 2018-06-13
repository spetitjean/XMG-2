class  dian0Vactive
{
        {active[] ; Subject[]} 
	|
	betaVn[]*=[vmode = ger]  
	
}

%-------------------------------------------------

class  diaEn1Vactive
{
        {active[] ; Subject[]} 
	|  betaVn[]*=[vmode = ger]  
}

%-------------------------------------------------

class  dian0Vn1active
{
        {active[] ; Subject[] ; Object[]}
	| betaVn[]*=[vmode = ppart] 
	| alphaAV[]
}

class  dian0Vn1shortpassive
{
        passive[] ; Subject[] 
}	

class  dian0Vn1passive
{
    	passive[] ; Subject[] ; ByAgent[]
}

%-------------------------------------------------

class  dian0Vn2n1active 
{
        active[] ; Subject[] ; IObject[] ; Object[] 
}

class  dian0Vn2n1shortpassive
{
        passive[] ; Subject[] ; Object[]
}

class  dian0Vn2n1passive
{
        passive[] ; Subject[] ; Object[] ; ByAgent[]
}

%-------------------------------------------------

class  dian0Vn1pn2active
{
	active[] ; Subject[] ; Object[] ; PPIObjectSubst[] 
}

class  dian0Vn1pn2shortpassive
{
	passive[] ; Subject[] ; PPIObjectSubst[]
}

class  dian0Vn1pn2passive
{ 	
	passive[] ; Subject[] ; PPIObjectSubst[] ; ByAgent[]
}

%-------------------------------------------------

class  dian0Vn1Pn2active
{
        active[] ; Subject[] ; Object[] ; PPIObjectAnchor[]
}

class  dian0Vn1Pn2shortpassive
{
        passive[] ; Subject[] ; PPIObjectAnchor[]
}

class  dian0Vn1Pn2passive
{
	passive[] ; Subject[] ; PPIObjectAnchor[] ; ByAgent[]
}


%-------------------------------------------------

class  dian0Vn1s2active
{     
      active[] ;  Subject[] ; Object[] ; SentComplement[]
}

class  dian0Vn1s2shortpassive
{
      passive[] ; Subject[] ; SentComplement[]
}

class  dian0Vn1s2passive
{     
      passive[] ; Subject[] ; SentComplement[] ; ByAgent[]
}

%-------------------------------------------------

class  dian0Vplactive
{
        active[] ; particle[] ; Subject[]
}

%-------------------------------------------------

class  dian0Vpln1active
{
        active[] ; particle[] ; Subject[] ; Object[]
}

class  dian0Vpln1shortpassive
{
        passive[] ; particle[] ; Subject[]
}

class  dian0Vpln1passive
{
    	passive[] ; particle[] ; Subject[] ; ByAgent[] 
}

%-------------------------------------------------

class  dian0Vpln2n1active
{
        active[] ; particle[] ; Subject[] ; Object[] ; IObject[]	
}

%-------------------------------------------------

class  dian0Vpn1active
{
        active[] ; Subject[] ; PPIObjectSubst[]
}

class  dian0Vpn1passive
{
	passive[] ; Subject[] ; CanPPSubstExhaustive[] ; ByAgent[]
}

class  dian0Vpn1shortpassive
{
	passive[] ; Subject[] ; CanPPSubstExhaustive[]
}

%-------------------------------------------------

class  dian0VPn1active
{
       active[] ; Subject[] ; PPIObjectAnchor[]
}

class  dian0VPn1passive
{
	passive[] ; Subject[] ; CanPPCoanchorExhaustive[] ;  ByAgent[]
}

class  dian0VPn1shortpassive
{
	passive[] ; Subject[] ; CanPPCoanchorExhaustive[]
}

%-------------------------------------------------

class  dian0Vs1active
{
	active[] ; Subject[] ; SentComplement[]
}

%-------------------------------------------------

class  dian0Va1active
{
       active[] ; Subject[] ; AdjComplement[]
}

%-------------------------------------------------

class  dias0Vn1active  
{
	SententialSubject[] ; CanObject[] ; active[]
}


%-------------------------------------------------

class  dian0lVN1active
{
        active[] ; Subject[] ; ObjectNCoanchor[] 
}

%-------------------------------------------------
%Non-shifted

class  dian0lVn2N1active
{
	active[] ; Subject[] ; IObject[] ; ObjectNCoanchorCan[]
}

class  dian0lVn2N1passive
{
    	passive[] ; 
	{CanSubject[] | ProSubject[] | NPGerundSubject[]} ; 
	ObjectNCoanchor[] ; CanByAgent[]
}

class  dian0lVn2N1NPgerundshortpassive[]
{
	passive[] ; NPGerundSubject[] ; ObjectNCoanchor[]
}

%Shifted
class  dian0lVN1Pn2active
{
	active[] ; Subject[] ; ObjectNCoanchor[] ; ToObject[]
}

class  dian0lVN1Pn2passive
{
	passive[] ; SubjectNCoanchor[] ; CanToObject[] ; CanByAgent[]
}

class  dian0lVN1Pn2NPgerundshortpassive[]
{
	passive[] ; SubjectNCoanchorNPGerund[] ; CanToObject[]
}

%-------------------------------------------------

class  diaItVn1s2
{
 	 active[] ; NominalCleft[]
}

%-------------------------------------------------

class  diaItVpn1s2
{
	active[] ; PPCleft[]
}

%-------------------------------------------------

class  diaItVad1s2
{
	active[] ; AdverbCleft[]
}


%-------------------------------------------------

class  Dian0A1
{
	Subject[] ; verbless[] ; AdjComplementAnchor[] 
} 

%-------------------------------------------------

class  Dian0A1s1
{
	Dian0A1[] ; CanSentComplement2[]
}

%-------------------------------------------------

class  Dias0A1
{
	SententialSubject[] ; verbless[] ; CanAdjAnchor[]
}

%-------------------------------------------------

class  Dian0BEn1
{
	CanSubject[] ; {active[] | VerbalInverted[]} ; CanBEComplement[]
}

%-------------------------------------------------

class  Dian0N1
{
	Subject[] ; verbless[] ; ObjectAnchor[]
}

%-------------------------------------------------

class  Dian0N1s1
{
	Dian0N1[] ; CanSentComplement2[]
}

%-------------------------------------------------

class  Dias0N1
{
	SententialSubject[] ; verbless[] ; ObjectAnchor[]
}

%-------------------------------------------------

class  Dian0Pn1
{
	Subject[] ; verbless[] ; PPAnchorArgumentNP[]
}

%-------------------------------------------------

class  Dian0P1
{
	Subject[] ; verbless[] ; PPAnchorExhaustive[]
}

%-------------------------------------------------

class  Dias0Pn1
{
	SententialSubject[] ; verbless[] ; PPAnchorArgumentNP[]
}

%-------------------------------------------------

class  dias0Vactive
{
	SententialSubject[] ; active[]
}

%-------------------------------------------------

class  dias0Vton1active
{
	SententialSubject[] ; active[] ; CanToObject[]
}

%-------------------------------------------------


class  Dian0ARBPn1
{
	Subject[] ; verbless[] ;  PPAnchorArgumentAdv[]
}

%-------------------------------------------------

class  Dian0APn1
{
	Subject[] ; verbless[] ;  PPAnchorArgumentAdj[]
}

%-------------------------------------------------

class  Dian0NPn1
{
	Subject[] ; verbless[] ;  PPAnchorArgumentN[]
}

%-------------------------------------------------

class  Dian0PPn1
{
	Subject[] ; verbless[] ;  PPAnchorArgumentP[]  
}

%-------------------------------------------------

class  Dian0PNaPn1
{
	Subject[] ; verbless[] ; PPAnchorArgumentPNP[]
}

%-------------------------------------------------

class  Dias0ARBPn1
{
	SententialSubject[] ; verbless[] ;  PPAnchorArgumentAdv[]  
}

%-------------------------------------------------

class  Dias0APn1
{
	SententialSubject[] ; verbless[] ;  PPAnchorArgumentAdj[]
}

%-------------------------------------------------

class  Dias0NPn1
{
	SententialSubject[] ; verbless[] ;  PPAnchorArgumentN[]
}

%-------------------------------------------------

class  Dias0PPn1
{
	SententialSubject[] ; verbless[] ;  PPAnchorArgumentP[]
}

%-------------------------------------------------

class  Dias0PNaPn1
{
	SententialSubject[] ; verbless[] ; PPAnchorArgumentPNP[]
}

%-------------------------------------------------

class  dias0Vs1active
{
	SententialSubject[] ; active[] ; CanSentComplementFoot[]
}

%-------------------------------------------------

class  Dian0n1ARB
{
	Subject[] ; verbless[] ; Locative[]
}

%-------------------------------------------------

class  diaXn0Vs1active
{
	active[] ; Subject[] ; SentComplementECM[]
}

%-------------------------------------------------

class  dian0VDN1active
{
	Subject[] ; active[] ; DetCoanchorCan[] ; ObjectNCoanchorCan[]
}

class  dian0VDN1passive
{
	SubjectDetCoanchorCan[] ; SubjectNCoanchorCan[] ; passive[] ; ByAgent[]
}

class  dian0VDN1shortpassive
{
	SubjectDetCoanchorCan[] ; SubjectNCoanchorCan[] ; passive[]  
}

%-------------------------------------------------

class  dian0VDAN1active
{
	Subject[] ; active[] ; DetCoanchorCan[] ; AdjCoanchorCan[] ; ObjectNCoanchorCan[]
}

class  dian0VDAN1passive
{
	SubjectDetCoanchorCan[] ; SubjectAdjCoanchorCan[] ; SubjectNCoanchorCan[] ; passive[] ; ByAgent[]
}

class  dian0VDAN1shortpassive
{
	SubjectDetCoanchorCan[] ; SubjectAdjCoanchorCan[] ; SubjectNCoanchorCan[] ; passive[]  
}

%-------------------------------------------------

class  dian0VN1active
{
	Subject[] ; active[] ;  ObjectNCoanchorCan[] 
}

class  dian0VN1passive
{
 	SubjectNCoanchorCan[] ; passive[] ; ByAgent[]
}

class  dian0VN1shortpassive
{
 	SubjectNCoanchorCan[] ; passive[]
}

%-------------------------------------------------

class  dian0VAN1active
{
	Subject[] ; active[] ; AdjCoanchorCan[] ; ObjectNCoanchorCan[]
}

class  dian0VAN1passive
{
	SubjectNCoanchorCan[] ; SubjectAdjCoanchorCan[] ; passive[] ; ByAgent[]
}

class  dian0VAN1shortpassive
{
	SubjectNCoanchorCan[] ; SubjectAdjCoanchorCan[] ; passive[] 
}

%-------------------------------------------------

class  dian0VDAN1Pn2active
{      
       dian0VDAN1active[] ; CanPPIObject[]
}

class  dian0VDAN1Pn2passive
{      
       dian0VDAN1passive[] ; CanPPIObject[] 
}

class  dian0VDAN1Pn2shortpassive
{      
       dian0VDAN1shortpassive[] ; CanPPIObject[]
}

class  dian0VDAN1Pn2outershortpassive
{
	SubjectOuter[] ; passive[] ; 
	DetCoanchorCan[] ; AdjCoanchorCan[] ; ObjectNCoanchorCan[]	
}

class  dian0VDAN1Pn2outerpassive
{
	SubjectOuter[] ; passive[] ; 
	DetCoanchorCan[] ; AdjCoanchorCan[] ; ObjectNCoanchorCan[]; 
	ByAgent[] 	 	
}

%-------------------------------------------------

class  dian0VAN1Pn2active
{      
       dian0VAN1active[] ; CanPPIObject[]
}

class  dian0VAN1Pn2passive
{      
       dian0VAN1passive[] ; CanPPIObject[] 
}

class  dian0VAN1Pn2shortpassive
{      
       dian0VAN1shortpassive[] ; CanPPIObject[]
}

class  dian0VAN1Pn2outershortpassive
{
	SubjectOuter[] ; passive[] ; AdjCoanchorCan[] ; ObjectNCoanchorCan[]	
}

class  dian0VAN1Pn2outerpassive
{
	SubjectOuter[] ; passive[] ; AdjCoanchorCan[] ; ObjectNCoanchorCan[]; ByAgent[] 	 	
}


%-------------------------------------------------

class  dian0VN1Pn2active
{      
       dian0VN1active[] ; CanPPIObject[]
}

class  dian0VN1Pn2passive
{      
       dian0VN1passive[] ; CanPPIObject[] 
}

class  dian0VN1Pn2shortpassive
{      
       dian0VN1shortpassive[] ; CanPPIObject[]
}

class  dian0VN1Pn2outershortpassive
{
	SubjectOuter[] ; passive[] ; ObjectNCoanchorCan[]	
}

class  dian0VN1Pn2outerpassive
{
	SubjectOuter[] ; passive[] ; ObjectNCoanchorCan[]; ByAgent[] 	 	
}

%-------------------------------------------------

class  dian0VDN1Pn2active
{      
       dian0VDN1active[] ; CanPPIObject[]
}

class  dian0VDN1Pn2passive
{      
       dian0VDN1passive[] ; CanPPIObject[] 
}

class  dian0VDN1Pn2shortpassive
{      
       dian0VDN1shortpassive[] ; CanPPIObject[]
}

class  dian0VDN1Pn2outershortpassive
{
	SubjectOuter[] ; passive[] ; DetCoanchorCan[] ; ObjectNCoanchorCan[]	
}

class  dian0VDN1Pn2outerpassive
{
	SubjectOuter[] ; passive[] ; DetCoanchorCan[] ; ObjectNCoanchorCan[] ; ByAgent[] 	 	
}

%-------------------------------------------------

class  diaRn0Vn1A2active
{
	dian0Vn1active[]  ; AdjComplementCoanchor[]
}

class  diaRn0Vn1A2passive
{
	dian0Vn1passive[] ; AdjComplementCoanchor[]
}


class  diaRn0Vn1A2shortpassive
{
	dian0Vn1shortpassive[] ; AdjComplementCoanchor[]
}


%-------------------------------------------------

class  diaRn0Vn1Pn2active
{
	Subject[] ; active[] ; Object[] ; PPIObject[]
}

class  diaRn0Vn1Pn2passive
{
	dian0Vn1passive[] ; PPIObject[]
}

class  diaRn0Vn1Pn2shortpassive
{
	dian0Vn1shortpassive[] ; PPIObject[]
}

%-------------------------------------------------

class  diaREn1VA2active
{
	 Subject[] ; active[] ; AdjComplementCoanchor[]
}

%-------------------------------------------------

class  diaREn1VPn2active
{
	  Subject[] ; active[] ; PPIObject[]
}


