# -*- coding: utf-8 -*-
import sys, configparser, subprocess, os
from PyQt4 import QtGui,QtCore
from xmg.treeview.widcentral import WidCentral
from xmg.treeview.configuration import Configuration
from xmg.treeview.grammar import *
from xmg.treeview.index import Index
from xmg.treeview.xslt import Xslt
from xmg.treeview.outlog import OutLog
from xmg.treeview.lang import Lang
import xmg.treeview.image as IMAGE
from xmg.treeview.config import config
#classe principale
class PyTreeView(QtGui.QMainWindow):
    dict = {}
    cpt = 0
    font = None
    fontcolor = None
    filename = None
    dockWidget = None
    path = ''
    #charge la configuration
    def loadconfig(self):
        self.fontcolor = QtGui.QColor(config['INDEX']['fontcolor'])
        self.font = QtGui.QFont(config['INDEX']['font'])
        self.path = config['GENERAL']['xmgpath']

    #genere l'affichage + l'index
    def generergraphe(self,  str, formalism):
        self.widcentral.filename = str
        self.setCursor(QtGui.QCursor(QtCore.Qt.WaitCursor))
        if str.find(".mg")>-1 and os.path.isfile(str):
            xmltxt = ""
            if not os.path.isdir(self.path) or self.path == "":
                self.adderror(self.tr('XMG inéxistant. Impossible de compiler le fichier. Récupérer XMG avec la commande suivante \"bzr branch lp:~petitjean-sim/xmg/xmg.sim\"'))
            else:
                with subprocess.Popen('yap -l '+ self.path + '/compiler -z \"add_to_path(\''+self.path +'\'),compiler:compile(\''+str + '\',A,tagprint),halt \"', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as proc:
                    c = proc.communicate()
                    xmltxt = c[0].decode("utf-8")
                    self.adderror(c[1].decode("utf-8"))
                    proc.wait()
                self.addtext(self.tr('Lecture du fichier XML'))
                self.tree = Grammar.fromstring(xmltxt)            
        elif str.find('.xml') > -1 and os.path.isfile(str):
                self.addtext(self.tr('Lecture du fichier XML'))
                self.addtext(self.tr(formalism))
                
                self.tree = Grammar.fromFile(self.widcentral.filename, formalism)

        if str == "":
            self.adderror('Pas de fichier passer en paramètre')
        else:
            self.index = Index()
            self.index.entlist.itemClicked.connect(self.gestiondoubleclick)
            self.index.famlist.itemClicked.connect(self.famclick)
            self.index.famlist.itemDoubleClicked.connect(self.doubfamclick)
            pal = self.index.famlist.palette()
            pal.setColor(QtGui.QPalette.Text, QtGui.QColor(self.fontcolor))
            self.index.famlist.setPalette(pal)
            self.index.famlist.setFont(self.font)
            pal = self.index.entlist.palette()
            pal.setColor(QtGui.QPalette.Text, QtGui.QColor(self.fontcolor))
            self.index.entlist.setPalette(pal)
            self.index.entlist.setFont(self.font)
            if self.dockWidget is not None:
                self.removeDockWidget(self.dockWidget)
            self.dockWidget = QtGui.QDockWidget('Index');
            self.dockWidget.setAllowedAreas(QtCore.Qt.RightDockWidgetArea)
            self.dockWidget.setFeatures(QtGui.QDockWidget.NoDockWidgetFeatures)
            self.dockWidget.setWidget(self.index)
            self.addDockWidget(QtCore.Qt.RightDockWidgetArea, self.dockWidget)
            self.addtext('Generation de l\'index')
            self.s = {}
            for i in self.tree.entries:
                find = False
                for j in self.s.keys():
                    if i.family == j:
                        find = True
                        self.s[j].append(i.name)
                        break
                if not find:
                    self.s[i.family] = []
                    self.s[i.family].append(i.name)
            for i in self.s.keys():
                self.index.famlist.addItem(i)
            for i in range(self.index.famlist.count()):
                self.index.famlist.item(i).setTextAlignment(QtCore.Qt.AlignHCenter)
            self.setCursor(QtGui.QCursor(QtCore.Qt.ArrowCursor))

    def gestiondoubleclick(self, item):
        if self.diffAction.isChecked():
            self.condiff(item)
            self.diff = False
        else:
            self.connection(item)
    
    def connection(self, item):
        s = item.text()
        for i in self.tree.entries:
            if i.name == s:
                self.addtext('Affichage de l\'arbre de ' +s )
                self.widcentral.connection(i)
                break
    
    def famclick(self, item):
        self.index.entlist.clear()
        self.index.entlist.addItems(self.s[item.text()])
        for i in range(self.index.entlist.count()):
            self.index.entlist.item(i).setTextAlignment(QtCore.Qt.AlignHCenter)
    
    def doubfamclick(self,item):
        if len(self.index.entlist) == 1:
            self.connection(self.index.entlist.item(0))
        else:
            listitem = []
            for i in range(self.index.entlist.count()):
                s = self.index.entlist.item(i).text()
                for k in self.tree.entries:
                    if s ==  k.name:
                        listitem.append(k)
            self.widcentral.connectionfam(listitem)
    
    
    def condiff(self, item):
            s = item.text()
            for i in self.tree.entries:
                if i.name == s:
                    self.widcentral.diff(i)
                    break
    #constructeur de la classe
    def __init__(self, formalism):
        super(PyTreeView, self).__init__()        
        self.initUI()
        self.formalism=formalism
        
    #initialise les elements de la clasee
    def initUI(self):
        self.loadconfig()
        self.widcentral = WidCentral()
        self.widcentral.addtxt.connect(self.addtext)
        self.widcentral.error.connect(self.adderror)
        self.setCentralWidget(self.widcentral)
        #definition des actions
        exitAction = QtGui.QAction(QtGui.QIcon(IMAGE.QUIT), self.tr('Quitter'), self)
        exitAction.setShortcut('Ctrl+Q')
        exitAction.setStatusTip(self.tr('Quitter l\'application'))
        exitAction.triggered.connect(self.close)
        reloadAction = QtGui.QAction(QtGui.QIcon(IMAGE.XML),  self.tr('Ouvrir un XML'),  self)
        reloadAction.setShortcut('Ctrl+O')
        reloadAction.setStatusTip(self.tr('Ouvrir un XML'))
        reloadAction.triggered.connect(self.getxmlname)        
        mgAction = QtGui.QAction(QtGui.QIcon(IMAGE.MG),  self.tr('Compiler un MG'),  self)
        mgAction.setShortcut('Ctrl+Alt+O')
        mgAction.setStatusTip(self.tr('Compiler et charger un fichier MG'))
        mgAction.triggered.connect(self.getmgname)
        dezoomAction = QtGui.QAction(QtGui.QIcon(IMAGE.ZOOMAR),  self.tr('Dezoomer'),  self)
        dezoomAction.setShortcut('Ctrl+-')
        dezoomAction.setStatusTip(self.tr('Dézoomer'))
        dezoomAction.triggered.connect(self.widcentral.dezoom)
        zoomAction = QtGui.QAction(QtGui.QIcon(IMAGE.ZOOMAV),  self.tr('Zoomer'),  self)
        zoomAction.setShortcut('Ctrl++')
        zoomAction.setStatusTip(self.tr('Zoomer'))
        zoomAction.triggered.connect(self.widcentral.zoom)
        upAction = QtGui.QAction(self.tr("Déplacer vers le haut"), self)
        upAction.setShortcut('Ctrl+Up')
        upAction.setStatusTip(self.tr("Déplacer vers le haut"))
        upAction.triggered.connect(self.widcentral.movup)
        downAction = QtGui.QAction(self.tr("Déplacer vers le bas"), self)
        downAction.setShortcut('Ctrl+Down')
        downAction.setStatusTip(self.tr('Déplacer vers le haut'))
        downAction.triggered.connect(self.widcentral.movdown)
        leftAction = QtGui.QAction(self.tr("Déplacer vers la gauche"), self)
        leftAction.setShortcut('Ctrl+Left')
        leftAction.setStatusTip(self.tr("Déplacer vers la gauche"))
        leftAction.triggered.connect(self.widcentral.movleft)
        rigthAction = QtGui.QAction(self.tr("Déplacer vers la droite"), self)
        rigthAction.setShortcut('Ctrl+Right')
        rigthAction.setStatusTip(self.tr("Déplacer vers la droite"))
        rigthAction.triggered.connect(self.widcentral.movrigth)
        saveAction = QtGui.QAction(QtGui.QIcon(IMAGE.SAVE),self.tr("Sauvegarder image"), self)
        saveAction.setShortcut('Ctrl+S')
        saveAction.setStatusTip(self.tr("Sauvegarder dans une image"))  
        saveAction.triggered.connect(self.widcentral.save)
        helpAction = QtGui.QAction(QtGui.QIcon("aide.png"),self.tr("Aide"), self)
        helpAction.setShortcut('F1')
        helpAction.setStatusTip(self.tr('Aide'))
        helpAction.triggered.connect(self.aide)
        aboutAction = QtGui.QAction(QtGui.QIcon("about.png"),self.tr("A propos de"), self)
        aboutAction.setStatusTip(self.tr("A propos de PyTreeView"))
        aboutAction.triggered.connect(self.about)
        configAction = QtGui.QAction(QtGui.QIcon("config.png"),self.tr("Configuration"), self)
        configAction.setStatusTip(self.tr("Configurer PyTreeView"))
        configAction.triggered.connect(self.config)
        printAction = QtGui.QAction(QtGui.QIcon(IMAGE.PRINT), self.tr('Imprimer'), self)
        printAction.setShortcut('Ctrl+P')
        printAction.setStatusTip(self.tr('Imprimer L\'arbre'))
        printAction.triggered.connect(self.widcentral.impression)
        previewAction = QtGui.QAction(QtGui.QIcon(IMAGE.PREVIEW),self.tr('Apercu'), self)
        previewAction.setShortcut('Ctrl+Alt+P')
        previewAction.setStatusTip(self.tr('Apercu avant impression'))
        previewAction.triggered.connect(self.widcentral.apercu)
        self.diffAction = QtGui.QAction(QtGui.QIcon(IMAGE.DIFF), self.tr('Comparaison'), self)
        self.diffAction.setCheckable(True)
        self.diffAction.setChecked(False)
        self.diffAction.setShortcut('Ctrl+D')
        self.diffAction.setStatusTip(self.tr('Comparaison entre 2 entrées'))
        self.diffAction.triggered.connect(self.verdiff)
        xsltAction = QtGui.QAction(self.tr('XSLT'), self)
        xsltAction.setStatusTip(self.tr('Applique un filtre XSLT au xml chargé'))
        xsltAction.triggered.connect(self.xlstact)
        self.logAction = QtGui.QAction(self.tr('Journal'), self)
        self.logAction.setCheckable(True)
        self.logAction.setChecked(True)
        self.logAction.setStatusTip(self.tr('Afffichage du journal'))
        self.logAction.triggered.connect(self.afflog)
        langAction = QtGui.QAction(self.tr('Langage'), self)
        langAction.setStatusTip(self.tr("Change la langue de l'application"))
        langAction.triggered.connect(self.langch)
        #mise en place de la status bar
        self.statusBar()

        #mise en place de la barre de menu
        menubar = self.menuBar()
        fileMenu = menubar.addMenu(self.tr('&Fichier'))       
        fileMenu.addAction(reloadAction)
        fileMenu.addAction(mgAction)
        fileMenu.addAction(saveAction)
        fileMenu.addSeparator()
        fileMenu.addAction(printAction)
        fileMenu.addAction(previewAction)
        fileMenu.addSeparator()
        fileMenu.addAction(exitAction)
        affMenu = menubar.addMenu(self.tr('&Affichage'))
        affMenu.addAction(self.logAction)
        viewMenu = menubar.addMenu(self.tr('&Vue'))
        viewMenu.addAction(zoomAction)
        viewMenu.addAction(dezoomAction)
        actMenu = menubar.addMenu(self.tr('&Action'))
        actMenu.addAction(self.diffAction)
        actMenu.addAction(xsltAction)
        configMenu = menubar.addMenu(self.tr('&Options'))
        configMenu.addAction(configAction)
        configMenu.addAction(langAction)
        aideMenu = menubar.addMenu('&?')
        aideMenu.addAction(helpAction)
        aideMenu.addAction(aboutAction)
        
        #mise en place d'une toolbar
        fictoolbar = self.addToolBar(self.tr('Fichier'))
        fictoolbar.addAction(reloadAction)
        fictoolbar.addAction(mgAction)
        fictoolbar.addAction(saveAction)
        fictoolbar.addSeparator()
        fictoolbar.addAction(printAction)
        fictoolbar.addAction(previewAction )
        fictoolbar.addSeparator()
        fictoolbar.addAction(exitAction)
        viewtoolbar = self.addToolBar(self.tr('Vue'))
        viewtoolbar.addAction(zoomAction)
        viewtoolbar.addAction(dezoomAction)
        acttoolbar = self.addToolBar(self.tr('Action'))
        acttoolbar.addAction(self.diffAction)
        self.log = QtGui.QTextEdit(self)
        self.log.setReadOnly(True)
        sys.stderr = OutLog(self.log, sys.stderr)
        sys.stdout = OutLog(self.log, sys.stdout)
        self.docklog = QtGui.QDockWidget(self.tr('Journal'))
        self.docklog.setAllowedAreas(QtCore.Qt.BottomDockWidgetArea)
        self.docklog.setWidget(self.log)
        self.docklog.setFeatures(QtGui.QDockWidget.NoDockWidgetFeatures)
        self.addDockWidget(QtCore.Qt.BottomDockWidgetArea, self.docklog)
        self.setWindowTitle('PyTreeView')
        self.affilog = True
        
    #affiche le message d'aide
    def aide(self):
        QtGui.QMessageBox.about(self,self.tr("Aide"),self.tr("Veuillez lire le README.pdf fournit avec l'application pour son fonctionnement."))
    
    #affiche le message a propos
    def about(self):
        QtGui.QMessageBox.about(self,self.tr("A propos de PyTreeView"),self.tr("Cette application a ete devellope durant un stage de 3° annee par Jean-Baptiste PERRIN."))

    #affiche le widget de configuration
    def config(self):
        self.config = Configuration()
        self.config.show()
        self.centralWidget().configchange()
    
    #ajoute du text dans le widget de texte
    def addtext(self, str):
        self.log.insertHtml('<font color=\'black\'><pre>' + str + '</pre></font><br>')
        c =  self.log.textCursor()
        c.movePosition(QtGui.QTextCursor.End)
        self.log.setTextCursor(c)

    def adderror(self, str):
        self.log.insertHtml('<font color=\'red\'><pre>' + str + '</pre></font><br>')
        c =  self.log.textCursor()
        c.movePosition(QtGui.QTextCursor.End)
        self.log.setTextCursor(c)


#fonction principale
    def xlstact(self):
        if self.widcentral.filename is not None:
            self.wid = Xslt(self.widcentral.filename)
            self.wid.show()
        else:
            self.adderror(self.tr('Aucun fichier chargé'))
    
    def afflog(self):
        if self.affilog:
            self.removeDockWidget(self.docklog)
            self.affilog = False
        else:
            self.docklog.setVisible(True)
            self.addDockWidget(QtCore.Qt.BottomDockWidgetArea, self.docklog)
            self.affilog = True
        
    def verdiff(self):
        if self.widcentral.last is None:
                self.adderror(self.tr('Aucune entrée chargé. Impossible de faire une comparaison avec rien'))
                self.diffAction.setChecked(False)

    def getxmlname(self):
        str = QtGui.QFileDialog.getOpenFileName(self,self.tr('Ouvrir un fichier XML'),QtCore.QDir().homePath(), self.tr('Fichier XML (*.xml)'))
        self.generergraphe(str,self.formalism)
    
    def getmgname(self):
        str = QtGui.QFileDialog.getOpenFileName(self,self.tr('Ouvrir un fichier MG'),QtCore.QDir().homePath(), self.tr('Fichier MG (*.mg)'))
        self.generergraphe(str,self.formalism)
     
    def langch(self):
        self.widlang = Lang()
        self.widlang.show()

#fonction principale
def main(args=[],formalism="tag"):
    app = QtGui.QApplication(args)
    if config['GENERAL']['lang']=='ENG':
        appTranslator = QtCore.QTranslator()
        appTranslator.load("PyTreeView_en")
        app.installTranslator(appTranslator)
    ex=PyTreeView(formalism)                
    ex.showMaximized()
    if len(QtGui.QApplication.arguments()) > 1:
        s = QtGui.QApplication.arguments()[1]
        ex.generergraphe(s,formalism)
    sys.exit(app.exec_())

if __name__ == '__main__':
    main(sys.argv)
