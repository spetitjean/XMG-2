type NUM = {sg, pl}

feature num: NUM

class root
{
  <morph>{
	field root
  }
}


class plural_suffix
{
  <morph>{
	field suffix;
	root >> suffix;
	suffix <- "s"
  }
}

class inflect
{
  <morph>{num:sg}
  |
  {
    <morph>{num:pl} ; plural_suffix[]
  }
 
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
  root[]; noun[]; inflect[]
}

value main