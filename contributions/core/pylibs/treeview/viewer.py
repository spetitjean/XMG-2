# -*- coding: utf-8 -*-
from PyQt4 import QtGui, QtCore
import codecs, re, os
class TraceViewer(QtGui.QMainWindow):
    modif = False
    #constructeur de la classe
    def __init__(self, search, filename):
        super(TraceViewer, self).__init__()
        self.filename = filename
        self.initUI(search)
    #initialise les elements de la clasee
    def initUI(self, search):
        self.textedit = QtGui.QTextEdit()
        self.setCentralWidget(self.textedit)
        self.resize(500, 250)
        self.filename = self.filename[:self.filename.find('.xml')] + '.mg'
        if os.path.isfile(self.filename):
            self.findtext(self.filename, search)
            file = codecs.open(self.filename, encoding='utf-8', mode='r')
            lines = file.readlines()
            file.close()
            for i in lines:
                self.textedit.insertPlainText(i)
            exitAction = QtGui.QAction(QtGui.QIcon('quit.png'),self.tr('Quitter'), self)
            exitAction.setShortcut('Ctrl+Q')
            exitAction.setStatusTip(self.tr('Quitter l\'application'))
            exitAction.triggered.connect(self.close)
            saveAction = QtGui.QAction(QtGui.QIcon('save.png'),self.tr("Sauvegarder"), self)
            saveAction.setShortcut('Ctrl+S')
            saveAction.setStatusTip(self.tr("Sauvegarder"))
            saveAction.triggered.connect(self.save)
            printAction = QtGui.QAction(QtGui.QIcon('print.png'), self.tr('Imprimer'), self)
            printAction.setShortcut('Ctrl+P')
            printAction.setStatusTip(self.tr('Imprimer'))
            printAction.triggered.connect(self.impression)
            previewAction = QtGui.QAction(QtGui.QIcon('preview.png'), self.tr('Apercu'), self)
            previewAction.setShortcut('Ctrl+Alt+P')
            previewAction.setStatusTip(self.tr('Apercu avant impression'))
            previewAction.triggered.connect(self.apercu)
            menubar = self.menuBar()
            fileMenu = menubar.addMenu(self.tr('&Fichier'))       
            fileMenu.addAction(saveAction)
            fileMenu.addSeparator()
            fileMenu.addAction(printAction)
            fileMenu.addAction(previewAction)
            fileMenu.addSeparator()
            fileMenu.addAction(exitAction)
            self.setWindowTitle('TraceViewer (' + self.filename + ')')
            reg = QtCore.QRegExp('class ' + search + '(\[\])?\{?')
            reg.setMinimal(True)
            self.textedit.setTextCursor(self.textedit.document().find(reg, 0, QtGui.QTextDocument.FindWholeWords))
            self.textedit.textChanged.connect(self.textmodif)
        else:
            self.close()
    def textmodif(self):
        self.modif = True
        self.setWindowTitle('TraceViewer (' + self.filename + ')*')

    
    def save(self):
        file = codecs.open(self.filename, encoding='utf-8', mode='w')
        file.write(self.textedit.toPlainText())
        if self.modif:
            self.setWindowTitle('TraceViewer (' + self.filename + ')')
            self.modif = False

    
    def impression(self):
            printer = QtGui.QPrinter()
            printDialog = QtGui.QPrintDialog(printer, self)
            if printDialog.exec_() == QtGui.QDialog.Accepted:
                self.impre(printer)
  
    def apercu(self):
        printer = QtGui.QPrinter(QtGui.QPrinter.HighResolution)
        printer.setPageSize(QtGui.QPrinter.A4)
        preview = QtGui.QPrintPreviewDialog(printer)
        preview.paintRequested.connect(self.impre)
        preview.exec_()

    def impre(self, qprinter):
        self.textedit.print_(qprinter)
        
    def findtext(self, filename, search):
        file = codecs.open(filename, encoding='utf-8', mode='r')
        lines = file.readlines()
        file.close()
        find = False
        reg = re.compile('class ' + search +  '(\[.*\])?\{?$')
        for i in lines:
            if reg.match(i):
                find = True
                self.filename = filename
                break
        if not find:
            for i in lines:
                if i.find('include') == -1:
                    break
                else:
                    namefile = i.split()[1]
                    self.findtext(namefile, search)

def closeEvent(self,event):
        if self.modif:
            if QtGui.QMessageBox.question(self,self.tr("Question"),self.tr("Voulez-vous sauvegarder les changements ?"),QtGui.QMessageBox.Yes,QtGui.QMessageBox.No) == QtGui.QMessageBox.Yes:
                self.save()
