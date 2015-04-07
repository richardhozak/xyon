import model.qobjectlistmodel
import model.playlist
import model.controller
import model
import resource_manager
import sys

from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine, \
                        qmlRegisterUncreatableType


def register_type(rtype, name):
    qmlRegisterUncreatableType(rtype, "Xyon", 1, 0, name, name + " could not be registered.")

if __name__ == "__main__":

    resource_manager.init_resources()

    app = QGuiApplication(sys.argv)

    register_type(model.playlist.Playlist, "Playlist")
    register_type(model.audioentry.AudioEntry, "AudioEntry")

    engine = QQmlApplicationEngine()
    controller = model.controller.Controller()

    context = engine.rootContext()
    context.setContextProperty("controller", controller)

    engine.load(QUrl("qrc:/ui/main.qml"))

    app.exec_()
