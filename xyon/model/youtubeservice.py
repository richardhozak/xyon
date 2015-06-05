import urllib.request
import urllib.parse
import sys
import pafy
import os
import model.audioentry
import model.abstractservice
import platform
import bs4

from PyQt5.QtCore import pyqtSignal, pyqtSlot


def print_error_info(info=""):
    print(info)
    exc_type, exc_obj, exc_tb = sys.exc_info()
    fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
    print(exc_type, fname, exc_tb.tb_lineno)


class YoutubeService(model.abstractservice.AbstractService):

    search_completed = pyqtSignal(list, name="searchCompleted")
    track_resolved = pyqtSignal(str, str, name="trackResolved")
    playlist_entries_fetched = pyqtSignal(str, list, name="playlistEntriesFetched")

    def __init__(self):
        super().__init__()

        self.options = {
            "tracks": model.abstractservice.ServiceOptions(),
            "playlists": model.abstractservice.ServiceOptions()
        }

        self.query_filter = None

    @pyqtSlot(str, int, str, name="search")
    def search(self, query, page=1, query_filter="tracks"):
        try:
            if not (query_filter == "tracks" or query_filter == "playlists"):
                raise TypeError("Filter is not valid, valid options are 'tracks' or 'playlists'")

            def create_query_object(result):
                try:
                    time_element = result.parent.parent.parent.find("span", {"class": "video-time"})
                    time = time_element.text if time_element is not None else ""

                    href = result['href']
                    is_list = 'list' in href
                    video_id = href[9:20]
                    playlist_id = href[26:]

                    url = "https://www.youtube.com/" + ("playlist?list=" + playlist_id if is_list else "watch?v=" + video_id)
                    audio_type = 'youtube_list' if is_list else 'youtube_track'
                    img = "https://img.youtube.com/vi/" + video_id + "/default.jpg"

                    return model.audioentry.AudioEntry(url, audio_type, time, result["title"], img)
                except:
                    print_error_info("Error while creating query object")

            self.query_filter = query_filter
            option = self.options[query_filter]
            option.page = page
            option.query = query

            query_string = urllib.parse.urlencode({"search_query": query,
                                                   "page": page,
                                                   "filters": "playlist" if query_filter == "playlists" else "video"})

            html_content = urllib.request.urlopen("http://www.youtube.com/results?" + query_string)
            soup = bs4.BeautifulSoup(html_content.read().decode())
            search_results = soup.find_all("a", {"class": "yt-uix-tile-link"})
        except Exception as e:
            print(e)

        self.search_completed.emit(list(map(create_query_object, search_results)))

    @pyqtSlot(str, name="loadMore")
    def load_more(self, query_filter=None):
        if self.query_filter is not None:
            query_filter = self.query_filter if query_filter is None else query_filter
            option = self.options[query_filter]
            self.search(option.query, option.page + 1, query_filter)

    @pyqtSlot(str, name="resolveTrackUrl")
    def resolve_track_url(self, vid):
        video = pafy.new(vid)
        print("Getting audio stream link", vid)
        audio = video.getbestaudio(preftype=("ogg" if platform.system() == "Linux" else "m4a"))

        if not hasattr(audio, "url_https"):
            print("Error getting audio, falling back to best video.")
            audio = video.getbest()

        print(audio.url_https)
        print(audio.extension)

        self.track_resolved.emit(vid, audio.url_https)

    @pyqtSlot(str, name="getPlaylistEntries")
    def get_playlist_entries(self, list_url):
        def get_entry_info(entry):
            timestamp_element = entry.find("div", {"class": "timestamp"})
            if hasattr(timestamp_element, "span"):
                time = timestamp_element.span.text
            else:
                return None

            title = entry["data-title"]
            vid = entry["data-video-id"]
            url = "https://www.youtube.com/watch?v=" + vid
            img = "https://img.youtube.com/vi/" + vid + "/default.jpg"
            print(time, vid, title)
            return model.audioentry.AudioEntry(url, "youtube_track", time, title, img)

        print(list_url)
        html_content = urllib.request.urlopen(list_url)
        soup = bs4.BeautifulSoup(html_content.read().decode())
        entries = soup.find_all("tr", {"class": "pl-video"})

        self.playlist_entries_fetched.emit(list_url, list(filter(lambda e: e is not None, map(get_entry_info, entries))))

    def can_load_more(self):
        pass
