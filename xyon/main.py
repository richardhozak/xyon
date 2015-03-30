import resource_manager
import sys
# from PyQt5.QtCore import QUrl, QObject, pyqtProperty, QAbstractListModel, QModelIndex, QVariant
from PyQt5.QtCore import *
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine  # , QQmlListProperty
from PyQt5.QtMultimedia import QMediaPlayer
import model.qobjectlistmodel


class Playlist(QObject):

    def __init__(self, parent=None):
        super(Playlist, self).__init__(parent)


class Controller(QObject):

    def __init__(self, parent=None):
        super(Controller, self).__init__(parent)
        self._list = model.qobjectlistmodel.QObjectListModel([])
        self._mediaPlayer = QMediaPlayer(self)

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def items(self):
        return self._list

    @pyqtProperty(QMediaPlayer)
    def mediaPlayer(self):
        return self._mediaPlayer

if __name__ == "__main__":

    resource_manager.init_resources()

    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    controller = Controller()
    # controller.items.append(QObject())

    context = engine.rootContext()
    context.setContextProperty("controller", controller)
    context.setContextProperty("mediaPlayer", controller.mediaPlayer)

    engine.load(QUrl("qrc:/ui/main.qml"))

    app.exec_()
