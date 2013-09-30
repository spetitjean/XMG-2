import os
from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def ADisj(prefix='ADisj'):
    ADisjLang = BrickGrammar(os.path.dirname(__file__)+'/xmg-adisj.xmg', prefix=prefix)
    return Brick(ADisjLang,'ADisj')
