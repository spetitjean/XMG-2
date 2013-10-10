from xmg.command import subparsers

#==============================================================================
# xmg startbrick NAME
#==============================================================================

LANGDEF = """
"""

CONFDEF = """[DEFAULT]
dimension = no
"""

# the function implementing the command
def handler_xmg_startbrick(args):
    import os, os.path
    if not (os.path.islink(".xmg/type") and os.readlink(".xmg/type")=="CONTRIBUTION"):
        raise RuntimeError("startbrick must be invoked at the top-level of a contribution")
    name = args.name
    path = os.path.join("bricks", name)
    if os.path.lexists(path):
        raise RuntimeError("%s exists already" % path)
    os.makedirs(path, exist_ok=True)
    os.makedirs(os.path.join(path, "compiler"))
    os.makedirs(os.path.join(path, "yaplib"))
    with open(os.path.join(path, "lang.def")) as f:
        f.write(LANGDEF % {"name": name})
    with open(os.path.join(path, "config.ini")) as f:
        f.write(CONFDEF % {"name": name})

# create the xmg subcommand
cmd = subparsers.add_parser(
    "startbrick", description="start a new language brick")
cmd.set_defaults(handler=handler_xmg_startbrick)

# add options and arguments here
cmd.add_argument("name", metavar="NAME")
