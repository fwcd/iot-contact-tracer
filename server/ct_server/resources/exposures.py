from flask_restful import marshal_with, fields, Resource

from ct_server.models import Exposure, db

exposure_marshaller = {
    "id": fields.String,
    "timestamp": fields.DateTime(dt_format="iso8601")
}

class Exposures(Resource):
    @marshal_with(exposure_marshaller)
    def get(self, id):
        return Exposure.query.filter_by(id=id).first_or_404()

    def put(self, id):
        exposure = Exposure(id=id)
        db.session.add(exposure)
        db.session.commit()
        return "Created", 201, {}
