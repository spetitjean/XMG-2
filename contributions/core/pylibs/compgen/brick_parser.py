import xmg.compgen.Symbol
import xmg.compgen.Grammar

# Punctuation
semicolon=xmg.compgen.Symbol.T(";")
colon=xmg.compgen.Symbol.T(":")
pipe=xmg.compgen.Symbol.T("|")
quote=xmg.compgen.Symbol.T("'")
arrow=xmg.compgen.Symbol.T("->")
equal=xmg.compgen.Symbol.T("=")
coma=xmg.compgen.Symbol.T(',')
openpred=xmg.compgen.Symbol.T("(")
closepred=xmg.compgen.Symbol.T(")")
openlist=xmg.compgen.Symbol.T("[")
closelist=xmg.compgen.Symbol.T("]")

endsection=xmg.compgen.Symbol.T("%%")


_id=xmg.compgen.Symbol.T("identifier")
sqstring=xmg.compgen.Symbol.T("sqstring")
_ids_or_t=xmg.compgen.Symbol.NT("ids_or_t")
_id_or_t=xmg.compgen.Symbol.NT("id_or_t")
ids_coma=xmg.compgen.Symbol.NT("ids_coma")
RID=xmg.compgen.Rule.Rule(_ids_or_t,(_id_or_t,))
RID2=xmg.compgen.Rule.Rule(_ids_or_t,(_id_or_t,_ids_or_t))
RID3=xmg.compgen.Rule.Rule(_id_or_t,(_id,))
RID4=xmg.compgen.Rule.Rule(_id_or_t,(sqstring,))



# Terminals
TD=xmg.compgen.Symbol.NT("TD")
T=xmg.compgen.Symbol.T("%token")
RT=xmg.compgen.Rule.Rule(TD,(T,_id))


# Non-terminals
NTD=xmg.compgen.Symbol.NT("NTD")
NT=xmg.compgen.Symbol.T("%type")
RNT=xmg.compgen.Rule.Rule(NTD,(NT,_id,_id))

# Externs
EXTD=xmg.compgen.Symbol.NT("EXTD")
EXT=xmg.compgen.Symbol.T("%ext")
REXT=xmg.compgen.Rule.Rule(EXTD,(EXT,_id,_id))

# Rules
RuD=xmg.compgen.Symbol.NT("RuD")
RuleParts=xmg.compgen.Symbol.NT("RuleParts")
RulePart=xmg.compgen.Symbol.NT("RulePart")
openAction=xmg.compgen.Symbol.T("{")
closeAction=xmg.compgen.Symbol.T("}")
RRu=xmg.compgen.Rule.Rule(RuD,(_id,colon,RuleParts))
RRu1=xmg.compgen.Rule.Rule(RuleParts,(RulePart,semicolon))
RRu2=xmg.compgen.Rule.Rule(RuleParts,(RulePart,pipe,RuleParts))
RRu3=xmg.compgen.Rule.Rule(RulePart,(_ids_or_t,))
#RRu4=xmg.compgen.Rule.Rule(RulePart,(_ids_or_t,openAction,sqstring,closeAction))
Action=xmg.compgen.Symbol.NT("Action")
RRu4=xmg.compgen.Rule.Rule(RulePart,(_ids_or_t,openAction,Action,closeAction))
ActionPart=xmg.compgen.Symbol.NT("ActionPart")
Eq=xmg.compgen.Symbol.NT("Eq")
Pred=xmg.compgen.Symbol.NT("Pred")
List=xmg.compgen.Symbol.NT("List")
ListEnum=xmg.compgen.Symbol.NT("ListEnum")
ListCons=xmg.compgen.Symbol.NT("ListCons")
RListEnum=xmg.compgen.Rule.Rule(ListEnum,(sqstring,))
RListCons=xmg.compgen.Rule.Rule(ListCons,(sqstring,pipe,sqstring))

RAction1=xmg.compgen.Rule.Rule(Action,(ActionPart,))
RAction2=xmg.compgen.Rule.Rule(Action,(ActionPart,coma,Action))
RAction3=xmg.compgen.Rule.Rule(Action,(ActionPart,semicolon,Action))
RActionP1=xmg.compgen.Rule.Rule(ActionPart,(Eq,))
#REq=xmg.compgen.Rule.Rule(Eq,(_id,equal,_id))
REq1=xmg.compgen.Rule.Rule(Eq,(sqstring,equal,sqstring))
REq2=xmg.compgen.Rule.Rule(Eq,(sqstring,equal,Pred))
REq3=xmg.compgen.Rule.Rule(Eq,(sqstring,equal,List))
#RPred=xmg.compgen.Rule.Rule(Pred,(_id,openpred,ids_coma,closepred))
RPred=xmg.compgen.Rule.Rule(Pred,(sqstring,openpred,ids_coma,closepred))
RIdsComa1=xmg.compgen.Rule.Rule(ids_coma,(sqstring,))
RIdsComa2=xmg.compgen.Rule.Rule(ids_coma,(sqstring,coma,ids_coma))

RList1=xmg.compgen.Rule.Rule(List,(openlist,ListEnum,closelist))
RList2=xmg.compgen.Rule.Rule(List,(openlist,ListCons,closelist))
#RIdsComa1=xmg.compgen.Rule.Rule(ids_coma,(_id,))
#RIdsComa2=xmg.compgen.Rule.Rule(ids_coma,(_id,coma,ids_coma))


# Grammar file
S=xmg.compgen.Symbol.NT("S")
Decls=xmg.compgen.Symbol.NT("Decls")
Decl=xmg.compgen.Symbol.NT("Decl")
Rules=xmg.compgen.Symbol.NT("Rules")
RDecls=xmg.compgen.Rule.Rule(Decls,(Decl,))
RDecls1=xmg.compgen.Rule.Rule(Decls,(Decl,Decls))
RDecl=xmg.compgen.Rule.Rule(Decl,(TD,))
RDecl1=xmg.compgen.Rule.Rule(Decl,(NTD,))
RDecl2=xmg.compgen.Rule.Rule(Decl,(EXTD,))
RRules=xmg.compgen.Rule.Rule(Rules,(RuD,))
RRules1=xmg.compgen.Rule.Rule(Rules,(RuD,Rules,))
R=xmg.compgen.Rule.Rule(S,(Decls,endsection,Rules,endsection))

# S ::= Decls endsection Rules endSection
# Decls ::= Decl
#         | Decl Decls
# Rules ::= RuD
#         | RuD Rules
# RuD ::= Id : RuleParts
# RuleParts ::= RulePart ;
#             | RulePart|RuleParts
# RulePart ::= Ids | Ids { Action }
# Ids ::= Id | Id Ids
# Decl ::= TD | NTD
# TD ::= %token Id
# NTD ::= %type Id Id

G=xmg.compgen.Grammar.Grammar((R,RID,RID2,RID3,RID4,RT,RNT,REXT,RRu,RRu1,RRu2,RRu3,RRu4,RDecls,RDecls1,RDecl,RDecl1,RDecl2,RRules,RRules1,RAction1,RAction2,RAction3,RActionP1,REq1,REq2,REq3,RPred,RIdsComa1,RIdsComa2,RList1,RList2,RListEnum,RListCons))


