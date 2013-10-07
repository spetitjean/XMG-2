from xmg.command import subparsers

#==============================================================================
# xmg startyaplib NAME
#==============================================================================

# the function implementing the command
def handler_xmg_startyaplib(args):
    import os, os.path
    if not (os.path.islink(".xmg/type") and os.readlink(".xmg/type")=="CONTRIBUTION"):
        raise RuntimeError("startyaplib must be invoked at the top-level of a contribution")
    name = args.name
    if args.directory:
        path = os.path.join("yaplibs", name)
        if os.path.lexists(path):
            raise RuntimeError("%s exists already" % path)
        os.makedirs(path, exist_ok=True)
    else:
        path = os.path.join("yaplibs", "%s.yap" % name)
        if os.path.lexists(path):
            raise RuntimeError("%s exists already" % path)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "wt") as f:
            f.write(FORMAT % {"name": name})


FORMAT = """%%==============================================================================
%% module xmg_%(name)s
%%==============================================================================

:- module(xmg_%(name)s).
"""


# create the xmg subcommand
cmd = subparsers.add_parser(
    "startyaplib", description="start a new yap library module")
cmd.set_defaults(handler=handler_xmg_startyaplib)

# add options and arguments here
cmd.add_argument("name", metavar="NAME")
cmd.add_argument("--directory", "-d", action='store_true')
