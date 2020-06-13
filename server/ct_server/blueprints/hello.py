from flask import Blueprint

def create_blueprint():
    bp = Blueprint("hello", __name__)

    @bp.route("/")
    def hello_world():
        return "Hello World from Flask!"
    
    return bp
