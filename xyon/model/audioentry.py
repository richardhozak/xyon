from PyQt5.QtCore import \
    QObject, \
    pyqtProperty


class AudioEntry(QObject):

    def __init__(self, url, type, time, title, img=None, parent=None):
        super(AudioEntry, self).__init__(parent)
        self._url = url
        self._type = type
        self._time = time
        self._title = title
        self._img = img

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
        return {"id": entry.url[-11:],
                "type": entry.type,
                "time": entry.time,
                "title": entry.title}

    @staticmethod
    def deserialize(entry, parent=None):
        entry_url = ""
        entry_img = ""
        entry_type = entry["type"]
        if entry_type == "youtube_audio":
            entry_url = "https://www.youtube.com/watch?v=" + entry["id"]
            entry_img = "https://img.youtube.com/vi/" + entry["id"] + "/default.jpg"
        elif entry_type == "soundcloud_audio":
            print("To be implemented.")
            raise ValueError("Will be implemented.")
        else:
            raise ValueError("Entry is not of valid type.")

        return AudioEntry(entry_url,
                          entry["type"],
                          entry["time"],
                          entry["title"],
                          entry_img,
                          parent)
