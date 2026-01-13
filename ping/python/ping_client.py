#!/usr/bin/env python3
"""
Simple ping client using generated Python client code.
Make sure ping_server.py is running first!

Usage: python ping_client.py
"""
import sys
import os

# Add generated client to path
sys.path.insert(0, os.path.join(os.path.dirname(
    __file__), '../../generated/python-client'))

try:
    from api_client import Configuration, ApiClient
    from api_client.api.health_api import HealthApi
except ImportError as e:
    print(f"✗ Error: Could not import generated client: {e}")
    print("Run: make generate-py-client spec=ping/openapi.json")
    sys.exit(1)


def main():
    # Configure client to point to local server
    config = Configuration()
    config.host = "http://localhost:8080"

    print("=" * 50)
    print(" Ping Client Test")
    print("=" * 50)
    print(f"Connecting to: {config.host}")
    print()

    # Create API instance
    with ApiClient(config) as api_client:
        api = HealthApi(api_client)

        try:
            # Call ping endpoint
            print(" Calling /ping endpoint...")
            response = api.ping()

            print(" Success")
            print(f"  Status:    {response.status}")
            print(f"  Timestamp: {response.timestamp}")
            if hasattr(response, 'version') and response.version:
                print(f"  Version:   {response.version}")
            print()
            print("=" * 50)

            return 0

        except Exception as e:
            print(f"✗ Error: {e}")
            print()
            print("Make sure the server is running:")
            print("  python ping/python/ping_server.py")
            print("=" * 50)
            return 1


if __name__ == "__main__":
    sys.exit(main())
