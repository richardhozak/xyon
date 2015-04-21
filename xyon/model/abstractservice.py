import abc


class ServiceOptions:

    def __init__(self):
        self.page = 0
        self.query = None


class AbstractService:
    __metaclass__ = abc.ABCMeta

    def __init__(self, callback):
        if not callable(callback):
            raise TypeError("Passed parameter 'callback' is not callable.")
        print("abstract service init call")

    @abc.abstractmethod
    def search(self, query, page, query_filter):
        pass

    @abc.abstractmethod
    def load_more(self):
        pass

    @abc.abstractmethod
    def resolve_track_url(self, track_url):
        pass

    @abc.abstractmethod
    def get_playlist_entries(self, playlist_url):
        pass

    @abc.abstractmethod
    def can_load_more(self):
        pass
