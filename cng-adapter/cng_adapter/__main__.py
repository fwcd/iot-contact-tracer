import argparse
from socketserver import StreamRequestHandler, TCPServer

class CNGAdapterTCPHandler(StreamRequestHandler):
    def handle(self):
        its = 0
        while True:
            raw = self.rfile.readline().strip()
            print(raw)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=7533, help="Sets the port of the server")

    args = parser.parse_args()
    port = args.port

    with TCPServer(("localhost", port), CNGAdapterTCPHandler) as server:
        print(f"Listening on port {port} for TCP connections...")
        server.serve_forever()

if __name__ == "__main__":
    main()
