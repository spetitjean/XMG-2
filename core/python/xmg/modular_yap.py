# -*- mode:python; coding:utf-8 -*-

import subprocess, sys

class YAP(subprocess.Popen):

    def __init__(self, load=None, goal=None, **kargs):
        call = ['yap']
        pregoals = []
        import xmg.modular_program
        if xmg.modular_program.YAPDIR is not None:
            pregoals.append("asserta(file_search_path(library,'%s'))" % xmg.modular_program.YAPDIR)
        if load is not None:
            pregoals.append("consult(library('%s'))" % load)
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
    def xmg_compile(cls, compiler, filename, debug, latin, **kargs):
        import xmg.modular_program
        if debug:
            xmgDebug="xmg_compiler:debug_mode_on,"
        else:
            xmgDebug=""
        if latin:
            xmgLatin=", iso_latin_1"
        else:
            xmgLatin=", utf8"
        xmgCompiler="use_module(\'"+xmg.modular_program.YAPDIR+"/compilers/"+compiler+"/conf\'),"
        return cls(load="core/cmd/xmg_cmd_compile",
                   goal=xmgDebug+xmgCompiler+"xmg_compiler:compile_file('%s',A"  % filename +"),halt",
                   **kargs)

  
