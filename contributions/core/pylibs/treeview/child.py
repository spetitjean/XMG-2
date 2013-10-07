# -*- coding: utf-8 -*-
from PyQt4 import QtGui, QtCore
from xmg.treeview.config import config
#classe representant un noeud de l'arbre
class Child(QtGui.QWidget):
    bot = None
    top = None
    #constructeur de la classe
    def __init__(self, list, type, dict):
        super(Child, self).__init__()
        self.initUI(list, type, dict)
    
    #charge le configuration
    def loadconfig(self):
        pal = self.palette()
        pal.setColor(self.backgroundRole(), QtGui.QColor(config['WIDGET']['widcolor']))
        pal.setColor(QtGui.QPalette.WindowText, QtGui.QColor(config['WIDGET']['fontcolor']))
        self.setPalette(pal)
        self.setFont(QtGui.QFont(config['WIDGET']['font'])) 
        self.top = True if config['WIDGET']['top'].find('True')>-1 else False
        self.bot = True if config['WIDGET']['bot'].find('True')>-1 else False

    def changecolor(self, color):
        pal = self.palette()
        pal.setColor(self.backgroundRole(), color)
        self.setPalette(pal)
        
    #genere les valeurs des noeuds internes
    def fsinterne(self,  fs):
        listtext = []
        for i in fs.table.keys():
            if str(fs.table[i]).find('ALT') >-1:
                s = ""
                for j in fs.table[i].values:
                    s+= j + '|'
                s = s[:-1]
                listtext.append(i + "=" + s)
            elif str(fs.table[i]).find('FS')>-1:
                listtext.expend(self.fsinterne(fs.table[i]))
            else: 
                listtext.append(i + "=" +fs.table[i])
        return listtext

    #initialise les elements de la classe
    def initUI(self,list, type, dict):
        self.loadconfig()
        self.layout = QtGui.QGridLayout()
        self.setLayout(self.layout)
        cpt = 1
        s = ''
        for i in list.table.keys():
            if i.find('cat') > -1:
                s=""
                if str(list.table[i]).find('ALT') > -1:
                    for j in list.table[i].values:
                        s+= j + '|'
                    s = s[:-1]
                else:
                    s+= list.table[i]
                if type.find('subst')>-1:
                    s +='\u2193'
                elif type.find('foot')>-1:
                    s +='*'
                elif type.find('anchor')>-1:
                    s +='\u2666'
                title = QtGui.QLabel(s)
                title.setAlignment( QtCore.Qt.AlignHCenter)
                self.layout.addWidget(title, 0, 0, 1, 2)
                if not self.top and not self.bot:
                    break
            elif i.find('bot')>-1 and self.bot:
                labbot = QtGui.QLabel('bot:')
                self.layout.addWidget(labbot, cpt, 0)
                if str(list.table[i]).find('ALT') >-1:
                    s = ""
                    for j in list.table[i].values:
                        s+= j + '|'
                    s = s[:-1]
                    lab = QtGui.QLabel(s)
                    self.layout.addWidget(lab, cpt, 1)
                elif str(list.table[i]).find('FS')>-1:
                    listt = self.fsinterne(list.table[i])
                    for h in listt:
                        cpt +=1
                        if h.find('_G')> -1:
                            s = h[h.find('_G'):]
                            if s not in dict:
                                dict[s] = '?X' + str(len(dict))
                            lab = QtGui.QLabel(h[:h.find('_G')] + dict[s])
                        else:
                            lab = QtGui.QLabel(h) 
                        self.layout.addWidget(lab, cpt, 1)
                else:
                    if list.table[i].find('_G')> -1:
                        s = list.table[i][list.table[i].find('_G'):]
                        QtGui.QMessageBox.information(self, 'titre', s)
                        if s not in dict:
                            dict[s] = '?X' + str(len(dict))
                        lab = QtGui.QLabel(list.table[i][:list.table[i].find('_G')] + dict[s])
                    else:
                        lab = QtGui.QLabel(list.table[i])
                    self.layout.addWidget(lab, cpt, 1)
                cpt +=1
            elif i.find('top')>-1 and self.top:
                labtop = QtGui.QLabel('top:')
                self.layout.addWidget(labtop, cpt, 0)
                if str(list.table[i]).find('ALT') >-1:
                    s = ""
                    for j in list.table[i].values:
                        s+= j + '|'
                    s = s[:-1]
                    lab = QtGui.QLabel(s)
                    self.layout.addWidget(lab, cpt, 1)
                elif str(list.table[i]).find('FS')>-1:
                    listt = self.fsinterne(list.table[i])
                    for h in listt:
                        cpt +=1
                        if h.find('_G')> -1:
                            s = h[h.find('_G'):]
                            if s not in dict:
                                dict[s] = '?X' + str(len(dict))
                            lab = QtGui.QLabel(h[:h.find('_G')] + dict[s])
                        else:
                            lab = QtGui.QLabel(h) 
                        self.layout.addWidget(lab, cpt, 1)
                else:
                    if list.table[i].find('_G')> -1:
                        s = list.table[i][list.table[i].find('_G'):]
                        if s not in dict:
                            dict[s] = '?X' + str(len(dict))
                        lab = QtGui.QLabel(list.table[i][:list.table[i].find('_G')] + dict[s])
                    else:
                        lab = QtGui.QLabel(list.table[i])
                    self.layout.addWidget(lab, cpt, 1)
                cpt +=1
            else:
                if str(list.table[i]).find('ALT') >-1:
                    s = ""
                    for j in list.table[i].values:
                        s+= j + '|'
                    s = s[:-1]
                    lab = QtGui.QLabel(s)
                    self.layout.addWidget(lab, cpt, 0, 1, 2)
                elif str(list.table[i]).find('FS')>-1:
                    listt = self.fsinterne(list.table[i])
                    for h in listt:
                        cpt +=1
                        if h.find('_G')> -1:
                            s = h[h.find('_G'):]
                            if s not in dict:
                                dict[s] = '?X' + str(len(dict))
                            lab = QtGui.QLabel(h[:h.find('_G')] + dict[s])
                        else:
                            lab = QtGui.QLabel(h) 
                        self.layout.addWidget(lab, cpt, 0, 1, 2)
                else:
                    if list.table[i].find('_G')> -1:
                        s = list.table[i][list.table[i].find('_G'):]
                        if s not in dict:
                            dict[s] = '?X' + str(len(dict))
                            lab = QtGui.QLabel(list.table[i][:list.table[i].find('_G')] + dict[s])
                    else:
                        lab = QtGui.QLabel(i + " : " +list.table[i])
                        self.layout.addWidget(lab, cpt, 0, 1, 2)
                    cpt +=1
                
