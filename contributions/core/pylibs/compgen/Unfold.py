import xmg.compgen.Symbol
import xmg.compgen.Grammar
import xmg.compgen.BrickTokenizer
import xmg.compgen.Parser
from xmg.compgen.Brick import Brick
import xmg.compgen.brick_parser
import warnings

class Unfold(object):

    def __init__(self,brick):
        self._brick=brick
        self._punctuation=brick._punctuation
        self._Ts=dict()
        self._NTs=dict()
        self._EXTs=dict()
        self._Rules=[]
        self._macros=[]
        self._prefix=brick._prefix
        #self._rename_nt=brick._rename_nt
        #self._rename_t=rename_t
        self._params=brick._connections
        self._unfold=self.unfold(brick._grammar.sem[0])
        #self._grammar=self.build_grammar(brick._grammar.sem[0])

    @property
    def params(self):
        return self._params  
    @property
    def prefix(self):
        return self._prefix       
    @property
    def rename_nt(self):
        return self._rename_nt  
    # @property
    # def rename_t(self):
    #     return self._rename_t    
    
    @property
    def Ts(self):
        return self._Ts    
    @property
    def NTs(self):
        return self._NTs    
    @property
    def EXTs(self):
        return self._EXTs
    @property
    def Rules(self):
        return self._Rules
    @property
    def macros(self):
        return self._macros
    #@property
    #def grammar(self):
    #    return self._grammar


    def build_grammar(self):

        # check whether every given parameter is an extern non terminal
        for param in self.params:
            if param not in self.EXTs:
                raise Exception("\n\n"+param+" is not an extern non terminal in "+self._brick._file+"\n\n")


        # if dimension, add the dimension rule

        # if necessary, do the renaming
        # if self.rename_nt is not None:
        #     nt, rename_nt= self.rename_nt
        #     self.NTs[nt]=rename_nt

        #self.unfold(sem)
        # for each extern non terminal, parse the file and add the rules
        for i in self.EXTs:
            if i in self.params:
            #if self.prefix in self.params and i in self.params[self.prefix]:
                extf=self.params[i]
                print("Using bricks ")
                for brick in extf:
                    print(brick._prefix)
            else:
                warnings.warn("\n\n No brick set for "+i+" in "+self._brick._file+"\n\n")
                continue
            
            for extg in extf: 
                G=extg._unfold
                if not extg._unfolded:
                    extg._unfolded=True
                    G.build_grammar()
                    for rule in G.Rules:
                        self.Rules.append(rule)
                    for rule in G.macros:
                        self.Rules.append(rule)                        
            
                #print(G)
                axiom=G.Rules[0].head

                # the language brick is a dimension brick
                if extg._dim:
                    tdim=xmg.compgen.Symbol.T('<'+extg._prefix+'>')
                    brick._punctuation.append('<'+extg._prefix+'>')
                    openStmt=xmg.compgen.Symbol.T('{')
                    closeStmt=xmg.compgen.Symbol.T('}')

                    # new instance of control brick
                    newControl=Brick('control','newcontrol')
                    NCL=newControl.language_brick
                    NG=NCL._unfold
                    NG.build_grammar()
                    for rulenc in NG.Rules:
                        self.Rules.append(rulenc)
                    for rulenc in NG.macros:
                        self.Rules.append(rulenc)   
                    # extern NT _Stmt must be pluged into the dimension
                    
                    self.Rules.append(xmg.compgen.Rule.Rule(self.NTs[i],(tdim,openStmt,NG.Rules[0].head,closeStmt),action=('VAR__RESULT=control:dimStmt('+extg._prefix+',VAR__PARAM__3)',4)))

                    print(NG.EXTs)
                    print(NG.NTs)
                    self.Rules.append(xmg.compgen.Rule.Rule(NG.NTs['_Stmt'],(axiom,),action=('VAR__RESULT=VAR__PARAM__1',1)))



                else:
                    self.Rules.append(xmg.compgen.Rule.Rule(self.NTs[i],(axiom,),action=('VAR__RESULT=VAR__PARAM__1',1)))
  
                # check that every non terminal appears in the left part of a rule
                for g_nt in G.NTs:
                    found=False
                    if g_nt in G.EXTs:
                        continue
                    else:
                        g_nt=G.NTs[g_nt]
                    for rule in G.Rules+G.macros:
                        if rule.head == g_nt :
                            found=True
                            break

                    if not found:
                        raise Exception("No rule for Non Terminal "+str(g_nt))

        Gram=xmg.compgen.Grammar.Grammar(tuple(self.Rules+self.macros))
        #Gram=xmg.compgen.Grammar.Grammar(tuple(self.Rules))
        return Gram

    def add_terminal(self,T):
        if T[0].isupper():
            raise Exception("Terminal "+T+" should not begin with a capital letter in "+self.prefix)
        if T not in self.Ts:
            self.Ts[T]=xmg.compgen.Symbol.T(T)
            
    def add_non_terminal(self,NT):
        if not NT[0].isupper():
            raise Exception("Non-Terminal "+NT+" should begin with a capital letter in "+self.prefix)
        if NT not in self.NTs:
            self.NTs[NT]=xmg.compgen.Symbol.NT(self.prefix+"-"+NT)

    def add_extern(self,NT):
        if not (NT[0].isupper() or NT[0]=='_'):
            raise Exception("Non-Terminal "+NT+" should begin with an underscore or a capital letter in "+self.prefix)
        if NT not in self.NTs:
            self.NTs[NT]=xmg.compgen.Symbol.NT(self.prefix+"-"+NT)
            self.EXTs[NT]=NT

    def unfold(self,Sem):
        if type(Sem).__name__ != 'str':
            (H,T)=Sem
            if H == 'TD':
                self.add_terminal(T[0])
            elif H == 'NTD':
                self.add_non_terminal(T[0])
            elif H == 'EXTD':
                self.add_extern(T[0])
            elif H == 'RuD':
                if not T[0] in self.NTs:
                    self.add_non_terminal(T[0])
                Left=T[0]
                T=T[1:]
                Right=[]
                for Rule in T:
                    self.unfold_rule(Rule,Right)
                    
                    for (part,action) in Right:
                        self.Rules.append(self.create_rule(Left,part,action))
            else:
                for ht in T:
                    self.unfold(ht)
        else : print(Sem)


    def unfold_rule(self,Sem,Right):
        if type(Sem).__name__ == 'str':
            Right.append(Sem)
        else:
            (H,T)=Sem
            action=None
            if H=='RulePart':
                if len(T) == 2:
                    action=T[1]
                    action=self.unfold_action(action)
                id=T[0]
                ids=[]
                self.unfold_ids(id,ids)
                Right.append((ids,action))
            else:
                for ht in T:
                    self.unfold_rule(ht,Right)
    
    # def unfold_action(self,action):
    #     #print(action)
    #     ret=[]
    #     for actionpart in action[1]:
    #         uactionpart=self.unfold_actionpart(actionpart)
    #         ret.append(uactionpart)
    #     return ret

    def unfold_action(self,action):
        return action

    def unfold_actionpart(self,actionpart):
        for part in actionpart[1]:
            if part[0] == 'Pred':
                upred=self.unfold_pred(part)
                return upred
            elif part[0] == 'Eq':
                ueq=self.unfold_eq(part)
                return ueq
            elif part[0] == 'List':
                if part[1] == []:
                    return 'listenum([])'
                else:
                    ulist=self.unfold_list(part[1][0])
                    return ulist

    def unfold_pred(self,pred):
        body=[]
        head=self.unfold_ref(pred[1][0])
        self.unfold_refs(pred[1][1],body)
        return 'pred('+str(head)+",["+",".join(map(str,body))+'])'
 
    def unfold_eq(self,eq):
        left=self.unfold_ref(eq[1][0])
        right=self.unfold_actionpart(('actionpart',[eq[1][1]]))
        return 'eq('+left+','+right+')'

    def unfold_list(self,lst):
        if lst[0] == 'ListCons':
            cons1=self.unfold_ref(lst[1][0])
            cons2=self.unfold_ref(lst[1][1])
            return 'listcons('+cons1+','+cons2+')'
        elif lst[0]== 'ListEnum':
            return 'listenum(['+self.unfold_ref(lst[1][0])+'])'

        
    def unfold_ids(self,Sem,Right):
        if type(Sem).__name__=='str':
            Right.append(Sem)
        else:
            if Sem[0] == 'Macro':
                Right.append(self.unfold_macro(Sem[1]))
            else:                      
                (H,T)=Sem
                for ht in T:
                    self.unfold_ids(ht,Right)

    def unfold_macro_op(self,op):
        if op == ('MacroOp', [('MacroOpP', [])]):
            return '+'
        elif op == ('MacroOp', [('MacroOpS', [])]):
            return '*'
        elif op == ('MacroOp', [('MacroOpQ', [])]):
            return '?'

    def unfold_macro(self,macro):
        rules=[]
        sep=[]
        if len(macro)==3:
            (ids,sep_,op)=macro
            sep=sep_[1]
        else:
            (ids,op)=macro
        if not sep:
            sepstr=""
        else:
            sepstr=sep[0]
        uids=[]
        self.unfold_ids(ids,uids)
        uop=self.unfold_macro_op(op)
        ntid=self.prefix+"-"+"Macro4"+"-".join(map(str,uids))+"sep_"+sepstr+uop
        nt=xmg.compgen.Symbol.NT(ntid)
        self.NTs[ntid]=nt
        if op[1][0][0] == 'MacroOpP' :
            if sep:
                LAST_PARAM="3"
            else:
                LAST_PARAM="2"
            rules.append(self.create_rule(ntid,uids,('VAR__RESULT=[VAR__PARAM__1]',len(uids))))
            rules.append(self.create_rule(ntid,uids+sep+[ntid],('VAR__RESULT=[VAR__PARAM__1|VAR__PARAM__'+LAST_PARAM+']',len(uids))))
        elif op[1][0][0] == 'MacroOpS' :
            rules.append(self.create_rule(ntid,[],('VAR__RESULT=[]',0)))
            if len(macro)==3:
                (pids,psep,sop)=macro
                pmacro=(pids,psep,('MacroOp', [('MacroOpP', [])]))
            else:
                (pids,sop)=macro
                pmacro=(pids,('MacroOp', [('MacroOpP', [])]))                
            unfoldp=self.unfold_macro(pmacro)
            rules.append(self.create_rule(ntid,[unfoldp],('VAR__RESULT=VAR__PARAM__1',1)))
        if op[1][0][0] == 'MacroOpQ' :
            rules.append(self.create_rule(ntid,uids,('VAR__RESULT=some(VAR__PARAM__1)',len(uids))))
            rules.append(self.create_rule(ntid,[],('VAR__RESULT=none',0)))
        for rule in rules:
            self.macros.append(rule)
        return(ntid)

    def unfold_refs(self,ids,unfold):
        if type(ids).__name__=='str':
            if ids[0] == '$':
                if ids[1] == '$':
                    gid='left'
                else:
                    gid=ids[1:]
                uid='get('+gid+')'
            else:
                uid='put('+ids+')'
            unfold.append(uid)
        else:
            (H,T)=ids
            for ht in T:
                self.unfold_refs(ht,unfold)
        
    def unfold_ref(self,_id):
        if _id[0] == '$':
            if _id[1] == '$':
                gid='left'
            else:
                gid=_id[1:]
            uid='get('+gid+')'
        else:
            uid='put('+_id+')'
        return uid

        
    def create_rule(self,Left,Right,Action):
        R=list()
        for r in Right:
            if r in self.Ts:
                R.append(self.Ts[r])
            elif r in self.NTs:
                R.append(self.NTs[r])
            elif r in self._punctuation:
                R.append(xmg.compgen.Symbol.T(r))
            else:
                print("\nUndefined symbol :"+r+"\n")
                if r[0].isupper():
                    print('non-terminal')
                    self.add_non_terminal(r)
                    R.append(self.NTs[r])
                elif r[0] == '_':
                    print('extern')  
                    self.add_extern(r)
                    R.append(self.NTs[r])
                else:
                    print('terminal')
                    self.add_terminal(r)
                    R.append(self.Ts[r])
        return xmg.compgen.Rule.Rule(self.NTs[Left],tuple(R),action=Action)
    




