from PyQt5.QtCore import QObject, pyqtProperty


class AudioEntry(QObject):

    def __init__(self, url, type, time, title, parent=None):
        super(AudioEntry, self).__init__(parent)
        self._url = url
        self._type = type
        self._time = time
        self._title = title

    @pyqtProperty(type=str, constant=True)
    def url(self):
        return self._url

    @pyqtProperty(type=str, constant=True)
    def type(self):
        return self._type

    @pyqtProperty(type=str, constant=True)
    def time(self):
        return self._time

    @pyqtProperty(type=str, constant=True)
    def title(self):
        return self._title
