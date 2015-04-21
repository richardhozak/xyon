import model.qobjectlistmodel
import model.youtubeservice
import model.soundcloudservice

# import subprocess
import json
import urllib.parse
import pickle
import os

from PyQt5.QtNetwork import *
from PyQt5.QtMultimedia import QMediaPlayer
from PyQt5.QtCore import \
    QObject, \
    pyqtSignal, \
    pyqtProperty, \
    pyqtSlot, \
    QUrl

from PyQt5.QtWidgets import QFileDialog, QWidget


class Controller(QObject):

    def __init__(self, parent=None):
        super(Controller, self).__init__(parent)

        self._suggestionList = model.qobjectlistmodel.QObjectListModel([], self)

        self._player = QMediaPlayer(self, QMediaPlayer.StreamPlayback)
        self._player.mediaStatusChanged.connect(self.playerStatusChanged)

        self._playlist = model.playlist.Playlist(self._player)
        self._playlist.resolveUrl.connect(self.resolveUrl)

        self.services = {
            "youtube": model.youtubeservice.YoutubeService(self.search_callback),
            "soundcloud": model.soundcloudservice.SoundcloudService(self.search_callback)
        }

        self._trackResults = model.qobjectlistmodel.QObjectListModel([], self)
        self._playlistResults = model.qobjectlistmodel.QObjectListModel([], self)

        # self._scService = model.soundcloudservice.SoundcloudService(self.search_callback)
        # self._ytService = model.youtubeservice.YoutubeService(self.search_callback)

        self._network_manager = QNetworkAccessManager(self)
        self._network_manager.finished.connect(self.reply_finished)

        self._entryPlaylist = model.qobjectlistmodel.QObjectListModel([], self)

        self._searchOption = "tracks"
        self._selectedService = "youtube"
        self._canLoadMore = True

        self.searchOptionChanged.connect(self.on_search_option_changed)

    searchOptionChanged = pyqtSignal()
    selectedServiceChanged = pyqtSignal()
    canLoadMoreChanged = pyqtSignal()

    @property
    def service(self):
        return self.services[self._selectedService]

    @pyqtSlot()
    def on_search_option_changed(self):
        if self.service.query_filter is None:
            return
        last_query = self.service.options[self.service.query_filter].query
        print("search:", "option =", self.searchOption, "query =", last_query)
        if last_query is None:
            return
        if self.searchOption == "tracks" and self.trackResults.count == 0:
            self.service.search(query=last_query, query_filter="tracks")
        elif self.searchOption == "playlists" and self.playlistResults.count == 0:
            self.service.search(query=last_query, query_filter="playlists")

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def trackResults(self):
        return self._trackResults

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def playlistResults(self):
        return self._playlistResults

    @pyqtProperty(str, notify=searchOptionChanged)
    def searchOption(self):
        return self._searchOption

    @searchOption.setter
    def searchOption(self, value):
        if self._searchOption != value:
            self._searchOption = value
            self.searchOptionChanged.emit()

    @pyqtProperty(bool, notify=canLoadMoreChanged)
    def canLoadMore(self):
        return self._canLoadMore

    @canLoadMore.setter
    def canLoadMore(self, value):
        if self._canLoadMore != value:
            self._canLoadMore = value
            self.canLoadMoreChanged.emit()

    @pyqtProperty(model.playlist.Playlist, constant=True)
    def playlist(self):
        return self._playlist

    @pyqtProperty(QMediaPlayer, constant=True)
    def player(self):
        return self._player

    @pyqtSlot(str)
    def search(self, query):
        self.trackResults.clear()
        self.playlistResults.clear()
        print("searching for", query, "with filter", self.searchOption)
        self.service.search(query=query, query_filter=self.searchOption)

    def search_callback(self, results):
        if self.service.query_filter == "tracks":
            self.trackResults.extend(results)
        elif self.service.query_filter == "playlists":
            self.playlistResults.extend(results)

    @pyqtSlot()
    def load_more(self):
        self.service.load_more(self.searchOption)

    @pyqtSlot(str)
    def query_completion(self, text):
        if text is None or text == "":
            print("Empty query")
            self.reply_finished(None)
        else:
            print("Querying completion for", text)
            self._network_manager.get(QNetworkRequest(QUrl("http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&"
                                                           + urllib.parse.urlencode({"q": text}))))

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def suggestionList(self):
        return self._suggestionList

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def entryPlaylist(self):
        return self._entryPlaylist

    @pyqtProperty(str, notify=selectedServiceChanged)
    def selectedService(self):
        return self._selectedService

    @selectedService.setter
    def selectedService(self, service):
        if self._selectedService != service:
            self._selectedService = service
            self.selectedServiceChanged.emit()
            self._searchlist.clear()

    @pyqtSlot(QNetworkReply)
    def reply_finished(self, reply):
        if reply is None:
            self._suggestionList.clear()
        else:
            data_str = reply.readAll().data().decode("utf-8")
            obj = json.loads(data_str)
            if len(obj) == 2:
                # print("reply", obj[1])
                self._suggestionList.setObjectList(obj[1])
            else:
                self._suggestionList.clear()

    def resolveUrl(self, entry):
        print("resolving url for", entry.type, entry.title)
        if entry.type.endswith("track"):
            url = self.service.resolve_track_url(entry.url)
            self._playlist.urlResolved(entry, url)
            return
        else:
            return

        url = ""
        filename = os.getcwd() + os.sep + "out.mp3"

        if os.path.exists(filename):
            os.remove(filename)

        if url.startswith("https"):
            url = "http" + url[5:]

        # print("repaired url:", url)

        # subprocess.Popen(["ffmpeg", "-i", url, "-ab", "128k", "-vn", "-ar", "44100", "out.mp3"])

        self._playlist.urlResolved(entry, "http://127.0.0.1:2000")  # "file://" + filename

    @pyqtSlot(QMediaPlayer.MediaStatus)
    def playerStatusChanged(self, status):
        if status == QMediaPlayer.EndOfMedia:
            self._playlist.currentIndex += 1

    @pyqtSlot(model.audioentry.AudioEntry)
    def load_playlist(self, entry):
        if entry.type.endswith("list"):
            print("Getting playlist for", entry.title)
            entries = self.service.get_playlist_entries(entry.url)
            self.entryPlaylist.setObjectList(entries)
        else:
            print("Entry is not playlist")

    @pyqtSlot()
    def add_playlist(self):
        for entry in self.entryPlaylist:
            self._playlist.addAudioEntry(entry)

    @pyqtSlot()
    def save_playlist(self):
        def print_entry(entry):
            print(entry.title)
            return model.audioentry.AudioEntry.serialize(entry)

        print("Saving playlist")

        file_name = QFileDialog.getSaveFileName(QWidget(), "Save playlist", "", "Xyon Playlist (*.xyp)")[0]
        print(file_name)

        playlist_file = open(file_name, "wb+")
        serialized_entries = list(map(model.audioentry.AudioEntry.serialize, self._playlist.items.raw_data()))
        pickle.dump(serialized_entries, playlist_file)
        playlist_file.close()

        print("Playlist saved")

    @pyqtSlot()
    def open_playlist(self):
        print("Loading playlist")
        file_name = QFileDialog.getOpenFileName(QWidget(), "Open playlist", "", "Xyon Playlist (*.xyp)")[0]
        print(file_name)
        playlist_file = open(file_name, "rb")
        data = pickle.load(playlist_file)

        self._playlist.load_playlist(list(map(lambda e: model.audioentry.AudioEntry.deserialize(e, self), data)))

        playlist_file.close()

        print("Playlist loaded")

    @pyqtSlot()
    def test(self):
        pass
