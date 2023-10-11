%-------------------------------------------------------------------------------------------------------------------------
%  A simple STAG metagrammar
%    -> generates the grammar presented in Figure 1 of "Synchronous Tree-Adjoining Grammars" (Schieber & Schabes, 1990)
%       links between source and target trees are expressed with co-indexing in the node's feature structures
%-------------------------------------------------------------------------------------------------------------------------
 
%type declarations:

type CAT={s,np,vp,v,advp,ap,n,
          F,R,T}
type MARK ={subst,foot,flex}
type PHON ={hates,hates_,George,george_,broccoli,broccoli_,violently,violently_,cooked,cooked_}
type LINK !

%property declarations:

property color : COLOR 

%feature declarations
feature cat : CAT
feature phon : PHON
feature mark : MARK
feature link : LINK

% Class definitions:

class hates 
declare ?L1 ?L2 ?L3
{
  <source>{
    node[cat=s]{
      node(mark=subst)[cat=np, link=?L1]
      node[cat=vp, link=?L2]{
        node[cat=v]{
          node(mark=flex)[phon=hates]
        }
        node(mark=subst)[cat=np, link=?L3]
      }
    }
  }
  ;
  <target>{
    node[cat=F, link=?L2]{
      node[cat=R]{
        node(mark=flex)[phon=hates_]
      }
      node(mark=subst)[cat=T, link=?L1]
      node(mark=subst)[cat=T, link=?L3]
    }
  }
}

class george
{
  <source>{
    node[cat=np]{
      node(mark=flex)[phon=George]
    }
  }
  ;
  <target>{
    node[cat=T]{
      node(mark=flex)[phon=george_]
    }
  }
}

class broccoli
declare ?L1
{
  <source>{
    node[cat=np]{
      node[cat=n, link=?L1]{
        node(mark=flex)[phon=broccoli]
      }
    }
  }
  ;
  <target>{
    node[cat=T, link=?L1]{
      node(mark=flex)[phon=broccoli_]
    }
  }
}

class violently
declare ?L1
{
  <source>{
    node[cat=vp, link=?L1]{
      node(mark=foot)[cat=vp]
      node[cat=advp]{
        node(mark=flex)[phon=violently]
      }
    }
  }
  ;
  <target>{
    node[cat=F, link=?L1]{
      node[cat=R]{
        node(mark=flex)[phon=violently_]
      }
      node(mark=foot)[cat=F]
    }
  }
}

class cooked
declare ?L1
{
  <source>{
    node[cat=n, link=?L1]{
      node[cat=ap]{
        node(mark=flex)[phon=cooked]
      }
      node(mark=foot)[cat=n]
    }
  }
  ;
  <target>{
    node[cat=T, link=?L1]{
      node[cat=R]{
        node(mark=flex)[phon=cooked_]
      }
      node(mark=foot)[cat=T]
    }
  }
}




% Selecting the classes to evaluate (axioms)
value hates
value george
value broccoli
value violently
value cooked
