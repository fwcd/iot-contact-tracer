import argparse

from cng_adapter.handler import CNGAdapterTCPHandler
from cng_adapter.server import CNGAdapterTCPServer

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=7533, help="Sets the port of the server")

    args = parser.parse_args()
    port = args.port

    with CNGAdapterTCPServer(("localhost", port), CNGAdapterTCPHandler) as server:
        print(f"Listening on port {port} for TCP connections...")
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("Shutting down...")
            pass

if __name__ == "__main__":
    main()
