#!/bin/sh
gunicorn --bind 0.0.0.0:5000 'ct_server:create_app()'
