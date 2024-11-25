from flask import Flask, jsonify
#from config.config import setup_logging

# import jira blueprint from local file
from jira.jira import jira_blueprint

# import health blueprint from local file
from health.healthcheck import health_blueprint

# import system blueprint from local file
from system.system import system_blueprint

def create_app():
    # Initialize Flask app
    app = Flask(__name__)
    
    # Set up logging
    #setup_logging()

    # import and register the Health blueprint
    app.register_blueprint(health_blueprint, url_prefix='/')

    # Import and register the System blueprint
    app.register_blueprint(system_blueprint, url_prefix='/')
c
    # Import and register the Jira blueprint
    app.register_blueprint(jira_blueprint, url_prefix='/v1/jira')

    return app
