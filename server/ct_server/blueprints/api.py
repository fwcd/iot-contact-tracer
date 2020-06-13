from flask import Blueprint
from flask_restful import Api

from ct_server.resources.exposures import Exposures

def create_blueprint():
    bp = Blueprint("api", __name__, url_prefix="/api/v1")
    api = Api(bp)

    api.add_resource(Exposures, "/exposures/<string:id>")

    return bp
