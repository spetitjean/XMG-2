from xmg.compgen.BrickSpec import BrickSpec, counter

class DimBrickSpec(BrickSpec):

    @classmethod
    def create(cls, name, brick_name, plugs):
        control_name = "control__%d" % counter()
        Ctrl=BrickSpec.make(control_name, {"_Stmt": plugs["Stmt"]})
        #print(Ctrl)
        #yield Ctrl
        for CtrlPart in Ctrl:
            yield CtrlPart
        yield DimBrickSpec(name, brick_name, plugs, control_name)

    def __init__(self, name, brick_name, plugs, control_name):
        self.tag = plugs["tag"]
        del plugs["tag"]
        del plugs["Stmt"]
        plugs["_Extern"] = control_name
        self.control_name = control_name
        super().__init__(name, brick_name, plugs)

    def init_brick(self, brick):
        brick._text = """
%%%%

Dim : '<%s>' '{' _Extern '}' {$$=dim:dim($1,$3)};

%%%%
""" % self.tag
        
