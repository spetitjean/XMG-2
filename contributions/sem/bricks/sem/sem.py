import os
from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Sem(prefix='sem'):
    SemLang = BrickGrammar(os.path.dirname(__file__)+'/xmg-sem.xmg', prefix=prefix, dim=True)

    return Brick(SemLang,'sem')
