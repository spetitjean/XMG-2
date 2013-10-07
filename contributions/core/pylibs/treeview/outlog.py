from PyQt4 import QtGui

class OutLog:
    def __init__(self, edit, out=None, color='black'):
        self.edit = edit
        self.out = None
        self.couleur = color

    def write(self, m):
        self.edit.moveCursor(QtGui.QTextCursor.End)
        self.edit.insertHtml('<font color=\''+self.couleur+'\'><pre>' + m + '</pre></font><br>')
        if self.out:
            self.out.write(m)

    def fileno(self):
        if self.couleur =="black":
            return 1
        else:
            return 2
