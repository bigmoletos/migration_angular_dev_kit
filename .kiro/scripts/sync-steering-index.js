#!/usr/bin/env node

/**
 * Script de synchronisation automatique de l'index des steering
 *
 * Ce script :
 * 1. Scanne tous les fichiers .md dans .kiro/steering/
 * 2. Génère automatiquement le fichier _index.json à jour
 * 3. Peut être appelé manuellement ou via un hook
 *
 * Usage:
 *   node sync-steering-index.js
 */

const fs = require('fs');
const path = require('path');

// Configuration
const STEERING_DIR = path.join(__dirname, '..', 'steering');
const INDEX_FILE = path.join(STEERING_DIR, '_index.json');
const IGNORE_FILES = ['README.md', '_index.json'];

/**
 * Extrait les métadonnées d'un fichier steering
 */
function extractSteeringMetadata(filename) {
  const filePath = path.join(STEERING_DIR, filename);
  const content = fs.readFileSync(filePath, 'utf8');

  // Extraire le titre (première ligne avec #)
  const titleMatch = content.match(/^#\s+(.+)$/m);
  const title = titleMatch ? titleMatch[1] : filename.replace('.md', '');

  // Extraire une description
  const descMatch = content.match(/^#\s+.+\n\n(.+?)(?:\n\n|$)/s);
  const description = descMatch ? descMatch[1].replace(/\n/g, ' ').substring(0, 100) : title;

  // Générer des mots-clés
  const keywords = extractKeywords(filename, title, content);

  // Estimation du nombre de tokens
  const tokenEstimate = Math.ceil(content.length / 4);

  // Détecter les triggers (fichiers qui devraient déclencher le chargement de ce steering)
  const triggers = extractTriggers(content);

  // Détecter si c'est un steering "toujours chargé"
  const alwaysLoaded = content.includes('TOUJOURS chargé') || content.includes('always loaded');

  return {
    name: filename.replace('.md', ''),
    path: filename,
    description: description,
    keywords: keywords,
    tokenEstimate: tokenEstimate,
    triggers: triggers,
    alwaysLoaded: alwaysLoaded
  };
}

/**
 * Extrait des mots-clés pertinents
 */
function extractKeywords(filename, title, content) {
  const keywords = new Set();

  // Mots-clés du nom de fichier
  const filenameParts = filename.replace('.md', '').split(/[-_]/);
  filenameParts.forEach(part => {
    if (part.length > 2 && !part.match(/^\d+$/)) {
      keywords.add(part.toLowerCase());
    }
  });

  // Mots-clés spécifiques du contenu
  if (content.includes('RxJS')) keywords.add('rxjs');
  if (content.includes('Ivy')) keywords.add('ivy');
  if (content.includes('Webpack')) keywords.add('webpack');
  if (content.includes('TypeScript')) keywords.add('typescript');
  if (content.includes('Playwright')) keywords.add('playwright');
  if (content.includes('test')) keywords.add('testing');
  if (content.includes('Angular')) keywords.add('angular');

  return Array.from(keywords);
}

/**
 * Extrait les triggers (patterns de fichiers qui devraient charger ce steering)
 */
function extractTriggers(content) {
  const triggers = [];

  // Patterns courants
  if (content.includes('*.spec.ts') || content.includes('tests')) triggers.push('*.spec.ts');
  if (content.includes('.module.ts')) triggers.push('*.module.ts');
  if (content.includes('webpack')) triggers.push('webpack*.js');
  if (content.includes('e2e')) triggers.push('**/e2e/**/*.ts');
  if (content.includes('playwright')) triggers.push('**/playwright/**/*.ts');

  return triggers;
}

/**
 * Génère l'index complet
 */
function generateIndex() {
  console.log('🔍 Scan du dossier steering...');

  // Lire tous les fichiers .md
  const files = fs.readdirSync(STEERING_DIR)
    .filter(file => file.endsWith('.md') && !IGNORE_FILES.includes(file))
    .sort();

  console.log(`📄 ${files.length} steerings trouvés`);

  // Générer les métadonnées pour chaque steering
  const steerings = files.map(file => {
    const metadata = extractSteeringMetadata(file);
    const loadType = metadata.alwaysLoaded ? '🔴 TOUJOURS' : '🟢 Contextuel';
    console.log(`   ${loadType} ${file} (${metadata.tokenEstimate} tokens)`);
    return metadata;
  });

  // Calculer les statistiques
  const totalTokens = steerings.reduce((sum, s) => sum + s.tokenEstimate, 0);
  const alwaysLoadedCount = steerings.filter(s => s.alwaysLoaded).length;
  const contextualCount = steerings.length - alwaysLoadedCount;

  // Générer l'objet index
  const index = {
    version: "1.0",
    description: "Index des steering - Chargés contextuellement selon les fichiers modifiés",
    lastUpdated: new Date().toISOString().split('T')[0],

    loadingStrategy: {
      mode: "contextual",
      note: "Certains steerings sont toujours chargés, d'autres uniquement selon le contexte"
    },

    steerings: steerings,

    statistics: {
      totalSteerings: steerings.length,
      alwaysLoaded: alwaysLoadedCount,
      contextual: contextualCount,
      totalTokensIfAllLoaded: totalTokens
    },

    usage: "Les steerings sont chargés automatiquement selon les fichiers modifiés ou les tâches en cours"
  };

  // Écrire le fichier index
  fs.writeFileSync(INDEX_FILE, JSON.stringify(index, null, 2), 'utf8');

  console.log(`\n✅ Index mis à jour : ${INDEX_FILE}`);
  console.log(`📊 Total : ${steerings.length} steerings (${alwaysLoadedCount} toujours chargés, ${contextualCount} contextuels)`);
  console.log(`📊 Tokens : ${totalTokens} estimés`);

  return index;
}

// Exécution
try {
  const index = generateIndex();
  process.exit(0);
} catch (error) {
  console.error('❌ Erreur lors de la synchronisation :', error.message);
  process.exit(1);
}
