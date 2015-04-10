import urllib.request
import urllib.parse
import sys
import pafy
import os
import model.audioentry
import platform
import bs4


def print_error_info(info=""):
    print(info)
    exc_type, exc_obj, exc_tb = sys.exc_info()
    fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
    print(exc_type, fname, exc_tb.tb_lineno)


class YoutubeService():

    def __init__(self, callback):
        if not callable(callback):
            raise TypeError("Passed parameter 'callback' is not callable.")
        self.callback = callback
        self.last_page = 0
        self.last_query = None

    def search(self, query, page=1):
        def create_query_object(result):
            try:
                time_element = result.parent.parent.parent.find("span", {"class": "video-time"})
                time = time_element.text if time_element is not None else ""

                # print("href", result["href"])
                # print(time, result["title"].encode("utf-8"))

                href = result['href']
                is_list = 'list' in href
                video_id = href[9:20]
                playlist_id = href[26:]

                url = "https://www.youtube.com/" + ("playlist?list=" + playlist_id if is_list else "watch?v=" + video_id)
                audio_type = 'youtube_list' if is_list else 'youtube_audio'
                img = "https://img.youtube.com/vi/" + video_id + "/default.jpg"

                return model.audioentry.AudioEntry(url, audio_type, time, result["title"], img)
            except:
                print_error_info("Error while creating query object")

        self.last_page = page
        self.last_query = query
        print("search query", query)
        query_string = urllib.parse.urlencode({"search_query": query, "page": page})
        # print("query_string", query_string)

        html_content = urllib.request.urlopen("http://www.youtube.com/results?" + query_string)
        soup = bs4.BeautifulSoup(html_content.read().decode())
        search_results = soup.find_all("a", {"class": "yt-uix-tile-link"})
        self.callback(list(map(create_query_object, search_results)))

    def load_more(self):
        if self.last_query is not None:
            self.search(self.last_query, self.last_page + 1)

    def resolve_url(self, vid):
        video = pafy.new(vid)
        print("Getting audio stream link", vid)
        audio = video.getbestaudio(preftype=("ogg" if platform.system() == "Linux" else "m4a"))

        if not hasattr(audio, "url_https"):
            print("Error getting audio, falling back to best video.")
            audio = video.getbest()

        print(audio.url_https)
        print(audio.extension)

        return audio.url_https

    def get_playlist_items(self, list_url):
        def get_entry_info(entry):
            title = entry["data-title"]
            vid = entry["data-video-id"]
            time = entry.find("div", {"class": "timestamp"}).span.text
            url = "https://www.youtube.com/watch?v=" + vid
            img = "https://img.youtube.com/vi/" + vid + "/default.jpg"
            print(time, vid, title)
            return model.audioentry.AudioEntry(url, "youtube_audio", time, title, img)

        print(list_url)
        html_content = urllib.request.urlopen(list_url)
        soup = bs4.BeautifulSoup(html_content.read().decode())
        entries = soup.find_all("tr", {"class": "pl-video"})
        return list(map(get_entry_info, entries))
