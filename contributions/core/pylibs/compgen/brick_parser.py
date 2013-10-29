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
star=xmg.compgen.Symbol.T("*")
plus=xmg.compgen.Symbol.T("+")
question=xmg.compgen.Symbol.T("?")
sepMacro=xmg.compgen.Symbol.T("//")
endsection=xmg.compgen.Symbol.T("%%")

# Terminals
action=xmg.compgen.Symbol.T("action")
_id=xmg.compgen.Symbol.T("identifier")
sqstring=xmg.compgen.Symbol.T("sqstring")

# Non Terminals
Macro=xmg.compgen.Symbol.NT("Macro")
ID_MACRO=xmg.compgen.Symbol.NT("ID_MACRO")
MacroOp=xmg.compgen.Symbol.NT("MacroOp")
MacroOpP=xmg.compgen.Symbol.NT("MacroOpP")
MacroOpS=xmg.compgen.Symbol.NT("MacroOpS")
MacroOpQ=xmg.compgen.Symbol.NT("MacroOpQ")
IDS=xmg.compgen.Symbol.NT("IDS")
ID=xmg.compgen.Symbol.NT("ID")

RID=xmg.compgen.Rule.Rule(IDS,())
RID2=xmg.compgen.Rule.Rule(IDS,(ID_MACRO,IDS))

RID3=xmg.compgen.Rule.Rule(ID,(_id,))
RID4=xmg.compgen.Rule.Rule(ID,(sqstring,))

RID5=xmg.compgen.Rule.Rule(ID_MACRO,(Macro,))
RID6=xmg.compgen.Rule.Rule(ID_MACRO,(ID,))

RID7=xmg.compgen.Rule.Rule(Macro,(openpred,ID,closepred,MacroOp))
RID71=xmg.compgen.Rule.Rule(Macro,(openpred,ID,sepMacro,ID,closepred,MacroOp))

RID8=xmg.compgen.Rule.Rule(MacroOp,(MacroOpP,))
RID9=xmg.compgen.Rule.Rule(MacroOp,(MacroOpS,))
RID10=xmg.compgen.Rule.Rule(MacroOp,(MacroOpQ,))

RID11=xmg.compgen.Rule.Rule(MacroOpP,(plus,))
RID12=xmg.compgen.Rule.Rule(MacroOpS,(star,))
RID13=xmg.compgen.Rule.Rule(MacroOpQ,(question,))



# Parsing Terminals
TD=xmg.compgen.Symbol.NT("TD")
T=xmg.compgen.Symbol.T("%token")

RT=xmg.compgen.Rule.Rule(TD,(T,_id))


# Parsing Non-terminals
NTD=xmg.compgen.Symbol.NT("NTD")
NT=xmg.compgen.Symbol.T("%type")

RNT=xmg.compgen.Rule.Rule(NTD,(NT,_id,_id))

# Parsing Externs
EXTD=xmg.compgen.Symbol.NT("EXTD")
EXT=xmg.compgen.Symbol.T("%ext")

REXT=xmg.compgen.Rule.Rule(EXTD,(EXT,_id,_id))

# Parsing Rules
RuD=xmg.compgen.Symbol.NT("RuD")
RuleParts=xmg.compgen.Symbol.NT("RuleParts")
RulePart=xmg.compgen.Symbol.NT("RulePart")

RRu=xmg.compgen.Rule.Rule(RuD,(_id,colon,RuleParts))
RRu1=xmg.compgen.Rule.Rule(RuleParts,(RulePart,semicolon))
RRu2=xmg.compgen.Rule.Rule(RuleParts,(RulePart,pipe,RuleParts))
RRu3=xmg.compgen.Rule.Rule(RulePart,(IDS,))
RRu4=xmg.compgen.Rule.Rule(RulePart,(IDS,action))


# Grammar file
S=xmg.compgen.Symbol.NT("S")
Decls=xmg.compgen.Symbol.NT("Decls")
Decl=xmg.compgen.Symbol.NT("Decl")
Rules=xmg.compgen.Symbol.NT("Rules")
RDecls=xmg.compgen.Rule.Rule(Decls,())
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
# RulePart ::= Ids | Ids action
# Ids ::= Id_or_Macro | Id_or_Macro Ids
# Id_or_Macro ::= ( Ids ) MacOp | Id
# MacOp ::= MacOpP | MacOpS
# MacOpP ::= +
# MacOpS ::= *
# Decl ::= TD | NTD
# TD ::= %token Id
# NTD ::= %type Id Id

G=xmg.compgen.Grammar.Grammar((R,RID,RID2,RID3,RID4,RID5,RID6,RID7,RID71,RID8,RID9,RID10,RID11,RID12,RID13,RT,RNT,REXT,RRu,RRu1,RRu2,RRu3,RRu4,RDecls,RDecls1,RDecl,RDecl1,RDecl2,RRules,RRules1))


