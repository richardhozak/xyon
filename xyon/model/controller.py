import model.qobjectlistmodel
import model.youtubeservice
import model.soundcloudservice

import json
import urllib.parse
import pickle

from PyQt5.QtNetwork import *
from PyQt5.QtMultimedia import \
    QMediaPlayer, \
    QAudioBuffer
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

        self._searchlist = model.qobjectlistmodel.QObjectListModel([], self)
        self._queryList = model.qobjectlistmodel.QObjectListModel([], self)

        self._player = QMediaPlayer(self, QMediaPlayer.StreamPlayback)
        self._player.mediaStatusChanged.connect(self.playerStatusChanged)

        self._playlist = model.playlist.Playlist(self._player)
        self._playlist.resolveUrl.connect(self.resolveUrl)

        self._canGoPrevPage = False
        self._canGoNextPage = False

        self._scService = model.soundcloudservice.SoundcloudService(self.search_callback)
        self._ytService = model.youtubeservice.YoutubeService(self.search_callback)

        self._network_manager = QNetworkAccessManager(self)
        self._network_manager.finished.connect(self.reply_finished)

        self._entryPlaylist = model.qobjectlistmodel.QObjectListModel([], self)

        self._selectedService = "youtube"

        '''
        self._probe = QAudioProbe(self)
        self._probe.setSource(self._player)
        self._probe.audioBufferProbed.connect(self.process_buffer)
        '''

    canGoPrevPageChanged = pyqtSignal()
    canGoNextPageChanged = pyqtSignal()
    selectedServiceChanged = pyqtSignal()

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
        if self.selectedService == "youtube":
            self._ytService.search(query)
        else:
            self._scService.search(query)

    def search_callback(self, results):
        for entry in results:
            self._searchlist.append(entry)

    @pyqtSlot()
    def load_more(self):
        if self.selectedService == "youtube":
            self._ytService.load_more()
        elif self.selectedService == "soundcloud":
            self._scService.load_more()

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
        url = ""
        if entry.type == "youtube_audio":
            url = self._ytService.resolve_url(entry.url)
        elif entry.type == "soundcloud_audio":
            url = self._scService.resolve_url(entry.url)
        else:
            return
        self._playlist.urlResolved(entry, url)

    @pyqtSlot(QMediaPlayer.MediaStatus)
    def playerStatusChanged(self, status):
        if status == QMediaPlayer.EndOfMedia:
            self._playlist.currentIndex += 1

    @pyqtSlot(model.audioentry.AudioEntry)
    def load_playlist(self, entry):
        if entry.type == "youtube_list":
            print("Getting playlist for", entry.title)
            entries = self._ytService.get_playlist_items(entry.url)
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
        def deserialize(entry):
            return model.audioentry.AudioEntry.deserialize(entry)

        print("Loading playlist")
        file_name = QFileDialog.getOpenFileName(QWidget(), "Open playlist", "", "Xyon Playlist (*.xyp)")[0]
        print(file_name)
        playlist_file = open(file_name, "rb")
        data = pickle.load(playlist_file)

        self._playlist.load_playlist(list(map(deserialize, data)))

        playlist_file.close()

        print("Playlist loaded")

    @pyqtSlot()
    def test(self):
        pass

    def calculate_window(self):
        self.window = []
        for i in range(4096 * 2):
            self.window[i] = 0.5 * ()

    @pyqtSlot(QAudioBuffer)
    def process_buffer(self, buffer):

        if hasattr(self, "doit") and self.doit:
            self.doit = False
            print("Plotting...")

            import matplotlib.pyplot as plt
            from numpy.fft import fft, fftfreq
            from numpy import arange

            # print("Buffer probed")
            # print(type(buffer.constData()))
            array = buffer.constData()  # .asarray(buffer.byteCount())
            array.setsize(buffer.byteCount())

            inp = []
            i = 0
            while i < buffer.byteCount():
                number = int.from_bytes(array[i:i + 2].asstring(2), byteorder="little", signed=True) / 32768
                i += 2
                # print(number)
                inp.append(number)
                # print(array.__getitem__(slice(i, i+2, None)))

            t = arange(44100)
            sp = fft(inp)
            # freq = fftfreq(t.shape[-1])

            print(sp)
            print(len(sp))

            # plt.plot(freq, sp.real, freq, sp.imag)
            # pl.show()

            '''
            N = buffer.sampleCount()
            T = 44100
            yf = scipy.fftpack.fft(inp)
            xf = np.linspace(0.0, 1.0 / (2.0 * T), N / 2)

            fix, ax = plt.subplots()
            ax.plot(xf, 2.0 / N * np.abs(yf[0:N / 2]))
            ax.show()
            '''
            # for i in range(len(array)):
            #    print(i)
            # print(len(array))
            # for i in array:
            #    print(i)

            # print("")
            # print(buffer.constData().getsize())
            # buffer.constData().setsize(buffer.byteCount())
            # print(buffer.constData())
            # print(buffer.constData() / 32768)
