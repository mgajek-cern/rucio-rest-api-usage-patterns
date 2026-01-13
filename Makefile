# OpenAPI Client/Server Generator

SHELL := /bin/bash

# Input spec
spec ?= ping/openapi.json

# Output directories
OUT := generated
PY_CLIENT := $(OUT)/python-client
TS_CLIENT := $(OUT)/typescript-client
PY_SERVER := $(OUT)/python-server
TS_TYPES := $(OUT)/typescript-types

.PHONY: help validate clean generate-py-client generate-ts-client generate-py-server generate-ts-types generate-clients generate-servers setup start-py-server start-py-client start-ts-server start-ts-client all

all: clients

help:
	@echo "OpenAPI Generator"
	@echo ""
	@echo "Usage:"
	@echo "  make <target> spec=path/to/openapi.json"
	@echo ""
	@echo "Generate:"
	@echo "  validate    - Validate OpenAPI spec"
	@echo "  generate-py-client   - Generate Python client"
	@echo "  generate-ts-client   - Generate TypeScript client (@hey-api)"
	@echo "  generate-py-server   - Generate Python server (Connexion)"
	@echo "  generate-ts-types    - Generate TypeScript types"
	@echo "  generate-clients     - Generate both clients (default)"
	@echo "  generate-servers     - Generate Python server + TS types"
	@echo ""
	@echo "Setup:"
	@echo "  setup       - Install all dependencies"
	@echo ""
	@echo "Start:"
	@echo "  start-py-server  - Start Python server only"
	@echo "  start-py-client  - Run Python client only"
	@echo "  start-ts-server  - Start TypeScript server only"
	@echo "  start-ts-client  - Run TypeScript client only"
	@echo ""
	@echo "Cleanup:"
	@echo "  clean       - Remove generated code"
	@echo ""

validate:
	@echo " Validating $(spec)"
	@if [ ! -f "$(spec)" ]; then \
		echo " Error: File not found: $(spec)"; \
		exit 1; \
	fi
	@OUTPUT=$$(openapi-generator-cli validate -i $(spec) 2>&1); \
	echo "$$OUTPUT"; \
	if echo "$$OUTPUT" | grep -q "\[error\]"; then \
		exit 1; \
	fi
	@echo " Validation complete"
	@echo ""

# Generate Python client (using OpenAPI Generator)
generate-py-client: validate
	@echo " Generating Python client"
	@mkdir -p $(PY_CLIENT)
	@openapi-generator-cli generate \
		-i $(spec) \
		-g python \
		-o $(PY_CLIENT) \
		--additional-properties=packageName=api_client \
		--global-property=apiTests=false,modelTests=false
	@echo " Python client  $(PY_CLIENT)/"
	@echo ""

# Generate TypeScript client (using @hey-api/openapi-ts)
generate-ts-client: validate
	@echo " Generating TypeScript client (@hey-api/openapi-ts)"
	@mkdir -p $(TS_CLIENT)
	@npx --yes @hey-api/openapi-ts \
		-i ./$(spec) \
		-o $(TS_CLIENT) \
		-c @hey-api/client-axios
	@echo " TypeScript client  $(TS_CLIENT)/"
	@echo ""

# Python server (Connexion)
generate-py-server: validate
	@echo " Generating Python server"
	@mkdir -p $(PY_SERVER)
	@openapi-generator-cli generate \
		-i $(spec) \
		-g python-flask \
		-o $(PY_SERVER) \
		--additional-properties=packageName=api_server
	@echo " Python server  $(PY_SERVER)/"
	@echo ""

# TypeScript types (for Express server)
generate-ts-types: validate
	@echo " Generating TypeScript types"
	@mkdir -p $(TS_TYPES)
	@npx --yes @hey-api/openapi-ts \
		-i ./$(spec) \
		-o $(TS_TYPES)
	@echo " TypeScript types  $(TS_TYPES)/"
	@echo ""

generate-clients: generate-py-client generate-ts-client
	@echo "════════════════════════════════════════"
	@echo " Clients generated from $(spec)"
	@echo "═════════════════════════════"

generate-servers: generate-py-server generate-ts-types
	@echo "════════════════════════════════════════"
	@echo " Servers generated from $(spec)"
	@echo "════════════════════════════════════════"

clean:
	@echo " Cleaning generated code"
	@rm -rf $(OUT)
	@echo " Cleaned"

# Setup - install all dependencies
setup:
	@echo " Installing dependencies..."
	@echo ""
	@echo "Python..."
	@pip install -q connexion[flask] flask-cors urllib3 python-dateutil 2>/dev/null || pip install connexion[flask] flask-cors urllib3 python-dateutil
	@if [ -d "$(PY_CLIENT)" ]; then \
		cd $(PY_CLIENT) && pip install -q -e . 2>/dev/null || pip install -e .; \
	fi
	@echo " Python ready"
	@echo ""
	@echo "TypeScript..."
	@if [ -d "ping/ts" ]; then \
		cd ping/ts && npm install --silent 2>/dev/null || npm install; \
	fi
	@if [ -d "$(TS_CLIENT)" ]; then \
		cd $(TS_CLIENT) && npm install --silent 2>/dev/null || npm install axios; \
	fi
	@echo " TypeScript ready"
	@echo ""
	@echo "════════════════════════════════════════"
	@echo " Setup complete!"
	@echo "════════════════════════════════════════"

# Start Python server
start-py-server:
	@echo "Starting Python server..."
	@python ping/python/ping_server.py

# Start Python client
start-py-client:
	@python ping/python/ping_client.py

# Start TypeScript server
start-ts-server:
	@echo "Starting TypeScript server..."
	@cd ping/ts && npm run server

# Start TypeScript client
start-ts-client:
	@cd ping/ts && npm run client