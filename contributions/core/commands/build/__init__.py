from xmg.command import subparsers

#==============================================================================
# xmg build
#==============================================================================

# the function implementing the command
def handler_xmg_build(args):
    import yaml
    desc = yaml.load(open("compiler.yml"))
    from xmg.command.build.BrickSpec import yaml_to_specs
    specs = yaml_to_specs(desc)

# create the xmg subcommand
cmd = subparsers.add_parser(
    "build", description="generate the code for a metagrammar compiler from the description in compiler.yaml")
cmd.set_defaults(handler=handler_xmg_build)

# add options and arguments here

