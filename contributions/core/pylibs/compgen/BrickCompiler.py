import os, sys

class BrickCompiler(object):

    def __init__(self, folder=None, parser_file=None):
        self._folder     = folder
        self._parser_file= parser_file
        self._languages  = []
        self._compilers  = []
        self._dimensions = []
        #self._links      = dict()
        self._links      = []
        self._dims       = []
        self._dimsp      = ['trace-TRACE']
        self._accs       = ['xmg_acc:trace']
        self._accs_init  = ['xmg_acc:trace(TRACE)']
        self._dimbricks  = dict()
        self._punctuation= []
        self._keywords   = []

    def set_folder(self,folder):
        self._folder=folder

    def set_parser_file(self,path):
        self._parser_file=path

    def add_language(self,lang,dim=False):
        self._languages.append(lang)
        if dim :
            self._dimensions.append(lang)

    def add_languages(self,langs,dim=False):
        for lang in langs:
            self.add_language(lang,dim)
        

    def add_compiler(self,comp):
        self._compilers.append(comp)

    def add_compilers(self,comps):
        for comp in comps:
            self.add_compiler(comp)
        

    def add_link(self,language,compiler):
        print(language)
        if not language in self._languages:
            raise Exception("Brick "+language._prefix+" is not part of the compiler, try one of "+self._languages)
        if not compiler in self._compilers:
            raise Exception("Brick "+compiler+" is not part of the compiler")
        #self._links[language]=compiler
        if language._prefix == 'control':
            self._links.append((language,compiler))
        elif language._prefix == 'mg':
            self._links.insert(0,(language,compiler))
        else:
            self._links.insert(1,(language,compiler))

    def add_links(self,links):
        for (language,compiler) in links:
            self.add_link(language,compiler)

    def add_brick(self,brick,dim=False):
        self.add_language(brick.language_brick,dim)
        self.add_compiler(brick.compiler_brick)
        self.add_link(brick.language_brick,brick.compiler_brick)

    def init_dims(self):
        if self._dimensions == [] :
            raise Exception("No dimensions")
        for brick in self._dimensions:
            # Create accumulator in yap, and do the add_path and use_module
            dim=brick._prefix.lower()
            DIM=dim.capitalize()
            self._dimsp.append(dim+'-'+dim.capitalize())
            self._dims.append(dim)
            self._accs.append('xmg_acc:'+dim)
            self._accs_init.append('xmg_acc:'+dim+'('+DIM+')')
            self._dimbricks[dim]=brick._name

    def generate_dimensions(self):
        dimfile=open(self._folder+"/dimensions.yap","w")
        dimfile.write('%% -*- prolog -*-\n\n')
        dimfile.write(':-module(xmg_dimensions).\n\n')
        self.init_dims()
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        dimfile.write('%% Dimensions initialization\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')


        dimfile.write('dims([')
        dimfile.write(", ".join(self._dimsp))
        dimfile.write(', trace-Trace]).\n\n')
        dimfile.close()
        print("Dimensions generated in "+self._folder)

    def generate_edcg(self):
        dimfile=open(self._folder+"/edcg.yap","w")
        dimfile.write('%% -*- prolog -*-\n\n')
        dimfile.write(':-module(xmg_edcg).\n\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        dimfile.write('%% Threads initialization\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')
        
        for dim in self._dims:
            dimbrick=self._dimbricks[dim]
            import xmg
            yapdir=xmg.config['DEFAULT']['xmg_yap_rootdir']
            print(yapdir)
            if os.path.exists(yapdir+'/xmg/brick/'+dimbrick+'/compiler/edcg.yap'):
                dimfile.write(':-edcg:thread(xmg_acc:'+dim+', xmg_brick_'+dimbrick+'_edcg:accu_type).\n\n')
            else:
                dimfile.write(':-edcg:thread(xmg_acc:'+dim+', edcg:stack).\n\n')

        dimfile.write(':-edcg:thread(xmg_acc:trace, edcg:stack).\n\n')



        dimfile.write(':-edcg:weave(['+", ".join(self._accs)+'],[xmg:value_class/3]).\n\n')

        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        dimfile.write('%% Starting valuation\n')
        dimfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

        accs=", ".join(self._dimsp)

        dimfile.write('xmg:start_value_class(Class,['+accs+']):--\n')
        dimfile.write('  xmg:value_class(Class,_,_) with ('+", ".join(self._accs_init))
        dimfile.write(').')

        print("Threads generated in "+self._folder)
        dimfile.close()

        
    def generate_tokenize_dims(self):
        tokenizefile=open(self._folder+"/tokenizer_dims.yap","w")
        tokenizefile.write('%% -*- prolog -*-\n\n')
        tokenizefile.write(':-module(xmg_tokenizer).\n\n')
        tokenizefile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        tokenizefile.write('%% Part of tokenizer\n')
        tokenizefile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

        # To be replaced by 
        # dim('dim').
        # and (but maybe already generated with punctuation)
        # punctuation('<dim>') -->> input_gets("<dim>"),!.
        for dim in self._dims:
            tokenizefile.write('dim(\'<'+dim+'>\') -->> input_gets("'+dim+'"),!. \n')
            tokenizefile.write('dim(dim(\''+dim+'\')) -->> input_gets("<'+dim+'>"),!.\n')   

        print("Part of tokenizer generated in "+self._folder)

    def collect_punctuation(self):
        for lang in self._languages:
            #print(lang._punctuation)
            for npunct in lang._punctuation:
                if npunct not in self._punctuation and npunct > '':
                    #print(npunct)
                    self._punctuation.append(npunct)
        #print(self._punctuation)
        self._punctuation.sort(reverse=True)
        #print(self._punctuation)

    def collect_keywords(self):
        for lang in self._languages:
            #print(lang._punctuation)
            for nkey in lang._keywords:
                if nkey not in self._keywords and nkey > '':
                    #print(npunct)
                    self._keywords.append(nkey)
        #print(self._punctuation)
        self._keywords.sort(reverse=True)
        #print(self._punctuation)


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
        print("Part of tokenizer generated in "+self._folder)

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
        print("Part of tokenizer generated in "+self._folder)

    def generate_unfold_rules(self):
        unfoldfile=open(self._folder+"/unfolder.yap","w")
        unfoldfile.write('%% -*- prolog -*-\n\n')
        unfoldfile.write(':-module(xmg_unfolder_control).\n\n')
        unfoldfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        unfoldfile.write('%% Part of unfolding\n')
        unfoldfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

        for dim in self._dims:
            unfoldfile.write('unfold_stmt([\''+dim+'-DimStmt\'(Stmt)],\''+dim+'Stmt\'(UStmt)):-\n')
            unfoldfile.write('    Stmt=..[\''+dim+'-DimStmt\',token(_,\'<\'),token(_,\''+dim+'\'),token(_,\'>\'),token(_,\'{\'),DimStmt,token(_,\'}\')],!,\n')
            #unfoldfile.write('    add_to_path(\''+dim+'\'),\n')
            unfoldfile.write('    use_module(\'xmg_unfolder_'+dim+'\'),\n')
            unfoldfile.write('    xmg_unfolder_'+dim+':unfold(DimStmt,UStmt).\n\n')      
        unfoldfile.close()
        print("Part of unfolder generated in "+self._folder)


    def generate_gen_rules(self):
        genfile=open(self._folder+"/generator.yap","w")
        genfile.write('%% -*- prolog -*-\n\n')
        genfile.write(':-module(xmg_generator_control).\n\n')
        genfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        genfile.write('%% Part of generation\n')
        genfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')  
        for dim in self._dims:
            genfile.write('generate_dimStmt(\''+dim+'Stmt\'(Stmt),List,Class,Generated):-\n')
            genfile.write('    use_module(\'xmg_generator_'+dim+'\'),\n')
            genfile.write('    xmg_generator_'+dim+':generate_Stmt(Stmt,List,Class,Generated).\n\n')   
        genfile.close()
        print("Part of generator generated in "+self._folder)

    def generate_modules(self):
        compfile=open(self._folder+"/modules_def.yap","w")
        compfile.write('%% -*- prolog -*-\n\n')
        compfile.write(':-module(xmg_modules_def).\n\n')
        compfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        compfile.write('%% Part of modules\n')
        compfile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n') 
        ## MG must be the first module, and Control the last one !
        # for comp in self._links:
        #     compfile.write('module_def(\''+comp._prefix+'\',\''+self._links[comp]+'\').\n')
        for (comp,brick) in self._links:
            compfile.write('module_def(\''+comp._prefix+'\',\''+brick+'/loader\').\n')
        compfile.close()
        print("Part of modules generated in "+self._folder)

    # def generate_conf(self,path):
    #     conffile=open(path,"w")
    #     conffile.write('%% -*- prolog -*-\n\n')
    #     conffile.write(':-module(xmg_compiler_conf).\n\n')
    #     conffile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
    #     conffile.write('%% Compiler Configuration\n')
    #     conffile.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n') 
    #     conffile.write('init:-\n')
    #     conffile.write('\tuse_module(\'' + self._parser_file + '\'),\n')
    #     conffile.write('\tadd_to_path(\'' + self._folder + '\'),\n')
    #     conffile.write('\tuse_module(\'xmg_dimensions\'),\n')
    #     conffile.write('\tuse_module(\'xmg_modules_def\').')
    #     conffile.close()
    #     print("Configuration file generated in "+path)

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
        #conffile.write('\tadd_to_path(\'' + os.path.abspath(os.path.dirname(sys.argv[0])) + '\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/' + self._parser_file + '\'),\n')
        #conffile.write('\tadd_to_path(\'' + os.path.join(os.path.abspath(os.path.dirname(sys.argv[0])), self._folder) + '\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/dimensions\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/tokenizer_punct\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/tokenizer_keywords\'),\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/modules_def\').\n\n')
        conffile.write('init_threads:-\n')
        conffile.write('\tuse_module(\'xmg/compiler/'+compName+'/generated/edcg\').')
        conffile.close()
        print("Configuration file generated in "+self._folder)

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
            self.generate_tokenize_punctuation()
            self.generate_tokenize_keywords()
            #self.generate_tokenize_dims()
            self.generate_modules()
            self.generate_edcg()
            self.generate_conf()
        else:
            raise Exception("No directory set for the compiler")

            
