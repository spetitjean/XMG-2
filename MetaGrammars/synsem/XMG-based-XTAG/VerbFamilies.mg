 class  Dian0V
 {
         dian0Vactive[] 
 }

 class  Reln0V
 {
         Dian0V[] ; RelativeAdjunct[]
 }

 class  n0V
 {
         Dian0V[]
	 |
	 Reln0V[]
 }

 %-------------------------------------------------
 
 class  DiaEn1V
 {
         diaEn1Vactive[]  
 }

 class  RelEn1V
 {
         DiaEn1V[] ; RelativeAdjunct[]   
 }

 class  En1V
 {
         DiaEn1V[] | RelEn1V[]
 }

 %-------------------------------------------------
 
 class  Dian0Vn1
 {
           dian0Vn1active[] 
         | dian0Vn1shortpassive[] 	 
	 | dian0Vn1passive[] 
 }

 class  Reln0Vn1
 {
         Dian0Vn1[] ; RelativeAdjunct[]
 }

 class  n0Vn1
 {
         Dian0Vn1[] | Reln0Vn1[] 
 }

 %-------------------------------------------------

 class  Dian0Vn2n1
 {
        dian0Vn2n1active[] 
        | dian0Vn2n1shortpassive[] 
        | dian0Vn2n1passive[] 
 }

 class  Reln0Vn2n1
 {
         Dian0Vn2n1[] ; RelativeAdjunct[]
 }

 class  n0Vn2n1
 {
         Dian0Vn2n1[] | Reln0Vn2n1[]
 }

 %-------------------------------------------------

 class  Dian0Vn1pn2
 {
        dian0Vn1pn2active[] 
         | dian0Vn1pn2shortpassive[] 
         | dian0Vn1pn2passive[]  
 }

 class  Reln0Vn1pn2
 {
         Dian0Vn1pn2[] ; RelativeAdjunct[]
 }

 class  n0Vn1pn2
 {
         Dian0Vn1pn2[] | Reln0Vn1pn2[]
 }

 %-------------------------------------------------

 class  Dian0Vn1Pn2
 {
         dian0Vn1Pn2active[] 
         | dian0Vn1Pn2shortpassive[] 
         | dian0Vn1Pn2passive[]
 }

 class  Reln0Vn1Pn2
 {
          Dian0Vn1Pn2[] ; RelativeAdjunct[]
 }

 class  n0Vn1Pn2
 {       
         Dian0Vn1Pn2[] | Reln0Vn1Pn2[]
 }

 %-------------------------------------------------

 class  Dian0Vn1s2
 {
         dian0Vn1s2active[] 
         | dian0Vn1s2shortpassive[] 
         | dian0Vn1s2passive[]
 }

 class  Reln0Vn1s2
 {
         Dian0Vn1s2[] ; RelativeAdjunct[]
 }

 class  n0Vn1s2
 {
         Dian0Vn1s2[] | Reln0Vn1s2[]
 }

 %-------------------------------------------------

 class  Dian0Vpl
 {
         dian0Vplactive[]
 }

 class  Reln0Vpl
 {
         Dian0Vpl[] ; RelativeAdjunct[]
 }

 class  n0Vpl
 {
         Dian0Vpl[] | Reln0Vpl[]
 }

 %-------------------------------------------------

 class  Dian0Vpln1
 {
         dian0Vpln1active[] 
         | dian0Vpln1shortpassive[] 
         | dian0Vpln1passive[]
 }

 class  Reln0Vpln1
 {
         Dian0Vpln1[] ; RelativeAdjunct[]
 }

 class  n0Vpln1
 {
         Dian0Vpln1[] | Reln0Vpln1[]
 }

 %-------------------------------------------------

 class  Dian0Vpln2n1
 {
         dian0Vpln2n1active[]
 }

 class  Reln0Vpln2n1
 {
         Dian0Vpln2n1[] ; RelativeAdjunct[]
 }

 class  n0Vpln2n1
 {
         Dian0Vpln2n1[] | Reln0Vpln2n1[]
 }

 %-------------------------------------------------

 class  Dian0Vpn1
 {
         dian0Vpn1active[] 
         | dian0Vpn1passive[]
         | dian0Vpn1shortpassive[]
 }

 class  Reln0Vpn1
 {
         Dian0Vpn1[] ; RelativeAdjunct[]
 }

 class  n0Vpn1
 {
         Dian0Vpn1[] | Reln0Vpn1[]
 }

 %-------------------------------------------------

 class  Dian0VPn1
 {
         dian0VPn1active[] 
         | dian0VPn1passive[]
         | dian0VPn1shortpassive[]
 }

 class  Reln0VPn1
 {
         Dian0VPn1[] ; RelativeAdjunct[]
 }

 class  n0VPn1
 {
         Dian0VPn1[] | Reln0VPn1[]
 }

 %-------------------------------------------------

 class  Dian0Vs1
 {
         dian0Vs1active[] 
 }

 class  Reln0Vs1
 {
         Dian0Vs1[] ; RelativeAdjunct[]
 }

 class  n0Vs1
 {
         Dian0Vs1[] | Reln0Vs1[]
 }

 %-------------------------------------------------

 class  Dian0Va1
 {
         dian0Va1active[] 
 }

 class  Reln0Va1
 {
         Dian0Va1[] ; RelativeAdjunct[]
 }

 class  n0Va1
 {
         Dian0Va1[] | Reln0Va1[] 
 }

 %-------------------------------------------------

 class  Dias0Vn1
 {
          dias0Vn1active[]
 }

 class  Rels0Vn1
 {
         Dias0Vn1[] ; RelativeAdjunct[]
 }

 class  s0Vn1
 {
         Dias0Vn1[] | Rels0Vn1[]
 }

 %-------------------------------------------------
 class  Dian0lVN1
 {
         dian0lVN1active[] 
 }

 class  Reln0lVN1
 {
         Dian0lVN1[] ; RelativeAdjunct[]
 }

 class  n0lVN1
 {
          Dian0lVN1[] | Reln0lVN1[]
 }

 %-------------------------------------------------

 class  Dian0lVN1Pn2
 {
         dian0lVn2N1active[] 
         | dian0lVn2N1passive[] 
         | dian0lVn2N1NPgerundshortpassive[]

         | dian0lVN1Pn2active[] 
         | dian0lVN1Pn2passive[] 
         | dian0lVN1Pn2NPgerundshortpassive[]
 }

 class  Reln0lVN1Pn2
 {
         Dian0lVN1Pn2[] ; RelativeAdjunct[]      
 }

 class  n0lVN1Pn2
 {
         Dian0lVN1Pn2[] | Reln0lVN1Pn2[]
 }

 %-------------------------------------------------

 class  DiaItVn1s2
 {
         diaItVn1s2[]
 }

 class  RelItVn1s2
 {
         DiaItVn1s2[] ; RelativeAdjunct[]
 }

 class  ItVn1s2
 {
         DiaItVn1s2[] | RelItVn1s2[]
 }

 %-------------------------------------------------

 class  DiaItVpn1s2
 {
         diaItVpn1s2[]
 }

 class  RelItVpn1s2
 {
         DiaItVpn1s2[] ; RelativeAdjunct[]
 }

 class  ItVpn1s2
 {
         DiaItVpn1s2[] | RelItVpn1s2[]
 }

 %-------------------------------------------------

 class  DiaItVad1s2
 {
         diaItVad1s2[]
 }

 class  RelItVad1s2
 {
         DiaItVad1s2[] ; RelativeAdjunct[]
 }

 class  ItVad1s2
 {
         DiaItVad1s2[] | RelItVad1s2[] 
 }

 %-------------------------------------------------

 class  Reln0A1
 {
         Dian0A1 [] ; RelativeAdjunct[] 
 } 

 class  n0A1
 {
         Dian0A1[] | Reln0A1[]
 }

 %-------------------------------------------------

 class  Reln0A1s1 
 {
         Dian0A1s1[] ; RelativeAdjunct[]
 }

 class  n0A1s1
 {
         Dian0A1s1[] | Reln0A1s1[]
 }

 %-------------------------------------------------

 class  Rels0A1
 {
         Dias0A1[] ; RelativeAdjunct[]
 }

 class  s0A1
 {
         Dias0A1[] | Rels0A1[]
 }

 %-------------------------------------------------

 class  n0BEn1
 {
         Dian0BEn1[]
 }

 %-------------------------------------------------

 class  Reln0N1
 {
         Dian0N1[] ; RelativeAdjunct[]
 }

 class  n0N1
 {
         Dian0N1[] | Reln0N1[]
 }

 %-------------------------------------------------

 class  Reln0N1s1
 {
         Dian0N1s1[] ; RelativeAdjunct[]
 }

 class  n0N1s1
 {
         Dian0N1s1[] | Reln0N1s1[]
 }

 %-------------------------------------------------

 class  Rels0N1
 {
         Dias0N1[] ; RelativeAdjunct[]
 }

 class  s0N1
 {
         Dias0N1[] | Rels0N1[]
 }

 %-------------------------------------------------

 class  Reln0Pn1
 {
         Dian0Pn1[] ; RelativeAdjunct[]
 }

 class  n0Pn1
 {
         Dian0Pn1[] | Reln0Pn1[]
 }

 %-------------------------------------------------

 class  Reln0P1
 {
         Dian0P1[] ; RelativeAdjunct[]
 }

 class  n0P1
 {
         Dian0P1[] | Reln0P1[]
 }

 %-------------------------------------------------

 class  Rels0Pn1
 {
         Dias0Pn1[] ; RelativeAdjunct[]
 }

 class  s0Pn1
 {
         Dias0Pn1[] | Rels0Pn1[]
 }

 %-----------------------------------------------
 class  Dias0V
 {
	 dias0Vactive[]
 }
 
 class  Rels0V
 {
         Dias0V[] ; RelativeAdjunct[]
 }

 class  s0V
 {
         Dias0V[] | Rels0V[]
 }

 %-------------------------------------------------

 class  Dias0Vton1
 {
	dias0Vton1active[]
 }

 class  Rels0Vton1
 {
         Dias0Vton1[] ; RelativeAdjunct[]
 }

 class  s0Vton1
 {
         Dias0Vton1[] | Rels0Vton1[]
 }

 %-------------------------------------------------

 class  Reln0ARBPn1
 {
         Dian0ARBPn1[] ; RelativeAdjunct[]
 }

 class  n0ARBPn1
 {
         Dian0ARBPn1[] | Reln0ARBPn1[]
 }

 %-------------------------------------------------

 class  Reln0APn1
 {
         Dian0APn1[] ; RelativeAdjunct[]
 } 

 class  n0APn1
 {
         Dian0APn1[] | Reln0APn1[]
 }

 %-------------------------------------------------

 class  Reln0NPn1
 {
         Dian0NPn1[] ; RelativeAdjunct[]
 }

 class  n0NPn1
 {
         Dian0NPn1[] | Reln0NPn1[]       
 }

 %-------------------------------------------------

 class  Reln0PPn1
 {
         Dian0PPn1[] ; RelativeAdjunct[]
 }

 class  n0PPn1
 {
         Dian0PPn1[] | Reln0PPn1[]
 }

 %-------------------------------------------------

 class  Reln0PNaPn1
 {
         Dian0PNaPn1[] ; RelativeAdjunct[]
 }

 class  n0PNaPn1
 {
         Dian0PNaPn1[] | Reln0PNaPn1[]
 }

 %-------------------------------------------------

 class  Rels0ARBPn1
 {
         Dias0ARBPn1[] ; RelativeAdjunct[]
 }

 class  s0ARBPn1
 {
         Dias0ARBPn1[] | Rels0ARBPn1[]
 }

 %-------------------------------------------------

 class  Rels0APn1
 {
         Dias0APn1[] ; RelativeAdjunct[]
 }

 class  s0APn1
 {
         Dias0APn1[] | Rels0APn1[]
 }

 %-------------------------------------------------

 class  Rels0NPn1
 {
         Dias0NPn1[] ; RelativeAdjunct[]
 }

 class  s0NPn1
 {
         Dias0NPn1[] | Rels0NPn1[]
 }

 %-------------------------------------------------

 class  Rels0PPn1
 {
         Dias0PPn1[] ; RelativeAdjunct[]
 }

 class  s0PPn1
 {
         Dias0PPn1[] | Rels0PPn1[]
 }

 %-------------------------------------------------

 class  Rels0PNaPn1
 {
         Dias0PNaPn1[] ; RelativeAdjunct[]
 }

 class  s0PNaPn1
 {
         Dias0PNaPn1[] | Rels0PNaPn1[]
 }

 %-------------------------------------------------

 class  s0Vs1
 {
         dias0Vs1active[]
 }

 %-------------------------------------------------

 class  n0n1ARB
 {
         Dian0n1ARB[]
 }

 %-------------------------------------------------
  
 class  DiaXn0Vs1
 {
         diaXn0Vs1active[]
 }

 class  RelXn0Vs1
 {
         DiaXn0Vs1[] ; RelativeAdjunct[]
 }

 class  Xn0Vs1
 {
         DiaXn0Vs1[] | RelXn0Vs1[]
 }

 %-------------------------------------------------

 class  Dian0VDN1
 {
          dian0VDN1active[]
         | dian0VDN1passive[]
         | dian0VDN1shortpassive[]
 }

 class  Reln0VDN1
 {
         dian0VDN1active[] ; RelativeAdjunct[]
 }

 class  n0VDN1
 {
         Dian0VDN1[] | Reln0VDN1[]
 }

 %-------------------------------------------------

 class  Dian0VDAN1
 {
         dian0VDAN1active[]
         | dian0VDAN1passive[]
         | dian0VDAN1shortpassive[]
 }


 class  Reln0VDAN1
 {
         dian0VDAN1active[] ; RelativeAdjunct[]
 }

 class  n0VDAN1
 {
         Dian0VDAN1[] | Reln0VDAN1[]
 }

 %-------------------------------------------------

 class  Dian0VN1
 {
         dian0VN1active[] 
         | dian0VN1passive[]
         | dian0VN1shortpassive[]
 }

 class  Reln0VN1
 {
         dian0VN1active[] ; RelativeAdjunct[]
 } 

 class  n0VN1
 {
         Dian0VN1[] | Reln0VN1[]
 }

 %-------------------------------------------------

 class  Dian0VAN1
 {
         dian0VAN1active[]
         | dian0VAN1passive[]
         | dian0VAN1shortpassive[]
 }

 class  Reln0VAN1
 {
         dian0VAN1active[] ; RelativeAdjunct[]   
 }

 class  n0VAN1
 {
         Dian0VAN1[] | Reln0VAN1[]
 }

 %-------------------------------------------------

 class  Dian0VDAN1Pn2
 {
         dian0VDAN1Pn2active[]
         | dian0VDAN1Pn2passive[]
         | dian0VDAN1Pn2shortpassive[]
         | dian0VDAN1Pn2outerpassive[]
         | dian0VDAN1Pn2outershortpassive[]
 }


 class  Reln0VDAN1Pn2
 {
         dian0VDAN1Pn2active[] ; RelativeAdjunct[]
 }

 class  n0VDAN1Pn2
 {
         Dian0VDAN1Pn2[] | Reln0VDAN1Pn2[]
 }

 %-------------------------------------------------

 class  Dian0VAN1Pn2
 {
         dian0VAN1Pn2active[]
         | dian0VAN1Pn2passive[]
         | dian0VAN1Pn2shortpassive[]
         | dian0VAN1Pn2outerpassive[]
         | dian0VAN1Pn2outershortpassive[]
 }

 class  Reln0VAN1Pn2
 {
         dian0VAN1Pn2active[] ; RelativeAdjunct[]
 }

 class  n0VAN1Pn2
 {
         Dian0VAN1Pn2[] | Reln0VAN1Pn2[]
 }

 %-------------------------------------------------

 class  Dian0VN1Pn2
 {
         dian0VN1Pn2active[]
         | dian0VN1Pn2passive[]
         | dian0VN1Pn2shortpassive[]
         | dian0VN1Pn2outerpassive[]
         | dian0VN1Pn2outershortpassive[]
 }

 class  Reln0VN1Pn2
 {
         dian0VN1Pn2active[] ; RelativeAdjunct[]
 }

 class  n0VN1Pn2
 {
         Dian0VN1Pn2[] | Reln0VN1Pn2[] 
 }

 %-------------------------------------------------

 class  Dian0VDN1Pn2
 {
         dian0VDN1Pn2active[]
         | dian0VDN1Pn2passive[]
         | dian0VDN1Pn2shortpassive[]
         | dian0VDN1Pn2outerpassive[]
         | dian0VDN1Pn2outershortpassive[]
 }

 class  Reln0VDN1Pn2
 {
         dian0VDN1Pn2active[] ; RelativeAdjunct[]
 }

 class  n0VDN1Pn2
 {
         Dian0VDN1Pn2[] | Reln0VDN1Pn2[]
 }

 %-------------------------------------------------

 class  DiaRn0Vn1A2
 {      diaRn0Vn1A2active[]
        | diaRn0Vn1A2passive[]
        | diaRn0Vn1A2shortpassive[]
 }

 class  RelRn0Vn1A2
 {
         DiaRn0Vn1A2[] ; RelativeAdjunct[]
 }

 class  Rn0Vn1A2
 {
         DiaRn0Vn1A2[] | RelRn0Vn1A2[]
 }

 %-------------------------------------------------

 class  DiaRn0Vn1Pn2
 {      diaRn0Vn1Pn2active[]
        | diaRn0Vn1Pn2passive[]
        | diaRn0Vn1Pn2shortpassive[]

 }

 class  RelRn0Vn1Pn2
 {
         DiaRn0Vn1Pn2[] ; RelativeAdjunct[]
 } 

 class  Rn0Vn1Pn2
 {
         DiaRn0Vn1Pn2[] | RelRn0Vn1Pn2[]
 }

 %-------------------------------------------------

 class  DiaREn1VA2
 {
         diaREn1VA2active[]
 }

 class  RelREn1VA2
 {
         DiaREn1VA2[] ; RelativeAdjunct[]
 } 

 class  REn1VA2
 {
         DiaREn1VA2[] | RelREn1VA2[]
 }

 %-------------------------------------------------

 class  DiaREn1VPn2
 {
         diaREn1VPn2active[]
 }

 class  RelREn1VPn2
 {
         DiaREn1VPn2[] ; RelativeAdjunct[]
 }

 class  REn1VPn2
 {
         DiaREn1VPn2[] | RelREn1VPn2[]
 }


