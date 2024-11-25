from flask import Blueprint, request, jsonify
import logging

# Create a blueprint for Jira-related routes
jira_blueprint = Blueprint('jira', __name__)

# Set up logger
logger = logging.getLogger(__name__)

@jira_blueprint.route('/create/project', methods=['POST'])
def create_project():
    try:
        # Parse incoming JSON from the Jira webhook
        data = request.json

        # Extract project and creator details
        project_key = data.get('project', {}).get('key', 'Unknown')
        project_name = data.get('project', {}).get('name', 'Unknown')
        creator = data.get('creator', {}).get('displayName', 'Unknown')

        # Log the event
        logger.info(f"New project created: {project_key} - {project_name} by {creator}")

        # Respond with a success message
        return jsonify({'status': 'success', 'message': f"Project {project_key} created successfully!"}), 200

    except Exception as e:
        # Log the error with stack trace
        logger.error(f"Error processing Jira webhook: {e}", exc_info=True)
        return jsonify({'status': 'error', 'message': str(e)}), 500
