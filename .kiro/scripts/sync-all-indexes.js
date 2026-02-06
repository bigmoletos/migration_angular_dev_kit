#!/usr/bin/env node

/**
 * Script principal de synchronisation de tous les index Kiro
 *
 * Ce script exécute tous les scripts de synchronisation :
 * - sync-specs-index.js
 * - sync-steering-index.js
 *
 * Usage:
 *   node sync-all-indexes.js
 */

const { execSync } = require('child_process');
const path = require('path');

const SCRIPTS_DIR = __dirname;

console.log('🔄 Synchronisation de tous les index Kiro...\n');

const scripts = [
  { name: 'Specs', file: 'sync-specs-index.js' },
  { name: 'Steering', file: 'sync-steering-index.js' }
];

let allSuccess = true;
const results = [];

scripts.forEach(({ name, file }) => {
  console.log(`\n${'='.repeat(60)}`);
  console.log(`📋 Synchronisation de l'index ${name}`);
  console.log(`${'='.repeat(60)}\n`);

  try {
    const scriptPath = path.join(SCRIPTS_DIR, file);
    execSync(`node "${scriptPath}"`, { stdio: 'inherit' });
    results.push({ name, success: true });
  } catch (error) {
    console.error(`❌ Erreur lors de la synchronisation de ${name}`);
    results.push({ name, success: false });
    allSuccess = false;
  }
});

console.log(`\n${'='.repeat(60)}`);
console.log('📊 RÉSUMÉ DE LA SYNCHRONISATION');
console.log(`${'='.repeat(60)}\n`);

results.forEach(({ name, success }) => {
  const icon = success ? '✅' : '❌';
  const status = success ? 'OK' : 'ÉCHEC';
  console.log(`${icon} ${name.padEnd(20)} : ${status}`);
});

console.log('');

if (allSuccess) {
  console.log('✅ Tous les index ont été synchronisés avec succès !');
  process.exit(0);
} else {
  console.log('⚠️ Certains index n\'ont pas pu être synchronisés');
  process.exit(1);
}
