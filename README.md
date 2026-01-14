# rucio-rest-api-usage-patterns

## Summary

![Cancelled](https://img.shields.io/badge/status-Cancelled-red) due to unresolved OpenAPI spec validation errors that prevent reliable client generation. See [following issue](https://github.com/rucio/rucio/issues/8327) that won't be addressed.

Reference usage patterns with generated client libraries in common languages (Python, TypeScript) capable of invoking Rucio 39.0.0 REST API.

**NOTE:** The [Rucio openapi.json file](./rucio/openapi.json) was downloaded from https://rucio.cern.ch/documentation/html/rest_api_doc.html (click the `Download` button on the page).

## Quick Start

Generate Python and TypeScript clients/servers from OpenAPI specs using appropriate tools.

```bash
# Generate code
make generate-clients spec=ping/openapi.json
make generate-servers spec=ping/openapi.json

# After generating code, install dependencies
make setup

# Start one fo the servers in terminal A
make start-py-server
make start-ts-server

# Start one of the clients in terminal B
make start-py-client
make start-ts-client
```

## Makefile Targets

```bash
OpenAPI Generator

Usage:
  make <target> spec=path/to/openapi.json

Generate:
  validate    - Validate OpenAPI spec
  generate-py-client   - Generate Python client
  generate-ts-client   - Generate TypeScript client (@hey-api)
  generate-py-server   - Generate Python server (Connexion)
  generate-ts-types    - Generate TypeScript types
  generate-clients     - Generate both clients (default)
  generate-servers     - Generate Python server + TS types

Setup:
  setup       - Install all dependencies

Start:
  start-py-server  - Start Python server only
  start-py-client  - Run Python client only
  start-ts-server  - Start TypeScript server only
  start-ts-client  - Run TypeScript client only

Cleanup:
  clean       - Remove generated code
```

## Requirements

Ideally utilize the [dev container](.devcontainer/devcontainer.json) for reproducablity in an IDE supporting it.

## Why These Tools?

### Python: OpenAPI Generator

- Python support
- Mature, stable
- Connexion integration

### TypeScript: @hey-api/openapi-ts

- Appropriate, clean API
- Better types than openapi-generator
- Smaller generated code
- No dependency confusion (once setup correctly)
- Each operation as a function (not class-based)

## Development Workflow

1. **Write/update** OpenAPI spec
2. **Generate** code: `make generate-clients spec=...` || `make generate-servers spec=...`
3. **Install** deps: `make setup`
4. **Start Servers/Clients**: e.g. `make start-py-server` && `make start-py-client`
5. **Integrate** into your app
