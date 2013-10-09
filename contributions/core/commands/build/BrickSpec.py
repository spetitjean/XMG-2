class BrickSpec:

    def __init__(self, name, plugs):
        import re
        name_regex = re.compile(r"^([A-Za-z][A-Za-z0-9]*)(.*)$")
        m = name_regex.match(name)
        if not m:
            raise RuntimeError("unparseable identifier in compiler.yml: %s" % name)
        self.name = name
        self.brick_name = m.group(1)
        self.plugs = plugs

    def deref_plugs(self, table):
        plugs = {}
        for k,v in self.plugs.items():
            brs = []
            for id in v.strip().split():
                br = table.get(id, None)
                if id is None:
                    raise RuntimeError("unknown identifier in compiler.yml: %s" id)
                brs.append(br)
            plugs[k] = brs
        self.plugs = plugs

def yaml_to_specs(desc):
    table = {}
    for name, plugs in desc.items():
        table[name] = BrickSpec(name, plugs)
    for spec in table.values():
        spec.deref_plugs(table)
