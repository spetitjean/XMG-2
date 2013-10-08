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
        d = os.path.realpath(d)
        self.install_bricks(d)
        self.install_commands(d)
        self.install_pylibs(d)
        self.install_yaplibs(d)

    def ensure_dirs(self, d):
        os.makedirs(d, exist_ok=True)

    def link_directory(self, old, new):
        if os.path.lexists(new):
            if os.path.islink(new) and os.path.realpath(old) == os.path.realpath(new):
                return
            raise RuntimeError("conflict linking %s -> %s" % (new, old))
        self.ensure_dirs(os.path.dirname(new))
        os.symlink(old, new, target_is_directory=True)

    def link_directory_if_exists(self, old, new):
        if os.path.lexists(old):
            self.link_directory(old, new)

    def link_file(self, old, new):
        if os.path.lexists(new):
            if os.path.islink(new) and os.path.realpath(old) == os.path.realpath(new):
                return
            raise RuntimeError("conflict linking %s -> %s" % (new, old))
        self.ensure_dirs(os.path.dirname(new))
        os.symlink(old, new, target_is_directory=False)

    def link_file_if_exists(self, old, new):
        if os.path.lexists(old):
            self.link_file(old, new)

    def subdirs(self, d):
        l=[]
        d=os.path.realpath(d)
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
        for name in bricks:
            self.install_brick(name, os.path.join(bricks_dir, name))

    def install_brick(self, name, path):
        brick_dir_yap = os.path.join(self.yap_rootdir, "xmg/brick", name)
        brick_dir_data = os.path.join(self.data_rootdir, "xmg/brick", name)
        self.link_file_if_exists(
            os.path.join(path, "lang.def"),
            os.path.join(brick_dir_data, "lang.def"))
        self.link_directory_if_exists(
            os.path.join(path, "compiler"),
            os.path.join(brick_dir_yap, "compiler"))
        yaplib = os.path.join(path, "yaplib")
        for subdir in self.subdirs(yaplib):
            self.link_directory(
                subdir,
                os.path.join(brick_dir_yap, os.path.basename(subdir)))
        for yapfile in self.yapfiles(yaplib):
            self.link_file(
                yapfile,
                os.path.join(brick_dir_yap, os.path.basename(yapfile)))

    def extfiles(self, path, ext):
        import glob
        return (os.path.realpath(f)
                for f in glob.glob(os.path.join(path, "*.%s" % ext))
                if os.path.isfile(f))

    def pyfiles(self, path):
        return self.extfiles(path, "py")

    def yapfiles(self, path):
        return self.extfiles(path, "yap")

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

    def install_compilers(self, d):
        compiler_dir = os.path.join(d, "compilers")
        compilers = self.subdirs(compilers_dir)
        if not compilers:
            return
        xmg_compilers_dir = os.path.join(self.python_rootdir, "xmg/compiler")
        self.ensure_dirs(xmg_compilers_dir)
        for name in compilers:
            self.link_directory(os.path.join(compilers_dir, name),
                                os.path.join(xmg_compilers_dir, name))

    def install_pylibs(self, d):
        libraries_dir = os.path.realpath(os.path.join(d, "pylibs"))
        libraries = self.subdirs(libraries_dir)
        xmg_library_dir = os.path.join(self.python_rootdir, "xmg")
        if libraries:
            self.ensure_dirs(xmg_library_dir)
            for name in libraries:
                self.link_directory(os.path.join(libraries_dir, name),
                                    os.path.join(xmg_library_dir, name))
        import glob
        libraries = glob.glob(os.path.join(libraries_dir, "*.py"))
        if libraries:
            self.ensure_dirs(xmg_library_dir)
            for path in libraries:
                self.link_file(path, os.path.join(xmg_library_dir, os.path.basename(path)))

    def install_yaplibs(self, d):
        libraries_dir = os.path.realpath(os.path.join(d, "yaplibs"))
        libraries = self.subdirs(libraries_dir)
        xmg_library_dir = os.path.join(self.yap_rootdir, "xmg")
        if libraries:
            self.ensure_dirs(xmg_library_dir)
            for name in libraries:
                self.link_directory(os.path.join(libraries_dir, name),
                                    os.path.join(xmg_library_dir, name))
        import glob
        libraries = glob.glob(os.path.join(libraries_dir, "*.yap"))
        if libraries:
            self.ensure_dirs(xmg_library_dir)
            for path in libraries:
                self.link_file(path, os.path.join(xmg_library_dir, os.path.basename(path)))

def handler_xmg_install(args):
    installer = ContribInstaller()
    installer.run(args.contrib)

cmd = subparsers.add_parser(
    "install", description="install a contribution")
cmd.add_argument("contrib", metavar="CONTRIB", nargs='?', default=".")
cmd.set_defaults(handler=handler_xmg_install)
