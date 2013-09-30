import os
from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def AVM(prefix='AVM'):
    AVMLang = BrickGrammar(os.path.dirname(__file__)+'/xmg-avm.xmg', prefix=prefix)

    return Brick(AVMLang,'AVM')
