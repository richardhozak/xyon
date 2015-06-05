import os
import threading

from urllib.request import urlopen
from urllib.error import URLError, HTTPError
from queue import Queue


class Download(threading.Thread):

    def __init__(self, url, dest):
        super().__init__()
        self.url = url
        self.dest = dest
        self.daemon = True

    def run(self):
        print("downloading file")
        self.downloadfile(self.url, self.dest)
        print("done")
        for callback in self.done_callbacks:
            callback()

    def done(self, *callbacks):
        self.done_callbacks = callbacks

    def downloadfile(self, url, dest):
        # Open the url
        try:
            f = urlopen(url)

            # Open our local file for writing
            with open(dest, "wb") as local_file:
                local_file.write(f.read())

        # handle errors
        except HTTPError as e:
            print("HTTP Error:", e.code, url)
        except URLError as e:
            print("URL Error:", e.reason, url)


class DownloadManager(threading.Thread):

    def __init__(self, destfolder, maxdownloads=2):
        super().__init__()
        self.destfolder = destfolder
        self.semaphore = threading.Semaphore(maxdownloads)
        self.queue = Queue()
        self.daemon = True

    def download_done(self):
        print("download done")

    def run(self):
        while True:
            entry = self.queue.get()
            print("got entry", entry)
            self.semaphore.acquire()
            print("lock acquired")
            dest = os.path.join(self.destfolder, entry.name)
            print("dest", dest)
            download = Download(entry.url, dest)
            download.done(self.queue.task_done, self.semaphore.release, self.download_done)
            download.start()

    def add(self, entry):
        self.queue.put(entry)
