import re
import requests
from socketserver import StreamRequestHandler

def create_handler(url):
    class CNGAdapterTCPHandler(StreamRequestHandler):
        def handle(self):
            print("Handling new connection...")
            while True:
                raw = self.rfile.readline().decode("utf-8").strip()
                req = re.search(r"\[REQUEST\s+(?P<name>\w+)\s*(?P<body>.*)\]", raw)
                if req:
                    name = req.group("name")
                    body = req.group("body")
                    if name == "reportExposure":
                        # TODO: Perform validation of the body
                        rsp = requests.put(f"{url}/api/v1/exposures/{body}")
                        rsp.raise_for_status()
                        print(f"Reported exposure {body}: {rsp.content}")
                    else:
                        print(f"Unsupported request name: {name}")
                else:
                    print(f"Got: {raw}")
    return CNGAdapterTCPHandler
