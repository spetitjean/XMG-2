import os
from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Syn(prefix='syn'):
    SynLang = BrickGrammar(os.path.dirname(__file__)+'/xmg-syn.xmg', prefix=prefix, dim=True)

    return Brick(SynLang,'syn')
