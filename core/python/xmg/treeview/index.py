from PyQt4 import QtGui
import re

class Index(QtGui.QWidget):
    def __init__(self):
        super(Index, self).__init__()
        self.initUI()
        
    #initialise les elements de la classe   
    def initUI(self):
        layout = QtGui.QVBoxLayout()
        self.setLayout(layout)
        
        self.line = QtGui.QLineEdit()
        layout.addWidget(self.line)
        self.line.textEdited.connect(self.find)
        self.famlist = QtGui.QListWidget()
        layout.addWidget(self.famlist)
        self.entlist = QtGui.QListWidget()
        layout.addWidget(self.entlist)
    
    def find(self, string):
        reg = re.compile(string)
        for i in range(self.famlist.count()):
            if not reg.search(self.famlist.item(i).text()):
                self.famlist.item(i).setHidden(True)
            else:
                self.famlist.item(i).setHidden(False)
        for i in range(self.entlist.count()):
            if not reg.search(self.entlist.item(i).text()):
                self.entlist.item(i).setHidden(True)
            else:
                self.entlist.item(i).setHidden(False)
