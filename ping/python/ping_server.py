#!/usr/bin/env python3
"""
Server using generated Connexion/Flask server.
Controller must return dict, not model object.

Usage: python ping_server.py
"""
import sys
import os
from datetime import datetime

# Add generated server to path
sys.path.insert(0, os.path.join(os.path.dirname(
    __file__), '../../generated/python-server'))


def ping():
    """
    Ping endpoint controller.
    IMPORTANT: Return dict, not PingResponse object!
    Connexion will serialize the dict.
    """
    from api_server.models.ping_response import PingResponse

    # Create model object
    response = PingResponse(
        status="ok",
        timestamp=datetime.utcnow().isoformat() + "Z",
        version="1.0.0"
    )

    # Return as dict (use to_dict() method from generated model)
    return response.to_dict()


def main():
    try:
        # Patch the generated controller with our implementation
        import api_server.controllers.health_controller as controller
        controller.ping = ping

        print("=" * 50)
        print(" Ping Server (Generated Connexion/Flask)")
        print("=" * 50)
        print("Server: http://localhost:8080")
        print("Endpoint: http://localhost:8080/ping")
        print("=" * 50)

        # Start the generated Connexion server
        import connexion
        app = connexion.App(
            __name__, specification_dir='../../generated/python-server/api_server/openapi/')
        app.add_api('openapi.yaml')
        app.run(port=8080)

    except ImportError as e:
        print(f"✗ Error: {e}")
        print()
        print("Install dependencies:")
        print("  pip install connexion[flask] flask-cors")
        sys.exit(1)


if __name__ == '__main__':
    main()
