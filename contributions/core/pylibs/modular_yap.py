# -*- mode:python; coding:utf-8 -*-

import subprocess, sys

class YAP(subprocess.Popen):

    def __init__(self, load=None, goal=None, **kargs):
        call = ['yap']
        pregoals = []
        #import xmg.modular_program
        import xmg.command
        #if xmg.modular_program.YAPDIR is not None:
        if xmg.command.YAPDIR is not None:
            pregoals.append("asserta(file_search_path(library,'%s'))" % xmg.command.YAPDIR)
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
        #import xmg.modular_program
        import xmg.command
        if debug:
            xmgDebug="xmg_bricks_mg_compiler:debug_mode_on,"
        else:
            xmgDebug=""
        if latin:
            xmgLatin=", iso_latin_1"
        else:
            xmgLatin=", utf8"
        xmgCompiler="use_module(\'"+xmg.command.YAPDIR+"/contributions/"+compiler+"/compilers/synsem/generated/conf\'),"
        return cls(load="core/cmd/xmg_cmd_compile",
                   goal=xmgDebug+xmgCompiler+"xmg_bricks_mg_compiler:compile_file('%s',A"  % filename +"),halt",
                   **kargs)

  
