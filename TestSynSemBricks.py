from core.compiler_generator.BrickCompiler import BrickCompiler
from core.compiler_generator.BrickGrammar import BrickGrammar
from core.compiler_generator.skeleton import generate_compiler_brick
from contributions.MG.bricks.MG.mg import MG
from contributions.Decls.bricks.Decls.decls import Decls
from contributions.feats.bricks.feats.feats import Feats
from contributions.Control.bricks.Control.control import Control
from contributions.AVM.bricks.AVM.avm import AVM
from contributions.Value.bricks.Value.value import Value
from contributions.ADisj.bricks.ADisj.adisj import ADisj
from contributions.sem.bricks.sem.sem import Sem
from contributions.syn.bricks.syn.syn import Syn
 

MG=MG()
Decls=Decls()
Feats=Feats()
Control=Control()
AVM=AVM()
Value=Value()
ADisj=ADisj()
Sem=Sem()
Syn=Syn()

#generate_compiler_brick('test', MG.language_brick._unfold, 'src/yap/xmg')

Compiler = BrickCompiler('compilers/test','compilers/test/generated_parser_test.yap')

MG.connect('Stmt',Control)
MG.connect('EDecls',Decls)
Decls.connect('ODecl',Feats)
Control.connect('IFace',AVM)
AVM.connect('Value',Value)
Value.connect('Else',AVM)
Value.connect('ADisj',ADisj)
Control.connect('DimStmt',Sem)
Control.connect('DimStmt',Syn)
Syn.connect('AVM',AVM)

Compiler.add_brick(MG)
Compiler.add_brick(Decls)
Compiler.add_brick(Feats)
Compiler.add_brick(Control)
Compiler.add_brick(AVM)
Compiler.add_brick(ADisj)
Compiler.add_brick(Value)
Compiler.add_brick(Sem,dim=True)
Compiler.add_brick(Syn,dim=True)

Compiler.generate_parser(MG)
Compiler.generate_all()
