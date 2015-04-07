import model.qobjectlistmodel
import model.youtubeservice

import json
import urllib.parse

from PyQt5.QtNetwork import *
from PyQt5.QtMultimedia import QMediaPlayer
from PyQt5.QtCore import \
    QObject, \
    pyqtSignal, \
    pyqtProperty, \
    pyqtSlot, \
    QUrl


class Controller(QObject):

    def __init__(self, parent=None):
        super(Controller, self).__init__(parent)
        self._searchlist = model.qobjectlistmodel.QObjectListModel([])
        self._queryList = model.qobjectlistmodel.QObjectListModel([])

        self._player = QMediaPlayer(self, QMediaPlayer.StreamPlayback)
        self._player.mediaStatusChanged.connect(self.playerStatusChanged)

        self._playlist = model.playlist.Playlist(self._player)
        self._playlist.resolveUrl.connect(self.resolveUrl)

        self._canGoPrevPage = False
        self._canGoNextPage = False

        self._ytService = model.youtubeservice.YoutubeService(self.search_callback)

        self._network_manager = QNetworkAccessManager(self)
        self._network_manager.finished.connect(self.reply_finished)

    canGoPrevPageChanged = pyqtSignal()
    canGoNextPageChanged = pyqtSignal()

    @pyqtProperty(bool, notify=canGoPrevPageChanged)
    def canGoPrevPage(self):
        return self._canGoPrevPage

    @canGoPrevPage.setter
    def canGoPrevPage(self, value):
        if self._canGoPrevPage != value:
            self._canGoPrevPage = value
            self.canGoPrevPage.emit()

    @pyqtProperty(bool)
    def canGoNextPage(self):
        return self._canGoNextPage

    @canGoNextPage.setter
    def canGoNextPage(self, value):
        if self._canGoNextPage != value:
            self._canGoNextPage = value
            self.canGoNextPageChanged.emit()

    @pyqtProperty(model.playlist.Playlist, constant=True)
    def playlist(self):
        return self._playlist

    @pyqtProperty(QMediaPlayer, constant=True)
    def player(self):
        return self._player

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def searchlist(self):
        return self._searchlist

    @pyqtSlot(str)
    def search(self, query):
        self._searchlist.clear()
        self._ytService.search(query)

    def search_callback(self, results):
        for entry in results:
            self._searchlist.append(entry)

    @pyqtSlot()
    def load_more(self):
        self._ytService.load_more()

    @pyqtSlot(str)
    def query_completion(self, text):
        if text is None or text == "":
            print("Empty query")
            self.reply_finished(None)
        else:
            print("Querying completion for", text)
            self._network_manager.get(QNetworkRequest(QUrl("http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&" + urllib.parse.urlencode({"q": text}))))

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def queryList(self):
        return self._queryList

    @pyqtSlot(QNetworkReply)
    def reply_finished(self, reply):
        if reply is None:
            self._queryList.clear()
        else:
            data_str = reply.readAll().data().decode("utf-8")
            obj = json.loads(data_str)
            if len(obj) == 2:
                # print("reply", obj[1])
                self._queryList.setObjectList(obj[1])
            else:
                self._queryList.clear()

    def resolveUrl(self, entry):
        print("resolving url for", entry.type, entry.title)
        url = self._ytService.resolve_url(entry.url)
        self._playlist.urlResolved(entry, url)

    @pyqtSlot(QMediaPlayer.MediaStatus)
    def playerStatusChanged(self, status):
        if status == QMediaPlayer.EndOfMedia:
            self._playlist.currentIndex += 1

    @pyqtSlot()
    def test(self):
        print("hola")
        self.testattach = pyqtProperty('QString')
        self.testattach = "Hello"
