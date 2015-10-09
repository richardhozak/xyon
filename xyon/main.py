import model.qobjectlistmodel
import model.playlist
import model.controller
import model.servicemanager
import model
import resourcemanager  # need to compile_resources.py first
import sys
import os
import codecs

from PyQt5.QtCore import \
    QUrl, \
    qInstallMessageHandler
from PyQt5.QtWidgets import \
    QApplication
from PyQt5.QtQml import \
    QQmlApplicationEngine, \
    qmlRegisterUncreatableType


class UnbufferedWriter(object):

    def __init__(self, stream):
        self.stream = stream

    def write(self, data):
        self.stream.write(data)
        self.stream.flush()

    def __getattr__(self, attr):
        return getattr(self.stream, attr)


def message_handler(type, context, msg):
    print("%s(%u): %s" % (QUrl(context.file).fileName(), context.line, msg))


def register_type(rtype, name):
    qmlRegisterUncreatableType(rtype, "Xyon", 1, 0, name, name + " could not be registered.")

if __name__ == "__main__":
    # if not os.path.exists("tracks"):
    #     os.makedirs("tracks")

    # weird encoding fix, so the application won't crash when we print something bad
    if sys.stdout.encoding != 'cp850':
        sys.stdout = UnbufferedWriter(codecs.getwriter('cp850')(sys.stdout.buffer, 'replace'))
    if sys.stderr.encoding != 'cp850':
        sys.stderr = UnbufferedWriter(codecs.getwriter('cp850')(sys.stderr.buffer, 'replace'))

    resourcemanager.init_resources()

    app = QApplication(sys.argv)

    qInstallMessageHandler(message_handler)

    register_type(model.playlist.Playlist, "Playlist")
    register_type(model.servicemanager.ServiceManager, "ServiceManager")
    register_type(model.audioentry.AudioEntry, "AudioEntry")

    engine = QQmlApplicationEngine()
    controller = model.controller.Controller()

    context = engine.rootContext()
    context.setContextProperty("controller", controller)

    engine.load(QUrl("qrc:/ui/main.qml"))

    app.exec_()