import os
from flask import Flask
from flask_env import MetaFlaskEnv
from flask_sqlalchemy import SQLAlchemy

import ct_server.blueprints.api as api
import ct_server.blueprints.hello as hello
from ct_server.blueprints.frontend import exposures
from ct_server.models import db

class Configuration(metaclass=MetaFlaskEnv):
    ENV_LOAD_ALL = True

def create_app():
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(Configuration)

    app.register_blueprint(api.create_blueprint())
    app.register_blueprint(hello.create_blueprint())
    app.register_blueprint(exposures)

    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    db.init_app(app)
    with app.app_context():
        db.create_all()
        db.session.commit()

    return app
