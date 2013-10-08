# creates patterns for bricks

# language bricks (in language_bricks)

# compiler bricks : a folder containing an unfolder at least (in src/yap/xmg)
# if we have the language brick, the unfolder can be partly generated. If we don't, only generate the headings ?


# brick object associating the language and compiler bricks


def generate_language_brick(lpath):
    # tokens ? NTs ? Rules ? Exts ?
    pass

def generate_compiler_brick(name, grammar, cpath):
    # from the grammar, get the rules 
    # an unfolding rule for every rule
    file=open(cpath+"/xmg_unfolder"+name+".yap","w")
    file.write('%% -*- prolog -*-\n\n')
    file.write(':-module(xmg_unfolder_'+name+').\n\n')
    file.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
    file.write('%% Unfolder for '+name+'\n')
    file.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')

    for rule in grammar._Rules:
        file.write('unfold('+str(rule.head)+', [')
        file.write(", ".join(map(str,rule.body)))
        file.write('], '+str(rule.head)+'):-\n')
        for part in rule.body:
            file.write('    unfold('+str(part)+', '+'U'+str(part)+'),\n')
        file.write(',!.\n\n')

    ## and the generic unfolding rules

    file.write('%% GENERIC RULES\n\n')

    file.write('unfold(Term,UTerm):-\n')
    file.write('Term=..[Head|Params],\n')
    file.write('head_module(Head,Module),\n')
    file.write('(\n')
    file.write('(\n')
    file.write('Module='+name+',\n')
    file.write('unfold(Head,Params,UTerm)\n')
    file.write('    )\n')
    file.write(';\n')
    file.write('	(\n')
    file.write('	    not(Module='+name+'),\n')
    file.write('	    xmg_modules:get_module(Module,unfolder,UModule),\n')
    file.write('	    xmg_compiler:send(info, \'switching to \'),\n')
    file.write('	    xmg_compiler:send(info, UModule),\n')

    file.write('	    UModule:unfold(Term,UTerm)\n')
    file.write('	)\n')
    file.write('    ),!.\n\n')

    file.write('unfold(Rule,_):-\n') 
    file.write('	throw(xmg(unfolder_error(no_unfolding_rule('+name+',Rule)))),\n')	
    file.write('	!.\n\n')


    file.write('unfold(Head,Params,UList):-\n')
    file.write('	unfold_type(Head,list),\n')
    file.write('	unfold_list(Params,UList),!.\n\n')
    file.write('unfold(Head,Params,UList):-\n')
    file.write('	unfold_type(Head,maybe),\n')
    file.write('	unfold_maybe(Params,UList),!.\n\n')

    file.write('head_module(Head,Module):-\n')
    file.write('	atomic_list_concat(A,\'-\',Head),\n')
    file.write('	A=[Module|_],!.\n\n')

    file.write('%% PATTERNS\n\n')

    file.write('unfold_list([''],[]):-!.\n')
    file.write('unfold_list([Elem],[UElem]):-\n')
    file.write('	unfold(Elem,UElem),!.\n')
    file.write('unfold_list([Elem,List],[UElem|UList]):-\n')
    file.write('	unfold(Elem,UElem),!,\n')
    file.write('	unfold(List,UList),!.\n\n')

    file.write('unfold_maybe([''],[]):-!.\n')
    file.write('unfold_maybe([Elem],UElem):-\n')
    file.write('	unfold(Elem,UElem),!.\n')


    file.close()
    print("Unfolder skeleton generated in "+cpath)
        

def generate_brick(lpath='language_bricks',cpath='src/yap/xmg'):
    generate_language_brick(lpath)
    generate_compiler_brick(cpath)
    
