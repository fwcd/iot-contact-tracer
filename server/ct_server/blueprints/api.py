from flask import Blueprint
from flask_restful import Api

from ct_server.resources.exposure import ExposureResource, ExposureListResource, HealthCheckResource


def create_blueprint():
    bp = Blueprint("api", __name__, url_prefix="/api/v1")
    api = Api(bp)

    api.add_resource(ExposureListResource, "/exposures")
    api.add_resource(ExposureResource, "/exposures/<string:id>")
    api.add_resource(HealthCheckResource, "/health")

    return bp
