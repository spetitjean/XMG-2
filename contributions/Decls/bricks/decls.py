from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Decls(prefix='Decls'):
    DeclLang = BrickGrammar('contributions/Decls/bricks/xmg-decls.xmg', prefix=prefix)

    return Brick(DeclLang,'Decls')
