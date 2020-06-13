import os
from flask import Flask
from flask_env import MetaFlaskEnv
from flask_sqlalchemy import SQLAlchemy

import ct_server.blueprints.hello as hello

class Configuration(metaclass=MetaFlaskEnv):
    ENV_LOAD_ALL = True

db = SQLAlchemy()

def create_app():
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(Configuration)
    app.register_blueprint(hello.create_blueprint())

    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    db.init_app(app)
    return app
