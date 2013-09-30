from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def MG(prefix='XMG'):
    MGLang = BrickGrammar('contributions/MG/bricks/MG/xmg-mg.xmg', prefix=prefix)

    return Brick(MGLang,'MG')
