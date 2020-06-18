from flask_restful import marshal_with, fields, Resource
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.sql import text

from ct_server.models import Exposure, db

exposure_marshaller = {
    "id": fields.String
    # "timestamp": fields.DateTime(dt_format="iso8601")
}


class ExposureResource(Resource):
    @marshal_with(exposure_marshaller)
    def get(self, id):
        return Exposure.query.filter_by(id=id).first_or_404()

    def put(self, id):
        if bool(Exposure.query.filter_by(id=id).first()):
            return "Already exists", 200, {}

        exposure = Exposure(id=id)
        db.session.add(exposure)
        db.session.commit()

        return "Created", 201, {}


class ExposureListResource(Resource):
    @marshal_with(exposure_marshaller)
    def get(self):
        return Exposure.query.all()


class HealthCheckResource(Resource):
    def get(self):
        try:
            Exposure.query.all()
            return "Healthy", 200, {}
        except SQLAlchemyError as e:
            print(f"DB connection failed: {e}")
            return "DB connection lost", 500, {}
