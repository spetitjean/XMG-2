from xmg.command import subparsers
 
#------------------------------------------------------------------------------
# xmg COMPILER gui [IFILE]
#------------------------------------------------------------------------------

def handler_xmg_gui(args):
    import xmg.treeview.PyTreeView as PyTreeView
    if args.type is None:
        parser.exit(status=1, message="type is required\n") 
 
    if args.input is None:
        PyTreeView.main(formalism=args.type)
    else: 
        # call PyTreeView with input loaded
        PyTreeView.main([args.input])

cmd = subparsers.add_parser(
    "gui", description="view a resource")
cmd.add_argument("type", metavar="TYPE", help="TYPE (formalism)")
cmd.add_argument("--input","-i", metavar="IFILE", help="XML file",
                 default=None)
cmd.add_argument("input", nargs='?', default=None, help="Grammar file")
cmd.set_defaults(handler=handler_xmg_gui)
