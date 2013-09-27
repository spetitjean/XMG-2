from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Control(prefix='Control'):
    CtrlLang = BrickGrammar('contributions/Control/bricks/xmg-control.xmg', prefix=prefix)

    return Brick(CtrlLang,'Control')
