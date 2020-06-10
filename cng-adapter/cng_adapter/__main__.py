import argparse
import re
import socket
from socketserver import StreamRequestHandler, TCPServer

class CNGAdapterTCPHandler(StreamRequestHandler):
    def handle(self):
        while True:
            raw = self.rfile.readline().decode("utf-8").strip()
            print(raw)

class CNGAdapterTCPServer(TCPServer):
    def server_bind(self):
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.socket.bind(self.server_address)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=7533, help="Sets the port of the server")

    args = parser.parse_args()
    port = args.port

    with TCPServer(("localhost", port), CNGAdapterTCPHandler) as server:
        print(f"Listening on port {port} for TCP connections...")
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("Shutting down...")
            pass

if __name__ == "__main__":
    main()
