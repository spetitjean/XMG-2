from PyQt4 import QtGui
from xmg.treeview.config import config as conf

class Lang(QtGui.QWidget):
        #constructeur de la classe
    def __init__(self):
        super(Lang, self).__init__()
        self.initUI()
    #initialise les elements de la clasee
    def initUI(self):
        grid = QtGui.QGridLayout()
        self.setLayout(grid)
        lab = QtGui.QLabel(self.tr('Langue :'))
        grid.addWidget(lab, 0, 0)
        self.lang = QtGui.QComboBox()
        self.lang.setEditable(False)
        self.lang.addItems([self.tr('Français'), self.tr('Anglais')])
        grid.addWidget(self.lang, 0, 1)
        butok = QtGui.QPushButton(self.tr("Valider"))
        butok.clicked.connect(self.change)
        grid.addWidget(butok, 1, 1)
        butan = QtGui.QPushButton(self.tr('Annuler'))
        butan.clicked.connect(self.close)
        grid.addWidget(butan, 1, 0)
        self.setWindowTitle(self.tr('Langage'))
        if conf['GENERAL']['lang']=='ENG':
            self.lang.setCurrentIndex(1)
            
    def change(self):
        if self.lang.currentText() == self.tr('Anglais'):
            conf['GENERAL']['lang']='ENG'
        else:
            conf['GENERAL']['lang']='FRA'
        conf.save()
        QtGui.QMessageBox.information(self, self.tr('Information'), self.tr('Le changement de langue prendra effet au prochain redémarrage'))
        self.close()
