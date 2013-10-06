import configparser, os.path
__all__ = ('config',)

config = None
def load_inifile(inifile):
    global config
    config = configparser.ConfigParser()
    config.read(inifile)
