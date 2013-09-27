from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def ADisj(prefix='ADisj'):
    ADisjLang = BrickGrammar('contributions/ADisj/bricks/xmg-adisj.xmg', prefix=prefix)
    return Brick(ADisjLang,'ADisj')
