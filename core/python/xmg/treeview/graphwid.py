from PyQt4 import QtGui, QtCore
class Graphwid(QtGui.QGraphicsView):
    #constructeur de la classe
    select = QtCore.pyqtSignal(str)
    raz = QtCore.pyqtSignal()
    under = QtCore.pyqtSignal(str)
    bool = False
    def __init__(self, scene, chaine):
        super(Graphwid, self).__init__(scene)
        self.chaine = chaine
        
    def mousePressEvent(self, event):
        if event.buttons() == QtCore.Qt.LeftButton:
            self.bool = True
            
    def mouseReleaseEvent(self, event):
        if self.bool:
            self.select.emit(self.chaine)
        else:
            self.raz.emit()
    def razbool(self):
        self.bool = False
 
    def mouseMoveEvent(self, event):
        self.under.emit(self.chaine)
