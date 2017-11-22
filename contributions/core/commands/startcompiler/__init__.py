from xmg.command import subparsers
import fileinput
import re
import shutil

#==============================================================================
# xmg startcompiler NAME
#==============================================================================

COMPDEF = """
"""

# the function implementing the command
def handler_xmg_startcompiler(args):
    import os, os.path
    if not (os.path.islink(".xmg/type") and os.readlink(".xmg/type")=="CONTRIBUTION"):
        raise RuntimeError("startcompiler must be invoked at the top-level of a contribution")
    name = args.name
    path = os.path.join("compilers", name)
    if os.path.lexists(path):
        raise RuntimeError("%s exists already" % path)
    os.makedirs(path, exist_ok=True)
    os.makedirs(os.path.join(path, "generated"))
    with open(os.path.join(path, "compiler.yml"),'w') as f:
        f.write(COMPDEF % {"name": name})
    # create the yap files from patterns
    patterndir=os.path.dirname(os.path.realpath(__file__))+"/patterns/generated"
    yap_files = os.listdir(patterndir) 
    for yap_file in yap_files:
        print(yap_file)
        full_yap_file = os.path.join(patterndir, yap_file)
        print(full_yap_file)     
        if (os.path.isfile(full_yap_file)):
            print(" is file ")
            shutil.copy(full_yap_file, path+"/generated")
            newfile=path+"/generated/"+yap_file

# create the xmg subcommand
cmd = subparsers.add_parser(
    "startcompiler", description="start a new compiler brick")
cmd.set_defaults(handler=handler_xmg_startcompiler)

# add options and arguments here
cmd.add_argument("name", metavar="NAME")
