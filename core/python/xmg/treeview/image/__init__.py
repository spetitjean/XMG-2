import os.path

# look for images first relative to the module location
# then in the normal data directory

_DIR = os.path.dirname(__file__)
if not os.path.exists(os.path.join(_DIR,"about.png")):
    from xmg.treeview.install_prefix import install_prefix
    _DIR = os.path.join(install_prefix,"share","xmg","treeview")

ABOUT = os.path.join(_DIR, "about.png")
AIDE = os.path.join(_DIR, "aide.png")
CONFIG = os.path.join(_DIR, "config.png")
DIFF = os.path.join(_DIR, "diff.png")
IMAGE1 = os.path.join(_DIR, "image1.png")
IMAGE2 = os.path.join(_DIR, "image2.png")
IMAGE3 = os.path.join(_DIR, "image3.png")
IMAGE4 = os.path.join(_DIR, "image4.png")
MG = os.path.join(_DIR, "mg.png")
OPEN = os.path.join(_DIR, "open.png")
PREVIEW = os.path.join(_DIR, "preview.png")
PRINT = os.path.join(_DIR, "print.png")
QUIT = os.path.join(_DIR, "quit.png")
RELOAD = os.path.join(_DIR, "reload.png")
SAVE = os.path.join(_DIR, "save.png")
SEARCH = os.path.join(_DIR, "search.png")
TEST = os.path.join(_DIR, "test.png")
XML = os.path.join(_DIR, "xml.png")
ZOOMAR = os.path.join(_DIR, "zoomar.png")
ZOOMAV = os.path.join(_DIR, "zoomav.png")
