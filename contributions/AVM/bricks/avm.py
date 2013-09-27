from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def AVM(prefix='AVM'):
    AVMLang = BrickGrammar('contributions/AVM/bricks/xmg-avm.xmg', prefix=prefix)

    return Brick(AVMLang,'AVM')
