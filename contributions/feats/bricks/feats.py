from core.compiler_generator.Brick import Brick
from core.compiler_generator.BrickGrammar import BrickGrammar

def Feats(prefix='feats'):
    FeatsLang = BrickGrammar('contributions/feats/bricks/xmg-decls-feats.xmg', prefix=prefix)

    return Brick(FeatsLang,'feats')
