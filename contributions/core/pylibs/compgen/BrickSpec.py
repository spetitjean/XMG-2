class BrickSpec:

    @staticmethod
    def make(name, plugs):
        import re, importlib
        name_regex = re.compile(r"^([A-Za-z][A-Za-z0-9]*)(.*)$")
        m = name_regex.match(name)
        if not m:
            raise RuntimeError("unparseable identifier in compiler.yml: %s" % name)
        name = re.sub("[^A-Za-z0-9]", "_", name)
        brick_name = m.group(1)
        try:
            mod = importlib.import_module("xmg.brick.%s.brickspec" % brick_name)
            clsname = brick_name.capitalize() + "BrickSpec"
            #print(clsname)
            cls = getattr(mod, clsname)
        except ImportError:
            cls = BrickSpec
        #print(name)
        #print(str(cls))
        ret=cls.create(name, brick_name, plugs)
        #print(ret)
        return ret

    @classmethod
    def create(cls, *args):
        yield cls(*args)

    def __init__(self, name, brick_name, plugs, dim=False):
        self.name = name
        self.brick_name = brick_name
        self.dim = dim
        # added the option to have none as value for a plug
        self.plugs = {k:[Plug(s) for s in v.split()] for k,v in plugs.items() if v is not None}

    def deref_plugs(self, table):
        for plugs in self.plugs.values():
            for plug in plugs:
                br = table.get(plug.brick_name)
                if br is None:
                    for br in BrickSpec.make(plug.brick_name, {}):
                        if br.name in table:
                            raise Exception("BrickSpec collision: %s" % br.name)
                        table[br.name] = br
                plug.brickspec = table[plug.brick_name]

    def create_brick(self):
        from xmg.compgen.Brick import Brick
        # prefix voir si self.name != self.brick_name
        self.brick = Brick(self.brick_name, prefix=self.name, dim=self.dim)
        self.init_brick(self.brick)

    def init_brick(self, brick):
        pass

class Plug:

    def __init__(self, spec):
        if "." in spec:
            bname,sname = spec.split(".", 1)
            self.brick_name = bname
            self.symbol_name = sname
        else:
            self.brick_name = spec
            self.symbol_name = None

_COUNTER = 0
def counter():
    global _COUNTER
    _COUNTER += 1
    return _COUNTER
