from xmg.compgen.BrickSpec import BrickSpec, Plug

class StardimBrickSpec(BrickSpec):

    def __init__(self, name, brick_name, plugs):
        self.proxy = plugs["proxy"]
        del plugs["proxy"]
        super().__init__(name, brick_name, plugs)

    def deref_plugs(self, table):
        proxy = table[self.proxy]
        ctrl = proxy.control_name
        self.tag = proxy.tag
        self.plugs["_Constraint"] = [Plug(ctrl + "._Stmt")]
        super().deref_plugs(table)

    def init_brick(self, brick):
        brick._text = """
%%%%

Stmt : _Dim {$$=$1} | _Dim '*=' _Constraint {$$=control:and($1,dim:dim('%s',$3))} ;

%%%%
""" % self.tag
