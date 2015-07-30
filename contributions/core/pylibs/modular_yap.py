# -*- mode:python; coding:utf-8 -*-

import subprocess, sys

class YAP(subprocess.Popen):

    def __init__(self, load=None, goal=None, **kargs):
        call = ['yap']
        pregoals = []
        #import xmg.modular_program
        import xmg.command
        #if xmg.modular_program.YAPDIR is not None:
        print(xmg.command.YAPDIR)
        if xmg.command.YAPDIR is not None:
            pregoals.append("add_to_path('%s')" % xmg.command.YAPDIR)
        pregoals.append("use_module(\'%s/xmg/brick/mg/compiler/compiler.yap\')" % xmg.command.YAPDIR)
        if pregoals:
            call.extend(['-g',",".join(pregoals)])
        if goal is not None:
            call.extend(['-z',goal])
        super(YAP, self).__init__(call, **kargs)
     

    def maybe_kill(self):
        try:
            self.kill()
        except:
            pass

    @classmethod
    def xmg_compile(cls, compiler, filename, debug, latin, types, **kargs):
        #import xmg.modular_program
        import xmg.command
        if debug:
            xmgDebug="on"
        else:
            xmgDebug="off"
        if types:
            xmgType="on"
        else:
            xmgType="off"
        if latin:
            xmgLatin="iso_latin_1"
        else:
            xmgLatin="utf8"
        xmgCompiler="use_module('%s/xmg/compiler/%s/generated/conf')," % (xmg.command.YAPDIR, compiler)
        return cls(
                   goal=xmgCompiler+"xmg_brick_mg_compiler:compile_file('%s',A,%s,%s,%s)" % (filename,xmgLatin,xmgDebug,xmgType),
                   **kargs)

  
