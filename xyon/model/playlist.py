import model.qobjectlistmodel
import model.audioentry

from PyQt5.QtQuick import *
from PyQt5.QtMultimedia import QMediaContent
from PyQt5.QtCore import \
    QObject, \
    pyqtProperty, \
    pyqtSignal, \
    pyqtSlot, \
    QUrl


class Playlist(QObject):

    def __init__(self, player):
        super(Playlist, self).__init__(player)
        self._currentIndex = -1
        self._currentPlayingIndex = -1
        self._items = model.qobjectlistmodel.QObjectListModel([])
        self._playingItem = None
        self.player = player
        self._resolvingEntry = None

    currentIndexChanged = pyqtSignal()

    @pyqtProperty(int, notify=currentIndexChanged)
    def currentIndex(self):
        return self._currentIndex

    @currentIndex.setter
    def currentIndex(self, value):
        if self._currentIndex != value:
            self._currentIndex = value
            self.currentIndexChanged.emit()
            self.playCurrentIndex()

    currentPlayingIndexChanged = pyqtSignal()

    @pyqtProperty(int, notify=currentPlayingIndexChanged)
    def currentPlayingIndex(self):
        return self._currentPlayingIndex

    @currentPlayingIndex.setter
    def currentPlayingIndex(self, value):
        if self._currentPlayingIndex != value:
            self._currentPlayingIndex = value
            self.currentPlayingIndexChanged.emit()
            self.playingItemChanged.emit()

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def items(self):
        return self._items

    playingItemChanged = pyqtSignal()

    @pyqtProperty(model.audioentry.AudioEntry, notify=playingItemChanged)
    def playingItem(self):
        if self._currentPlayingIndex < 0:
            return None

        return self._items.at(self._currentPlayingIndex)

    @pyqtSlot(model.audioentry.AudioEntry)
    def addAudioEntry(self, entry):
        self._items.append(entry)

    @pyqtSlot(int)
    def removeAt(self, index):
        self._items.removeAt(index)

    resolveUrl = pyqtSignal(model.audioentry.AudioEntry)

    def urlResolved(self, entry, url):
        if self._currentIndex == self._items.indexOf(entry):
            print("entries match")
            print("playing url")
            self.currentPlayingIndex = self._currentIndex
            self.player.setMedia(QMediaContent(QUrl(url)))
            self.player.play()

    def load_playlist(self, playlist):
        self._items.clear()
        self.currentPlayingIndex = -1
        self.currentIndex = -1
        self._items.setObjectList(playlist)

    def playCurrentIndex(self):
        print("play current index")
        print("currentIndex", self._currentIndex)
        print("items count", self._items.count)
        print("currentPlayingIndex", self._currentPlayingIndex)

        # self.player.setMedia(QMediaContent(QUrl("videoplayback.mp4")))
        # self.player.play()
        # return

        if ((self._currentIndex != -1 and
             self._currentIndex < self._items.count and
             self._currentPlayingIndex != self._currentIndex)):

            entry = self._items.at(self._currentIndex)

            if entry.type.endswith("track"):
                print("resolving url")
                self.player.setMedia(QMediaContent())
                self.resolveUrl.emit(entry)
            else:
                print("type is not audio")
