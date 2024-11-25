from flask import Blueprint, jsonify
import sys

import flask


# Create a blueprint for Health-related routes
system_blueprint = Blueprint('system', __name__)


# json response returns the following key:value pairs:
# python_version: version of python
# flask_version: version of flask

def get_flask_version():
    return flask.__version__

def get_python_version():
    return sys.version

@system_blueprint.route('/system', methods=['GET'])

# system overview route, displays the version of python and flask
def system_overview():
    return jsonify({'python_version': get_python_version(), 'flask_version': get_flask_version()}), 200



