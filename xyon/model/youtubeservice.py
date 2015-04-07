from bs4 import BeautifulSoup
import urllib.request
import urllib.parse
import sys
import pafy
import os
import model.audioentry
import platform


def print_error_info(info=""):
    print(info)
    exc_type, exc_obj, exc_tb = sys.exc_info()
    fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
    print(exc_type, fname, exc_tb.tb_lineno)


class YoutubeService():

    def __init__(self):
        self.dict = {}
        self.last_page = 0
        self.last_query = None
        for name in dir(self):
            attr = getattr(self, name)
            if callable(attr) and not name.startswith("__") and not name.endswith("__"):
                self.dict[name] = attr

    def search(self, query, page=1):
        def create_query_object(result):
            try:
                time = result.parent.parent.parent.find("span", {"class": "video-time"})
                if time is None:
                    time = ""
                else:
                    time = time.text

                print(time, result["title"].encode("utf-8"))
                href = result['href']
                is_list = 'list' in href
                aid = href[26:] if is_list else href[9:]
                url = "http://www.youtube.com/" + ("playlist?list=" if is_list else "watch?v=") + aid
                atype = 'youtube_list' if is_list else 'youtube_audio'

                self.last_page = page

                return model.audioentry.AudioEntry(url, atype, time, result["title"])
                '''
                return {'type': 'youtube_list' if is_list else 'youtube_audio',
                        'id': href[26:] if is_list else href[9:],
                        'title': result['title'],
                        'time': time}
                '''
            except:
                print_error_info("Error while creating query object")

        print("search query", query)
        query_string = urllib.parse.urlencode({"search_query": query, "page": page})
        print("query_string", query_string)

        html_content = urllib.request.urlopen("http://www.youtube.com/results?" + query_string)
        soup = BeautifulSoup(html_content.read().decode())
        search_results = soup.find_all("a", {"class": "yt-uix-tile-link"})
        return list(map(create_query_object, search_results))

    def load_more(self):
        if self.last_query is not None:
            return self.search(self.last_query, self.last_page + 1)
        return None

    def resolve_url(self, vid):
        return self.get_stream_link(vid)

    def get_stream_link(self, vid):
        video = pafy.new(vid)
        print("Getting audio stream link", vid)
        audio = video.getbestaudio(preftype=("ogg" if platform.system() == "Linux" else "m4a"))
        if hasattr(audio, 'url_https'):
            print("has attribute")
            print(audio.url_https)
            print(audio.extension)
            return audio.url
        else:
            print("does not have attribute")
            best = video.getbest()
            print(best)
            return best.url_https
