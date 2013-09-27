import pylr.BrickTokenizer
import pylr.Parser
import pylr.user_parser
import pylr.Unfold

y=pylr.Parser.Parser(pylr.user_parser.G,pylr.BrickTokenizer.BrickTokenizer,'meta_morph/xmg-mg.xmg')

params=dict()

params['XMG']=dict()
# in xmg-mg : 
params['XMG']['Stmt']=[('xmg-control','Control')]

params['Control']=dict()
# in xmg-control :
params['Control']['DimStmt']=[('xmg-morph','morph'),('xmg-syn','syn'),('xmg-pg','pg'),('xmg-phon','phon'),('xmg-sem','sem')]

params['pg']=dict()
params['syn']=dict()
# in xmg-pg and xmg-syn :
params['syn']['AVM']=[('xmg-avm','SAVM')]
params['pg']['AVM']=[('xmg-avm','PAVM')]

params['SAVM']=dict()
params['PAVM']=dict()
# in xmg-avm :
params['SAVM']['Value']=[('xmg-value','Value')]
params['SAVM']['ADisj']=[('xmg-adisj','ADisj')]
params['PAVM']['Value']=[('xmg-value','Value'),('this','PAVM')]

G=pylr.Unfold.Unfold(y.sem[0],params)
for Rule in G.grammar.rules:
    print(Rule)
G.grammar.lr1.parser()

################################################
# Code Generator :
################################################

dimfile=open("XMG/xmg_generated_dimensions.yap","w")
dimfile.write('%% -*- prolog -*-\n\n')
dimfile.write('module(xmg_dimensions).\n\n')
dims=[]
dimsp=[]
for (descFile,dim) in params['Control']['DimStmt']:
    # Create accumulator in yap, and do the add_path and use_module
    dimsp.append(dim+'-'+dim.capitalize())
    dims.append(dim)
    
dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
dimfile.write('%% Dimensions initialization\n')
dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')


dimfile.write('dims(')
dimfile.write(", ".join(dimsp))
dimfile.write(').\n\n')

# Should be done in unfolder_control, but later

# unfolding 
# <dim>{Contrib}
# calling the right unfolder (dim/unfolder_dim) for Contrib

dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
dimfile.write('%% Part of unfolding\n')
dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

for dim in dims:
    dimfile.write('unfold_stmt([\''+dim+'-DimStmt\'(Stmt)],\''+dim+'Stmt\'(UStmt)):-\n')
    dimfile.write('    Stmt=..[\''+dim+'-DimStmt\',token(_,\'<\'),token(_,\''+dim+'\'),token(_,\'>\'),token(_,\'{\'),DimStmt,token(_,\'}\')],!,\n')
    dimfile.write('    add_to_path(\''+dim+'\'),\n')
    dimfile.write('    use_module(\'xmg_unfolder_'+dim+'\'),\n')
    dimfile.write('    xmg_unfolder_'+dim+':unfold_'+dim+'Stmts(DimStmt,UStmt).\n\n')

# generating
# <dim>{Contrib}
# calling the right generator (dim/generator_dim) for Contrib

dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
dimfile.write('%% Part of generation\n')
dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

for dim in dims:
    dimfile.write('generate_dimStmt(\''+dim+'Stmt\'(Stmt),List,Class,Generated):-\n')
    dimfile.write('    use_module(\'xmg_generator_'+dim+'\'),\n')
    dimfile.write('    xmg_generator_'+dim+':generate_Stmt(Stmt,List,Class,Generated).\n\n')
    

# for all non control param (and non MG param), generate the unfold predicate in the right file.
# params['pg']['AVM']=[('xmg-avm','PAVM')]
# -> in unfolder pg, unfold_PAVM

    


