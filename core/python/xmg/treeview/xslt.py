from PyQt4 import QtGui, QtCore
import os

class Xslt(QtGui.QWidget):
    def __init__(self, filename):
        super(Xslt, self).__init__()
        self.filename = filename
        self.initUI()
        
    #initialise les elements de la classe   
    def initUI(self):
        layout = QtGui.QGridLayout()
        self.setLayout(layout)
        lab = QtGui.QLabel(self.tr('Filtre xslt à appliquer :'))
        layout.addWidget(lab, 0, 0)
        self.line = QtGui.QLineEdit()
        layout.addWidget(self.line, 0, 1)        
        butpar = QtGui.QPushButton(self.tr('Parcourir'))
        butpar.clicked.connect(self.parcourir)
        layout.addWidget(butpar, 0, 2)
        butcan = QtGui.QPushButton(self.tr('Annuler'))
        butcan.clicked.connect(self.close)
        layout.addWidget(butcan, 1, 1)
        butapp = QtGui.QPushButton(self.tr('Appliquer'))
        butapp.clicked.connect(self.applique)
        layout.addWidget(butapp, 1, 2)
        
        
    def applique(self):
        os.system('xsltproc ' + self.line.text() + ' ' + self.filename + ' > ' + self.filename[:self.filename.find('.xml')] + '.html')
        self.close()


    def parcourir(self):
        self.line.setText(QtGui.QFileDialog.getOpenFileName(self,self.tr("Selectionner un filtre xslt"),QtCore.QDir.homePath(),self.tr("Fichier XSLT (*.xsl)")))
        
