import os, sys, glob, xmg.command

class BrickCompiler(object):

    def __init__(self, folder=None, parser_file=None):
        self._folder     = folder
        self._parser_file= parser_file
        self._languages  = []
        self._compilers  = []
        self._dimensions = [('trace','trace')]
        self._links      = []
        self._punctuation= []
        self._keywords   = []
        self._solvers    = dict()
        self._tags       = dict()

    def set_folder(self,folder):
        self._folder=folder

    def set_parser_file(self,path):
        self._parser_file=path

    def add_language(self,lang):
        self._languages.append(lang)
  

    def add_languages(self,langs):
        for lang in langs:
            self.add_language(lang)
        

    def add_compiler(self,comp):
        if comp in self._compilers:
            pass
        else:
            # add dependencies
            yapdir=xmg.config['DEFAULT']['xmg_yap_rootdir']
            deppath=yapdir+"/"+comp+"/compiler/deps"
            if(os.path.exists(deppath)):
                depfile=open(deppath,"r")
                for line in depfile:
                    print("\nAdding dependency:")
                    print(line)
                    self.add_compiler(line)
            basename = os.path.basename(comp)
            if basename== "mg":
                self._compilers=[comp]+self._compilers
            elif basename== "dim":
                if len(self._compilers) > 1:
                    self._compilers.insert(1,comp)
            else:
                self._compilers.append(comp)

    def add_compilers(self,comps):
        for comp in comps:
            self.add_compiler(comp)
        

    def add_link(self,language,compiler):
        if not language in self._languages:
            raise Exception("Brick "+language._prefix+" is not part of the compiler, try one of "+self._languages)
        if not compiler in self._compilers:
            raise Exception("Brick "+compiler+" is not part of the compiler")
        self._links.append((language,compiler))
    

    def add_links(self,links):
        for (language,compiler) in links:
            self.add_link(language,compiler)

    def add_brick(self,brick,dim=False):
        self.add_language(brick.language_brick)
        self.add_compiler(brick.compiler_brick)
        self.add_link(brick.language_brick,brick.compiler_brick)
        if brick._solver is not None:
            self._solvers[brick._prefix]=brick._solver
        if brick._tag is not None:
            self._tags[brick._prefix]=brick._tag
        if dim:
            self._dimensions.append((brick._tag,brick._dimbrick))
 

    def generate_dimensions(self):
        dimfile=open(self._folder+"/dimensions.yap","w")
        dimfile.write('%% -*- prolog -*-\n\n')
        dimfile.write(':-module(xmg_dimensions).\n\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        dimfile.write('%% Dimensions initialization\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

        for (dim,dimbrick) in self._dimensions:
            dimfile.write('xmg:dimbrick(')
            dimfile.write(dim)
            dimfile.write(',')
            dimfile.write(dimbrick)
            dimfile.write(').\n')
            
        dimfile.close()
        print("Dimensions generated in %s/dimensions.yap"%self._folder)

    def generate_solvers(self):
        dimfile=open(self._folder+"/solvers.yap","w")
        dimfile.write('%% -*- prolog -*-\n\n')
        dimfile.write(':-module(xmg_solvers).\n\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        dimfile.write('%% Solvers bindings to dimensions\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

        if not self._solvers:
            dimfile.write('xmg:solver(_,_):- false.\n')
        for solver in self._solvers:
            dimfile.write('xmg:solver(')
            dimfile.write(self._tags[solver])
            dimfile.write(',')
            dimfile.write(self._solvers[solver])
            dimfile.write(').\n')
        dimfile.close()
        print("Solvers bindings generated in %s/solvers.yap"%self._folder)

    def generate_edcg(self):
        dimfile=open(self._folder+"/edcg.yap","w")
        dimfile.write('%% -*- prolog -*-\n\n')
        dimfile.write(':-module(xmg_edcg).\n\n')
        dimfile.write(':-xmg:edcg.\n\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        dimfile.write('%% Threads initialization\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')
        
        dimsp=[]
        accs=[]
        accspairs=[]
        accs_init=[]
        for (dim,dimbrick) in self._dimensions:
            dimsp.append(dim+"-"+str.capitalize(dim))
            accs.append('xmg_acc:%s' % dim)
            accspairs.append('')
            accs_init.append('xmg_acc:%s(%s)' % (dim,str.capitalize(dim)))



        for (dim,dimbrick) in self._dimensions:
            import xmg
            yapdir=xmg.config['DEFAULT']['xmg_yap_rootdir']
            if os.path.exists(yapdir+'/xmg/brick/'+dimbrick+'/compiler/edcg.yap'):
                dimfile.write(':-edcg:thread(xmg_acc:'+dim+', xmg_brick_'+dimbrick+'_edcg:accu_type).\n\n')
            else:
                dimfile.write(':-edcg:thread(xmg_acc:'+dim+', edcg:stack).\n\n')

        #dimfile.write(':-edcg:thread(xmg_acc:trace, edcg:stack).\n\n')
        dimfile.write(':-edcg:weave(['+", ".join(accs)+'],[xmg:value_class/3]).\n\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        dimfile.write('%% Starting valuation\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

        accs=", ".join(dimsp)

        dimfile.write('xmg:start_value_class(Class,['+accs+']):--\n')
        dimfile.write('  xmg:value_class(Class,_,_) with ('+", ".join(accs_init))
        dimfile.write(').')

        print("Threads generated in %s/edcg.yap"%self._folder)
        dimfile.close()


    def collect_punctuation(self):
        for lang in self._languages:
            for npunct in lang._punctuation:
                if npunct not in self._punctuation and npunct > '':
                    self._punctuation.append(npunct)
        self._punctuation.sort(reverse=True)

    def collect_keywords(self):
        for lang in self._languages:
            for nkey in lang._keywords:
                if nkey not in self._keywords and nkey > '':
                    self._keywords.append(nkey)
        self._keywords.sort(reverse=True)


    def generate_tokenize_punctuation(self):
        self.collect_punctuation()
        tokenizefile=open(self._folder+"/tokenizer_punct.yap","w")
        tokenizefile.write('%% -*- prolog -*-\n\n')
        tokenizefile.write(':-module(xmg_tokenizer_punct).\n\n')
        tokenizefile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        tokenizefile.write('%% Part of tokenizer\n')
        tokenizefile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')
        if not self._punctuation:
            tokenizefile.write('xmg:punctuation(_):- false.\n')

        
        for punct in self._punctuation:
            #tokenizefile.write('punctuation(\''+punct+'\') -->> input_gets("'+punct+'"), !.\n')
            tokenizefile.write('xmg:punctuation(\''+punct+'\').\n')

        tokenizefile.close()
        print("Part of tokenizer generated in %s/tokenizer_punct.yap"%self._folder)

    def generate_tokenize_keywords(self):
        self.collect_keywords()
        tokenizefile=open(self._folder+"/tokenizer_keywords.yap","w")
        tokenizefile.write('%% -*- prolog -*-\n\n')
        tokenizefile.write(':-module(xmg_tokenizer_keywords).\n\n')
        tokenizefile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        tokenizefile.write('%% Part of tokenizer\n')
        tokenizefile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')
        if not self._keywords:
            tokenizefile.write('xmg:keyword(_):- false.\n')

        
        for key in self._keywords:
            #tokenizefile.write('punctuation(\''+punct+'\') -->> input_gets("'+punct+'"), !.\n')
            tokenizefile.write('xmg:keyword(\''+key+'\').\n')

        tokenizefile.close()
        print("Part of tokenizer generated in %s/tokenizer_keywords.yap"%self._folder)

    def generate_loader(self):
        compfile=open(self._folder+"/loader.yap","w")
        compfile.write('%% -*- prolog -*-\n\n')
        compfile.write(':-module(xmg_loader).\n\n')
        compfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        compfile.write('%% Loader\n')
        compfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n') 
        import glob
        yapdir= xmg.command.YAPDIR 
        for comp in self._compilers:  
            for yapfile in glob.glob("%s/%s/*.yap" % (yapdir,comp)):
                compfile.write(':-use_module(\'%s\').\n' % yapfile)
            yapfiles=glob.glob("%s/%s/compiler/*.yap" % (yapdir,comp))
            yapfiles.sort()
            for yapfile in yapfiles:
                # if a loader is there, do not load it, to avoid double imports
                if not os.path.basename(yapfile)=="loader.yap": 
                    compfile.write(':-use_module(\'%s\').\n' % yapfile)
        for solver in self._solvers:
            for yapfile in glob.glob("%s/xmg/brick/%s/*.yap" % (yapdir,self._solvers[solver])):
                compfile.write(':-use_module(\'%s\').\n' % yapfile)
            for yapfile in glob.glob("%s/xmg/brick/%s/compiler/*.yap" % (yapdir,self._solvers[solver])):
                 # if a loader is there, do not load it, to avoid double imports
                if not os.path.basename(yapfile)=="loader.yap": 
                    compfile.write(':-use_module(\'%s\').\n' % yapfile)
        print("Modules loader generated in %s/loader.yap"%self._folder)


    def generate_conf(self):
        compPath=os.getcwd()
        compSplit=compPath.split('/')
        compName=compSplit[len(compSplit)-1]
        conffile=open(self._folder+"/conf.yap","w")
        conffile.write('%% -*- prolog -*-\n\n')
        conffile.write(':-module(xmg_compiler_conf).\n\n')
        conffile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        conffile.write('%% Compiler Configuration\n')
        conffile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n') 
        conffile.write('init:-\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/' + self._parser_file + '\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/dimensions\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/tokenizer_punct\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/tokenizer_keywords\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/loader\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/solvers\').\n\n')
        conffile.write('init_threads:-\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/edcg\').')
        conffile.close()
        print("Configuration file generated in %s/conf.yap"%self._folder)

    def generate_parser(self,Brick):
        if self._parser_file is not None:
            #Brick.generate_parser(self._parser_file)
            Brick.language_brick.generate_parser(self._parser_file)
        else:
            raise Exception("No file set to generate the parser")


    def generate_all(self):
        directory=self._folder
        if not os.path.exists(directory):
            os.makedirs(directory)            
        if directory is not None:
            self.generate_dimensions()
            self.generate_solvers()
            self.generate_tokenize_punctuation()
            self.generate_tokenize_keywords()
            self.generate_loader()
            self.generate_edcg()
            self.generate_conf()
        else:
            raise Exception("No directory set for the compiler")

            
