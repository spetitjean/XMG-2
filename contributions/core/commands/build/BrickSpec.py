class BrickSpec:

    def __init__(self, name, plugs):
        import re
        name_regex = re.compile(r"^([A-Za-z][A-Za-z0-9]*)(.*)$")
        m = name_regex.match(name)
        if not m:
            raise RuntimeError("unparseable identifier in compiler.yml: %s" % name)
        self.name = re.sub("[^A-Za-z0-9]", "_", name)
        self.brick_name = m.group(1)
        self.plugs = plugs
        self.params = []
        if "_" in plugs:
            self.params = plugs["_"]
            del plugs["_"]

    def deref_plugs(self, table):
        plugs = {}
        for k,v in self.plugs.items():
            brs = []
            for id in v.strip().split():
                br = table.get(id, None)
                if br is None:
                    br = BrickSpec(id, {})
                    table[id] = br
                brs.append(br)
            plugs[k] = brs
        self.plugs = plugs

    def create_brick(self):
        from xmg.compgen.Brick import Brick
        # prefix voir si self.name != self.brick_name
        self.brick = Brick(self.brick_name, prefix=self.name)
        

def yaml_to_specs(desc):
    table = {}
    for name, plugs in desc.items():
        table[name] = BrickSpec(name, plugs)
    for spec in tuple(table.values()):
        spec.deref_plugs(table)
    return table

def determine_axioms(table):
    used = set()
    for s in table.values():
        for ps in s.plugs.values():
            for p in ps:
                used.add(p.name)
    axioms = set(table.keys()) - used
    return axioms

def build_and_connect(table):
    for b in table.values():
        b.create_brick()
    for b in table.values():
        for k,v in b.plugs.items():
            for b2 in v:
                b.brick.connect(k, b2.brick)
