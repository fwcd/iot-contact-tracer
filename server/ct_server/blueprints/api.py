from flask import Blueprint
from flask_restful import Api, Resource

class HelloResource(Resource):
    def get(self):
        return "Hello REST!"

def create_blueprint():
    bp = Blueprint("api", __name__, url_prefix="/api/v1")
    api = Api(bp)

    api.add_resource(HelloResource, "/hello")

    return bp
