from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Sem(prefix='sem'):
    SemLang = BrickGrammar('contributions/sem/bricks/xmg-sem.xmg', prefix=prefix, dim=True)

    return Brick(SemLang,'sem')
