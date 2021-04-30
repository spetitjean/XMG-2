from xmg.command import parser, subparsers
from shutil import which

YAPDIR = '.install/yap'

#------------------------------------------------------------------------------
# xmg compile COMPILER IFILE [OFILE]
#------------------------------------------------------------------------------

def handler_xmg_compile(args):
    import os, os.path, xmg.modular_yap
    YAPDIR = xmg.command.YAPDIR
    if args.compiler is None:
        parser.exit(status=1, message="compiler is required\n") 
    compilers_dir=YAPDIR+'/xmg/compiler/'
    if not os.path.exists(compilers_dir+args.compiler):
        comps=""
        for comp in os.listdir(compilers_dir):
            comps=comps+" "+comp
        parser.exit(status=1, message=args.compiler+" is not a compiler, try one of:\n"+comps+"\n")
    if args.input is None:
        parser.exit(status=1, message="input file is required\n")
    if args.output is not None and \
       not args.output == "-" and \
       os.path.exists(args.output) and \
       not args.force:
        parser.exit(status=1, message="output file already exists, use --force to overwrite\n") 
    # call the compiler and configure the output 
    if args.output is not None:
        if args.output == "-":
            rename=""
        else: rename=args.output
    else: 
        rename_input=os.path.splitext(args.input)[0]
        if not args.json:
            rename=str(rename_input)+".xml"
        else:
            rename=str(rename_input)+".json"            
    if not rename == "":
        if os.path.exists(rename) and not args.force:
            parser.exit(status=1, message=rename+" already exists, use --force to overwrite\n") 
        if os.path.exists(rename) and args.force:
            os.remove(rename)
        file=os.open(rename,os.O_RDWR|os.O_CREAT)
        yap_out= os.fdopen(file)
    else : yap_out=1
    YAP=xmg.modular_yap.YAP.xmg_compile(args.compiler,args.input,args.debug,args.json,args.latin,args.notype,args.more,args.hierarchy,stdout=yap_out)
    try:
        YAP.communicate()
    finally:
        YAP.maybe_kill()
    if os.path.exists('.more'):
        more_path = '.'.join(rename.split('.')[:-1])+'_more.mac'
        print('An additional file was created, moving it to the file: '+more_path)
        os.rename('.more',more_path)
    if os.path.exists('.class_hierarchy'):
        class_hierarchy_dir = rename.replace('.xml','') + '_class_hierarchy'
        print('Hierarchy graphs were generated, moving them to the directory: '+class_hierarchy_dir)
        if os.path.exists(class_hierarchy_dir):
            for dotfile in os.listdir(class_hierarchy_dir):
                os.remove(class_hierarchy_dir+'/'+dotfile)
            os.rmdir(class_hierarchy_dir)
        os.rename('.class_hierarchy',class_hierarchy_dir)
        if which('dot') is not None:
            print('Dot installed, generating the pdf files')
            for dotfile in os.listdir(class_hierarchy_dir):
                os.system('dot '+class_hierarchy_dir+'/'+dotfile+' -O -Tpdf')
        else:
            print('Dot not found')
        
    if not rename == "":
        parser.exit(status=0, message="Resource produced in file '%s'\n" % rename )
    else:
        parser.exit(status=0)


cmd = subparsers.add_parser(
    "compile", description="compile a metagrammar")
cmd.add_argument("--force","-f", action='store_true',
                 help='overwrite the output file if it exists')
cmd.add_argument("compiler", metavar="COMPILER", help="compiler")
cmd.add_argument("--output","-o", metavar="OFILE", help="XML grammar file",
                 default=None)
cmd.add_argument("input", metavar="IFILE", help="metagrammar file")
cmd.add_argument("output", nargs='?', default=None)
cmd.add_argument("--debug", action='store_true', help="Prints some useful information")
cmd.add_argument("--json", action='store_true', help="Use JSON as output language (default: XML)")
cmd.add_argument("--latin", action='store_true', help="iso_latin_1 mode")
cmd.add_argument("--notype", action='store_true', help="Cancels type checking (not recommanded)")
cmd.add_argument("--more", action='store_true', help="Creates additional files when needed")
cmd.add_argument("--hierarchy", action='store_true', help="Generates graphs for the class hierarchy")
cmd.set_defaults(handler=handler_xmg_compile)
