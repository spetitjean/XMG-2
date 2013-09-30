import os
from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Feats(prefix='feats'):
    FeatsLang = BrickGrammar(os.path.dirname(__file__)+'/xmg-decls-feats.xmg', prefix=prefix)

    return Brick(FeatsLang,'feats')
