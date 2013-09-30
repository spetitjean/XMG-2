import os
from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Control(prefix='Control'):
    CtrlLang = BrickGrammar(os.path.dirname(__file__)+'/xmg-control.xmg', prefix=prefix)

    return Brick(CtrlLang,'Control')
