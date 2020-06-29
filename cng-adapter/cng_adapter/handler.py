import re
import requests
from socketserver import StreamRequestHandler

def create_handler(url):
    class CNGAdapterTCPHandler(StreamRequestHandler):
        regex = re.compile(r"\[REQUEST\s+(?P<name>\w+)\s*(?P<body>.*)\]")

        def handle(self):
            print(f"Handling new connection from {self.client_address}...")
            for line in self.rfile:
                raw = line.strip().decode("utf-8")
                req = re.search(CNGAdapterTCPHandler.regex, raw)
                if req:
                    name = req.group("name")
                    body = req.group("body")
                    idents = [i.strip() for i in body.split(" ") if i.strip()]

                    if name == "reportExposure":
                        for ident in idents:
                            rsp = requests.put(f"{url}/api/v1/exposures/{ident}")
                            rsp.raise_for_status()
                            print(f"Reported exposure {ident}: {rsp.content}")
                    elif name == "checkHealth":
                        rsp = requests.get(f"{url}/api/v1/exposures")
                        rsp.raise_for_status()
                        exposures = {e["id"] for e in rsp.json()}

                        if set(idents).intersection(exposures):
                            print(f"{self.client_address} is exposed!")
                            self.wfile.write(f"E\n".encode("utf-8"))
                        else:
                            print(f"{self.client_address} is healthy!")
                            self.wfile.write("H\n".encode("utf-8"))
                    else:
                        print(f"Unsupported request name: {name}")
                # else:
                #     print(f"Got: {raw}")
            print(f"Disconnected from {self.client_address}")
    return CNGAdapterTCPHandler
