import model.playlist
import model.youtubeservice

from PyQt5.QtCore import \
    QObject, \
    pyqtProperty, \
    pyqtSlot, \
    QUrl
from PyQt5.QtMultimedia import QMediaPlayer, QMediaContent


class Player(QMediaPlayer):

    def __init__(self, serviceManager, parent):
        super(Player, self).__init__(parent)
        self.service = serviceManager
        self.service.url_resolved.connect(self.on_url_resolved)
        self._playlist = model.playlist.Playlist([], self)
        self._playlist.current_index_changed.connect(self.on_playlist_index_changed)
        self.mediaStatusChanged.connect(self.on_media_status_changed)
        self.stateChanged.connect(self.on_state_changed)
        self.media_statuses = {
            QMediaPlayer.UnknownMediaStatus: "UnknownMediaStatus",
            QMediaPlayer.NoMedia: "NoMedia",
            QMediaPlayer.LoadingMedia: "LoadingMedia",
            QMediaPlayer.LoadedMedia: "LoadedMedia",
            QMediaPlayer.StalledMedia: "StalledMedia",
            QMediaPlayer.BufferingMedia: "BufferingMedia",
            QMediaPlayer.BufferedMedia: "BufferedMedia",
            QMediaPlayer.EndOfMedia: "EndOfMedia",
            QMediaPlayer.InvalidMedia: "InvalidMedia"
        }
        self.states = {
            QMediaPlayer.StoppedState: "StoppedState",
            QMediaPlayer.PlayingState: "PlayingState",
            QMediaPlayer.PausedState: "PausedState"
        }
        self.last_state = QMediaPlayer.StoppedState

    @pyqtProperty(model.playlist.Playlist, constant=True)
    def playlist(self):
        return self._playlist

    def resolve_url(self, index):
        if index == -1:
            return
        entry = self.playlist.get(index)
        print("resolving url for", entry.type, entry.title)
        if entry.type.endswith("track"):
            self.service.resolve_track_url(entry.type.split("_")[0], entry.url)

    def on_playlist_index_changed(self):
        if self.last_state != QMediaPlayer.StoppedState:
            self.resolve_url(self.playlist.currentIndex)

    def on_media_status_changed(self, status):
        print("MediaStatus:", self.media_statuses[status])
        if status == QMediaPlayer.EndOfMedia:
            self.next()

    def on_state_changed(self, state):
        print("State:", self.states[state])

    @pyqtSlot(str, str, name="onUrlResolved")
    def on_url_resolved(self, vid, url):
        print("Url resolved")
        self.setMedia(QMediaContent(QUrl(url)))
        if self.last_state == QMediaPlayer.StoppedState:
            self.stop()
        elif self.last_state == QMediaPlayer.PlayingState or self.last_state == QMediaPlayer.PausedState:
            self.play()

    def print_info(self, payload):
        print(payload)
        print("LastState", self.states[self.last_state])
        print("State:", self.states[self.state()])

    @pyqtSlot(int, name="playIndex")
    def play_index(self, index):
        print("play index", index)
        if self.playlist.currentIndex != index:
            self.setMedia(QMediaContent())
            self.playlist.currentIndex = index
            self.play()

    @pyqtSlot()
    def play(self):
        print("play")
        if self.playlist.count == 0:
            return
        if self.last_state == QMediaPlayer.StoppedState:
            self.last_state = QMediaPlayer.PlayingState
            if self.playlist.currentIndex == -1:
                self.setMedia(QMediaContent())
                self.playlist.currentIndex = 0
            else:
                self.resolve_url(self.playlist.currentIndex)
        super().play()

    @pyqtSlot()
    def pause(self):
        print("pause")
        super().pause()

    @pyqtSlot()
    def stop(self):
        print("stop")
        super().stop()

    @pyqtSlot()
    def next(self):
        print("next")
        if self.playlist.currentIndex < self.playlist.count - 1:
            self.last_state = self.state()
            self.setMedia(QMediaContent())
            self.playlist.currentIndex += 1

    @pyqtSlot()
    def previous(self):
        print("previous")
        if self.playlist.currentIndex > 0:
            self.last_state = self.state()
            self.setMedia(QMediaContent())
            self.playlist.currentIndex -= 1

    @pyqtSlot(model.audioentry.AudioEntry, name="addTrack")
    def add_track(self, entry):
        self.playlist.append(entry)

    @pyqtSlot(model.audioentry.AudioEntry, name="removeTrack")
    def remove_track(self, entry):
        if self.playlist.indexOf(entry) == self.playlist.currentIndex:
            self.setMedia(QMediaContent())
            self.stop()
            self.last_state = QMediaPlayer.StoppedState
        self.playlist.remove(entry)

    @pyqtSlot(QObject, name="addPlaylist")
    def add_playlist(self, entry_list):
        self.playlist.extend(entry_list.raw_data())
