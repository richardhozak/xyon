import model.youtubeservice
import model.soundcloudservice
import model.qobjectlistmodel
import model.audioentry

from PyQt5.QtCore import \
    QObject, \
    pyqtProperty, \
    pyqtSignal, \
    pyqtSlot, \
    QUrl, \
    QThread, \
    QMetaObject, \
    Qt, \
    Q_ARG

class ServiceManager(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)

        self._serviceDict = {
            "youtube": model.youtubeservice.YoutubeService()# ,
            # "soundcloud": model.soundcloudservice.SoundcloudService(self.query_callback)
        }

        self._last_query = None
        self._query_filter = "tracks"
        self._service = self._serviceDict["youtube"]
        self._services = model.qobjectlistmodel.QObjectListModel(list(self._serviceDict.values()), self)

        thread = QThread(self)
        #for service in self._serviceDict.values():
        service = self._serviceDict["youtube"]
        service.search_completed.connect(self.query_callback)
        service.playlist_entries_fetched.connect(self.on_playlist_entries_fetched)
        service.track_resolved.connect(self.on_track_resolved)
        service.moveToThread(thread)

        thread.start()

        self._trackResults = model.qobjectlistmodel.QObjectListModel([], self)
        self._playlistResults = model.qobjectlistmodel.QObjectListModel([], self)
        self._playlistList = model.qobjectlistmodel.QObjectListModel([], self)

    can_load_more_changed = pyqtSignal(name="canLoadMoreChanged")
    service_changed = pyqtSignal(name="serviceChanged")
    query_filter_changed = pyqtSignal(name="queryFilterChanged")
    open_playlist_page = pyqtSignal(name="openPlaylistPage")
    url_resolved = pyqtSignal(str, str, name="urlResolved")

    def on_track_resolved(self, vid, url):
        self.url_resolved.emit(vid, url)

    def query_callback(self, results):
        if self._query_filter == "tracks":
            print("extending tracks")
            self.trackResults.extend(results)
        elif self._query_filter == "playlists":
            print("extending playlist")
            self.playlistResults.extend(results)

    @pyqtSlot(str, list, name="onPlaylistEntriesFetched")
    def on_playlist_entries_fetched(self, id, playlist):
        self.playlistList.setObjectList(playlist)
        self.open_playlist_page.emit()

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def trackResults(self):
        return self._trackResults

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def playlistResults(self):
        return self._playlistResults

    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def playlistList(self):
        return self._playlistList

    @pyqtProperty(str, notify=query_filter_changed)
    def queryFilter(self):
        return self._query_filter

    @queryFilter.setter
    def queryFilter(self, query_filter):
        if self._query_filter != query_filter:
            print("query filter changed to", query_filter)
            self._query_filter = query_filter
            self.query_filter_changed.emit()
            self.on_query_filter_changed()

    def on_query_filter_changed(self):
        if self._last_query is None:
            return

        print("option:", self._query_filter, "query:", self._last_query)
        if self._last_query is None:
            return
        if self._query_filter == "tracks" and self.trackResults.count == 0:
            self.service.search(query=self._last_query, query_filter="tracks")
        elif self._query_filter == "playlists" and self.playlistResults.count == 0:
            self.service.search(query=self._last_query, query_filter="playlists")


    @pyqtProperty(model.abstractservice.AbstractService, notify=service_changed)
    def service(self):
        return self._service

    @service.setter
    def service(self, service):
        self._service = service
        self.service_changed.emit()

    @pyqtSlot(str, name="changeService")
    def change_service(self, name):
        if name in self._serviceDict:
            self.service = self._serviceDict[name]
            self.trackResults.clear()
            self.playlistResults.clear()
            self.on_query_filter_changed()


    @pyqtProperty(model.qobjectlistmodel.QObjectListModel, constant=True)
    def services(self):
        return self._services

    @pyqtSlot(str, name="search")
    def search(self, query):
        print("searching for", query)
        self.trackResults.clear()
        self.playlistResults.clear()
        self._last_query = query

        QMetaObject.invokeMethod(self._service, "search", Qt.QueuedConnection, Q_ARG(str, query), Q_ARG(int, 1), Q_ARG(str, self.queryFilter))
        # self.service.search(query, 1, self.queryFilter)

    @pyqtSlot(str, name="loadMore")
    def load_more(self, query_filter=None):
        print("loading more", query_filter)
        # self.service.load_more(query_filter)
        QMetaObject.invokeMethod(self._service, "loadMore", Qt.QueuedConnection, Q_ARG(str, query_filter))
        # self.can_load_more_changed.emit()

    @pyqtSlot(str, name="resolveTrackUrl")
    def resolve_track_url(self, service_name, track_url):
        service = self._serviceDict[service_name] # .resolve_track_url(track_url)
        QMetaObject.invokeMethod(service, "resolveTrackUrl", Qt.QueuedConnection, Q_ARG(str, track_url))

    @pyqtSlot(str, name="getPlaylistEntries")
    def get_playlist_entries(self, playlist_url):
        QMetaObject.invokeMethod(self._service, "getPlaylistEntries", Qt.QueuedConnection, Q_ARG(str, playlist_url))
        # return self.service.get_playlist_entries(playlist_url)

    @pyqtSlot(model.audioentry.AudioEntry, name="loadPlaylist")
    def load_playlist(self, entry):
        if entry.type.endswith("list"):
            print("Getting playlist for", entry.title)
            self.get_playlist_entries(entry.url)
        else:
            print("Entry is not playlist")

    @pyqtProperty(bool)
    def canLoadMore(self):
        return self.service.can_load_more()
