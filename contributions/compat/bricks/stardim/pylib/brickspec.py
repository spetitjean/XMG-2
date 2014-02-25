from xmg.compgen.BrickSpec import BrickSpec

class StardimBrickSpec(BrickSpec):

    def __init__(self, name, brick_name, plugs):
        self.proxy = plugs["proxy"]
        del plugs["proxy"]
        plugs["_Constraint"]=self.proxy+"._Extern"
        super().__init__(name, brick_name, plugs)

    def init_brick(self, brick):
        brick._text = """
%%%%

Stmt : _Dim {$$=$1} | _Dim '*=' _Constraint {$$=control:and($1,dim:dim('%s',$3))} ;

%%%%
""" % self.proxy
