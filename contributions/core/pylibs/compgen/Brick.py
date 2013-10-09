# A brick is a language brick, associated to a compiler brick

class Brick(object):

#    def __init__(self, language_brick, compiler_brick):
#        self.language_brick=language_brick
#        self.compiler_brick=compiler_brick

    def connect(self, ext, brick):
        self.language_brick.connect(ext,brick.language_brick)

    def __init__(self, name, prefix=None):
        self._name = name
        self._lang = None
        self._prefix = name if prefix is None else prefix

    @property
    def lang_def_pathname(self):
        import xmg, os.path
        xmg_data_rootdir = xmg.config['DEFAULT']['xmg_data_rootdir']
        return os.path.join(xmg_data_rootdir, "xmg/brick/%s/lang.def" % self._name)

    @property
    def compiler_pathname(self):
        import xmg, os.path
        xmg_yap_rootdir = xmg.config['DEFAULT']['xmg_yap_rootdir']
        return os.path.join(xmg_yap_rootdir, "xmg/brick/%s/compiler" % self._name)

    @property
    def language_brick(self):
        if self._lang is None:
            from core.compiler_generator.BrickGrammar import BrickGrammar
            self._lang = BrickGrammar(self.lang_def_pathname, prefix=self._prefix)
        return self._lang
        
