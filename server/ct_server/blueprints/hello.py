from flask import Blueprint

def create_blueprint():
    bp = Blueprint("hello", __name__, url_prefix="/hello")

    @bp.route("/")
    def hello_world():
        return "Hello World from Flask!"
    
    return bp
