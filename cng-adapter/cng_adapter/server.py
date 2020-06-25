import socket
from socketserver import ThreadingMixIn, TCPServer

class CNGAdapterTCPServer(ThreadingMixIn, TCPServer):
    def server_bind(self):
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.socket.bind(self.server_address)
