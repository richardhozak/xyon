import soundcloud
import model.audioentry
import model.abstractservice


class SoundcloudService(model.abstractservice.AbstractService):

    def __init__(self, callback):
        super(SoundcloudService, self).__init__(callback)

        self.callback = callback
        self._client = soundcloud.Client(client_id="f1f093847bebcecd9302dd6f73e601d6")

        self.options = {
            "tracks": model.abstractservice.ServiceOptions(),
            "playlists": model.abstractservice.ServiceOptions()
        }

        self.query_filter = None

    def search(self, query, page=1, query_filter="tracks"):
        if not (query_filter == "tracks" or query_filter == "playlists"):
            raise TypeError("Filter is not valid, valid options are 'tracks' or 'playlists'")

        if page < 1:
            page = 1

        self.query_filter = query_filter

        option = self.options[query_filter]
        option.page = page
        option.query = query

        def create_query_object(result):
            totalseconds = result.duration // 1000
            hours, remainder = divmod(totalseconds, 3600)
            minutes, seconds = divmod(remainder, 60)
            time = ""

            if hours > 0:
                time = "{:d}:{:02d}:{:02d}".format(hours, minutes, seconds)
            else:
                time = "{:d}:{:02d}".format(minutes, seconds)

            title = result.title
            url = ""
            img = ""
            atype = "soundcloud_track"
            if result.streamable:
                img = result.artwork_url
                url = result.stream_url
            elif result.downloadable:
                url = result.download_url
                img = self._client.get("/users/" + str(result.user_id)).avatar_url
            else:
                atype = "not_streamable"

            return model.audioentry.AudioEntry(url, atype, time, title, img)

        def create_playlist_object(result):
            print(result.streamable, result.downloadable, result.embeddable_by, result.artwork_url)
            track = result.tracks[0].title
            return model.audioentry.AudioEntry("http://www.example.com", "soundcloud_playlist", "4:20", result.title, result.artwork_url)

        results = self._client.get("/" + query_filter, q=query, limit=20, offset=(page - 1) * 20)
        self.callback(list(map(create_query_object if query_filter == "tracks" else create_playlist_object, results)))

    def load_more(self, query_filter=None):
        if self.query_filter is not None:
            query_filter = self.query_filter if query_filter is None else query_filter
            option = self.options[query_filter]
            self.search(option.query, option.page + 1, query_filter)

    def resolve_track_url(self, url):
        location = self._client.get(url, allow_redirects=False).location
        print(location)
        return location

    def get_playlist_entries(self):
        pass

    def can_load_more(self):
        pass
