type PATTERN = {p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15}

feature pattern: PATTERN
feature active: bool
feature r1: string
feature r2: string 
feature r3: string
feature v1: string
feature v2: string

%% creates the verbal root: 3 consonants
%% links the 3 fields to the interface
class root
declare ?RR1 ?RR2 ?RR3
{
  <morph>{
	field R1;
	field R2;
	field R3
  }
  ;
  <morph>{
	R1 <- ?RR1;
	R2 <- ?RR2;
	R3 <- ?RR3
  };
  <iface>{
	[r1=?RR1, r2=?RR2, r3=?RR3]
  }	
}

class pattern
declare ?RR1 ?RR2 ?RR3 ?VV1 ?VV2
{
  <iface>{
	[r1=?RR1, r2=?RR2, r3=?RR3, v1=?VV1, v2=?VV2]
  }
  ;
  <morph>{
	field V1;
	V1 <- ?VV1;
	field V2;
	V2 <- ?VV2
  };

%% alternatives
  {
   %% Pattern 1: cvcvc
   <morph>{
	pattern= p1;

	R1 >> V1;
	V1 >> R2;
	R2 >> V2;
	V2 >> R3
   }
   |
   %% Pattern 2: cvccvc 
   <morph>{
	pattern= p2;
   
	field C21;
	C21 <- ?RR2;
	R1 >> V1;
	V1 >> C21;
	C21 >> R2;
	R2 >> V2;
	V2 >> R3	
   }
  |
   %% Pattern 3: cvvcvc 
   <morph>{
	pattern= p3;
   
	field V11;
	V11 <- ?VV1;
	R1 >> V1;
	V1 >> V11;
	V11 >> R2;
	R2 >> V2;
	V2 >> R3	
   }
 |
   %% Pattern 4: ?vccvc
   <morph>{
	pattern= p4;
   	field V0;
	V0 <- "ʕ";
	%%V0 <- "ء";	
	
	V0 >> V1;
	V1 >> R1;
	R1 >> R2;
	R2 >> V2;
	V2 >> R3	
   }
 |
   %% Pattern 5: cvcvccvc (takattab), cv + Pattern 2
   <morph>{
	pattern= p5;
   	field V0;
	V0 <- ?VV1;
	field R0;
	R0 <- ?RR2;
	field R21;
	R21 <- ?RR2;	

	R0 >> V0;
	V0 >> R1;
	R1 >> V1;
	V1 >> R2;
	R2 >> R21;
	R21 >> V2;
	V2 >> R3	
   }
   | 
  %% Pattern 6: cvcvvcvc (takaatab), cv + Pattern 3
   <morph>{
	pattern= p6;
   	field V0;
	V0 <- ?VV1;
	field R0;
	R0 <- ?RR2;
	field V11;
	V11 <- ?VV1;	

	R0 >> V0;
	V0 >> R1;
	R1 >> V1;
	V1 >> V11;
	V11 >> R2;
	R2 >> V2;
	V2 >> R3	
   }
   |
   %% Pattern 7: ccvcvc (nkatab): n + Pattern 1
   <morph>{
	pattern= p7;
	field R0;
	R0 <- "n";
	%%R0 <- "ن";

	R0 >> R1;
	R1 >> V1;
	V1 >> R2;
	R2 >> V2;
	V2 >> R3
   }
   |
   %% Pattern 8: ccvcvc (ktatab): second consonant is replicated after the first one
   <morph>{
	pattern= p8;
	field R11;
	R11 <- ?RR2;

	R1 >> R11;
	R11 >> V1;
	V1 >> R2;
	R2 >> V2;
	V2 >> R3
   }
   |
   %% Pattern 9: ccvcvc (ktabab): second consonant is replaced by the third one and moved after the first one
   <morph>{
	active= +;
	pattern= p9;
	field R21;
	R21 <- ?RR3;

	R1 >> R2;
	R2 >> V1;
	V1 >> R21;
	R21 >> V2;
	V2 >> R3
   }
   |
   %% Pattern 10: ccvccvc (staktab): Pattern 4 with sk instead of ʕ
   <morph>{
	pattern= p10;
   	field R0;
	R0 <- "s";
	%%R0 <- "ث";
	field R01;
	R01 <- ?RR2;	
	
	R0 >> R01;
	R01 >> V1;
	V1 >> R1;
	R1 >> R2;
	R2 >> V2;
	V2 >> R3	
   }
   |
   %% Pattern 11: ccvvcvc (ktaabab): Pattern 9 with doubled first vowel (and as for 9, no passive)
   <morph>{
	active= +;
	pattern= p11;
	field R21;
	R21 <- ?RR3;
	field V11;
	V11 <- ?VV1;

	R1 >> R2;
	R2 >> V1;
	V1 >> V11;
	V11 >> R21;
	R21 >> V2;
	V2 >> R3
   }
   |
   %% Pattern 12: ccvvcvc (ktawtab): Pattern 11 with doubled vowel degraded into "w" (and as for 9, no passive)
   <morph>{
	active= +;
	pattern= p12;
	field R21;
	R21 <- ?RR2;
	field V11;
	V11 <- "w";
	%%V11 <- "و";

	R1 >> R2;
	R2 >> V1;
	V1 >> V11;
	V11 >> R21;
	R21 >> V2;
	V2 >> R3
   }
   |
   %% Pattern 13: ccvvcvc (ktawwab): Pattern 12 with R21 degraded into "w" (and as for 9, no passive)
   <morph>{
	active= +;
	pattern= p13;
	field R21;
	R21 <- "w";
	%%R21 <- "و";
	field V11;
	V11 <- "w";
	%%V11 <- "و";
	
	R1 >> R2;
	R2 >> V1;
	V1 >> V11;
	V11 >> R21;
	R21 >> V2;
	V2 >> R3
   }
   |
   %% Pattern 14: ccvvcvc (ktanbab): Pattern 13 with  (and as for 9, no passive)
   <morph>{
	active= +;
	pattern= p14;
	field R21;
	R21 <- ?RR3;
	field V11;
	V11 <- "n";
	%%V11 <- "ن";	

	R1 >> R2;
	R2 >> V1;
	V1 >> V11;
	V11 >> R21;
	R21 >> V2;
	V2 >> R3
   }
   %% Pattern 15: ccvvcvc (ktanbay): Pattern 14 with last consonant degraded to "y"
  }	

}


%% Give the vowels to the interface, depending on the voice
class active 
declare ?VV1 ?VV2
{
  
  <iface>{
	[v1=?VV1, v2=?VV2]
  }
  ;
  {
    %% Active
    {
      <morph>{
	active= +
      }
      ;
      ?VV1= "a";
      %%?VV1= "َ";

      ?VV2= "a"
      %%?VV2= "َ"
    }
    |
    %% Passive
    {
      <morph>{
        active= -
      }
      ;
      ?VV1= "u";
      %%?VV1= "ُ";
      ?VV2= "i"
      %%?VV2= "ِ"
    }
  }
}

class ktb
{
  <iface>{
	[r1="k", r2="t", r3="b"]
	%%[r1="ك", r2="ت", r3="ب"]
  }
}

class verb
{
  ktb[] %% |
  
}

class main
{
  root[]; verb[]; pattern[]; active[]
}

value main