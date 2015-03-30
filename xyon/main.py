import resource_manager
import sys
# from PyQt5.QtCore import QUrl, QObject, pyqtProperty, QAbstractListModel, QModelIndex, QVariant
from PyQt5.QtCore import *
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine  # , QQmlListProperty
import model.qobjectlistmodel


class Controller(QObject):

    def __init__(self, parent=None):
        super(Controller, self).__init__(parent)
        self._list = model.qobjectlistmodel.QObjectListModel([])

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def items(self):
        return self._list

if __name__ == "__main__":

    resource_manager.init_resources()

    app = QGuiApplication(sys.argv)

    controller = Controller()
    controller.items.append(QObject())
    # controller.append_item(controller, QObject())
    # print(controller.items.count)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("controller", controller)
    engine.load(QUrl("qrc:/ui/main.qml"))

    app.exec_()
