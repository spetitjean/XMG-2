import pylr.compiler_generator.Symbol
import pylr.compiler_generator.Grammar

# Punctuation
semicolon=pylr.compiler_generator.Symbol.T(";")
colon=pylr.compiler_generator.Symbol.T(":")
pipe=pylr.compiler_generator.Symbol.T("|")
quote=pylr.compiler_generator.Symbol.T("'")
arrow=pylr.compiler_generator.Symbol.T("->")
endsection=pylr.compiler_generator.Symbol.T("%%")


_id=pylr.compiler_generator.Symbol.T("identifier")
sqstring=pylr.compiler_generator.Symbol.T("sqstring")
_ids_or_t=pylr.compiler_generator.Symbol.NT("ids_or_t")
_id_or_t=pylr.compiler_generator.Symbol.NT("id_or_t")
RID=pylr.compiler_generator.Rule.Rule(_ids_or_t,(_id_or_t,))
RID2=pylr.compiler_generator.Rule.Rule(_ids_or_t,(_id_or_t,_ids_or_t))
RID3=pylr.compiler_generator.Rule.Rule(_id_or_t,(_id,))
RID4=pylr.compiler_generator.Rule.Rule(_id_or_t,(sqstring,))



# Terminals
TD=pylr.compiler_generator.Symbol.NT("TD")
T=pylr.compiler_generator.Symbol.T("%token")
RT=pylr.compiler_generator.Rule.Rule(TD,(T,_id))


# Non-terminals
NTD=pylr.compiler_generator.Symbol.NT("NTD")
NT=pylr.compiler_generator.Symbol.T("%type")
RNT=pylr.compiler_generator.Rule.Rule(NTD,(NT,_id,_id))

# Externs
EXTD=pylr.compiler_generator.Symbol.NT("EXTD")
EXT=pylr.compiler_generator.Symbol.T("%ext")
REXT=pylr.compiler_generator.Rule.Rule(EXTD,(EXT,_id,_id))

# Rules
RuD=pylr.compiler_generator.Symbol.NT("RuD")
RuleParts=pylr.compiler_generator.Symbol.NT("RuleParts")
RulePart=pylr.compiler_generator.Symbol.NT("RulePart")
RRu=pylr.compiler_generator.Rule.Rule(RuD,(_id,colon,RuleParts))
RRu1=pylr.compiler_generator.Rule.Rule(RuleParts,(RulePart,semicolon))
RRu2=pylr.compiler_generator.Rule.Rule(RuleParts,(RulePart,pipe,RuleParts))
RRu3=pylr.compiler_generator.Rule.Rule(RulePart,(_ids_or_t,))

# Grammar file
S=pylr.compiler_generator.Symbol.NT("S")
Decls=pylr.compiler_generator.Symbol.NT("Decls")
Decl=pylr.compiler_generator.Symbol.NT("Decl")
Rules=pylr.compiler_generator.Symbol.NT("Rules")
RDecls=pylr.compiler_generator.Rule.Rule(Decls,(Decl,))
RDecls1=pylr.compiler_generator.Rule.Rule(Decls,(Decl,Decls))
RDecl=pylr.compiler_generator.Rule.Rule(Decl,(TD,))
RDecl1=pylr.compiler_generator.Rule.Rule(Decl,(NTD,))
RDecl2=pylr.compiler_generator.Rule.Rule(Decl,(EXTD,))
RRules=pylr.compiler_generator.Rule.Rule(Rules,(RuD,))
RRules1=pylr.compiler_generator.Rule.Rule(Rules,(RuD,Rules,))
R=pylr.compiler_generator.Rule.Rule(S,(Decls,endsection,Rules,endsection))

# S ::= Decls endsection Rules endSection
# Decls ::= Decl
#         | Decl Decls
# Rules ::= RuD
#         | RuD Rules
# RuD ::= Id : RuleParts
# RuleParts ::= RulePart ;
#             | RulePart|RuleParts
# RulePart ::= Ids
# Ids ::= Id | Id Ids
# Decl ::= TD | NTD
# TD ::= %token Id
# NTD ::= %type Id Id

G=pylr.compiler_generator.Grammar.Grammar((R,RID,RID2,RID3,RID4,RT,RNT,REXT,RRu,RRu1,RRu2,RRu3,RDecls,RDecls1,RDecl,RDecl1,RDecl2,RRules,RRules1))


