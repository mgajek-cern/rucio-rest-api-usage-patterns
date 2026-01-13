#!/bin/bash
set -e

echo " Setting up development environment..."

# Install Python dependencies
pip install --upgrade pip
pip install openapi-generator-cli black isort

# Install Node.js dependencies globally
npm install -g typescript ts-node @types/node

# Verify tools
echo " Python: $(python --version)"
echo " Node.js: $(node --version)"
echo " Docker: $(docker --version)"

echo " Development environment ready"
echo ""
echo "Try: make help"