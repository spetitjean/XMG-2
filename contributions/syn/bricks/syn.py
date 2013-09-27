from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Syn(prefix='syn'):
    SynLang = BrickGrammar('contributions/syn/bricks/xmg-syn.xmg', prefix=prefix, dim=True)

    return Brick(SynLang,'syn')
