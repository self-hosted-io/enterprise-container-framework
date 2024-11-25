from flask import Blueprint, jsonify
import logging

# Create a blueprint for Health-related routes
health_blueprint = Blueprint('health', __name__)

# Set up logger
logger = logging.getLogger(__name__)

@health_blueprint.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'}), 200