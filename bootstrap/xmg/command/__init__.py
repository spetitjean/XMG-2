import argparse

parser = argparse.ArgumentParser(description="XMG metagrammar compiler")
subparsers = parser.add_subparsers()

def load_commands():
    import xmg.command.bootstrap
    import xmg.command.install
    import xmg, importlib
    for name in xmg.config['COMMANDS']['commands'].strip().split():
        importlib.import_module("xmg.command.%s" % name)

YAPDIR = None

#==============================================================================
# parse the command line and run the appropriate command
#==============================================================================

def main():
    load_commands()
    args = parser.parse_args()
    args.handler(args)
