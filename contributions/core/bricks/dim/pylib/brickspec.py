from xmg.compgen.BrickSpec import BrickSpec, counter

class DimBrickSpec(BrickSpec):

    @classmethod
    def create(cls, name, brick_name, plugs):
        control_name = "control__%d" % counter()
        Ctrl=BrickSpec.make(control_name, {"_Stmt": plugs["Stmt"], 
                                           "_Expr": plugs["Expr"]})
        
        #print(Ctrl)
        #yield Ctrl
        for CtrlPart in Ctrl:
            yield CtrlPart
        yield DimBrickSpec(name, brick_name, plugs, control_name)

    def __init__(self, name, brick_name, plugs, control_name):
        self.tag = plugs["tag"]
        if "solver" in plugs:
            self.solver = plugs["solver"]
            del plugs["solver"]
        else:
            self.solver = None
        self.dimbrick = plugs["Stmt"]
        del plugs["tag"]
        del plugs["Stmt"]
        del plugs["Expr"]
        plugs["_Extern"] = control_name
        self.control_name = control_name
        super().__init__(name, brick_name, plugs, dim=True)

    def init_brick(self, brick):
        brick._text = """
%%%%

Dim : '<%s>' '{' _Extern '}' {$$=dim:dim(%s,$3)};

%%%%
""" % (self.tag, self.tag)
        
        brick._solver=self.solver
        brick._tag=self.tag
        brick._dimbrick=self.dimbrick
