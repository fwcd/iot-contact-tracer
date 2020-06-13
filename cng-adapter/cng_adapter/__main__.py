import argparse

from cng_adapter.handler import create_handler
from cng_adapter.server import CNGAdapterTCPServer

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=7533, help="Sets the port to listen on")
    parser.add_argument("--url", type=str, default="http://localhost:5000", help="Sets the exposure server's url")

    args = parser.parse_args()
    port = args.port
    url = args.url

    with CNGAdapterTCPServer(("localhost", port), create_handler(url)) as server:
        print(f"Listening on port {port} for TCP connections...")
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("Shutting down...")
            pass

if __name__ == "__main__":
    main()
