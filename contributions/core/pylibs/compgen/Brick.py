# A brick is a language brick, associated to a compiler brick

class Brick(object):

    def __init__(self, language_brick, compiler_brick):
        self.language_brick=language_brick
        self.compiler_brick=compiler_brick

    def connect(self, ext, brick):
        self.language_brick.connect(ext,brick.language_brick)
