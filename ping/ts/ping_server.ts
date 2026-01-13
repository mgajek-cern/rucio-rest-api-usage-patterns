#!/usr/bin/env ts-node
/**
 * Express server using @hey-api/openapi-ts generated types.
 * Clean, simple, type-safe!
 * 
 * Usage: ts-node ping_server.ts
 */

import express from 'express';
import type { PingResponse } from '../../generated/typescript-types';

const app = express();
const PORT = 8080;

// Implement ping endpoint with generated types
app.get('/ping', (req, res) => {
  const response: PingResponse = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  };
  
  res.json(response);
});

app.listen(PORT, '0.0.0.0', () => {
  console.log('==================================================');
  console.log(' Ping Server (Express + Generated Types)');
  console.log('==================================================');
  console.log(`Server: http://localhost:${PORT}`);
  console.log(`Endpoint: http://localhost:${PORT}/ping`);
  console.log('==================================================');
});

process.on('SIGINT', () => {
  console.log('\n✓ Server stopped');
  process.exit(0);
});