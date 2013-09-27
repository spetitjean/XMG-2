from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Value(prefix='Value'):
    ValueLang = BrickGrammar('contributions/Value/bricks/xmg-value.xmg', prefix=prefix)

    return Brick(ValueLang,'Value')
