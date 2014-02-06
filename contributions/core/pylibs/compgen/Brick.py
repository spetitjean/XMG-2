# A brick is a language brick, associated to a compiler brick

class Brick(object):

#    def __init__(self, language_brick, compiler_brick):
#        self.language_brick=language_brick
#        self.compiler_brick=compiler_brick

    def connect(self, ext, brick):
        self.language_brick.connect(ext,brick.language_brick)

    def __init__(self, name, prefix=None, text=None):
        self._name = name
        self._lang = None
        self._text = text
        self._prefix = name if prefix is None else prefix
        self._is_dimension = None
        self._config = None

    @property
    def lang_def_pathname(self):
        import xmg, os.path
        xmg_data_rootdir = xmg.config['DEFAULT']['xmg_data_rootdir']
        return os.path.join(xmg_data_rootdir, "xmg/brick/%s/lang.def" % self._name)

    @property
    def compiler_pathname(self):
        import xmg, os.path
        xmg_yap_rootdir = xmg.config['DEFAULT']['xmg_yap_rootdir']
        #return os.path.join(xmg_yap_rootdir, "xmg/brick/%s/compiler" % self._name)
        return "xmg/brick/%s/compiler" % self._name

    @property
    def language_brick(self):
        if self._lang is None:
            from xmg.compgen.BrickGrammar import BrickGrammar
            pathname = self.lang_def_pathname
            if self._text:
                import io
                pathname = io.StringIO(self._text)
            self._lang = BrickGrammar(pathname, dim=self.is_dimension, prefix=self._prefix)
        return self._lang
        
    @property
    def compiler_brick(self):
        return self.compiler_pathname

    @property
    def config(self):
        if self._config is None:
            import xmg, os.path
            xmg_data_rootdir = xmg.config['DEFAULT']['xmg_data_rootdir']
            ini = os.path.join(xmg_data_rootdir, "xmg/brick/%s/config.ini" % self._name)
            from configparser import ConfigParser
            self._config = ConfigParser()
            if os.path.exists(ini):
                self._config.read(ini)
        return self._config

    @property
    def is_dimension(self):
        return self.config.getboolean('DEFAULT', 'dimension', fallback=False)
