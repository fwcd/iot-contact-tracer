import re
from socketserver import StreamRequestHandler

class CNGAdapterTCPHandler(StreamRequestHandler):
    def handle(self):
        while True:
            raw = self.rfile.readline().decode("utf-8").strip()
            print(raw)
