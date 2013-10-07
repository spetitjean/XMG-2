import argparse

parser = argparse.ArgumentParser(description="XMG metagrammar compiler")
subparsers = parser.add_subparsers()

def load_commands():
    import xmg, importlib
    for name in xmg.config['COMMANDS']['commands'].strip().split():
        importlib.import_module("xmg.command.%s" % name)
