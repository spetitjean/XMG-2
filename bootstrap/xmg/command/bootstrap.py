from xmg.command import subparsers
import xmg, os, os.path

#==============================================================================
# xmg bootstrap
#==============================================================================

def handler_xmg_bootstrap(args):
    xmg_srcdir = xmg.config['DEFAULT']['xmg_srcdir']
    python_rootdir = xmg.config['DEFAULT']['xmg_python_rootdir']
    xmg_dir = os.path.join(python_rootdir, "xmg")
    xmg_command_dir = os.path.join(xmg_dir, "command")
    os.makedirs(xmg_command_dir, exist_ok=True)
    #
    def link_file(src, dst):
        src = os.path.join(xmg_srcdir, src)
        src = os.path.realpath(src)
        dst = os.path.join(xmg_dir, dst)
        if os.path.lexists(dst):
            os.unlink(dst)
        os.symlink(src, dst)
    # link in the bootstrap files
    link_file("bootstrap/xmg/__init__.py", "__init__.py")
    link_file("bootstrap/xmg/command/__init__.py", "command/__init__.py")
    link_file("bootstrap/xmg/command/bootstrap.py", "command/bootstrap.py")
    link_file("bootstrap/xmg/command/install.py", "command/install.py")
    # record initial set of commands
    command_list = xmg.config['COMMANDS']['commands'].strip().split()
    if "bootstrap" not in command_list:
        command_list.append("bootstrap")
    if "install" not in command_list:
        command_list.append("install")
    xmg.config['COMMANDS']['commands'] = " ".join(command_list)
    xmg.config.save()

cmd = subparsers.add_parser(
    "bootstrap", description="bootstrap the xmg installation")
cmd.set_defaults(handler=handler_xmg_bootstrap)
