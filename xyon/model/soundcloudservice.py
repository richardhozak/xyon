import soundcloud
import model.audioentry
import model.abstractservice


class SoundcloudService(model.abstractservice.AbstractService):

    def __init__(self, callback):
        super().__init__(callback)

        self.callback = callback
        self._client = soundcloud.Client(client_id="f1f093847bebcecd9302dd6f73e601d6")
        self.last_query = None
        self.last_page = None
        self.last_filter = None

    def search(self, query, page=1, query_filter="tracks"):
        if not (query_filter == "tracks" or query_filter == "playlists"):
            raise TypeError("Filter is not valid, valid options are 'tracks' or 'playlists'")

        if page < 1:
            page = 1

        self.last_filter = query_filter
        self.last_query = query
        self.last_page = page

        def create_query_object(result):
            time = str(result.duration)
            title = result.title
            url = ""
            img = ""
            atype = "soundcloud_audio"
            if result.streamable:
                img = result.artwork_url
                url = result.stream_url
            elif result.downloadable:
                url = result.download_url
                img = self._client.get("/users/" + str(result.user_id)).avatar_url
            else:
                atype = "not_streamable"

            return model.audioentry.AudioEntry(url, atype, time, title, img)

        results = self._client.get("/" + query_filter, q=query, limit=20, offset=(page - 1) * 20)
        self.callback(list(map(create_query_object, results)))

    def load_more(self):
        if self.last_query is not None:
            self.search(self.last_query, self.last_page + 1, self.last_query)

    def resolve_track_url(self, url):
        location = self._client.get(url, allow_redirects=False).location
        print(location)
        return location

    def get_playlist_entries(self):
        pass

    def can_load_more(self):
        pass
