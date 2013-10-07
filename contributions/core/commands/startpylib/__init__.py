from xmg.command import subparsers

#==============================================================================
# xmg startpylib NAME
#==============================================================================

# the function implementing the command
def handler_xmg_startpylib(args):
    import os, os.path
    if not (os.path.islink(".xmg/type") and os.readlink(".xmg/type")=="CONTRIBUTION"):
        raise RuntimeError("startpylib must be invoked at the top-level of a contribution")
    name = args.name
    path = os.path.join("pylibs", name)
    if os.path.lexists(path):
        raise RuntimeError("%s exists already" % path)
    os.makedirs(path, exist_ok=True)
    init_file = os.path.join(path, "__init__.py")
    with open(init_file, "wt") as f:
        f.write(FORMAT % {"name": name})


FORMAT = """#==============================================================================
# module xmg.%(name)s
#==============================================================================
"""

# create the xmg subcommand
cmd = subparsers.add_parser(
    "startpylib", description="start a new python directory-module")
cmd.set_defaults(handler=handler_xmg_startpylib)

# add options and arguments here
cmd.add_argument("name", metavar="NAME")
