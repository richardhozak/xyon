import soundcloud
import model.audioentry


class SoundcloudService():

    def __init__(self, callback):
        if not callable(callback):
            raise TypeError("Passed parameter 'callback' is not callable.")
        self.callback = callback
        self._client = soundcloud.Client(client_id="f1f093847bebcecd9302dd6f73e601d6")
        self.last_query = None
        self.last_page = None

    def search(self, query, page=1):
        if page < 1:
            page = 1

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

        results = self._client.get("/tracks", q=query, limit=20, offset=(page - 1) * 20)
        self.callback(list(map(create_query_object, results)))

    def load_more(self):
        if self.last_query is not None:
            self.search(self.last_query, self.last_page + 1)

    def resolve_url(self, url):
        location = self._client.get(url, allow_redirects=False).location
        print(location)
        return location

    def get_playlist_items(self):
        pass
