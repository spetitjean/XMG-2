%%include sem.mac

*ENTRY: aimer
*CAT: v
*SEM: binaryRel[theta1=agent,rel=aimer,theta2=patient]
*ACC: 1
*FAM: n0Vn1
*FILTERS: []
*EX: {}
*EQUATIONS:
*COANCHORS:

*ENTRY: dormir
*CAT: v
*SEM: unaryRel[theta1=agent,rel=dormir]
*ACC: 1
*FAM: n0V
*FILTERS: []
*EX: {}
*EQUATIONS:
anc -> aux = avoir
anc -> aux-refl = -
*COANCHORS:

*ENTRY: appeler
*CAT: v
*SEM: binaryRel[theta1=agent,rel=appeler,theta2=patient]
*ACC: 1
*FAM: n0Vn1
*FILTERS: []
*EX: {}
*EQUATIONS:
*COANCHORS:

*ENTRY: avoir
*CAT: v
*SEM:
*ACC: 1
*FAM: Copule
*FILTERS: []
*EX: {}
*EQUATIONS:
*COANCHORS:

*ENTRY: etre
*CAT: v
*SEM:
*ACC: 1
*FAM: Copule
*FILTERS: []
*EX: {}
*EQUATIONS:
*COANCHORS:

*ENTRY: il
*CAT: cl
*SEM: basicProperty[rel=il]
*ACC: 1
*FAM: Clitic
*FILTERS: []
*EX: {}
*EQUATIONS:
*COANCHORS:

*ENTRY: jean
*CAT: n
*SEM: basicProperty[rel=jean]
*ACC: 1
*FAM: propername
*FILTERS: []
*EX: {}
*EQUATIONS:
anc -> gen = m
anc -> det = +
*COANCHORS:

*ENTRY: marie
*CAT: n
*SEM: basicProperty[rel=marie]
*ACC: 1
*FAM: propername
*FILTERS: []
*EX: {}
*EQUATIONS:
anc -> gen = f
anc -> det = +
*COANCHORS:

*ENTRY: par
*CAT: p
*SEM: 
*ACC: 1
*FAM: void
*FILTERS: []
*EX: {}
*EQUATIONS:
*COANCHORS:

*ENTRY: qui
*CAT: c
*SEM: 
*ACC: 1
*FAM: void
*FILTERS: []
*EX: {}
*EQUATIONS:
*COANCHORS:
