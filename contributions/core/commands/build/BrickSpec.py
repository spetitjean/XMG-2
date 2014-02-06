from xmg.compgen.BrickSpec import BrickSpec

def yaml_to_specs(desc):
    table = {}
    for name, plugs in desc.items():
        for bs in BrickSpec.make(name, plugs):
            if bs.name in table:
                raise Exception("BrickSpec collision: %s" % br.name)
            table[bs.name] = bs
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
        for k,plugs in b.plugs.items():
            for plug in plugs:
                b.brick.connect(k, plug.brickspec.brick, plug.symbol_name)
