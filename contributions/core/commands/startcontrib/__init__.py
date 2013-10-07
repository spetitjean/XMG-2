from xmg.command import subparsers

#==============================================================================
# xmg startcontrib NAME
#==============================================================================

def handler_xmg_startcontrib(args):
    import os, os.path
    name = args.name
    if os.path.exists(args.name):
        raise RuntimeError("%s already exists" % name)
    path = os.path.realpath(name)
    dotxmg = os.path.join(path, ".xmg")
    os.makedirs(dotxmg)
    typepath = os.path.join(dotxmg, "type")
    os.symlink('CONTRIBUTION', typepath)

cmd = subparsers.add_parser(
    "startcontrib", description="start a new contribution")
cmd.add_argument("name", metavar="NAME")
cmd.set_defaults(handler=handler_xmg_startcontrib)
