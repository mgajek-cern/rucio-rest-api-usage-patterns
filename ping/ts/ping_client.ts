#!/usr/bin/env ts-node
/**
 * Client using @hey-api/openapi-ts generated code.
 * Much cleaner than openapi-generator!
 * 
 * Usage: ts-node ping_client.ts
 */

import { ping } from '../../generated/typescript-client';
import type { PingResponse } from '../../generated/typescript-client';

async function main(): Promise<number> {
  console.log('==================================================');
  console.log(' Ping Client (@hey-api)');
  console.log('==================================================');
  console.log('Connecting to: http://localhost:8080');
  console.log();
  
  try {
    // Call ping endpoint - super simple!
    console.log(' Calling /ping endpoint...');
    const response = await ping({
      baseURL: 'http://localhost:8080',
    });
    
    if (response.error) {
      throw new Error(response.error.message || 'Unknown error');
    }
    
    const data = response.data as PingResponse;
    
    console.log(' Success');
    console.log(`  Status:    ${data.status}`);
    console.log(`  Timestamp: ${data.timestamp}`);
    if (data.version) {
      console.log(`  Version:   ${data.version}`);
    }
    console.log();
    console.log('==================================================');
    
    return 0;
    
  } catch (error: any) {
    console.error(` Error: ${error.message}`);
    console.log();
    console.log('Make sure the server is running:');
    console.log('  cd ping/ts && npm run server');
    console.log('==================================================');
    return 1;
  }
}

main().then(code => process.exit(code));