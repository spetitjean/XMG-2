import os
from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Value(prefix='Value'):
    ValueLang = BrickGrammar(os.path.dirname(__file__)+'/xmg-value.xmg', prefix=prefix)

    return Brick(ValueLang,'Value')
