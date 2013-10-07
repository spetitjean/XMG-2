
# -*- coding: utf-8 -*-
from PyQt4 import QtGui, QtCore
from xmg.treeview.child import Child
import configparser
from xmg.treeview.viewer import TraceViewer
from math import *
from xmg.treeview.graphwid import Graphwid
from xmg.treeview.config import config
#permet de de garder  le pere d'un noeud et son widget associe
class Contenir():
    parent = ""
    wid = None
    name = ""
    def __init__(self, parent, widget, name):
        self.parent = parent
        self.name = name
        self.wid = widget

class WidCentral(QtGui.QWidget):
    attend = QtCore.pyqtSignal()
    ferme = QtCore.pyqtSignal()
    addtxt =  QtCore.pyqtSignal(str)
    listwid = []
    listview = []
    listline = []
    dict = {}
    last = None
    arbre = None
    diffcolor = None
    filename = None
    laststr = ""
    error = QtCore.pyqtSignal(str)
    #charge la config
    def loadconfig(self):
        self.arbre = True if config['WIDGET']['mode'].find('Arbre') > -1 else False
        self.diffcolor = QtGui.QColor(config['WIDGET']['diffcolor'])

    #constructeur de la classe
    def __init__(self):
        super(WidCentral, self).__init__()
        self.initUI()
        
    #initialise les elements de la classe   
    def initUI(self):
        self.layout = QtGui.QGridLayout()
        topAction = QtGui.QAction(self.tr("Affichage top"), self)
        topAction.setShortcut('Ctrl+T')
        topAction.setStatusTip(self.tr("Affichage top"))
        topAction.triggered.connect(self.changetop)
        botAction = QtGui.QAction(self.tr("Affichage bot"), self)
        botAction.setShortcut('Ctrl+B')
        botAction.setStatusTip(self.tr("Affichage bot"))
        botAction.triggered.connect(self.changebot)

        traitAction = QtGui.QAction(self.tr("Changer lien"), self)
        traitAction.setShortcut('Ctrl+L')
        traitAction.setStatusTip(self.tr("Changer les liens entre les noeuds"))  
        traitAction.triggered.connect(self.changetrait)
        size = self.size()
        #widget permettant l'affichage de la scene graphique
        self.textEdit = QtGui.QGraphicsScene()
        self.view = QtGui.QGraphicsView(self.textEdit)
        self.view.setContextMenuPolicy(QtCore.Qt.ActionsContextMenu)
        self.view.addAction(traitAction)
        self.view.addAction(topAction)
        self.view.addAction(botAction)
        self.listview.append(self.view)
        self.view.resize(size.width(), size.height() * 0.80)
        labs = QtGui.QLabel("syntax")
        labs.setAlignment(QtCore.Qt.AlignHCenter)
        self.layout.addWidget(labs, 0, 0)
        self.graphlayout = QtGui.QGridLayout()
        self.layout.addLayout(self.graphlayout, 1, 0)
        self.graphlayout.addWidget(self.view, 0, 0)
        splitter2 = QtGui.QSplitter(QtCore.Qt.Vertical)
        self.layout.addWidget(splitter2, 0, 1, 2, 1)
        labsem = QtGui.QLabel("semantics")
        labsem.setAlignment(QtCore.Qt.AlignHCenter)
        splitter2.addWidget(labsem)
        self.linesem = QtGui.QTextEdit()
        self.linesem.setReadOnly(True)
        self.linesem.setAlignment(QtCore.Qt.AlignHCenter)
        splitter2.addWidget(self.linesem)
        labt = QtGui.QLabel("trace")
        labt.setAlignment(QtCore.Qt.AlignHCenter)
        splitter2.addWidget(labt)
        self.list = QtGui.QListWidget()
        self.list.itemClicked.connect(self.traceclick)
        splitter2.addWidget(self.list)
        labi = QtGui.QLabel("interface")
        labi.setAlignment(QtCore.Qt.AlignHCenter)
        splitter2.addWidget(labi)
        self.listinter = QtGui.QListWidget()
        splitter2.addWidget(self.listinter)
