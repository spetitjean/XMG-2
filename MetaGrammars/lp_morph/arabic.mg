type PATTERN = {p1,p2,p3,p4,p5,p6,p7,p8,p9,p10}

feature pattern: PATTERN
feature active: bool


class root
{
  <morph>{
	field R1;
	field R2;
	field R3
	%% ;
	%% R1 >>+ R2;
	%% R2 >>+ R3
  }
}

class pattern
{
  <morph>{
	field V1;
	field V2
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
   %% Pattern 2: cvvcvc
   <morph>{
	pattern= p2;
   
	field V11;
	R1 >> V1;
	V1 >> V11;
	V11 >> R2;
	R2 >> V2;
	V2 >> R3	
   }

  }	

}

class active 
declare ?VV1 ?VV2
{
  {
    %% Active
    {
      <morph>{
	active= +
      }
      ;
      ?VV1= "a";
      ?VV2= "a"
    }
    |
    %% Passive
    {
      <morph>{
        active= -
      }
      ;
      ?VV1= "u";
      ?VV2= "i"
    }
  }
  ;
  <morph>{
    V1 <- ?VV1;
    V2 <- ?VV2;
    {
      {
	pattern= p1
	|
	pattern= p3
	%% ...
	
      }
      |
      %% geminating patterns
      {
	{
	  pattern= p2
	  |
	  pattern= p4
	  %% ...
	  
	};
	V11 <- ?VV1
      }
    }
  }

}

class ktb
{
  <morph>{
	R1 <- "k";
	R2 <- "t";
	R3 <- "b"
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