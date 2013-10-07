from xmg.command import subparsers
import xmg, os, os.path

#==============================================================================
# xmg install [CONTRIB]
#==============================================================================

class ContribInstaller:

    def __init__(self):
        self.python_rootdir = xmg.config['DEFAULT']['XMG_PYTHON_ROOTDIR']
        self.yap_rootdir = xmg.config['DEFAULT']['XMG_YAP_ROOTDIR']
        self.data_rootdir = xmg.config['DEFAULT']['XMG_DATA_ROOTDIR']

    def run(self, d):
        self.install_bricks(d)
        self.install_commands(d)

    def ensure_dirs(self, d):
        os.makedirs(d, exist_ok=True)

    def link_directory(self, old, new):
        if os.path.exists(new):
            if os.path.islink(new) and os.path.realpath(old) == os.path.realpath(new):
                return
            raise RuntimeError("conflict linking %s -> %s" % (_old, _new))
        os.symlink(old, new, target_is_directory=True)

    def subdirs(self, d):
        l=[]
        if os.path.isdir(d):
            for name in os.listdir(d):
                path = os.path.join(d, name)
                if os.path.isdir(path):
                    l.append(name)
        return l

    def install_bricks(self, d):
        bricks_dir = os.path.join(d, "bricks")
        bricks = self.subdirs(bricks_dir)
        if not bricks:
            return
        xmg_brick_dir = os.path.join(self.python_rootdir, "xmg/brick")
        self.ensure_dirs(xmg_brick_dir)
        for name in bricks:
            self.link_directory(os.path.join(bricks_dir, name),
                                os.path.join(xmg_brick_dir, name))

    def install_commands(self, d):
        commands_dir = os.path.realpath(os.path.join(d, "commands"))
        commands = self.subdirs(commands_dir)
        if not commands:
            return
        xmg_command_dir = os.path.join(self.python_rootdir, "xmg/command")
        self.ensure_dirs(xmg_command_dir)
        command_list = xmg.config['COMMANDS']['commands'].strip().split()
        for name in commands:
            self.link_directory(os.path.join(commands_dir, name),
                                os.path.join(xmg_command_dir, name))
            if name not in command_list:
                command_list.append(name)
        xmg.config['COMMANDS']['commands'] = " ".join(command_list)
        xmg.config.save()


def handler_xmg_install(args):
    installer = ContribInstaller()
    installer.run(args.contrib)

cmd = subparsers.add_parser(
    "install", description="install a contribution")
cmd.add_argument("contrib", metavar="CONTRIB", nargs='?', default=".")
cmd.set_defaults(handler=handler_xmg_install)