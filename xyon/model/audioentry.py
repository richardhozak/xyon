from PyQt5.QtCore import \
    QObject, \
    pyqtProperty

from PyQt5.QtQml import QQmlEngine


class AudioEntry(QObject):

    def __init__(self, url, type, time, title, img=None, parent=None):
        super(AudioEntry, self).__init__(parent)
        self._url = url
        self._type = type
        self._time = time
        self._title = title
        self._img = img
        QQmlEngine.setObjectOwnership(self, QQmlEngine.CppOwnership)

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

    @pyqtProperty(type=str, constant=True)
    def img(self):
        return self._img

    @staticmethod
    def serialize(entry):
        return {"url": entry.url,
                "type": entry.type,
                "time": entry.time,
                "title": entry.title,
                "img": entry.img}

    @staticmethod
    def deserialize(entry, parent=None):
        return AudioEntry(entry["url"],
                          entry["type"],
                          entry["time"],
                          entry["title"],
                          entry["img"],
                          parent)
