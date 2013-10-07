import configparser, os, os.path, sys

class _ConfigParser(configparser.ConfigParser):

    def __init__(self):
        super(_ConfigParser, self).__init__()
        filenames = []
        filenames.append(os.path.join(os.path.dirname(__file__),"config.cfg"))
        try:
            from xmg.treeview.install_prefix import install_prefix
            filenames.append(os.path.join(install_prefix,
                                          "share","xmg","treeview","config.cfg"))
        except:
            pass
        filenames.append(os.path.expanduser("~/.config/xmg/treeview/config.cfg"))
        self.read(filenames)

    def save(self):
        filename = os.path.expanduser("~/.config/xmg/treeview/config.cfg")
        dirname = os.path.dirname(filename)
        if not os.path.exists(dirname):
            os.mkdirs(dirname)
        with open(filename,"w") as f:
            self.write(f)

config = _ConfigParser()
