# -*- coding: utf-8 -*-
from PyQt4 import QtGui, QtCore
from xmg.treeview.config import config

class Configuration(QtGui.QWidget):
        #constructeur de la classe
    def __init__(self):
        super(Configuration, self).__init__()
        self.initUI()
    #initialise les elements de la classe   
    def initUI(self):
        self.layout = QtGui.QGridLayout()
        self.setLayout(self.layout)
        
        gengrpbox = QtGui.QGroupBox(self.tr('Général'), self)
        self.layout.addWidget(gengrpbox, 0, 0, 1, 2)
        genlayout = QtGui.QGridLayout()
        gengrpbox.setLayout(genlayout)

        self.labemp = QtGui.QLabel(self.tr('Emplacement de XMG :'))
        genlayout.addWidget(self.labemp, 0, 0)
        self.emp= QtGui.QLineEdit()
        self.emp.setReadOnly(True)
        genlayout.addWidget(self.emp, 0, 1)        
        self.butemp = QtGui.QPushButton(self.tr('Parcourir'))
        self.butemp.clicked.connect(self.changeemp)
        genlayout.addWidget(self.butemp, 0, 2)

        widgrpbox = QtGui.QGroupBox(self.tr('Fenetre Graphique'), self)
        self.layout.addWidget(widgrpbox, 1, 0, 1, 2)
        widlayout = QtGui.QGridLayout()
        widgrpbox.setLayout(widlayout)
        
        self.labwidcolor = QtGui.QLabel(self.tr('Couleur des widgets :'))
        widlayout.addWidget(self.labwidcolor, 0, 0)
        self.linewid = QtGui.QLineEdit()
        self.linewid.setReadOnly(True)
        widlayout.addWidget(self.linewid, 0, 1)        
        self.widcolor = QtGui.QPushButton(self.tr('Changer la couleur'))
        self.widcolor.clicked.connect(self.changecolorwid)
        widlayout.addWidget(self.widcolor, 0, 2)
        
        self.labfontcolor = QtGui.QLabel(self.tr('Couleur de la police des widgets :'))
        widlayout.addWidget(self.labfontcolor, 1, 0)
        self.linefont= QtGui.QLineEdit()
        self.linefont.setReadOnly(True)
        widlayout.addWidget(self.linefont, 1, 1)        
        self.fontcolor = QtGui.QPushButton(self.tr('Changer la couleur'))
        self.fontcolor.clicked.connect(self.changecolorfont)
        widlayout.addWidget(self.fontcolor, 1, 2)
        
        self.labfont = QtGui.QLabel(self.tr("Police des widgets:"))
        widlayout.addWidget(self.labfont, 2, 0)
        self.font = QtGui.QFontComboBox()
        widlayout.addWidget(self.font, 2, 1)
        
        affgroupbox = QtGui.QGroupBox(self.tr('Affichage des traits'), self)
        widlayout.addWidget(affgroupbox, 3, 0, 1, 3)
        afflayout = QtGui.QHBoxLayout()
        affgroupbox.setLayout(afflayout)
        self.top = QtGui.QCheckBox("Top")
        afflayout.addWidget(self.top)
        self.bot = QtGui.QCheckBox("Bot")
        afflayout.addWidget(self.bot)
        
        self.labmode = QtGui.QLabel(self.tr('Mode des traits :'))
        widlayout.addWidget(self.labmode, 5, 0)
        self.mode = QtGui.QComboBox()
        self.mode.setEditable(False)
        self.mode.addItems([self.tr('Arbre'), self.tr('Organigramme')])
        widlayout.addWidget(self.mode, 5, 1)
        
        self.labwidcolordif = QtGui.QLabel(self.tr('Couleur des widgets differends (comparaison) :'))
        widlayout.addWidget(self.labwidcolordif, 4, 0)
        self.linewidcolordif= QtGui.QLineEdit()
        self.linewidcolordif.setReadOnly(True)
        widlayout.addWidget(self.linewidcolordif, 4, 1)        
        self.widcolordif = QtGui.QPushButton(self.tr('Changer la couleur'))
        self.widcolordif.clicked.connect(self.changecolorwiddif)
        widlayout.addWidget(self.widcolordif, 4, 2)
        
        famgrpbox = QtGui.QGroupBox(self.tr('Index'), self)
        self.layout.addWidget(famgrpbox,  2, 0, 1, 2)
        famlayout = QtGui.QGridLayout()
        famgrpbox.setLayout(famlayout)

        self.labfontcolorind = QtGui.QLabel(self.tr('Couleur de la police dans l\'index :'))
        famlayout.addWidget(self.labfontcolorind, 5, 0)
        self.linefontind= QtGui.QLineEdit()
        self.linefontind.setReadOnly(True)
        famlayout.addWidget(self.linefontind, 5, 1)        
        self.fontcolorind = QtGui.QPushButton(self.tr('Changer la couleur'))
        self.fontcolorind.clicked.connect(self.changecolorfontind)
        famlayout.addWidget(self.fontcolorind, 5, 2)

        self.labfontind = QtGui.QLabel(self.tr("Police de l\'index :"))
        famlayout.addWidget(self.labfontind, 6, 0)
        self.fontind = QtGui.QFontComboBox()
        famlayout.addWidget(self.fontind, 6, 1)
        
        self.cancel = QtGui.QPushButton(self.tr('Annuler'))
        self.layout.addWidget(self.cancel, 7, 0)
        self.cancel.clicked.connect(self.close)
        self.save = QtGui.QPushButton(self.tr('Savegarder'))
        self.save.clicked.connect(self.saved)
        self.layout.addWidget(self.save, 7, 1)
        
        self.emp.setText(config['GENERAL']["xmgpath"])
        pal = self.linewid.palette()
        pal.setColor(self.linewid.backgroundRole(), QtGui.QColor(config['WIDGET']['widcolor']))
        self.linewid.setPalette(pal)
        pal = self.linefont.palette()
        pal.setColor(self.linefont.backgroundRole(), QtGui.QColor(config['WIDGET']['fontcolor']))
        self.linefont.setPalette(pal)
        self.font.setCurrentFont(QtGui.QFont(config['WIDGET']['font']))
        pal = self.linewidcolordif.palette()
        pal.setColor(self.linewidcolordif.backgroundRole(), QtGui.QColor(config['WIDGET']['diffcolor']))
        self.linewidcolordif.setPalette(pal)
        if config['WIDGET']['mode'].find(self.tr("Arbre")) > -1:
            self.mode.setCurrentIndex(0)
        else:
            self.mode.setCurrentIndex(1)
        if config['WIDGET']['top'].find("True") > -1:
            self.top.setChecked(True)
        else:
            self.top.setChecked(False)
        if config['WIDGET']['bot'].find("True") > -1:
            self.bot.setChecked(True)
        else:
            self.bot.setChecked(False)
        pal = self.linefontind.palette()
        pal.setColor(self.linefontind.backgroundRole(), QtGui.QColor(config['INDEX']['fontcolor']))
        self.linefontind.setPalette(pal)
        self.fontind.setCurrentFont(QtGui.QFont(config['INDEX']['font']))
        self.setWindowTitle(self.tr('Configuration'))
    
    #Sauvegarde la configuration
    def saved(self):
        pal = self.linewid.palette()
        config['WIDGET']["widcolor"] = pal.color(self.linewid.backgroundRole()).name()
        pal = self.linefont.palette()
        config['WIDGET']["fontcolor"] = pal.color(self.linefont.backgroundRole()).name()
        config['WIDGET']["font"] = self.font.currentText()
        config['WIDGET']["top"] = "True" if self.top.isChecked() else "False"
        config['WIDGET']["bot"] = "True" if self.bot.isChecked() else "False"
        config['WIDGET']["mode"] = self.mode.currentText()
        pal = self.linewidcolordif.palette()
        config['WIDGET']["diffcolor"] = pal.color(self.linewidcolordif.backgroundRole()).name()
        pal = self.linefontind.palette()
        config['INDEX']["fontcolor"] = pal.color(self.linefontind.backgroundRole()).name()
        config['INDEX']["font"] = self.fontind.currentText()
        config['GENERAL']["xmgpath"] = self.emp.text()
        config.save()
        self.close()
     
    def changecolorwid(self):
        pal = self.linewid.palette()
        pal.setColor(self.linewid.backgroundRole(), QtGui.QColorDialog.getColor())
        self.linewid.setPalette(pal)
    
    def changecolorfont(self):
        pal = self.linefont.palette()
        pal.setColor(self.linefont.backgroundRole(), QtGui.QColorDialog.getColor())
        self.linefont.setPalette(pal)

    def changecolorfamind(self):
        pal = self.linefamind.palette()
        pal.setColor(self.linefamind.backgroundRole(), QtGui.QColorDialog.getColor())
        self.linefamind.setPalette(pal)
        
    def changecolorfontind(self):
        pal = self.linefontind.palette()
        pal.setColor(self.linefontind.backgroundRole(), QtGui.QColorDialog.getColor())
        self.linefontind.setPalette(pal)

    def changecolorwiddif(self):
        pal = self.linewidcolordif.palette()
        pal.setColor(self.linewidcolordif.backgroundRole(), QtGui.QColorDialog.getColor())
        self.linewidcolordif.setPalette(pal)
    
    def changeemp(self):
        self.emp.setText(QtGui.QFileDialog.getExistingDirectory(self, self.tr("Ouvrir le dossier contenant XMG"), QtCore.QDir.homePath(),QtGui.QFileDialog.ShowDirsOnly | QtGui.QFileDialog.DontResolveSymlinks ))
