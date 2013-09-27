class sypat
export ?S
declare ?S
{ <morph>{
        morpheme ?S;
        ?S <- "sypat'"
  }
}

class na
export ?S
declare ?S
{ <morph>{
        morpheme ?S;
        ?S <- "na"
  }
}

class PrefixVerb
declare ?M1 ?M2 ?S1 ?S2
{
  ?M1 = na[];
  ?M2 = sypat[];
  ?S1 = ?M1.?S;
  ?S2 = ?M2.?S;
  <morph>{
        ?S1 >> ?S2        
}
}

value PrefixVerb
