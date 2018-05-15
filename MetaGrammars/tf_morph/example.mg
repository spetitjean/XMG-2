%% -*- coding: utf-8 -*-

%% TYPES
type NUM = {sg, pl}

feature num: NUM

%% CONSTRAINTS ON TOPOLOGICAL FIELDS

field root
field suffix

root >> suffix

%% CLASSES

class plural_suffix
{
<morph>{
	suffix <- "s"
	}
}

class inflect
{
  <morph>{num:sg}
  |
  { <morph>{num:pl} ; plural_suffix[] }
}

class cat
{
  <morph>{
    root <- "cat"
  }
}

class balloon
{
  <morph>{
    root <- "balloon"
  }
}

class noun
{
  cat[] | balloon[]
  
}

class main
{
  noun[]; inflect[]
}

%% AXIOMS

value main
