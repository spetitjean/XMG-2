import configparser, os.path
__all__ = ('config',)

config = None

class XMGConfigParser(configparser.ConfigParser):

    def __init__(self, inifile):
        self.__inifile = inifile
        super().__init__()
        self.read(inifile)

    def save(self):
        with open(self.__inifile, "wt") as f:
            self.write(f)

def load_inifile(inifile):
    global config
    config = XMGConfigParser(inifile)
