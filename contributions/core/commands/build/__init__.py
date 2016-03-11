from xmg.command import subparsers
from collections import OrderedDict
import yaml


#==============================================================================
# xmg build
#==============================================================================

# the function implementing the command
def handler_xmg_build(args):
    #desc = yaml.load(open("compiler.yml"))
    desc = ordered_load(open("compiler.yml"))
    #print(desc)
    from xmg.command.build.BrickSpec import \
     yaml_to_specs, determine_axioms, build_and_connect
    specs = yaml_to_specs(desc)
    axioms = determine_axioms(specs)
    build_and_connect(specs)
    from xmg.compgen.BrickCompiler import BrickCompiler
    compiler = BrickCompiler("generated", "generated/parser.yap")
    for b in specs.values():
        compiler.add_brick(b.brick, dim=b.brick.is_dimension)
        print("\nAdding "+b.brick._prefix+", dimension: "+str(b.dim))
    axiom_id = list(axioms)[0]
    compiler.generate_parser(specs[axiom_id].brick)
    compiler.generate_all()

# create the xmg subcommand
cmd = subparsers.add_parser(
    "build", description="generate the code for a metagrammar compiler from the description in compiler.yaml")
cmd.set_defaults(handler=handler_xmg_build)

# add options and arguments here

# Customize yaml.load to get an ordered structure

def ordered_load(stream, Loader=yaml.Loader, object_pairs_hook=OrderedDict):
    class OrderedLoader(Loader):
        pass
    def construct_mapping(loader, node):
        loader.flatten_mapping(node)
        return object_pairs_hook(loader.construct_pairs(node))
    OrderedLoader.add_constructor(
        yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
        construct_mapping)
    return yaml.load(stream, OrderedLoader)
