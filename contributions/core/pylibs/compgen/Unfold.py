import xmg.compgen.Symbol
import xmg.compgen.Grammar
import xmg.compgen.BrickTokenizer
import xmg.compgen.Parser
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
                #raise Exception("No brick set for "+i+" in "+self._brick._file)
                warnings.warn("\n\n No brick set for "+i+" in "+self._brick._file+"\n\n")
                continue
            
            for extg in extf: 
                G=extg._unfold
                if not extg._unfolded:
                    extg._unfolded=True
                    G.build_grammar()
                    for rule in G.Rules:
                        self.Rules.append(rule)
            
                #print(G)
                axiom=G.Rules[0].head
                if extg._dim:
                    tdim=xmg.compgen.Symbol.T('<'+extg._prefix+'>')
                    brick._punctuation.append('<'+extg._prefix+'>')
                    openStmt=xmg.compgen.Symbol.T('{')
                    closeStmt=xmg.compgen.Symbol.T('}')
                    self.Rules.append(xmg.compgen.Rule.Rule(self.NTs[i],(tdim,openStmt,axiom,closeStmt)))
                else:
                    self.Rules.append(xmg.compgen.Rule.Rule(self.NTs[i],(axiom,)))
  
        Gram=xmg.compgen.Grammar.Grammar(tuple(self.Rules))
        return Gram


    def unfold(self,Sem):
        if type(Sem).__name__ != 'str':
            (H,T)=Sem
            if H == 'TD':
                if T[0] not in self.Ts:
                    self.Ts[T[0]]=xmg.compgen.Symbol.T(T[0])
            elif H == 'NTD':
                if T[0] not in self.NTs:
                    self.NTs[T[0]]=xmg.compgen.Symbol.NT(self.prefix+"-"+T[0])
            elif H == 'EXTD':
                self.NTs[T[0]]=xmg.compgen.Symbol.NT(self.prefix+"-"+T[0])
                self.EXTs[T[0]]=T[1]
            elif H == 'RuD':
                # check left part is a non terminal
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
    
    def unfold_action(self,action):
        #print(action)
        ret=[]
        for actionpart in action[1]:
            uactionpart=self.unfold_actionpart(actionpart)
            ret.append(uactionpart)
        return ret

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
            if Sem[0] == 'macro':
                Right.append(self.unfold_macro(Sem[1]))
            else:                      
                (H,T)=Sem
                for ht in T:
                    self.unfold_ids(ht,Right)

    def unfold_macro(self,macro):
        (ids,op)=macro
        uids=[]
        self.unfold_ids(ids,uids)
        ntid=self.prefix+"-"+"*4"+"-".join(map(str,uids))
        nt=xmg.compgen.Symbol.NT(ntid)
        self.NTs[ntid]=nt
        if op[1][0][0] == 'macroOpP' :
            self.Rules.append(self.create_rule(ntid,uids,['eq(get(left),listenum([get(1)]))']))
        elif op[1][0][0] == 'macroOpS' :
            self.Rules.append(self.create_rule(ntid,[''],['eq(get(left),listenum([]))']))
        self.Rules.append(self.create_rule(ntid,uids+[ntid],['eq(get(left),listenum([get(1)]))']))
        return ntid

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
            else:
                if r not in self._punctuation:
                    raise Exception('Undefined symbol: '+r)
                R.append(xmg.compgen.Symbol.T(r))
        return xmg.compgen.Rule.Rule(self.NTs[Left],tuple(R),action=Action)
    