#        labts = QtGui.QLabel("trace summary")
#        labts.setAlignment(QtCore.Qt.AlignHCenter)
#        splitter2.addWidget(labts)
#        self.sum = QtGui.QListWidget()
#        splitter2.addWidget(self.sum)
        
        self.setLayout(self.layout)
        #definition du zoom maximale et minimal
        self.minScale = 0
        self.maxScale = 2

    #retourne le nombre de fils d'un noeud
    def nbchild(self, name):
        cpt=0
        for i in self.listwid:
            if i.parent == name:
                cpt +=1
        return cpt
    
    def gensem(self, item):
        self.linesem.setText(item.semantics)
    
    def gentrace(self, item):
        self.list.addItems(item.trace)

    def geninter(self, item,  dict):
            lists = []
            for i in item.interface.table.keys():
                if item.interface.table[i] not in dict:
                    dict[item.interface.table[i]] = '?X' + str(len(dict))
                lists.append(i +'='+ dict[item.interface.table[i]])
            self.listinter.addItems(lists)
            for i in range(self.listinter.count()):
                self.listinter.item(i).setTextAlignment(QtCore.Qt.AlignHCenter)
       #definit la connection entre la fenetre graphique et l'index
    def connection(self,item):
        if len(self.listview) > 1:
            for i in self.listview:
                i.setVisible(False)
                self.graphlayout.removeWidget(i)
                i.close()
            self.listview = [self.view]
            self.view.setVisible(True)
            self.graphlayout.addWidget(self.view, 0, 0)
        self.loadconfig()
        self.list.clear()
        self.listinter.clear()
        self.linesem.clear()
        self.textEdit = self.view.scene()
        self.textEdit.clear()
        self.listwid = []
        self.listline = []
        self.last = item
        self.dict = {}
        self.gentrace(item)
        if not item.semantics is None:
            self.gensem(item)
        proxy = QtGui.QGraphicsProxyWidget()
        wid = Child(item.root.fs, item.root.type, self.dict)
        proxy.setWidget(wid)
        self.listwid.append(Contenir("", proxy,  item.root.name))
        self.generewid(item.root)
        sorted(self.listwid, key=lambda Contenir: Contenir.parent)
        x = self.calcullargeur(0)
        y = self.calculhauteur(0)
        self.view.scene().setSceneRect(0-50, 0, x+100, y+100)
        self.listwid[0].wid.setPos(x//2 - self.listwid[0].wid.rect().width()//2, 50)
        centre = self.listwid[0].wid.windowFrameGeometry().center()
        self.placement(0, 50, centre, x)
        if item.interface is not None:
            self.geninter(item, self.dict)
        if self.arbre:
            self.genererlineclassic()
        else:
            self.genererlinedroite()
        for i in self.listline:
            self.view.scene().addItem(i)                
        for i in self.listwid:
            self.view.scene().addItem(i.wid)
            
    #fonction qui remplit le tableau des lines et widgets a affiche
    def placement(self,  index, posy, centre, longeurfen):
        x = centre.x() - longeurfen//2
        for i in range(len(self.listwid)):
            if self.listwid[i].parent == self.listwid[index].name:
                w = self.calcullargeur(i)
                self.listwid[i].wid.setPos(x + (w//2 - self.listwid[i].wid.rect().width()//2) , posy+self.listwid[index].wid.rect().height()+50)
                self.placement(i, posy+self.listwid[index].wid.rect().height()+50, self.listwid[i].wid.windowFrameGeometry().center(), w)
                x += w + 100

    #fonction retournant le maximun de la liste
    def max(self,  list):
        max = 0
        for i in list:
            if i>max:
                max = i
        return max
    
    #fonction retournant la hauteur de l'arbre
    def hauteur(self,  root):
        nbchild = root.childCount()
        if nbchild > 0:
            list=[]
            for i in range(nbchild):
                list.append(self.hauteur(root.child(i)))
            return 1 + max(list)
        else:
            return 1

    #calcul la hauteur neccessaire de la scene
    def calculhauteur(self, index):
        h = self.listwid[index].wid.rect().height()
        listhauteur = []
        for i in range(len(self.listwid)):
            if self.listwid[i].parent == self.listwid[index].name:
                listhauteur.append(self.calculhauteur(i) + 50)
        return h + self.max(listhauteur)

    #fonction calculant la largeur neccessaire de la scene              
    def calcullargeur(self, index):
        cpt = 0
        nbchild = self.nbchild(self.listwid[index].name)
        if nbchild ==0:
            return self.listwid[index].wid.rect().width()
        elif nbchild ==1:
            for i in range(len(self.listwid)):
                if self.listwid[i].parent == self.listwid[index].name:
                    cpt = self.calcullargeur(i)
                    break
        elif nbchild > 1:
            cpt += (nbchild-1) * 100
            for i in range(len(self.listwid)):
                if self.listwid[i].parent == self.listwid[index].name:
                    cpt += self.calcullargeur(i)
        return cpt
        
            #zoom sur la scene graphique
    def zoom(self):
        if self.last is None:
            self.error.emit(self.tr('Impossible pour l\'instant. Car aucune entrée n\'est chargé'))
        else:
            self.scaleBy(1.1)
    
    #dezoom sur la scene graphique
    def dezoom(self):
        if self.last is None:
            self.error.emit(self.tr('Impossible pour l\'instant. Car aucune entrée n\'est chargé'))
        else:
            self.scaleBy(0.9)
    
    #retourn la zoom actuellement sur la scene
    def curScale(self):
        return self.view.transform().m11()
 
    #definit le zoom sur la scene graphique
    def scaleBy(self, scaleFactor):
        curScaleFactor = self.view.transform().m11();
        if ((curScaleFactor == self.minScale) and (scaleFactor < 1.0)) or ((curScaleFactor == self.maxScale) and (scaleFactor > 1.0)): 
            return;
        sc = scaleFactor; 
        if ((curScaleFactor * sc < self.minScale) and (sc < 1.0)):
            sc = self.minScale / curScaleFactor;
        else:
            if ((curScaleFactor * sc > self.maxScale) and (sc > 1.0)):
                sc = self.maxScale /     curScaleFactor
        self.view.scale(sc, sc);

    #definie le zoom par rapport ou % passe en paramêtre
    def setZoom(self, percentZoom):
        targetScale = percentZoom / 100.0
        scaleFactor = targetScale / self.centralWidget().transform().m11()
        self.scaleBy(scaleFactor)
    
    #deplace la scene vers le haut
    def movup(self):
        if self.last is None:
            self.error.emit(self.tr('Impossible pour l\'instant. Car aucune entrée n\'est chargé'))
        else:
            ancien = self.centralWidget().sceneRect()
            self.view.setSceneRect(ancien.x() - 10, ancien.y(), ancien.width(), ancien.height())

    #deplace la scene vers le bas
    def movdown(self):
        if self.last is None:
            self.error.emit(self.tr('Impossible pour l\'instant. Car aucune entrée n\'est chargé'))
        else:
            ancien = self.centralWidget().sceneRect()
            self.view.setSceneRect(ancien.x() + 10, ancien.y(), ancien.width(), ancien.height())

    #deplace la scene vers la gauche
    def movleft(self):
        if self.last is None:
            self.error.emit(self.tr('Impossible pour l\'instant. Car aucune entrée n\'est chargé'))
        else:
            ancien = self.centralWidget().sceneRect()
            self.view.setSceneRect(ancien.x(), ancien.y()-10, ancien.width(), ancien.height())
    
    #deplace la scene vers la droite
    def movrigth(self):
        if self.last is None:
            self.error.emit(self.tr('Impossible pour l\'instant. Car aucune entrée n\'est chargé'))
        else:
            ancien = self.centralWidget().sceneRect()
            self.view.setSceneRect(ancien.x(), ancien.y()+10, ancien.width(), ancien.height())
    
    #sauvegarde le graphique dans une image
    def save(self):
        if self.last is None:
            self.error.emit(self.tr('Aucune fenetre chargée'))
        else:
            img = QtGui.QImage(self.view.scene().sceneRect().width(),self.view.scene().sceneRect().height(),QtGui.QImage.Format_ARGB32_Premultiplied	)
            p = QtGui.QPainter(img)
            self.view.scene().render(p)
            p.end()
            img.save(QtGui.QFileDialog.getSaveFileName(self,self.tr("Sauvegarder l'image"),QtCore.QDir.homePath() +"\image.png", self.tr("Images (*.png)")))
    
    #recharge la config des widgets
    def configchange(self):
        for i in self.listwid:
            i.wid.widget().loadconfig()

    #genere les fils
    def generewid(self, item):
        for i in item.children:
            proxy = QtGui.QGraphicsProxyWidget()
            wid = Child(i.fs, i.type, self.dict)
            proxy.setWidget(wid)
            self.listwid.append(Contenir(item.name, proxy, i.name))
            self.generewid(i)
    
    #change le mode des widget
    def changebot(self):
        if self.last is not None:
            config['WIDGET']['bot'] = 'False' if config['WIDGET']['bot'].find('True')>-1 else 'True'
            config.save()
            self.addtxt.emit(self.tr('Changement d\'affichage de bot'))
            self.connection(self.last)
        else:
            self.error.emit(self.tr('Impossible pour l\'instant'))

    #change le mode des widget
    def changetop(self):
        if self.last is not None:
            config['WIDGET']['top'] = 'False' if config['WIDGET']['top'].find('True')>-1 else 'True'
            config.save()
            self.addtxt.emit(self.tr('Changement d\'affichage de top'))
            self.connection(self.last)
        else:
            self.error.emit(self.tr('Impossible pour l\'instant'))


    #change le mode des liens entre les noeuds
    def changetrait(self):
        if self.last is not None:
            config['WIDGET']['mode'] = 'Organigramme' if config['WIDGET']['mode'].find(self.tr('Arbre'))>-1 else 'Arbre'
            config.save()
            self.addtxt.emit(self.tr('Changement du mode des liens'))
            self.connection(self.last)
        else:
            self.error.emit(self.tr('Impossible pour l\'instant'))


    #genere les lines en mode "Arbre"
    def genererlineclassic(self, index=0):
        if self.nbchild(self.listwid[index].name) > 0:
            for i in range(len(self.listwid)):
                if self.listwid[i].parent == self.listwid[index].name:
                    centre1 = self.listwid[index].wid.windowFrameGeometry().center()
                    centre2 = self.listwid[i].wid.windowFrameGeometry().center()
                    self.listline.append(QtGui.QGraphicsLineItem(QtCore.QLineF(centre1, centre2)))
                    self.genererlineclassic(i)

    #genere les lines en mode "Organigramme"
    def genererlinedroite(self, index=0):
        if self.nbchild(self.listwid[index].name) > 0:
            maxx = 0 
            miny = 1000000
            minx = 1000000
            for i in range(len(self.listwid)):
                if self.listwid[i].parent == self.listwid[index].name:
                    centre = self.listwid[i].wid.windowFrameGeometry().center()
                    top = self.listwid[i].wid.windowFrameGeometry().topLeft()
                    if centre.x() < minx:
                        minx = centre.x()
                    if centre.x() > maxx:
                        maxx = centre.x()
                    if top.y() < miny:
                        miny = top.y()
            posybar = (miny + self.listwid[index].wid.windowFrameGeometry().bottomLeft().y())//2
            minbar = QtCore.QPointF(minx, posybar)
            maxbar =  QtCore.QPointF(maxx, posybar)
            self.listline.append(QtGui.QGraphicsLineItem(QtCore.QLineF(self.listwid[index].wid.windowFrameGeometry().center(), QtCore.QPointF(self.listwid[index].wid.windowFrameGeometry().center().x(), posybar))))
            self.listline.append(QtGui.QGraphicsLineItem(QtCore.QLineF(minbar, maxbar)))
            for i in range(len(self.listwid)):
                if self.listwid[i].parent == self.listwid[index].name:
                    centre = self.listwid[i].wid.windowFrameGeometry().center()
                    self.listline.append(QtGui.QGraphicsLineItem(QtCore.QLineF(centre, QtCore.QPointF(centre.x(), posybar))))
                    self.genererlinedroite(i)

    def impression(self):
        if self.last is not None:
            printer = QtGui.QPrinter()
            printDialog = QtGui.QPrintDialog(printer, self)
            if printDialog.exec_() == QtGui.QDialog.Accepted:
                self.printgraph(printer)
        else:
            self.error.emit(self.tr('Rien à imprimer dans la fenetre graphique'))
    
    def apercu(self):
        if self.last is not None:
            printer = QtGui.QPrinter(QtGui.QPrinter.HighResolution)
            printer.setPageSize(QtGui.QPrinter.A4)
            preview = QtGui.QPrintPreviewDialog(printer)
            preview.paintRequested.connect(self.printgraph)
            preview.exec_()
        else:
            self.error.emit(self.tr('Rien à imprimer dans la fenetre graphique'))
        

    def printgraph(self, printer):
        p = QtGui.QPainter(printer)
        self.view.scene().render(p,QtCore.QRectF(0, 0,printer.width(), printer.height() / 2))
#        self.view.scene().render(p)
        p.end()

    def diff(self, item):
        if self.last is not  None:
            self.addtxt.emit(self.tr('Comparaison entre le noeud') + item.root.name + self.tr(' et ')+  self.last.root.name)
            self.viewdiff = QtGui.QGraphicsView(QtGui.QGraphicsScene())
            self.listview.append(self.viewdiff)
            self.afffam(item, self.viewdiff.scene())
            self.afffam(self.last, self.view.scene())
            self.graphlayout.addWidget(self.viewdiff, 0, 1)
            if item.root == self.last.root:
                self.addtxt.emit(self.tr('Ils sont identiques'))
                k = 0
                for i in item.root.children:
                    if k > len(self.last.root.children):
                        break
                    self.diffrec(i, self.last.root.children[k])
                    k += 1
                if k < len(self.last.root.children):
                    for i in self.last.root.children[k:]:
                        for k in range(len(self.listwid)):
                            if i.name == self.listwid[k].name:
                                self.color(k)
                                break
            else:
                self.addtxt.emit(self.tr('Ils sont differents'))
                for i in range(len(self.listwid)):
                    if self.last.root.name == self.listwid[i].name:
                        self.color(i)
                        break

    def diffrec(self, item, diff):
            self.addtxt.emit(self.tr('Comparaison entre le noeud') + item.name + self.tr(' et ') + diff.name)
            if item == diff:
                k = 0
                for i in item.children:
                    if k > len(diff.children):
                        break
                    self.diffrec(i, diff.children[k])
                    k += 1
                if k < len(diff.children):
                    for i in diff.children[k:]:
                        for k in range(len(self.listwid)):
                            if i.name == self.listwid[k].name:
                                self.color(k)
                                break
            else:
                for i in range(len(self.listwid)):
                    if diff.name == self.listwid[i].name:
                        self.color(i)
                        break

    def color(self, index):
        self.listwid[index].wid.widget().changecolor(self.diffcolor)
        if self.nbchild(self.listwid[index].name):
            for i in range(len(self.listwid)):
               if self.listwid[index].name == self.listwid[i].parent:
                   self.color(i)

    def traceclick(self, item):
        self.viewer = TraceViewer(item.text(), self.filename)
        self.viewer.show()
        
    def connectionfam(self, listitem):
        if len(listitem) == 1:
            self.connection(listitem[0])
        else:
            self.last = None
            self.assoc = {}
            for i in self.listview:
                i.setVisible(False)
                self.graphlayout.removeWidget(i)
            self.listview = []
            if sqrt(len(listitem)) == trunc(sqrt(len(listitem))):
                maxx=maxy= sqrt(len(listitem))
            else:
                maxy = trunc(sqrt(len(listitem)))
                maxx = maxy + 1
            x = y = 0
            for i in listitem:
                viewaux = Graphwid(QtGui.QGraphicsScene(), i.name)
                viewaux.select.connect(self.select)
                viewaux.raz.connect(self.razbool)
                viewaux.under.connect(self.under)
                self.listview.append(viewaux)
                self.afffam(i, viewaux.scene())
                self.assoc[i.name] = (i, dict)
                self.graphlayout.addWidget(viewaux, y, x)
                x += 1
                if x == maxx:
                    y += 1
                    x = 0                
    #definit l'affichage d'une famille
    def afffam(self,item, scene):
        self.loadconfig()
        self.list.clear()
        self.listinter.clear()
        self.linesem.clear()
        self.textEdit = self.view.scene()
        self.textEdit.clear()
        self.listwid = []
        self.listline = []
        self.dict = {}
        proxy = QtGui.QGraphicsProxyWidget()
        wid = Child(item.root.fs, item.root.type, self.dict)
        proxy.setWidget(wid)
        self.listwid.append(Contenir("", proxy,  item.root.name))
        self.generewid(item.root)
        sorted(self.listwid, key=lambda Contenir: Contenir.parent)
        x = self.calcullargeur(0)
        self.listwid[0].wid.setPos(x//2 - self.listwid[0].wid.rect().width()//2, 50)
        centre = self.listwid[0].wid.windowFrameGeometry().center()
        self.placement(0, 50, centre, x)
        if self.arbre:
            self.genererlineclassic()
        else:
            self.genererlinedroite()
        for i in self.listline:
            scene.addItem(i)                
        for i in self.listwid:
            scene.addItem(i.wid)
    
    def select(self, str):
        self.connection(self.assoc[str][0])
        
    def razbool(self):
        for i in self.listview:
            i.razbool()
    
    def under(self, str):
        if not self.laststr == str:
            self.laststr = str
            self.list.clear()
            self.listinter.clear()
            self.linesem.clear()
            self.gentrace(self.assoc[str][0])
            if self.assoc[str][0].semantics is not None:
                self.gensem(self.assoc[str][0])
            if self.assoc[str][0].interface is not None:
                self.geninter(self.assoc[str][0], self.assoc[str][1])
