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
    
    def delete(self, id):
        n = Exposure.query.filter_by(id=id).delete()
        db.session.commit()
        if n == 0:
            return "ID not found", 404, {}
        else:
            return f"Deleted exposure with ID {id}", 200, {}


class ExposureListResource(Resource):
    @marshal_with(exposure_marshaller)
    def get(self):
        return Exposure.query.all()
    
    def delete(self):
        n = Exposure.query.delete()
        db.session.commit()
        return f"Deleted {n} exposure(s)", 200, {}


class HealthCheckResource(Resource):
    def get(self):
        try:
            Exposure.query.all()
            return "Healthy", 200, {}
        except SQLAlchemyError as e:
            print(f"DB connection failed: {e}")
            return "DB connection lost", 500, {}
