import model.qobjectlistmodel
import model.playlist
import model.controller
import model.servicemanager
import model
import resource_manager # need to compile_resources.py first
import sys
import codecs
import io
# import win32gui

from PyQt5.QtCore import QUrl, qInstallMessageHandler, QThread
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import QQmlApplicationEngine, \
                        qmlRegisterUncreatableType
# from PyQt5.QtGui import QCursor

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

    # weird encoding fix, so the application won't crash when we print something bad
    if sys.stdout.encoding != 'cp850':
        sys.stdout = UnbufferedWriter(codecs.getwriter('cp850')(sys.stdout.buffer, 'replace'))
    if sys.stderr.encoding != 'cp850':
        sys.stderr = UnbufferedWriter(codecs.getwriter('cp850')(sys.stderr.buffer, 'replace'))

    resource_manager.init_resources()

    qInstallMessageHandler(message_handler)

    app = QApplication(sys.argv)

    register_type(model.playlist.Playlist, "Playlist")
    register_type(model.servicemanager.ServiceManager, "ServiceManager")
    register_type(model.audioentry.AudioEntry, "AudioEntry")

    engine = QQmlApplicationEngine()
    controller = model.controller.Controller()

    context = engine.rootContext()
    context.setContextProperty("controller", controller)

    engine.load(QUrl("qrc:/ui/main.qml"))
    '''
    def callback(hwnd, extra):
        rect = win32gui.GetWindowRect(hwnd)
        x = rect[0]
        y = rect[1]
        w = rect[2] - x
        h = rect[3] - y
        print("Window %s:" % win32gui.GetWindowText(hwnd))
        print("\tLocation: (%d, %d)" % (x, y))
        print("\t    Size: (%d, %d)" % (w, h))

    win32gui.EnumWindows(callback, None)

    callback(win32gui.GetForegroundWindow(), None)
    '''

    '''
    while not app.closingDown():
        print("nigger")
        app.processEvents()
        print("nigger2")
        while app.hasPendingEvents():
            print("nigger3")
            app.processEvents()
            QThread.msleep(10)
        QThread.msleep(100)
    '''

    '''
    def enumHandler(hwnd, lParam):
        if win32gui.IsWindowVisible(hwnd):
            if 'Xyon' in win32gui.GetWindowText(hwnd):
                print("Found xyon", hwnd)
                # win32gui.MoveWindow(hwnd, 0, 0, 760, 500, True)

    win32gui.EnumWindows(enumHandler, None)
    '''

    app.exec_()