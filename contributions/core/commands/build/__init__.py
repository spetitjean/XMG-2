from xmg.command import subparsers

#==============================================================================
# xmg build
#==============================================================================

# the function implementing the command
def handler_xmg_build(args):
    import yaml
    desc = yaml.load(open("compiler.yml"))
    from xmg.command.build.BrickSpec import \
     yaml_to_specs, determine_axioms, build_and_connect
    specs = yaml_to_specs(desc)
    axioms = determine_axioms(specs)
    build_and_connect(specs)
    from xmg.compgen.BrickCompiler import BrickCompiler
    compiler = BrickCompiler("generated", "generated/parser.yap")
    for b in specs.values():
        compiler.add_brick(b.brick, dim=b.brick.is_dimension)
    axiom_id = list(axioms)[0]
    compiler.generate_parser(specs[axiom_id].brick)
    compiler.generate_all()

# create the xmg subcommand
cmd = subparsers.add_parser(
    "build", description="generate the code for a metagrammar compiler from the description in compiler.yaml")
cmd.set_defaults(handler=handler_xmg_build)

# add options and arguments here

