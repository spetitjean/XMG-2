from xmg.command import subparsers

#==============================================================================
# xmg startcommand NAME
#==============================================================================

def handler_xmg_startcommand(args):
    import os, os.path
    if not (os.path.islink(".xmg/type") and os.readlink(".xmg/type")=="CONTRIBUTION"):
        raise RuntimeError("startcommand must be invoked at the top-level of a contribution")
    name = args.name
    path = os.path.join("commands", name)
    if os.path.lexists(path):
        raise RuntimeError("%s exists already" % path)
    os.createdirs(path, exist_ok=True)
    init_file = os.path.join(path, "__init__.py")
    with open(init_file, "wt") as f:
        f.write(FORMAT % {"name": name})


FORMAT = """from xmg.command import subparsers

#==============================================================================
# xmg %(name)s ...
#==============================================================================

# the function implementing the command
def handler_xmg_%(name)s(args):
    pass

# create the xmg subcommand
cmd = subparsers.add_parser(
    "%(name)s", description="???")
cmd.set_defaults(handler=handler_xmg_startcommand)

# add options and arguments here

"""

cmd = subparsers.add_parser(
    "startcommand", description="add a new command to a contribution")
cmd.add_argument("name", metavar="NAME")
