import argparse

parser = argparse.ArgumentParser(description="XMG metagrammar compiler")
subparsers = parser.add_subparsers()

def load_commands():
    import xmg.command.compile
    import xmg.command.gui
